#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

# Please note that the FHS 3.0 specifiecs /usr/src for source files
ROOTFS="$WORK_DIR/src/minimal_overlay/rootfs"

cp -r "$WORK_DIR/src" "$ROOTFS/src"

cd $SRC_DIR
