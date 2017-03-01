#!/bin/sh

WORKDIR=/tmp/etc/ancdbg
IP=${WORKDIR}/ip
TC=${WORKDIR}/tc
DEFCL=30
eval `nvram get lan_if`
eval `nvram get wan_ifname`
eval `nvram get qos_uplink_rate`
#eval `nvram get qos_rate_unit`
UNIT=kbit
UPRATE=${qos_uplink_rate}${UNIT}
LOWRATE=$((${qos_uplink_rate} / 10))${UNIT}
DEFRATE=$((${qos_uplink_rate} * 3 / 20))${UNIT}
EXPRATE=$((${qos_uplink_rate} * 3 / 10))${UNIT}
TOPRATE=$((${qos_uplink_rate} * 9 / 20))${UNIT}
WANIF=$wan_ifname
LANIF=$lan_if

ipt -t mangle -N QOS_MARK_${IFACE}
ipt -t mangle -A QOS_MARK_${IFACE} -j MARK --set-mark 0x2/${IPT_MASK}
ipt -t mangle -A QOS_MARK_${IFACE} -m dscp --dscp-class CS1 -j MARK --set-mark 0x3/${IPT_MASK}
ipt -t mangle -A QOS_MARK_${IFACE} -m dscp --dscp-class CS6 -j MARK --set-mark 0x1/${IPT_MASK}
ipt -t mangle -A QOS_MARK_${IFACE} -m dscp --dscp-class EF -j MARK --set-mark 0x1/${IPT_MASK}
ipt -t mangle -A QOS_MARK_${IFACE} -m dscp --dscp-class AF42 -j MARK --set-mark 0x1/${IPT_MASK}
ipt -t mangle -A QOS_MARK_${IFACE} -m tos  --tos Minimize-Delay -j MARK --set-mark 0x1/${IPT_MASK}
ipt -t mangle -I PREROUTING -i $IFACE -m dscp ! --dscp 0 -j DSCP --set-dscp-class be
ipt -t mangle -A POSTROUTING -o $IFACE -m mark --mark 0x00/${IPT_MASK} -g QOS_MARK_${IFACE}
ipt -t mangle -I PREROUTING -i vtun+ -p tcp -j MARK --set-mark 0x2/${IPT_MASK}
ipt -t mangle -A OUTPUT -p udp -m multiport --ports 123,53 -j DSCP --set-dscp-class AF42
CEIL=${UPLINK}
PRIO_RATE=`expr $CEIL / 3` # Ceiling for prioirty
BE_RATE=`expr $CEIL / 6`   # Min for best effort
BK_RATE=`expr $CEIL / 6`   # Min for background
BE_CEIL=`expr $CEIL - 16`  # A little slop at the top
LQ="quantum `get_htb_quantum $IFACE $CEIL`"
BURST="`get_htb_burst $IFACE $CEIL`"
$TC qdisc del dev $IFACE root 2> /dev/null
$TC qdisc add dev $IFACE root handle 1: `get_stab_string` htb default 12
$TC class add dev $IFACE parent 1: classid 1:1 htb $LQ rate ${CEIL}kbit ceil ${CEIL}kbit $BURST `get_htb_adsll_string`
$TC class add dev $IFACE parent 1:1 classid 1:11 htb $LQ rate 128kbit ceil ${PRIO_RATE}kbit prio 1 `get_htb_adsll_string`
$TC class add dev $IFACE parent 1:1 classid 1:12 htb $LQ rate ${BE_RATE}kbit ceil ${BE_CEIL}kbit $BURST prio 2 `get_htb_adsll_string`
$TC class add dev $IFACE parent 1:1 classid 1:13 htb $LQ rate ${BK_RATE}kbit ceil ${BE_CEIL}kbit $BURST prio 3 `get_htb_adsll_string`
$TC qdisc add dev $IFACE parent 1:11 handle 110: $QDISC `get_limit ${ELIMIT}` `get_target "${ETARGET}" ${UPLINK}` `get_ecn ${EECN}` `get_quantum 300` `get_flows ${PRIO_RATE}` ${EQDISC_OPTS}
$TC qdisc add dev $IFACE parent 1:12 handle 120: $QDISC `get_limit ${ELIMIT}` `get_target "${ETARGET}" ${UPLINK}` `get_ecn ${EECN}` `get_quantum 300` `get_flows ${BE_RATE}` ${EQDISC_OPTS}
$TC qdisc add dev $IFACE parent 1:13 handle 130: $QDISC `get_limit ${ELIMIT}` `get_target "${ETARGET}" ${UPLINK}` `get_ecn ${EECN}` `get_quantum 300` `get_flows ${BK_RATE}` ${EQDISC_OPTS}
$TC filter add dev $IFACE parent 1:0 protocol all prio 999 u32 match ip protocol 0 0x00 flowid 1:12
$TC filter add dev $IFACE parent 1:0 protocol ip prio 1 handle 1/${IPT_MASK} fw classid 1:11
$TC filter add dev $IFACE parent 1:0 protocol ip prio 2 handle 2/${IPT_MASK} fw classid 1:12
$TC filter add dev $IFACE parent 1:0 protocol ip prio 3 handle 3/${IPT_MASK} fw classid 1:13
$TC filter add dev $IFACE parent 1:0 protocol ipv6 prio 4 handle 1/${IPT_MASK} fw classid 1:11
$TC filter add dev $IFACE parent 1:0 protocol ipv6 prio 5 handle 2/${IPT_MASK} fw classid 1:12
$TC filter add dev $IFACE parent 1:0 protocol ipv6 prio 6 handle 3/${IPT_MASK} fw classid 1:13
$TC filter add dev $IFACE parent 1:0 protocol arp prio 7 handle 1/${IPT_MASK} fw classid 1:11
$TC filter add dev $IFACE parent 1:0 protocol ip prio 8 u32 match ip protocol 1 0xff flowid 1:13
$TC filter add dev $IFACE parent 1:0 protocol ipv6 prio 9 u32 match ip protocol 1 0xff flowid 1:13

