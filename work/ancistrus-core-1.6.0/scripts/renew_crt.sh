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
# Renew the SSL CA bundle certificates file 'cacert.pem' (used as: 'ca-bundle.crt').
# https://curl.se/docs/caextract.html
# File is downloaded only if remote file has changed.
# Same as 'make ca-bundle' from curl source package.
#
# Usage: $0
#

PEM=cacert.pem
CERT=ca-bundle.crt
CERTDIR=/etc
CONFDIR=/usr${CERTDIR}
CERTURL=https://curl.se/ca/${PEM}
CTOUT=`anc nvram drget curl_conn_timeout 5`
TTOUT=`anc nvram drget curl_tr_timeout 30`

cd ${CERTDIR}
[ -r ${CERT} ] && cp -af ${CERT} ${PEM} >/dev/null 2>&1 && OLDTST=`date -r ${PEM}`
curl -f -s -k --connect-timeout ${CTOUT} -m ${TTOUT} -O -z ${PEM} ${CERTURL}
ERR=$?
	if [ $ERR -eq 0 ]; then
		if [ -r ${PEM} -a "`sed -n '2p;3q;' ${PEM}`" >/dev/null 2>&1 = "## Bundle of CA Root Certificates" ]; then
			if [ "`date -r ${PEM}`" != "${OLDTST}" ]; then
			chmod 600 ${PEM}
			cp -af ${PEM} ${CERT}
			mv -f ${PEM} ${CONFDIR}/${CERT}
			sync
			fi
		else
		ERR=127
		fi
	fi
[ -r ${PEM} ] && rm -f ${PEM}
exit $ERR
