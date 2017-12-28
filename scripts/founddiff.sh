#!/bin/sh
#
# ancistrus
#
# Netgear's D7000 Nighthawk Router Experience Distributed Project
#
# https://github.com/negan07/ancistrus
#
# License: GPLv2
#
#
# Found diffs between 2 different firmware version source dirs.
#
# Usage: $0 <absdir1> <absdir2>
#
# To be used before migrating code from old to new firmware version or to prepare some .diff patches.
# Parameters must be absolute dirs.
# Destination dir tree starts from the git root source dir.
# Suppose source dir structures to be similar (if not, edit this).
#

LISTDIR="Kernel/bcm963xx/kernel/linux-3.4rt Kernel/bcm963xx/bcmdrivers Kernel/bcm963xx/hostTools Kernel/bcm963xx/shared Kernel/bcm963xx/targets Kernel/bcm963xx Source/apps Source/Builds Source/image Source/shared Source/target Source/uClibc-0.9.32 Source Makefile"

cd ..
[ $# -ne 2 ] && echo "Usage: $0 <absdir1> <absdir2>" && exit 1

for DIR in $*
do
	case $DIR in
	/*)
	[ ! -d $DIR ] && echo "$DIR not a dir" && exit 2
	;;
	*)
	echo "$DIR not an absdir" && exit 3
	;;
	esac
done

TAG=`sudo echo ${1##*/} | cut -d '_' -f 1`_`echo ${1##*/} | cut -d '_' -f 2`

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
			case $I in
			apple)
			mkdir -p -m 0755 $DESTDIR/$D/$I
				for A in `ls $1/$D/$I`
				do
				diff -urN $1/$D/$I/$A $2/$D/$I/$A > $DESTDIR/$D/$I/${TAG}_apps_${I}-000-${A}.diff
				done
			;;
			mediaserver)
			mkdir -p -m 0755 $DESTDIR/$D/$I
				for M in `ls $1/$D/$I`
				do
					case $M in
					library)
						for L in `ls $1/$D/$I/$M`
						do
						diff -urN $1/$D/$I/$M/$L $2/$D/$I/$M/$L > $DESTDIR/$D/$I/${TAG}_apps_${I}-000-${M}_${L}.diff
						done
					;;
					*)
					diff -urN $1/$D/$I/$M $2/$D/$I/$M > $DESTDIR/$D/$I/${TAG}_apps_${I}-000-${M}.diff
					;;
					esac
				done
			;;
			Makefile)
			diff -uN $1/$D/$I $2/$D/$I > $DESTDIR/$D/${TAG}_misc-004-source_apps_makefile_cleanups_adaptations.diff
			;;
			*)
			mkdir -p -m 0755 $DESTDIR/$D/$I
			diff -urN $1/$D/$I $2/$D/$I > $DESTDIR/$D/$I/${TAG}_apps_${I}-000-all.diff
			;;
			esac
		done
	;;
	Source/target)
	sudo tar xjf $1/$D.tar.bz2 -C $1/Source
	sudo tar xjf $2/$D.tar.bz2 -C $2/Source
	diff -urN $1/$D $2/$D > $DESTDIR/$D.diff
	;;
	Source)
	rm -f $1/$D/crosstools-*.tar.bz2 $2/$D/crosstools-*.tar.bz2
	diff -uN $1/$D $2/$D > $DESTDIR/$D.diff
	;;
	Makefile|Kernel/bcm963xx)	
	diff -uN $1/$D $2/$D > $DESTDIR/$D.diff
	;;
	*)
	diff -urN $1/$D $2/$D > $DESTDIR/$D.diff
	;;
	esac
done

