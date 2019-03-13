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
# Original & work-thirdparty sources download & extract.
#
# Usage: $0 <destination_dir> <remote_www_url> <(arch)filename>
#
# if $DSTDIR existing do nothing
# if $DSTDIR not existing search for $SRCFILE
# if $SRCFILE existing extract it
# if $SRCFILE not existing download it then extract it
#

ERR=0

UNZIP() {										#check integrity and unzip: set error exit code
zip -T "${2}" && echo "Extracting: \"${2}\" ..." && unzip -qq "${2}"
ERR=$?
	if [ -f "${1}.tar.gz" ]; then							#.zip archive may include another
	UNTARGZ "${1}.tar.gz"
	rm -f "${1}.tar.gz"								#remove temporary one
	fi
	if [ -f "${1}.tgz" ]; then
	UNTARGZ "${1}.tgz"
	rm -f "${1}.tgz"
	fi
	if [ -f "${1}.tar.bz2" ]; then
	UNTARBZ2 "${1}.tar.bz2"
	rm -f "${1}.tar.bz2"
	fi
}

UNTARGZ() {										#check integrity and untar gz: set error exit code
tar xzf "${1}" -O > /dev/null 2>&1 && echo "Extracting: \"${1}\" ..." && tar xzf "${1}"
ERR=$?
}

UNTARBZ2() {										#check integrity and untar bz2: set error exit code
tar xjf "${1}" -O > /dev/null 2>&1 && echo "Extracting: \"${1}\" ..." && tar xjf "${1}"
ERR=$?
}

	case $# in									#Makefile param check compatibility
	1|2)										#no download needed
	DSTDIR="${1}"
	URL="void"
	SRCFILE="void"
	;;
	3)										#standard usage
	DSTDIR="${1}"
	URL="${2}"
	SRCFILE="${3}"
	;;
	*)										#too params: show usage
	DSTDIR=""
	ERR=1
	echo "Usage: $0 <destination_dir> <remote_www_url> <(arch)filename>"
	;;
	esac
	if [ ! -d $DSTDIR ]; then
	echo "$DSTDIR not present"
		if [ ! -f "${SRCFILE}" ]; then						#avoid dir overwritings
		echo "\"${SRCFILE}\" not present"
			case $URL in
			http*|ftp*|sftp*)						#download from http/ftp
			echo "Downloading: ${URL}/\"${SRCFILE}\" ..."
			wget ${URL}/"${SRCFILE}"					#set error flag on download error
			ERR=$?
			;;
			void)								#no need to copy or dload anything (own sources)
			;;
			*)								#local copy (typically from orig sources)
			echo "Copying local: ${URL}/\"${SRCFILE}\" ..."
			cp -rf "${URL}/${SRCFILE}" ./${DSTDIR}
			ERR=$?								#set error flag on copy error
			;;
			esac
		fi
		case "${SRCFILE}" in							#extract archive
		*.zip)
		UNZIP $DSTDIR "${SRCFILE}"
		;;
		*.tar.gz|*.tgz)
		UNTARGZ "${SRCFILE}"
		;;
		*.tar.bz2)
		UNTARBZ2 "${SRCFILE}"
		;;
		*.sh)									#move script only
		mv -f "${SRCFILE}" $DSTDIR
		ERR=$?
		;;
		*)
		;;
		esac
	[ $ERR -ne 0 ] && echo "Unable to obtain $DSTDIR"
	fi
exit $ERR

