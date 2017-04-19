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
BIN=opkg
OPKG=${DIR}/${BIN}
CONF=${OPKG}.conf
ARC=${OPKG}.zip
ABSARC=${BIN}.zip

URL=https://raw.githubusercontent.com/negan07/ancistrus/gh-pages/tools

[ ! -z "$1" ] && URL=$1

cd $DIR
echo "Downloading & extracting: ${ARC} ..."
curl -k -O ${URL}/${ABSARC}
unzip ${ARC}
	if [ $? -ne 0 -o ! -f ${OPKG} -o ! -f ${CONF} ]; then
	echo "Problem has occurred: check either connection or download urls."
	exit 1
	fi
chmod 755 ${OPKG}
chmod 644 ${CONF}
${OPKG} update
${OPKG} install $BIN
	if [ $? -ne 0 -o ! -x /usr/sbin/${BIN} ]; then
	echo "${BIN} installation failed: check repository urls on ${CONF}"
	exit 2
	fi
rm -f ${OPKG} ${ARC}
exit 0

