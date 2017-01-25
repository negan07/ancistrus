#!/bin/sh
#
# Apply all-in one firmware modifications.
# This script must be located in the root source dir.
#

RECUR=`readlink -f $0`

for F in `ls`
do
	if [ -d $F ]; then
	cd $F
	$RECUR
	else
		case $F in
		*.diff)
		patch -p0 < $F
		;;
		*)
		;;
		esac
	fi
done

