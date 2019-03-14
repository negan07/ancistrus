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
# Startup script: initialize router for package installations.
#
# Usage: $0 (<url>)
#
# <url> parameter is optionally used only if remote urls are different from the built-in one.
# This script can be executed once and only once and it should be deleted after being run successfully.
#
# web-login the router and enable debug mode: http://${ROUTERLANIP}/setup.cgi?todo=debug
# telnet the router.
# login: 'admin' or 'root' on older firmwares.
# password: same as web gui interface.
#
# cd /etc
# curl -k -O https://raw.githubusercontent.com/negan07/ancistrus/master/scripts/startup.sh
# chmod 755 startup.sh
# ./startup.sh
# Follow the instructions on terminal.
#

ETCDIR=/etc
USRETCDIR=/usr${ETCDIR}
BINDIR=/usr/sbin
MNTDIR=/usr/lib/opkg
MNTPART=mtd20
MNTLANGPART=/config/language_TUR

BIN=opkg
OPKG=${ETCDIR}/${BIN}
CONF=${OPKG}.conf
OPKGCMD="${OPKG} -f ${CONF}"
ARC=${OPKG}.zip
ABSARC=${BIN}.zip
TOINST="zlib openssl curl ancistrus-core utelnetd ${BIN}"

WWW=/www
LANGSDIR=${WWW}/langs

URL=https://raw.githubusercontent.com/negan07/ancistrus/gh-pages/tools/ancistrus-arm-D7000
[ ! -z "$1" ] && URL=$1

[ "`system get dev_name 2>/dev/null`" != "D7000" ] || [ ! -x ${BINDIR}/xdslctl ] && echo "This script can be used with Netgear D7000 (V1) only" && exit 5
[ -x ${BINDIR}/${BIN} ] || mount | grep ${MNTPART} >/dev/null 2>&1 && echo "${BIN} looks already installed." && exit 4

cd ${ETCDIR}
echo "Cleaning up some garbage/orphan dirs & files..."
killall -9 telnetenabled >/dev/null 2>&1
for D in "/opt" "${WWW}/cgi-bin"; do find $D -type d -name .svn -exec rm -rf '{}' \; >/dev/null 2>&1; done
for D in "CSY" "TUR"; do find ${LANGSDIR} -type d -name $D -exec rm -rf '{}' \; >/dev/null 2>&1; done
find ${LANGSDIR} -type f -name *.gz -exec rm -f '{}' \; >/dev/null 2>&1
rm -f ${OPKG} ${CONF} ${ARC} ${USRETCDIR}/rcS.MT ${USRETCDIR}/prepare_3g ${BINDIR}/reaim ${BINDIR}/telnetenabled ${WWW}/language/Czech.js ${WWW}/*DGND*.jpg ${WWW}/vw_* ${WWW}/vpn_* ${WWW}/h_vpn* ${WWW}/h_vauto* ${WWW}/h_vman* ${WWW}/index1.htm ${WWW}/start1.htm ${WWW}/*_demo.htm ${WWW}/start_old_style.htm ${WWW}/ORG-RST_status.htm ${WWW}/DSL_PRO_config.html ${WWW}/*3g*.htm
sync
echo
echo "Downloading & extracting: ${ARC} ..."
curl -k -O ${URL}/${ABSARC}
unzip ${ARC}
[ $? -ne 0 -o ! -f ${OPKG} -o ! -f ${CONF} ] && echo "Problem has occurred: check either connection or download urls." && exit 3
chmod 755 ${OPKG}
chmod 644 ${CONF}
echo
echo "Mounting opkg info & status files partition..."
[ ! -d ${MNTDIR} ] && mkdir -m 0777 ${MNTDIR}
for U in ${MNTDIR} ${MNTLANGPART}; do umount $U >/dev/null 2>&1; done
mount -n -t jffs2 ${MNTPART} ${MNTDIR}
[ $? -ne 0 ] && echo "Problem has occurred: opkg partition not mounted." && exit 2
rm -rf ${MNTDIR}/*
sync
echo
echo "Installing essential packages: ${TOINST}"
${OPKGCMD} update && sleep 1
for IPK in ${TOINST}
do
${OPKGCMD} install ${IPK}
[ $? -ne 0 ] && echo "${IPK} installation failed: check repository urls on ${CONF}" && exit 1
sleep 1
done
rm -f ${OPKG} ${ARC}
sync
echo
echo "This script can now be deleted: type 'rm `basename $0`'"
exit 0
