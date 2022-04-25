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
# Automate execution of 'speedtest'
# https://www.speedtest.net
# Maintainer: support@ookla.com
# License: 	https://www.speedtest.net/about/eula
# 		https://www.speedtest.net/about/terms
# 		https://www.speedtest.net/about/privacy
#
# Usage: $0 (<setlics>|<clean>) (<...> ... <...>)
#
# setlics = setup license flag storing them on nvram
# clean = remove all the related bins, config, license files & nvram stored license flags
#
# <...> parameters are optional and appended to the basic 'speedtest' command & parameters. 
# Type: '${BIN} -h' to see all the parameters available.
#
# Download all the necessary files needed to execute speedtest and run it accepting EULA license agreements if needed.
# All the files are downloaded into temporary ramfs and they are deleted after reboot or poweroff.
# This script should be executed from web gui accepting EULA license agreements on the related webpage.
#

set_lics() {
# setup license flags
for V in ${NVARS}
do
eval `nvram get ${V}` >/dev/null 2>&1
[ "`eval echo '$'${V}`" = "1" ] || nvram set ${V}=1
done
}

clean_files() {
# unset temp files & license flags
rm -rf ${BIN}* ${CONFDIR}/.config/
for V in ${NVARS}; do nvram unset ${V}; done
}

run_speedtest() {
# download, extract files & run speedtest in non-interactive mode
BINCMD=${BIN}													# command basic params
[ ! ${HOME} ] && BINCMD="${BINCMD} --ca-certificate=${CERT} --accept-license --accept-gdpr -p no"		# non interactive params

[ ! -r ${CERT} ] && cd ${CERTDIR} && curl -f -s -k --connect-timeout ${CTOUT} -m ${TTOUT} -O -z ${PEMNAME} ${CERTURL} && chmod 600 ${PEM} && mv -f ${PEM} ${CERT}												# download cert
[ ! -r ${CERT} ] && echo "Error: ${CERT} cert missing or unavailable !" && exit 2				# cert presence verification

if [ ! -x ${BIN} ]; then
curl -f -s -k --connect-timeout ${CTOUT} -m ${TTOUT} -L ${BINURL} | tar -oxz -C ${BINDIR} ${BINNAME} >/dev/null 2>&1 && chmod 755 ${BIN} || echo "Extract error"												# download & extract binary
fi
[ ! -x ${BIN} ] && echo "Error: ${BIN} binary missing or unavailable !" && exit 1				# bin presence verification

export HOME=${CONFDIR}												# avoid writing confdir on root
[ ! -z "${1}" ] && BINCMD="${BINCMD} ${@}"									# append parameters if any
nice -n -20 ${BINCMD}												# execute boosted command
}

BINNAME=speedtest
BINVER=1.1.1
BINARCH=armel
BINOS=linux
BINARCNAME=ookla-${BINNAME}-${BINVER}-${BINOS}-${BINARCH}.tgz
CERTNAME=ca-bundle.crt
PEMNAME=cacert.pem
NVARS="speedtest_net_license speedtest_net_gdpr"
CTOUT=`anc nvram drget curl_conn_timeout 5`
TTOUT=`anc nvram drget curl_tr_timeout 30`

BINDIR=/tmp
CONFDIR=/tmp
CERTDIR=/etc
CERT=${CERTDIR}/${CERTNAME}
PEM=${CERTDIR}/${PEMNAME}
BIN=${BINDIR}/${BINNAME}

CERTURL=https://curl.se/ca/${PEMNAME}
BINURL=https://install.${BINNAME}.net/app/cli/${BINARCNAME}

case "${1}" in
setlics)
set_lics
;;
clean)
clean_files
;;
-L|--servers)
run_speedtest "$@"
;;
*)
set_lics
run_speedtest "$@"
;;
esac

exit $?
