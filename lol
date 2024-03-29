#!bin/bash
IMAGE=$(pwd)/out/arch/arm64/boot/Image.gz-dtb
git clone https://github.com/najahiiii/priv-toolchains.git -b arm64 gcc
git clone https://github.com/najahiiii/priv-toolchains.git -b arm elf

GCC="$(pwd)/gcc/bin/aarch64-elf-"
GCCARM="$(pwd)/elf/bin/arm-eabi-"
curl -s -X POST https://api.telegram.org/bot869223630:AAGcCNFXbAxWT-SLowVzcQHXePXToulnPnw/sendMessage?chat_id=-1001314216463 -d "disable_web_page_preview=true" -d "parse_mode=html&text=<b>// BlueOcean //</b>%0ACompile Started"'!'"%0A<b>For device</b> <code>Rolex (Redmi 4A)</code>%0A<b>For Oreo/Pie</b>%0A<b>Under Commit</b> <code>$(git log --pretty=format:'"%h : %s"' -1)</code>%0A<b>Compiler</b> <code>$(${GCC}gcc --version | head -n 1)</code>%0A<b>Compiler</b> <code>$(${GCCARM}gcc --version | head -n 1)</code>%0AStarted on <code>$(TZ=Asia/Jakarta date)</code>%0A<b>Build Status:</b> #untested"
tanggal=$(date +'%H%M-%d%m%y')
START=$(date +"%s")
export ARCH=arm64
export KBUILD_BUILD_USER=Muhammadfadlyas
export KBUILD_BUILD_HOST=AyamGoreng

make -s -C $(pwd) O=out rolex_defconfig
make -s -C $(pwd) CROSS_COMPILE_ARM32=${GCCARM} CROSS_COMPILE=${GCC} O=out -j16 -l12 2>&1| tee build.log
if ! [ -a $IMAGE ]; then
	exit 1
fi
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel/zImage
paste

cd AnyKernel
zip -r9 blueocean-${tanggal}.zip *
END=$(date +"%s")
DIFF=$(($END - $START))
curl -F chat_id="-1001314216463" -F document=@"blueocean-${tanggal}.zip " -F "disable_web_page_preview=true" -F "parse_mode=html" -F caption="Build took $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s) " https://api.telegram.org/bot869223630:AAGcCNFXbAxWT-SLowVzcQHXePXToulnPnw/sendDocument
cd ..
rm -rf out
rm -rf AnyKernel/zImage
rm -rf AnyKernel/blueocean *.zip
