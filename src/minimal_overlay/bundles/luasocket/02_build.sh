#!/bin/sh

# TODO: compile the gnu readline library for line editing support

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/overlay/luasocket

DESTDIR="$PWD/luasocket_installed"

# Change to the luasocket source directory which ls finds, e.g. 'luasocket-5.3.4'.
cd $(ls -d luasocket-*)

LUA_DIR="$WORK_DIR/overlay/lua/lua_installed"
CC="$CC -I$LUA_DIR/usr/include -L$LUA_DIR/usr/lib"

# luaL_checkint has been removed in lua 5.3
CFLAGS="$CFLAGS -fPIC -DLUASOCKET_API='__attribute__((visibility(\"default\")))' -D 'luaL_checkint(L, n)=((int)luaL_checkinteger(L, n))'"

echo "Preparing luasocket work area. This may take a while..."
make -C src -j $NUM_JOBS clean
rm -rf "$DESTDIR"

echo "Building luasocket..."
make -C src -j $NUM_JOBS LUAV=5.3 CC="$CC" CFLAGS="$CFLAGS" linux
make -C src -j $NUM_JOBS LUAV=5.3 CC="$CC" CFLAGS="$CFLAGS" install DESTDIR="$DESTDIR" prefix=/usr

echo "Reducing luasocket size..."
strip -g $DESTDIR/usr/bin/* 2>/dev/null

ROOTFS="$WORK_DIR/src/minimal_overlay/rootfs"
mkdir -p $ROOTFS/usr/ $ROOTFS/lib
cp -r $DESTDIR/usr/* $ROOTFS/usr/

echo "luasocket has been installed."

cd $SRC_DIR

