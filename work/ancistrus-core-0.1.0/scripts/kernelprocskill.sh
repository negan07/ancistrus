#!/bin/sh

# some kprocs kills
for P in "telnetDBGD" "acktelnetDBGD"
do
S=`ps | grep "\[ ${P} \]" | grep -v grep | awk '{printf $1}'`
[ ! -z $S ] && [ "$S" -eq "$S" ] > /dev/null 2>&1 && kill -9 $S
done

