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
# Source code modifications.
#
# Usage: $0 <prj_name> <fw_ver> <diff_dir> <diffdircontainer>
#
# This script starts working from the git root source dir.
# It must be invoked from the script source dir.
# .diff patches must be located in $DIFFDIR dir.
# Destination dir must be present.
#

ALL="misc kernel uclibc"
ERR=0

DIRPATCH() {								#patch into a single dir/subdir
TAG=`echo $1 | sed s/'\/'/_/`
[ -d ${DIFFDIR}/${1} ] && FLIST=`ls ${DIFFDIR}/${1}`			#recursive Makefile compatibility
[ -z "$FLIST" ] && return
echo "Applying patch on $1 ..."
	for F in $FLIST
	do
		case $F in
		${PROJECT}_${FWVER}_${TAG}-*-*.diff)
		patch -p0 < ${DIFFDIR}/${1}/${F}
		[ $? -ne 0 ] && ERR=1 && return				#set error flag on patch error only
		;;
		*)
		;;
		esac
	done
}

TREEPATCH() {								#patch into a tree dir
[ -d ${DIFFDIR}/${1} ] && DLIST=`ls ${DIFFDIR}/${1}`			#recursive Makefile compatibility
[ -z "$DLIST" ] && return
echo "Applying patch on $1 ..."
	for D in $DLIST
	do
	DIRPATCH $1/$D
	[ $ERR -eq 1 ] && return					#abandon loop in case of patch error
	done
}

PROJECT=$1								#save params
FWVER=$2
DIFFDIR=$3
[ -z "$DIFFDIR" ] && DIFFDIR=diffs
cd ..
[ $# -lt 4 ] && echo "Usage: $0 <prj_name> <fw_ver> <diff_dir> all" `ls -A ${DIFFDIR}` && exit 1
shift;shift;shift;							#throw first 3 params

case $1 in
crosstools)								#toolchain patch
OLDFWVER=$FWVER
FWVER=""
DIRPATCH $1
FWVER=$OLDFWVER
;;
all)									#original sources patch
	for D in $ALL
	do
	DIRPATCH $D
	done
TREEPATCH apps
;;
apps|work)								#apps/work all or single app/work patch
	if [ -z "$2" ]; then
	TREEPATCH $1
	else
	DIRPATCH ${1}/${2}
	fi
;;
*)									#single dir patch
DIRPATCH $1
;;
esac
exit $ERR
