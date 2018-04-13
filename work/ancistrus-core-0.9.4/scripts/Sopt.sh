#!/bin/sh
# Optional startups

# Vars
TMPSCR=/tmp/ancstartups
BIN=/usr/sbin/anc

# Debug purpose
#BIN=/etc/ancdbg/anc

# Copy optional startups commands from nvram to a temporary file then run it
if [ -n "`${BIN} nvram rget anc_startup_opt`" ]; then
echo "#!/bin/sh" > ${TMPSCR}
${BIN} nvtotxt anc_startup_opt >> ${TMPSCR}
. ${TMPSCR} >/dev/null 2>&1
rm -f ${TMPSCR}
fi
