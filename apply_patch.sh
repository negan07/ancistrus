#!/bin/sh
#
# D7000 source modifications.
# This script must be located in the root source dir.
# It must be invoked from the root source dir.
# .diff patches must be located in $DIFFDIR dir.
#

PROJECT=D7000
FWVER=V1.0.1.44
DIFFDIR=diffs
ALL="misc kernel uclibc"

if [ $# -lt 1 ]; then
echo -n "$0 <all "
echo -n `ls ${DIFFDIR}`
echo " >"
exit 1
fi

DIRPATCH() {							#patch into a single dir/subdir
TAG=`echo $1 | sed s/'\/'/_/`
	for F in `ls ${DIFFDIR}/${1}`
	do
		case $F in
		${PROJECT}_${FWVER}_${TAG}-*-*.diff)
		patch -p0 < ${DIFFDIR}/${1}/${F}
		;;
		*)
		;;
		esac
	done
}

TREEPATCH() {							#patch into a tree dir
	for D in `ls ${DIFFDIR}/${1}`
	do
	DIRPATCH $1/$D
	done
}

case $1 in
crosstools)							#toolchain patch
OLDFWVER=$FWVER
FWVER=""
DIRPATCH $1
FWVER=$OLDFWVER
;;
all)								#sources patch
	for D in $ALL
	do
	DIRPATCH $D
	done
TREEPATCH apps
;;
apps|work)							#apps or single app patch
	if [ -z $2 ]; then
	TREEPATCH $1
	else
	DIRPATCH ${1}/${2}
	fi
;;
*)								#single dir patch
DIRPATCH $1
;;
esac

