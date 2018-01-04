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
# Usage: $0 (<url>) (<script_url>)
#
# <url> <script_url> are optionally used only if remote urls are different from the built-in one.
# This script can be executed once and only once and it should be deleted after being run successfully.
#
# web-login the router and enable debug mode: http://${ROUTERLANIP}/setup.cgi?todo=debug
# telnet the router (login: root):
# cd /etc
# curl -k -O https://raw.githubusercontent.com/negan07/ancistrus/master/scripts/startup.sh
# chmod 755 startup.sh
# ./startup.sh
# Follow the instructions on terminal.
#

ETCDIR=/etc
USRETCDIR=/usr${ETCDIR}
BINDIR=/usr/sbin
BIN=opkg
RCS=rcS
RCSANC=${RCS}.anc
RCSORIG=${RCS}.orig
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
ROMRCSANC=${USRETCDIR}/${RCSANC}
RAMRCSANC=${ETCDIR}/${RCSANC}
ROMRCSORIG=${USRETCDIR}/${RCSORIG}
NOLOGIN=${ETCDIR}/nologin
ME=${ETCDIR}/startup.sh

URL=https://raw.githubusercontent.com/negan07/ancistrus/gh-pages/tools/ancistrus-arm-D7000
[ ! -z "$1" ] && URL=$1

SCRURL=https://raw.githubusercontent.com/negan07/ancistrus/master/scripts
[ ! -z "$2" ] && SCRURL=$2

[ -x ${BINDIR}/${BIN} ] && echo "${BIN} looks already installed." && exit 6

cd ${ETCDIR}
echo "Cleaning up some garbage files..."
[ ! -z `pidof telnetenabled` ] && killall -9 telnetenabled
find /opt -type d -name .svn -exec rm -rf '{}' \; > /dev/null 2>&1
find ${WWW}/cgi-bin -type d -name .svn -exec rm -rf '{}' \; > /dev/null 2>&1
rm -f ${USRETCDIR}/${RCS}.MT ${BINDIR}/reaim ${BINDIR}/telnetenabled ${WWW}/*DGND*.jpg ${LANGSDIR}/ENU/*.gz ${OPKG} ${CONF} ${ARC}
	for D in `ls ${LANGSDIR}/GW`
	do
	[ -d ${LANGSDIR}/GW/${D} ] && rm -f ${LANGSDIR}/GW/${D}/*.gz
	done
echo
echo "Downloading & extracting: ${ARC} ..."
curl -k -O ${URL}/${ABSARC}
unzip ${ARC}
	if [ $? -ne 0 -o ! -f ${OPKG} -o ! -f ${CONF} ]; then
	echo "Problem has occurred: check either connection or download urls."
	exit 5
	fi
chmod 755 ${OPKG}
chmod 644 ${CONF}
echo
echo "Mounting opkg info & status files partition..."
[ ! -d ${OPKGISDIR} ] && mkdir -m 0777 ${OPKGISDIR}
umount ${OPKGISDIR} > /dev/null 2>&1
umount /config/${LANGPART} > /dev/null 2>&1
mount -n -t jffs2 ${PART} ${OPKGISDIR}
	if [ $? -ne 0 -o ! -d ${OPKGISDIR} ]; then
	echo "Problem has occurred: opkg partition not mounted."
	exit 4
	fi
rm -rf ${OPKGISDIR}/*
echo
echo "Updating console login passwd..."
eval `nvram get http_password`
echo "root:${http_password}" | chpasswd
echo "nobody:${http_password}" | chpasswd
touch ${NOLOGIN}
echo
echo "Starting ${BIN} ..."
${OPKG} update && sleep 1 && ${OPKG} install ${BIN}
	if [ $? -ne 0 -o ! -x ${BINDIR}/${BIN} ]; then
	echo "${BIN} installation failed: check repository urls on ${CONF}"
	exit 3
	fi
rm -f ${OPKG} ${ARC}
echo
echo "Downloading auxiliary boot script ${RCSANC} ..."
curl -k -O ${SCRURL}/${RCSANC}
chmod 755 ${RCSANC}
cp ${RCSANC} ${USRETCDIR}
	if [ $? -ne 0 -o ! -x ${ROMRCSANC} ]; then
	echo "Problem has occurred: check either connection or download urls."
	exit 2
	fi
echo
echo "Updating ${ROMRCS} ..."
[ ! -f ${ROMRCSORIG} ] && cp -f ${ROMRCS} ${ROMRCSORIG}
echo >> ${ROMRCS}
echo "# ancistrus" >> ${ROMRCS}
echo "${RAMRCSANC}" >> ${ROMRCS}
	if [ "$( head -n $(( `wc -l ${ROMRCS} | awk '{printf $1;}'` - 3 )) ${ROMRCS} )" != "$( head -n `wc -l ${RAMRCS} | awk '{printf $1;}'` ${RAMRCS} )" ]; then
	echo "${RCS} update failed: reverting to original ${RCS} ..."
	cp -f ${RAMRCS} ${ROMRCS}
	exit 1
	fi
echo
echo "This script can now be deleted: type 'rm ${ME}'"
exit 0

