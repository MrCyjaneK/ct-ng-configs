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
    (cat .config | grep -v "$1"= || true) > .config.new
    mv .config.new .config
    echo "$1"="$2" >> .config
    return 0
}

put_new_config CT_CC_LANG_CXX y

if [[ $BUILD_TUPLE == *-linux-* ]];
then
    put_new_config CT_CC_LANG_GOLANG y
    put_new_config CT_MULTILIB n
    put_new_config CT_OMIT_TARGET_VENDOR y
fi
put_new_config CT_GDB_CROSS n
put_new_config CT_GDB n
put_new_config CT_GDB_NATIVE n
put_new_config CT_PREFIX_DIR_RO n
put_new_config CT_PREFIX $PREFIX
put_new_config CT_LOG_LEVEL_MAX '"ALL"'

put_new_config CT_EXPERIMENTAL y
put_new_config CT_FORBID_DOWNLOAD y
put_new_config CT_WANTS_STATIC_LINK n
put_new_config CT_WANTS_STATIC_LINK_CXX n

unset LD_LIBRARY_PATH
unset LIBRARY_PATH
unset CFLAGS
unset CC
unset CXX

exec ct-ng build
