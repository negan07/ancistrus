#!/bin/sh
#
# ancistrus
#
# Netgear's Nighthawk Router Experience Distributed Project
#
# D7000
#
# https://github.com/negan07/ancistrus
#
#
# D7000 sources download & extract.
#

SOURCEDIR="D7000_V1.0.1.44_WW_src"
DLURL="http://www.downloads.netgear.com/files/GPL"
ZIPFILE="D7000_WW_SRC.TAR_V1.0.1.44.zip"
TARFILE="${SOURCEDIR}.tar.bz2"

	if [ ! -d $SOURCEDIR ]; then
		if [ ! -f $ZIPFILE ]; then
		echo "Source file not present: downloading..."
		echo
		wget $DLURL/$ZIPFILE
		fi
	zip -T $ZIPFILE
		if [ $? != 0 ]; then
		exit 1
		fi
	echo "Extracting sources from zip archive..."
	unzip -qq $ZIPFILE
	echo "Extracting sources from tar.bz2 archive..."
	tar xjf $TARFILE
	rm -f $TARFILE
	fi

