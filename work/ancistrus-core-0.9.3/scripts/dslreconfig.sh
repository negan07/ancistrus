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
# Dsl connection reinitializer script.
#
# Usage: $0
#
# To be used after tweaking dsl parameter settings.
#

BIN=/usr/sbin/xdslctl

$BIN configure
$BIN connection --up
