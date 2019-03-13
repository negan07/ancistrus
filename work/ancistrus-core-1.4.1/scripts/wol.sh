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
# Invoke Wake On Lan `ether-wake` busybox applet cmd and output response.
#
# Usage: $0 (-p <4/6_bytes_password_if_needed>) <mac_address>
#

BINDIR=/usr/sbin
WAKECMDNAME=ether-wake
WAKECMD=${BINDIR}/${WAKECMDNAME}

LANIF=`anc nvram rget lan_if`
[ -z "${LANIF}" ] && LANIF=group1

eval MAC=\${$#}

[ ! -e ${WAKECMD} ] && echo "${WAKECMDNAME} applet not present: upgrade/install busybox package to obtain it" && echo "Type: 'opkg update && opkg install busybox'" && exit 2

${WAKECMD} -b -i ${LANIF} "$@"
ERR=$?

[ $ERR -ne 0 ] && echo "${WAKECMDNAME}: error (${ERR}) occurred sending WOL magic packet to ${MAC}" || echo "${WAKECMDNAME}: WOL magic packet sent to ${MAC}"

exit $ERR
