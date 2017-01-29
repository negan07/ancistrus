#!/bin/sh
#
# D7000 source modifications.
# This script must be located in the root source dir.
# .diff patches must be located in $DIFFDIR dir.
#

PROJECT=D7000
DIFFDIR=diffs

	for F in `ls ${DIFFDIR}`
	do
		case $F in
		${PROJECT}*.diff)
		patch -p0 < ${DIFFDIR}/$F
		;;
		*)
		;;
		esac
	done

