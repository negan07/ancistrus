#!/bin/sh

# kill print server
eval `nvram get printserver_disable` > /dev/null 2>&1
if [ "${printserver_disable}" = "1" ]; then
killall -9 KC_BONJOUR > /dev/null 2>&1
sleep 1
killall -9 KC_PRINT > /dev/null 2>&1
sleep 1
fi

