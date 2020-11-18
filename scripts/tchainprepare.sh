#!/bin/sh
#
# ancistrus
#
# Netgear's D7000 (V1) Nighthawk Router Experience Distributed Project
#
# https://github.com/negan07/ancistrus
#
# License: GPLv2
#
#
# Toolchain crosstools extract & patch.
#
# Usage: $0 <prj_name> <fw_ver> <diff_dir> <source_dir> <crosstools_dir> <crosstools_tar> <inst_dir> <src_buildroot_dl_dir>
#
# This script starts working from the git root source dir.
# It must be invoked from the script source dir.
#

# parameters check
[ $# -ne 8 ] \
&& echo "Usage: $0 <prj_name> <fw_ver> <diff_dir> <source_dir> <crosstools_dir> <crosstools_tar> <inst_dir> <src_buildroot_dl_dir>" \
&& exit 1
# var assignements
PROJECT="$1"
FWVER="$2"
DIFFDIR="$3"
SOURCEDIR="$4"
TCDIR="$5"
TARTC="$6"
INSTDIR="$7"
BRDLDIR="$8"
PKGS="autoconf-2.65 automake-1.11.1 gcc-4.6.2 gdb-7.3.1 m4-1.4.15 uClibc-0.9.32"
# create compiled toolchain's root dir: the path cannot be modified
sudo mkdir -p -m 0755 $INSTDIR
# searching for source dir...
[ ! -d $SOURCEDIR ] && echo "Can't find ${SOURCEDIR} . Type: make download_sources to download sources" && exit 2
# avoid applying patch again...
[ -d $TCDIR ] && exit 0
# source dir includes the tar.bz2 toolchain to be built...
mkdir -p -m 0755 $TCDIR
cd $TCDIR
echo "Extracting crosstools from tar.bz2 archive..."
tar xjf ../${TARTC} || exit 3
chmod -f 755 src/build
chmod -f 644 src/*.config
# extract archives on dl dir
cd $BRDLDIR
echo "Extracting crosstools before patching..."
for P in ${PKGS}; do tar xjf ${P}.tar.bz2 || exit 3; done
# remove old archives
for P in ${PKGS}; do rm -f ${P}.tar.bz2; done
cd ../../../../scripts
# apply patches
./apply_patch.sh $PROJECT $FWVER $DIFFDIR crosstools
# repack them all
cd ../${TCDIR}/${BRDLDIR}
echo "Repacking crosstools after patching..."
for P in ${PKGS}; do tar cjf ${P}.tar.bz2 ${P} || exit 3; done
# dir cleanup
rm -Rf ${PKGS}
cd ../../../..
echo
echo "Ready to start:"
echo "type e.g.: sudo make toolchain"
echo
