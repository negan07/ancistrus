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

#xdslctl uses stderr for drv version show

xdslctl info --version 2>/tmp/ancdslinfo			#redirect stderr to tmp file
xdslctl info --vendor >>/tmp/ancdslinfo				#append vendor
xdslctl info --vectoring | grep Vectoring >>/tmp/ancdslinfo	#vectoring state
xdslctl info --show | grep Profile >>/tmp/ancdslinfo		#vdsl profile
opkg update >/dev/null 2>&1					#opkg not creating a list-upgradable file
opkg list-upgradable >/tmp/opkg/list-upgradable

exit 0
