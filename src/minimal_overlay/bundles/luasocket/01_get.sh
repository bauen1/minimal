#!/bin/sh

SRC_DIR=$(pwd)

. ../../common.sh

# Grab everything after the '=' character.
DOWNLOAD_URL=$(grep -i LUASOCKET_SOURCE_URL $MAIN_SRC_DIR/.config | cut -f2 -d'=')

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

# Read the 'USE_LOCAL_SOURCE' property from '.config'
USE_LOCAL_SOURCE="$(grep -i USE_LOCAL_SOURCE $MAIN_SRC_DIR/.config | cut -f2 -d'=')"

if [ "$USE_LOCAL_SOURCE" = "true" -a ! -f $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE  ] ; then
  echo "Source bundle $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE is missing and will be downloaded."
  USE_LOCAL_SOURCE="false"
fi

cd $MAIN_SRC_DIR/source/overlay

if [ ! "$USE_LOCAL_SOURCE" = "true" ] ; then
  # Downloading the Lua-socket bundle file. The '-c' option allows the download to resume.
  echo "Downloading the luasocket source bundle from $DOWNLOAD_URL"
  wget -c $DOWNLOAD_URL -o luasocket.tar.gz
else
  echo "Using local Lua source bundle $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE"
fi

# Delete folder with previously extracted Lua.
echo "Removing luasocket work area. This may take a while..."
rm -rf ../../work/overlay/luasocket
mkdir ../../work/overlay/luasocket

# Extract lua-socket to folder 'work/overlay/luasocket'.
# Full path will be something like 'work/overlay/lua-socket/luasocket-v3.0-rc1'.
tar -xvf $ARCHIVE_FILE -C ../../work/overlay/luasocket

cd $SRC_DIR

