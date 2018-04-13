#!/bin/sh
# Optional firewall rules
# Called by 'firewall_post -> run_fw_dir() "$@"' ($@=<fwup|fwdown|remoteup>)

# Vars
TMPSCR=/tmp/ancfw
BIN=/usr/sbin/anc

# Debug purpose
#BIN=/etc/ancdbg/anc

# Copy optional ruleset from nvram to a temporary file then run it
if [ -n "`${BIN} nvram rget anc_${1}_opt`" ]; then
${BIN} nvtotxt anc_${1}_opt > ${TMPSCR}
. ${TMPSCR} >/dev/null 2>&1
rm -f ${TMPSCR}
fi
