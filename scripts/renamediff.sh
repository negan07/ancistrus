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
# Rename $DIFFDIR .diff patches from old firmware version number to new one.
#
# Usage: $0 <oldfwvernum> <newfwvernum>
#
# This script starts working from $DIFFDIR source dir.
# It must be invoked from the script source dir.
# .diff patches must be located in $DIFFDIR dir.
# To be used when migrating .diff patches from old to new firmware version.
# Parameters must be version numbers like '1.0.1.50' .
# If oldfwvernum is wrong no change will be made on filenames.
# $DIFFDIR dir must be present.
#

DIFFDIR="diffs"

[ ! -d ../${DIFFDIR} ] && echo "${DIFFDIR} not present" && exit 1
cd ../${DIFFDIR}
[ $# -ne 2 ] && echo "Usage: $0 <oldfwvernum> <newfwvernum>" && exit 2

for N in "${1}" "${2}"
do
	case $N in
	[0-9].[0-9].[0-9].[0-99]*)							#tiny check
	;;
	*)
	echo "$N must be in the form 'num.num.num.num" && exit 3
	;;
	esac
done

echo "Renaming patches from 'V${1}' to 'V${2}' version number..."
find . -name "*V${1}*" -type f -print0 | xargs -0 -I {} sh -c 'mv "{}" "$(dirname "{}")/`echo $(basename "{}") | sed 's/V${1}/V${2}/g'`"'

