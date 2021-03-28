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

cd ${CERTDIR}
cp -f ${CERT} ${PEM}
curl -f -s -k -O -z ${PEM} ${CERTURL} || exit 1
chmod 600 ${PEM}
mv -f ${PEM} ${CERT}
cp -f ${CERT} ${CONFDIR}
sync

exit 0
