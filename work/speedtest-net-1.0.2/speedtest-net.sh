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
# clean = remove all the related bins, certs, license files & nvram stored license flags
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
rm -rf ${BIN}* ${CONFDIR}/.config/ ${CERTDIR}/
for V in ${NVARS}; do nvram unset ${V}; done
}

run_speedtest() {
# download, extract files & run speedtest in non-interactive mode
BINCMD=${BIN}													# command basic params
[ ! ${HOME} ] && BINCMD="${BINCMD} --accept-license --accept-gdpr -p no"					# non interactive params

[ ! -x ${BIN} ] && curl -f -s -k -L ${BINURL} | tar -oxz -C ${BINDIR} ${BINNAME} && chmod 755 ${BIN}		# download & extract binary
[ ! -x ${BIN} ] && echo "Error: ${BIN} binary missing or unavailable !" && exit 2				# bin presence verification

[ ! -d ${CERTDIR} ] && mkdir -p -m 0755 ${CERTDIR}								# create cert dir container
[ ! -r ${CERT} ] && curl -f -s -k -o ${CERT} ${CERTURL} && chmod 600 ${CERT}					# download pem cert
[ ! -d ${CERTDIR} -o ! -r ${CERT} ] && echo "Error: ${CERT} key file missing or unavailable !" && exit 1	# cert presence verification

export HOME=${CONFDIR}												# export non empty HOME env var
[ ! -z "${1}" ] && BINCMD="${BINCMD} ${@}"									# append parameters if any
nice -n -20 ${BINCMD}												# execute boosted command
}

BINNAME=speedtest
BINVER=1.0.0
BINARCH=arm
BINOS=linux
BINARCNAME=ookla-${BINNAME}-${BINVER}-${BINARCH}-${BINOS}.tgz
CERTNAME=cert.pem
NVARS="speedtest_net_license speedtest_net_gdpr"

BINDIR=/tmp
CONFDIR=/tmp
CERTDIR=/etc/ssl
CERT=${CERTDIR}/${CERTNAME}
BIN=${BINDIR}/${BINNAME}

BINURL=https://bintray.com/ookla/download/download_file?file_path=${BINARCNAME}
CERTURL=https://curl.se/ca/ca${CERTNAME}

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
