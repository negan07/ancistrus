#!/bin/sh
# Optional kills

# Vars
TMPSCR=/tmp/anckills
BIN=/usr/sbin/anc

# Debug purpose
#BIN=/etc/ancdbg/anc

# Copy optional kill commands from nvram to a temporary file then run it
if [ -n "`${BIN} nvram rget anc_kill_opt`" ]; then
echo "#!/bin/sh" > ${TMPSCR}
${BIN} nvtotxt anc_kill_opt >> ${TMPSCR}
. ${TMPSCR}
rm -f ${TMPSCR}
fi
