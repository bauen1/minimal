#!/bin/bash

SRC_DIR=$(pwd)

. ../../common.sh

# Grab everything after the '=' character.
DOWNLOAD_URL=$(grep -i TCC_SOURCE_URL $MAIN_SRC_DIR/.config | cut -f2 -d'=')

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
  # Downloading tcc source bundle file. The '-c' option allows the download to resume.
  echo "Downloading tcc source bundle from $DOWNLOAD_URL"
  wget -c $DOWNLOAD_URL
else
  echo "Using local tcc source bundle $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE"
fi

# Delete folder with previously extracted tcc.
echo "Removing tcc work area. This may take a while..."
rm -rf $WORK_DIR/overlay/tcc
mkdir $WORK_DIR/overlay/tcc

# Extract tcc to folder 'work/overlay/tcc'.
# Full path will be something like 'work/overlay/tcc/tcc-0.9.26'.
tar -xvf $ARCHIVE_FILE -C $WORK_DIR/overlay/tcc

cd $SRC_DIR

