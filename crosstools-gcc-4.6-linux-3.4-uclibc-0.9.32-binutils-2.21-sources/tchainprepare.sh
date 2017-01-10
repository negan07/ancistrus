#!/bin/sh
# D7000 toolchain
# host system: ubuntu yakkety x86/64

DLURL="http://www.downloads.netgear.com/files/GPL"
ZIPFILE="D7000_WW_SRC.TAR_V1.0.1.44.zip"
SOURCEDIR="D7000_V1.0.1.44_WW_src"
TCDIR="crosstools-gcc-4.6-linux-3.4-uclibc-0.9.32-binutils-2.21-sources"
TARFILE="${SOURCEDIR}.tar.bz2"
TARTC="${TCDIR}.tar.bz2"

# create compiled toolchain's root dir: the path cannot be modified
sudo mkdir /opt/toolchains
cd ..
	if [ ! -f $ZIPFILE -a ! -d $SOURCEDIR ]; then
	echo "Source files not present: downloading..."
	wget $DLURL/$ZIPFILE
		if [ ! -f $ZIPFILE ]; then
		echo "Unable to download source zip file"
		exit 1
		fi
	fi
	if [ ! -d $SOURCEDIR ]; then
	echo "Extracting sources from zip archive..."
	unzip -qq $ZIPFILE
	tar xjf $TARFILE
	rm -f $TARFILE
	fi
# source dir includes the tar.bz2 toolchain to be built...
cd $TCDIR
tar xjf ../$SOURCEDIR/Source/$TARTC
chmod 755 src/build
# xtract archives src/buildroot-2011.11/dl
cd src/buildroot-2011.11/dl
tar xjf autoconf-2.65.tar.bz2
tar xjf gcc-4.6.2.tar.bz2
tar xjf gdb-7.3.1.tar.bz2
tar xjf m4-1.4.15.tar.bz2
tar xjf uClibc-0.9.32.tar.bz2
# remove old archives
rm -f autoconf-2.65.tar.bz2 gcc-4.6.2.tar.bz2 gdb-7.3.1.tar.bz2 m4-1.4.15.tar.bz2 uClibc-0.9.32.tar.bz2
cd ../../..
# apply patch
patch -p1 < crosstools-gcc-4.6-linux-3.4-uclibc-0.9.32-binutils-2.21-sources.diff
# repack them all
cd src/buildroot-2011.11/dl
tar cjf autoconf-2.65.tar.bz2 autoconf-2.65
tar cjf gcc-4.6.2.tar.bz2 gcc-4.6.2
tar cjf gdb-7.3.1.tar.bz2 gdb-7.3.1
tar cjf m4-1.4.15.tar.bz2 m4-1.4.15
tar cjf uClibc-0.9.32.tar.bz2 uClibc-0.9.32
# dir cleanup
rm -Rf autoconf-2.65 gcc-4.6.2 gdb-7.3.1 m4-1.4.15 uClibc-0.9.32
cd ../../..
echo "Ready to start: type e.g.: sudo make"
echo
