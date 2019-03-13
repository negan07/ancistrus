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

DSLINFO=/tmp/ancdslinfo
LISTUPGR=/tmp/opkg/list-upgradable

xdslctl info --version 2>${DSLINFO}					#xdslctl uses stderr for drv version show
xdslctl info --vendor >>${DSLINFO}					#append vendor
xdslctl info --vectoring | grep Vectoring >>${DSLINFO}			#vectoring state
for G in Profile SNR Attn Pwr; do xdslctl info --stats | grep $G >>${DSLINFO}; done
eval `nvram get anc_upgr_disable` >/dev/null 2>&1			#perform rep update
	if [ "$anc_upgr_disable" != "1" -a -x /usr/sbin/opkg ]; then
	ping -4 -c 1 -w 1 -W 1 -q `cat /usr/etc/opkg.conf | grep "src/gz " | grep -v "#" | head -n 1 | awk '{printf $3}' | cut -f 3- -d "/" | cut -f 1 -d "/"` >/dev/null 2>&1					#test if main rep is up
		if [ $? -eq 0 ]; then					#ping is good update rep
		opkg update >/dev/null 2>&1
		opkg list-upgradable >${LISTUPGR}			#opkg not creating a file list-upgradable so redir the output
		fi
	fi
exit 0
