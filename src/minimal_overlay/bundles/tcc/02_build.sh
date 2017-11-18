#!/bin/bash

SRC_DIR=$(pwd)

. ../../common.sh

cd $WORK_DIR/overlay/tcc

DESTDIR="$PWD/tcc_installed"

# Change to the tcc source directory which ls finds, e.g. 'tcc-0.9.26'.
cd $(ls -d tcc-*)

echo "Preparing tcc work area. This may take a while..."
make -j $NUM_JOBS clean

rm -rf $DESTDIR

echo "Configuring tcc..."
CFLAGS="$CFLAGS" ./configure \
  --prefix=/usr

echo "Building tcc..."
make -j $NUM_JOBS

echo "Installing tcc..."
make -j $NUM_JOBS install DESTDIR=$DESTDIR

echo "Reducing tcc size..."
strip -g $DESTDIR/usr/bin/*

ROOTFS="$WORK_DIR/src/minimal_overlay/rootfs"

cp -r $DESTDIR/* $ROOTFS

echo "tcc has been installed."

cd $SRC_DIR
