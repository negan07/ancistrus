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
# Usage: $0 (<...> ... <...>)
#
# <...> parameters are optional and appended to the basic 'speedtest' command & parameters. 
# Type: '${BIN} -h' to see all the parameters available.
#
# Download all the necessary files needed to execute speedtest and run it accepting EULA license agreements if needed.
# All the files are downloaded into temporary ramfs and they are deleted after reboot or poweroff.
# This script should be executed from web gui accepting EULA license agreements on the related webpage.
#

BINNAME=speedtest
BINVER=1.0.0
BINARCH=arm
BINOS=linux
BINARCNAME=ookla-${BINNAME}-${BINVER}-${BINARCH}-${BINOS}.tgz
CERTNAME=cert.pem

BINDIR=/tmp
CONFDIR=/tmp
CERTDIR=/etc/ssl
CERT=${CERTDIR}/${CERTNAME}
BIN=${BINDIR}/${BINNAME}

BINURL=https://bintray.com/ookla/download/download_file?file_path=${BINARCNAME}					# urls
CERTURL=https://curl.haxx.se/ca/ca${CERTNAME}

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
exit $?
