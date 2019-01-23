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
# Create a new httpd pem rsa key and cert.
#
# Usage: $0 <digest_alg> <key_length> <duration_days>
#

PEM=mini_httpd.pem
CRT=mini_httpd.crt
CONF=openssl.cnf
PEMDIR=/etc
CONFDIR=/usr${PEMDIR}
SSLCONF=${CONFDIR}/${CONF}
SUBJ="/C=US/ST=California/L=San Jose/O=NETGEAR/OU=Home Consumer Products/CN=www.routerlogin.net"

[ ! -f $SSLCONF ] && echo "Openssl config file .cnf missing: job aborted !" && exit 3

DIGEST=$1
KEYLEN=$2
DAYS=$3
[ -z "$DIGEST" ] && DIGEST=sha256
[ -z "$KEYLEN" ] && KEYLEN=2048
[ -z "$DAYS" ] && DAYS=3650

cd /tmp
openssl genpkey -algorithm RSA -outform PEM -out ${PEM} -pkeyopt rsa_keygen_bits:${KEYLEN} || exit 2
openssl req -new -${DIGEST} -days ${DAYS} -key ${PEM} -batch -x509 -newkey rsa:${KEYLEN} -subj "${SUBJ}" -out ${CRT} || exit 1
cat ${CRT} >> ${PEM}
chmod 600 ${PEM}
cp -f $PEM $CONFDIR
mv -f $PEM $PEMDIR
echo "New $PEM key & cert created !"
rm -f $CRT
exit 0
