#!/bin/sh
# Compiles ffts for Android
# Make sure you have NDK_ROOT defined in .bashrc or .bash_profile
# Modify INSTALL_DIR to suit your situation

INSTALL_DIR="`pwd`/java/android/bin"

PLATFORM=android-19
TOOL="4.8"

case $(uname -s) in
  Darwin)
    CONFBUILD=i386-apple-darwin`uname -r`
    HOSTPLAT=darwin-`uname -m`
  ;;
  Linux)
    CONFBUILD=x86-unknown-linux
    HOSTPLAT=linux-`uname -m`
  ;;
  *) echo $0: Unknown platform; exit
esac

case arm in
  arm)
    TARGPLAT=arm-linux-androideabi
    ARCH=arm
    CONFTARG=arm-eabi
  ;;
  x86)
    TARGPLAT=x86
    ARCH=x86
    CONFTARG=x86
  ;;
  mips)
  ## probably wrong
    TARGPLAT=mipsel-linux-android
    ARCH=mips
    CONFTARG=mips
  ;;
  *) echo $0: Unknown target; exit
esac

: ${NDK_ROOT:?}

echo "Using: $NDK_ROOT/toolchains/${TARGPLAT}-${TOOL}/prebuilt/${HOSTPLAT}/bin"

export PATH="$NDK_ROOT/toolchains/${TARGPLAT}-${TOOL}/prebuilt/${HOSTPLAT}/bin/:$PATH"
export SYS_ROOT="$NDK_ROOT/platforms/${PLATFORM}/arch-${ARCH}/"
export CC="${TARGPLAT}-gcc --sysroot=$SYS_ROOT"
export CXX="${TARGPLAT}-g++ --sysroot=$SYS_ROOT"
export LD="${TARGPLAT}-ld"
export AR="${TARGPLAT}-ar"
export RANLIB="${TARGPLAT}-ranlib"
export STRIP="${TARGPLAT}-strip"
export CFLAGS="-Os"

mkdir -p $INSTALL_DIR
./configure --enable-neon --build=${CONFBUILD} --host=${TARGPLAT} --prefix=$INSTALL_DIR LIBS="-lc -lgcc -llog"

make clean
make
make install
