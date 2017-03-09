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
# Found diffs between 2 different firmware version source dirs.
#
# Usage: $0 <absdir1> <absdir2>
#
# To be used before migrating code from old to new firmware version.
# Parameters must be absolute dirs.
# Suppose source dir structure to be similar (if not, edit this).
#

LISTDIR="Kernel/bcm963xx/kernel/linux-3.4rt Kernel/bcm963xx/bcmdrivers Kernel/bcm963xx/hostTools Kernel/bcm963xx/shared Kernel/bcm963xx/targets Kernel/bcm963xx Source/apps Source/Builds Source/image Source/shared Source/uClibc-0.9.32 Source Makefile"

if [ $# != 2 ]; then
echo "Usage: $0 <absdir1> <absdir2>"
exit 1
fi

for DIR in $*
do
	case $DIR in
	/*)
		if [ ! -d $DIR ]
		then echo "$DIR not a dir"
		exit 2
		fi
	;;
	*)
	echo "$DIR not an absdir"
	exit 3
	;;
	esac
done

DESTDIR=diff-${1##*/}-${2##*/}
mkdir -p -m 0755 $DESTDIR

for D in $LISTDIR
do
	case $D in
	Kernel/bcm963xx/kernel/linux-3.4rt)
	mkdir -p -m 0755 $DESTDIR/$D
	diff -urN $1/$D $2/$D > $DESTDIR/$D.diff
	;;
	Source/apps)
	mkdir -p -m 0755 $DESTDIR/$D
		for I in `ls $1/$D`
		do
		diff -urN $1/$D/$I $2/$D/$I > $DESTDIR/$D/$I.diff
		done
	;;
	Makefile|Kernel/bcm963xx|Source)	
	diff -uN $1/$D $2/$D > $DESTDIR/$D.diff
	;;
	*)
	diff -urN $1/$D $2/$D > $DESTDIR/$D.diff
	;;
	esac
done

