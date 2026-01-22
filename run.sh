#!/bin/bash
set -e
cd $(dirname $0)

BUILD_TUPLE="$1"
WDIR="$PWD/work"
PREFIX="${PREFIX:-$HOME/x-tools}"
mkdir -p $WDIR
cd $WDIR

if [[ ! -f "$WDIR/../platforms/$BUILD_TUPLE/.config" ]];
then
    echo "Usage: $0 tuple [prefix]"
    cd $WDIR/../platforms/
    echo Tuples: * | tr ' ' "\n"
    exit 1
fi

cp $WDIR/../platforms/$BUILD_TUPLE/.config .config

function put_new_config {
    cat .config | grep -v "$1"= > .config.new
    mv .config.new .config
    echo "$1"="$2" >> .config
    return 0
}

put_new_config CT_CC_LANG_CXX y

if [[ $BUILD_TUPLE == *-linux-* ]];
then
    put_new_config CT_CC_LANG_GOLANG y
fi
put_new_config CT_OMIT_TARGET_VENDOR y
put_new_config CT_GDB_CROSS n
put_new_config CT_GDB n
put_new_config CT_GDB_NATIVE n
put_new_config CT_PREFIX_DIR_RO n
put_new_config CT_MULTILIB n
put_new_config CT_PREFIX $PREFIX
put_new_config CT_LOG_LEVEL_MAX '"ALL"'

put_new_config CT_EXPERIMENTAL=y
put_new_config CT_FORBID_DOWNLOAD=y

unset LD_LIBRARY_PATH
ct-ng build


exit 0
"*:{*-linux-gnu,*-linux-musl,*-w64-mingw32}:echo '' >> .config",
"*:{*-linux-gnu,*-linux-musl,*-w64-mingw32}:echo 'CT_CC_LANG_CXX=y' >> .config",
"*:none:echo 'CT_CC_LANG_FORTRAN=y' >> .config",
"*:none:echo 'CT_CC_LANG_D=y' >> .config",
"*:none:echo 'CT_CC_LANG_OBJC=y' >> .config",
"*:none:echo 'CT_CC_LANG_OBJCXX=y' >> .config",
"*:none:echo 'CT_CC_LANG_GOLANG=y' >> .config",
"*:{*-linux-gnu,*-linux-musl,*-w64-mingw32}:echo 'CT_BINUTILS_EXTRA_CONFIG_ARRAY=\"--with-system-zlib\"' >> .config",
"*:{*-linux-gnu,*-linux-musl,*-w64-mingw32}:echo 'CT_CC_GCC_SYSTEM_ZLIB=y' >> .config",
"*:{*-linux-gnu,*-linux-musl,*-w64-mingw32}:echo 'CT_DEBUG_CT_SAVE_STEPS=y' >> .config",
"*:{*-linux-gnu,*-linux-musl,*-w64-mingw32}:sed -i.bak 's/CT_GDB_CROSS=y/CT_GDB_CROSS=n/g' .config",
"*:{*-linux-gnu,*-linux-musl,*-w64-mingw32}:sed -i.bak 's/CT_GDB_GDBSERVER=y/CT_GDB_GDBSERVER=n/g' .config",
"*:{*-linux-gnu,*-linux-musl,*-w64-mingw32}:echo 'CT_GDB=n' >> .config",
"*:{*-linux-gnu,*-linux-musl,*-w64-mingw32}:echo 'CT_GDB_NATIVE=n' >> .config",
"*:{*-linux-gnu,*-linux-musl,*-w64-mingw32}:echo 'CT_PREFIX_DIR_RO=n' >> .config",
"*:{*-linux-gnu,*-linux-musl,*-w64-mingw32}:echo 'CT_MULTILIB=y' >> .config",
"*:{*-linux-gnu,*-linux-musl,*-w64-mingw32}:ln -s $TOOL_TARGET_ALT-objcopy $PREFIX/native/bin/objcopy",
"*:{*-linux-gnu,*-linux-musl,*-w64-mingw32}:ln -s $TOOL_TARGET_ALT-readelf $PREFIX/native/bin/readelf",
