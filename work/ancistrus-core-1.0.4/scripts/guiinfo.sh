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
# Prepare some infos for web gui homepage.
#
# Usage: $0 >/dev/null
#

xdslctl info --version 2>/tmp/ancdslinfo			#xdslctl uses stderr for drv version show
xdslctl info --vendor >>/tmp/ancdslinfo				#append vendor
xdslctl info --stats | grep Profile >>/tmp/ancdslinfo		#vdsl profile
xdslctl info --vectoring | grep Vectoring >>/tmp/ancdslinfo	#vectoring state
xdslctl info --stats | grep SNR >>/tmp/ancdslinfo		#snr dl/ul
xdslctl info --stats | grep Attn >>/tmp/ancdslinfo		#line att dl/ul
xdslctl info --stats | grep Pwr >>/tmp/ancdslinfo		#line pwr dl/ul
eval `nvram get anc_upgr_disable` >/dev/null 2>&1
	if [ "$anc_upgr_disable" != "1" ]; then			#update rep
	opkg update >/dev/null 2>&1
	opkg list-upgradable >/tmp/opkg/list-upgradable		#opkg not creating a file list-upgradable so redir the output
	fi
exit 0
