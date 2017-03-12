# You need to jiggle these parameters. Note limits are tuned towards a <10Mbit uplink <60Mbup down

[ -z "$UPLINK" ] && UPLINK=128
[ -z "$DOWNLINK" ] && DOWNLINK=0	# Ingress disabled as default
[ -z "$SCRIPT" ] && SCRIPT=simple.qos
[ -z "$IFACE" ] && IFACE=atm0.1
[ -z "$QDISC" ] && QDISC=fq_codel
[ -z "`eval nvram get ip6_mode`" ] && ip6_mode=disable
[ -z "$LLAM" ] && LLAM="default"
[ -z "$LINKLAYER" ] && LINKLAYER="none"
[ -z "$OVERHEAD" ] && OVERHEAD=0
[ -z "$STAB_MTU" ] && STAB_MTU=2047
[ -z "$STAB_MPU" ] && STAB_MPU=0
[ -z "$STAB_TSIZE" ] && STAB_TSIZE=512
[ -z "$AUTOFLOW" ] && AUTOFLOW=0
[ -z "$LIMIT" ] && LIMIT=1001		# sane global default for *LIMIT for fq_codel on a small memory device
[ -z "$ILIMIT" ] && ILIMIT=
[ -z "$ELIMIT" ] && ELIMIT=
[ -z "$ITARGET" ] && ITARGET=
[ -z "$ETARGET" ] && ETARGET=
[ -z "$IECN" ] && IECN="ECN"
[ -z "$EECN" ] && EECN="NOECN"
# These two used to be called something else; preserve backwards compatibility
[ -z "$ZERO_DSCP_INGRESS" ] && ZERO_DSCP_INGRESS=1
[ -z "$IGNORE_DSCP_INGRESS" ] && IGNORE_DSCP_INGRESS=1
[ -z "$IQDISC_OPTS" ] && IQDISC_OPTS=""
[ -z "$EQDISC_OPTS" ] && EQDISC_OPTS=""
[ -z "$TARGET" ] && TARGET="5ms"
[ -z "$IPT_MASK" ] && IPT_MASK="0xff"	# to disable: set mask to 0xffffffff
#sm: we need the functions above before trying to set the ingress IFB device
[ -z "$SHAPER_BURST" ] && SHAPER_BURST="1"
[ -z "$HTB_QUANTUM_FUNCTION" ] && HTB_QUANTUM_FUNCTION="linear"
# Paths & binaries
#[ -z "$LIBDIR" ] && LIBDIR=/lib
#[ -z "$BINDIR" ] && BINDIR=/usr/sbin
#[ -z "$SCRIPTSDIR" ] && SCRIPTSDIR=${BINDIR}/scripts
[ -z "$LIBDIR" ] && LIBDIR=.
[ -z "$BINDIR" ] && BINDIR=.
[ -z "$SCRIPTSDIR" ] && SCRIPTSDIR=.
[ -z "$INSMOD" ] && INSMOD=insmod
[ -z "$RMMOD" ] && RMMOD=rmmod
[ -z "$TC" ] && TC=tc_wrapper
[ -z "$IP" ] && IP=ip_wrapper
[ -z "$TC_BINARY" ] && TC_BINARY=${BINDIR}/tc
[ -z "$IP_BINARY" ] && IP_BINARY=${BINDIR}/ip

# Logging verbosity
VERBOSITY_SILENT=0
VERBOSITY_ERROR=1
VERBOSITY_WARNING=2
VERBOSITY_INFO=5
VERBOSITY_DEBUG=8
VERBOSITY_TRACE=10
[ -z "$SQM_VERBOSITY_MAX" ] && SQM_VERBOSITY_MAX=$VERBOSITY_INFO
# For silencing only errors
[ -z "$SQM_VERBOSITY_MIN" ] && SQM_VERBOSITY_MIN=$VERBOSITY_SILENT

[ -z "$SQM_DEBUG" ] && SQM_DEBUG=0
if [ "$SQM_DEBUG" -eq "1" ]
then
    SQM_DEBUG_LOG=/tmp/qosdebug.log
    OUTPUT_TARGET=${SQM_DEBUG_LOG}
else
    OUTPUT_TARGET="/dev/null"
fi

# These are the modules that do_modules() will attempt to load
#ALL_MODULES="act_ipt sch_$QDISC sch_ingress act_mirred cls_fw cls_flow cls_u32 sch_htb sch_hfsc"
#ALL_MODULES="sc_priority sc_track_ftp act_ipt sch_$QDISC cls_flow"
ALL_MODULES="act_ipt sch_$QDISC cls_flow"
