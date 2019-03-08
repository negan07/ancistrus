#!/bin/sh

KILL_PS() {
# kill print server
for K in "KC_PRINT" "KC_BONJOUR"
do
	for PID in `pidof ${K}`
	do
	[ -e /proc/${PID}/stat ] && while kill -9 $PID >/dev/null 2>&1; do :; done
	done
done
}

RUN_PS() {
# run print server
KC_BONJOUR &
KC_PRINT &
/etc/turn_on_printer_led
}

[ -z "$1" ] && echo "Usage: $0 <disablekill|enablekill>" && exit 1

case "$1" in
disablekill)											#stop, enable, then run printserver
KILL_PS
nvram set printserver_disable=0
RUN_PS >/dev/null 2>&1
;;
enablekill)											#disable & stop printserver
nvram set printserver_disable=1
KILL_PS
;;
esac

