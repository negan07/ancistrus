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
# Startup script: initialize router for package installations.
#
# Usage: $0 (<url>)
#
# <url> is optional and to be used only if remote url is different from the built-in one.
# This script can be executed once and only once and it should be deleted after being run successfully.
#
# web-login the router and enable debug mode: http://${ROUTERLANIP}/setup.cgi?todo=debug
# telnet the router (login: root):
# cd /etc
# curl -k -O https://raw.githubusercontent.com/negan07/ancistrus/gh-pages/scripts/debug/startup.sh
# chmod 755 startup.sh
# ./startup.sh
# Follow the instructions on terminal.
#

ETCDIR=/etc
USRETCDIR=/usr${ETCDIR}
DESTDIR=/usr/sbin
BIN=opkg
RCS=rcS
OPKG=${ETCDIR}/${BIN}
CONF=${OPKG}.conf
ARC=${OPKG}.zip
ABSARC=${BIN}.zip
WWW=/www
LANGSDIR=${WWW}/langs
OPKGISDIR=/usr/lib/${BIN}
LANGPART=language_TUR
PART="mtd:${LANGPART}"
ROMRCS=${USRETCDIR}/${RCS}
RAMRCS=${ETCDIR}/${RCS}
ME=startup.sh

URL=https://raw.githubusercontent.com/negan07/ancistrus/gh-pages/tools/debug

[ ! -z "$1" ] && URL=$1

[ -x ${DESTDIR}/${BIN} ] && echo "${BIN} looks already installed." && exit 5
cd ${ETCDIR}
rm -f ${OPKG} ${CONF} ${ARC}
echo "Cleaning up some garbage files..."
find /opt -type d -name .svn -exec rm -rf '{}' \; > /dev/null 2>&1
find ${WWW}/cgi-bin -type d -name .svn -exec rm -rf '{}' \; > /dev/null 2>&1
rm -f ${USRETCDIR}/${RCS}.MT ${DESTDIR}/reaim ${WWW}/*DGND*.jpg ${LANGSDIR}/ENU/*.gz
	for D in `ls ${LANGSDIR}/GW`
	do
	[ -d ${LANGSDIR}/GW/${D} ] && rm -f ${LANGSDIR}/GW/${D}/*.gz
	done
echo "Downloading & extracting: ${ARC} ..."
curl -k -O ${URL}/${ABSARC}
unzip ${ARC}
	if [ $? -ne 0 -o ! -f ${OPKG} -o ! -f ${CONF} ]; then
	echo "Problem has occurred: check either connection or download urls."
	exit 4
	fi
chmod 755 ${OPKG}
chmod 644 ${CONF}
echo "Mounting opkg info & status files partition..."
[ ! -d ${OPKGISDIR} ] && mkdir -m 0777 ${OPKGISDIR}
umount ${OPKGISDIR} > /dev/null 2>&1
umount /config/${LANGPART} > /dev/null 2>&1
mount -n -t jffs2 ${PART} ${OPKGISDIR}
	if [ $? -ne 0 -o ! -d ${OPKGISDIR} ]; then
	echo "Problem has occurred: partition not mounted."
	exit 3
	fi
${OPKG} update && sleep 1 && ${OPKG} install ${BIN}
	if [ $? -ne 0 -o ! -x ${DESTDIR}/${BIN} ]; then
	echo "${BIN} installation failed: check repository urls on ${CONF}"
	exit 2
	fi
rm -f ${OPKG} ${ARC}
echo
echo "Updating ${ROMRCS} ..."
echo "mount -n -t jffs2  \"mtd:${LANGPART}\" ${OPKGISDIR}" >> ${ROMRCS}
	if [ "$( head -n $(( `wc -l ${ROMRCS} | awk '{printf $1;}'` - 1 )) ${ROMRCS} )" != "$( head -n `wc -l ${RAMRCS} | awk '{printf $1;}'` ${RAMRCS} )" ]; then
	echo "${RCS} update failed: reverting to original ${RCS} ..."
	cp -f ${RAMRCS} ${ROMRCS}
	exit 1
	fi
echo
echo "This script can now be deleted: type 'rm ${ETCDIR}/${ME}'"
exit 0

