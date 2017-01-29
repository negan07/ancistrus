#!/bin/sh
#
# D7000 toolchain.
#

SOURCEDIR="D7000_V1.0.1.44_WW_src"
TCDIR="crosstools-gcc-4.6-linux-3.4-uclibc-0.9.32-binutils-2.21-sources"
TARTC="../${SOURCEDIR}/Source/${TCDIR}.tar.bz2"

# create compiled toolchain's root dir: the path cannot be modified
sudo mkdir /opt/toolchains
	if [ ! -d $SOURCEDIR ]; then
	./dl_sources.sh
		if [ $? != 0 ]; then
		echo "$0: script aborted"
		exit 1
		fi
	fi
# source dir includes the tar.bz2 toolchain to be built...
mkdir -p -m 0755 $TCDIR
cd $TCDIR
echo "Extracting crosstools from tar.bz2 archive..."
tar xjf $TARTC
chmod 755 src/build
# extract archives src/buildroot-2011.11/dl
cd src/buildroot-2011.11/dl
echo "Extracting crosstools before patching..."
tar xjf autoconf-2.65.tar.bz2
tar xjf gcc-4.6.2.tar.bz2
tar xjf gdb-7.3.1.tar.bz2
tar xjf m4-1.4.15.tar.bz2
tar xjf uClibc-0.9.32.tar.bz2
# remove old archives
rm -f autoconf-2.65.tar.bz2 gcc-4.6.2.tar.bz2 gdb-7.3.1.tar.bz2 m4-1.4.15.tar.bz2 uClibc-0.9.32.tar.bz2
cd ../../../..
# apply patch
patch -p0 < diffs/crosstools-gcc-4.6-linux-3.4-uclibc-0.9.32-binutils-2.21-sources.diff
# repack them all
cd $TCDIR/src/buildroot-2011.11/dl
echo "Repacking crosstools after patching..."
tar cjf autoconf-2.65.tar.bz2 autoconf-2.65
tar cjf gcc-4.6.2.tar.bz2 gcc-4.6.2
tar cjf gdb-7.3.1.tar.bz2 gdb-7.3.1
tar cjf m4-1.4.15.tar.bz2 m4-1.4.15
tar cjf uClibc-0.9.32.tar.bz2 uClibc-0.9.32
# dir cleanup
rm -Rf autoconf-2.65 gcc-4.6.2 gdb-7.3.1 m4-1.4.15 uClibc-0.9.32
cd ../../../..
echo
echo "Ready to start:"
echo "cd $TCDIR"
echo "type e.g.: sudo make"
echo