#----------------------------------------------------------------------------------------------------------------
$TC qdisc del dev $WANIF root >&- 2>&-

#$TC qdisc add dev $WANIF root handle 1: htb default $DEFCL
#$TC class add dev $WANIF parent 1: classid 1:1 htb rate $UPRATE ceil $UPRATE quantum 1500
$TC qdisc add dev $WANIF root handle 1: hfsc default $DEFCL
$TC class add dev $WANIF parent 1: classid 1:1 hfsc sc rate $UPRATE ul rate $UPRATE

#$TC class add dev $WANIF parent 1:1 classid 1:10 htb rate $TOPRATE ceil $UPRATE prio 0 quantum 1500
#$TC class add dev $WANIF parent 1:1 classid 1:20 htb rate $EXPRATE ceil $UPRATE prio 1 quantum 1500
#$TC class add dev $WANIF parent 1:1 classid 1:30 htb rate $DEFRATE ceil $UPRATE prio 2 quantum 1500
#$TC class add dev $WANIF parent 1:1 classid 1:40 htb rate $LOWRATE ceil $UPRATE prio 3 quantum 1500

#$TC class add dev $WANIF parent 1:1 classid 1:10 htb rate $TOPRATE prio 0 quantum 1500
#$TC class add dev $WANIF parent 1:1 classid 1:20 htb rate $EXPRATE prio 1 quantum 1500
#$TC class add dev $WANIF parent 1:1 classid 1:30 htb rate $DEFRATE prio 2 quantum 1500
#$TC class add dev $WANIF parent 1:1 classid 1:40 htb rate $LOWRATE prio 3 quantum 1500

$TC class add dev $WANIF parent 1:1 classid 1:10 hfsc sc rate $TOPRATE ul rate $UPRATE
$TC class add dev $WANIF parent 1:1 classid 1:20 hfsc sc rate $EXPRATE ul rate $UPRATE
$TC class add dev $WANIF parent 1:1 classid 1:30 hfsc sc rate $DEFRATE ul rate $UPRATE
$TC class add dev $WANIF parent 1:1 classid 1:40 hfsc sc rate $LOWRATE ul rate $UPRATE

$TC qdisc add dev $WANIF parent 1:10 handle 101: fq_codel limit 800 quantum 300 noecn
$TC qdisc add dev $WANIF parent 1:20 handle 102: fq_codel limit 800 quantum 300 noecn
$TC qdisc add dev $WANIF parent 1:30 handle 103: fq_codel limit 800 quantum 300 noecn
$TC qdisc add dev $WANIF parent 1:40 handle 104: fq_codel limit 800 quantum 300 noecn

#$TC filter add dev $WANIF parent 1: protocol all handle 0x804 fw classid 1:40 mask 0xfff
#$TC filter add dev $WANIF parent 1: protocol all handle 0x803 fw classid 1:30 mask 0xfff
#$TC filter add dev $WANIF parent 1: protocol all handle 0x802 fw classid 1:20 mask 0xfff
#$TC filter add dev $WANIF parent 1: protocol all handle 0x801 fw classid 1:10 mask 0xfff
$TC filter add dev $WANIF parent 1: prio 3 handle 0x804 fw flowid 1:40 mask 0xfff
$TC filter add dev $WANIF parent 1: prio 2 handle 0x803 fw flowid 1:30 mask 0xfff
$TC filter add dev $WANIF parent 1: prio 1 handle 0x802 fw flowid 1:20 mask 0xfff
$TC filter add dev $WANIF parent 1: prio 0 handle 0x801 fw flowid 1:10 mask 0xfff

