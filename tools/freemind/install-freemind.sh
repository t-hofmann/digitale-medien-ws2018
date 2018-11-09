#!/usr/bin/env sh
set -e

PACKAGE_NAME="freemind"
INSTALL_DIR="/opt/freemind"

URL="https://sourceforge.net/projects/freemind/files/freemind/1.0.1/freemind-bin-max-1.0.1.zip/download"
#SHA1="8b4c16f253d5c56b7fddf6a1878831556febfc48"
#SHA512="821c6ace0c1f8cb3ba81cd7af979addb5ff7b6de00c821239597da39a38c3c3b5f2e78c6948ddcab3538ac9b6b6220019574d854582db99f5bb0cbc2133f3b96"
SHA512_FILE="sha512.sums" # own sha512 was created from an initial download verified with the SHA1 provided on the download-page (download was on 2018-11-09)

DOWNLOADED_FILE="freemind-bin-max-1.0.1.zip"

cd $(dirname $0) # guarantee to be in the installer's directory

if [ ! -f $DOWNLOADED_FILE ]; then
	echo "downloading freemind"
	wget $URL -O $DOWNLOADED_FILE
fi

echo "checking download's sha512sum"
sha512sum --check $SHA512_FILE

if [ -d $INSTALL_DIR ]; then
	echo "error: directory \"$INSTALL_DIR\" already exists"
	echo "Maybe freemind is already installed?"
	exit 1
fi

echo "unzipping $DOWNLOADED_FILE to $INSTALL_DIR"
sudo unzip $DOWNLOADED_FILE -d $INSTALL_DIR

echo "copying freemind.ico to $INSTALL_DIR/."
sudo cp freemind.ico $INSTALL_DIR/.

DESKTOP_FILE="$PACKAGE_NAME.desktop"
DESKTOP_DIR="/usr/share/applications"
echo "copying $DESKTOP_FILE to $DESKTOP_DIR/."
if [ -f $DESKTOP_DIR/$DESKTOP_FILE ]; then
	echo "error: file \"$DESKTOP_DIR/$DESKTOP_FILE\" already exists"
	echo "can not copy $DESKTOP_FILE to that location"
	echo "please check if that is a problem, if possible correct manually"
	exit 1
fi

sudo cp $DESKTOP_FILE $DESKTOP_DIR/.
