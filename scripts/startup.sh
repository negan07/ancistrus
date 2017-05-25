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
# curl -k -O https://raw.githubusercontent.com/negan07/ancistrus/master/scripts/startup.sh
# chmod 755 startup.sh
# ./startup.sh
# Follow the instructions on terminal.
#

DIR=/etc
DESTDIR=/usr/sbin
BIN=opkg
OPKG=${DIR}/${BIN}
CONF=${OPKG}.conf
ARC=${OPKG}.zip
ABSARC=${BIN}.zip
WWW=/www
LANGSDIR=${WWW}/langs

URL=https://raw.githubusercontent.com/negan07/ancistrus/gh-pages/tools/ancistrus-arm-D7000

[ ! -z "$1" ] && URL=$1

[ -x ${DESTDIR}/${BIN} ] && echo "${BIN} looks already installed." && exit 3
cd $DIR
rm -f ${OPKG} ${CONF} ${ARC}
echo "Cleaning up some garbage files..."
find /opt -type d -name .svn -exec rm -rf '{}' \; > /dev/null 2>&1
find ${WWW}/cgi-bin -type d -name .svn -exec rm -rf '{}' \; > /dev/null 2>&1
rm -f ${WWW}/*DGND*.jpg ${LANGSDIR}/ENU/*.gz
	for D in `ls ${LANGSDIR}/GW`
	do
	[ -d ${LANGSDIR}/GW/${D} ] && rm -f ${LANGSDIR}/GW/${D}/*.gz
	done
echo "Downloading & extracting: ${ARC} ..."
curl -k -O ${URL}/${ABSARC}
unzip ${ARC}
	if [ $? -ne 0 -o ! -f ${OPKG} -o ! -f ${CONF} ]; then
	echo "Problem has occurred: check either connection or download urls."
	exit 2
	fi
chmod 755 ${OPKG}
chmod 644 ${CONF}
${OPKG} update
${OPKG} install $BIN
	if [ $? -ne 0 -o ! -x ${DESTDIR}/${BIN} ]; then
	echo "${BIN} installation failed: check repository urls on ${CONF}"
	exit 1
	fi
rm -f ${OPKG} ${ARC}
echo "This script can now be deleted: type 'rm ${DIR}/startup.sh'"
exit 0

