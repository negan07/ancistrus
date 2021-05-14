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
# Prepare some infos for web gui homepage.
#
# Usage: $0 >/dev/null
#

BINDIR=/usr/sbin/
CONFDIR=/usr/etc/

DSLINFO=/tmp/ancdslinfo
LISTUPGR=/tmp/opkg/list-upgradable
OPKGBIN=${BINDIR}/opkg
OPKGCONF=${CONFDIR}/opkg.conf
ERR=0

xdslctl info --version 2>${DSLINFO}					#xdslctl uses stderr for drv version show
xdslctl info --vendor >>${DSLINFO}					#append vendor
xdslctl info --vectoring | grep Vectoring >>${DSLINFO}			#vectoring state
for G in Profile SNR Attn Pwr; do xdslctl info --stats | grep $G >>${DSLINFO}; done
	if [ "`anc nvram drget anc_upgr_disable 0`" != "1" -a -x ${OPKGBIN} -a -r ${OPKGCONF} ]; then	#perform rep update
	opkg update >/dev/null 2>&1
	ERR=$?
	opkg list-upgradable >${LISTUPGR}				#opkg not creating a file list-upgradable so redir the output
	fi
exit $ERR
