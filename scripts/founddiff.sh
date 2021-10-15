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
# Found diffs between 2 different firmware version source dirs.
#
# Usage: $0 <absdir1> <absdir2>
#
# To be used before migrating code from old to new firmware version or to prepare some .diff patches.
# Parameters must be absolute dirs.
# Destination dir tree starts from the git root source dir.
# Suppose source dir structures to be similar (if not, edit this).
#

LISTDIR="Kernel/bcm963xx/kernel/linux-3.4rt Kernel/bcm963xx/kernel Kernel/bcm963xx/bcmdrivers Kernel/bcm963xx/hostTools Kernel/bcm963xx/shared Kernel/bcm963xx/targets Kernel/bcm963xx Source/apps Source/Builds Source/image Source/shared Source/target Source/uClibc-0.9.32 Source Makefile"

run_diff() {

[ $# -ne 4 ] && echo "run_diff(): missed diff params. Usage: run_diff <u(r)> <old> <new> <dest>" && exit 4

diff -${1} -x '*.lo' -x '*.Po' -x '*.po' -x '*.Plo' -x '*.o' -x '*.d' -x '*.a' -x '*.la' -x '*.lai' -x '*.so*' -x '*.pc' -x '*.spec' -x '*.dep' -x '*.mod' -x '.patched' -x '.compiled' -x 'config.h' -x 'autoconf.h' -x 'compile.h' -x 'auto.conf' -x 'config.log' -x 'config.status' -x 'config.fate' -x 'config.h.in' -x 'configure' -x 'Module.symvers' -x 'modules.order' -x 'entries' -x 'scanner.c' -x 'cfg_l.c' -x 'requests' -x 'md5' -x 'kernel_cksum' $2 $3 > $4 2>/dev/null
[ ! -s $4 ] && rm -f $4
}

rm_void_dir() {

[ -z "${1}" ] && echo "rm_void_dir(): dir name missed" && exit 5

[ -d "${1}" ] && [ "`echo "${1}/"*`" = "${1}/*" ] && rmdir "${1}"
}

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

TAG=`sudo echo ${2##*/} | cut -d '_' -f 1`_`echo ${2##*/} | cut -d '_' -f 2`

DESTDIR="diff-${1##*/}-${2##*/}"

mkdir -p -m 0755 $DESTDIR

for D in $LISTDIR
do
	case $D in
	Kernel/bcm963xx/kernel/linux-3.4rt)
	mkdir -p -m 0755 "$DESTDIR/$D"
	run_diff pur "$1/$D" "$2/$D" "$DESTDIR/$D.diff"
	rm_void_dir "$DESTDIR/$D"
	;;
	Kernel/bcm963xx/kernel)
	run_diff pu "$1/$D" "$2/$D" "$DESTDIR/$D.diff"
	rm_void_dir "$DESTDIR/$D"
	;;
	Source/apps)
	mkdir -p -m 0755 "$DESTDIR/$D"
		for I in `ls "$1/$D"`
		do
			case $I in
			apple)
			mkdir -p -m 0755 "$DESTDIR/$D/$I"
				for A in `ls "$1/$D/$I"`
				do
				run_diff pur "$1/$D/$I/$A" "$2/$D/$I/$A" "$DESTDIR/$D/$I/${TAG}_apps_${I}-000-${A}.diff"
				done
			rm_void_dir "$DESTDIR/$D/$I"
			;;
			mediaserver)
			mkdir -p -m 0755 "$DESTDIR/$D/$I"
				for M in `ls "$1/$D/$I"`
				do
					case $M in
					library)
						for L in `ls "$1/$D/$I/$M"`
						do
						run_diff pur "$1/$D/$I/$M/$L" "$2/$D/$I/$M/$L" "$DESTDIR/$D/$I/${TAG}_apps_${I}-000-${M}_${L}.diff"
						done
					;;
					*)
					run_diff pur "$1/$D/$I/$M" "$2/$D/$I/$M" "$DESTDIR/$D/$I/${TAG}_apps_${I}-000-${M}.diff"
					;;
					esac
				done
			rm_void_dir "$DESTDIR/$D/$I"
			;;
			Makefile)
			run_diff pu "$1/$D/$I" "$2/$D/$I" "$DESTDIR/$D/${TAG}_misc-004-source_apps_makefile_cleanups_adaptations.diff"
			;;
			*)
			mkdir -p -m 0755 "$DESTDIR/$D/$I"
			run_diff pur "$1/$D/$I" "$2/$D/$I" "$DESTDIR/$D/$I/${TAG}_apps_${I}-000-all.diff"
			rm_void_dir "$DESTDIR/$D/$I"
			;;
			esac
		done
	rm_void_dir "$DESTDIR/$D"
	;;
	Source/target)
	for T in $*; do sudo tar xjf "$T/$D.tar.bz2" -C $T/Source; done
	run_diff pur "$1/$D" "$2/$D" "$DESTDIR/$D.diff"
	;;
	Source)
	rm -f "$1/$D/crosstools-*.tar.bz2" "$2/$D/crosstools-*.tar.bz2"
	run_diff pu "$1/$D" "$2/$D" "$DESTDIR/$D.diff"
	;;
	Makefile|Kernel/bcm963xx)	
	run_diff pu "$1/$D" "$2/$D" "$DESTDIR/$D.diff"
	;;
	*)
	run_diff pur "$1/$D" "$2/$D" "$DESTDIR/$D.diff"
	;;
	esac
done

rm_void_dir $DESTDIR

exit 0
