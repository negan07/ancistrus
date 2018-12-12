#!/bin/sh
#
# This script provides a convenient means of on-device network performance testing for router devices, and subsumes functionality
# of the earlier CeroWrt scripts betterspeedtest.sh and netperfrunner.sh written by Rich Brown.
#
# When launched, this script uses netperf to run several upload and download streams to an Internet server.
# This places a heavy load on the bottleneck link of your network (probably your Internet connection) while measuring the total bandwidth
# of the link during the transfers. Under this network load, this script simultaneously measures the latency of pings to see whether the file
# transfers affect the responsiveness of your network. Additionally, this script tracks the per-CPU processor usage,
# as well as the netperf CPU usage used for the test.
#
# This script operates in two modes of network loading: sequential and concurrent.
# The default sequential mode emulates a web-based speed test by first downloading and then uploading network streams,
# while concurrent mode provides a stress test by dowloading and uploading streams simultaneously.
#
# NOTE: this script uses servers and network bandwidth that are provided by generous volunteers (not some wealthy "big company").
# Feel free to use the script to test your SQM configuration or troubleshoot network and latency problems:
# continuous or high rate use of this script may result in denied access.
#
# Usage: $0 [ -s | -c ] [-4 | -6] [ -H netperf-server ] [ -t duration ] [ -p host-to-ping ] [ -n simultaneous-streams ]
#
# Options (if present):
#
# -s | -c:              Sequential or concurrent download/upload (default sequential)
# -H | --host:   	DNS or IP address of a netperf server	 (default: netperf.bufferbloat.net)
#			Alternate servers are netperf-east (east coast US), netperf-west (California) and netperf-eu (Denmark)
# -4 | -6:		Enable ipv4 or ipv6 testing		 (default: ipv4)
# -t | --time:		Test duration time on each direction	 (default: 60 seconds)
# -p | --ping:   	Host to ping for latency measurements	 (default: gstatic.com)
# -n | --number:	Number of simultaneous sessions	based on whether concurrent or sequential upload/downloads (default: 5 sessions)
#
# Copyright (c) 2014 - Rich Brown <rich.brown@blueberryhillsoftware.com>
# Copyright (c) 2018 - Tony Ambardar <itugrok@yahoo.com>
# GPLv2
#
# Revised & adapted:
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

# Process the ping times, and summarize the results.
# Summarize the contents of the ping's output file to show min, avg, median, max, etc.
# Input parameter ($1) file contains the output of the ping command.
# grep to keep lines that have "time=", then sed to isolate the time stamps, and awk bubble-sort them.
# awk builds an array of those values, and prints first & last (which are min, max) and computes average.
# If the number of samples is >= 10, also computes median, and 10th and 90th percentile readings.

summarize_pings() {
	sed 's/^.*time=\([^ ]*\) ms/\1 pingtime/' < $1 | grep -v "PING" | awk '
BEGIN { line[NR] = $0 }
END {
  do {
    haschanged = 0
    for(i=1; i < NR; i++) {
      if ( line[i] > line[i+1] ) {
	t = line[i]
	line[i] = line[i+1]
	line[i+1] = t
	haschanged = 1
      }
    }
  } while ( haschanged == 1 )
  for(i=1; i <= NR; i++) {
    print line[i]
  }
}' | awk '
BEGIN {numdrops=0; numrows=0;}
{
	if ( $2 == "pingtime" ) {
		numrows += 1;
		arr[numrows]=$1; sum+=$1;
	} else {
		numdrops += 1;
	}
}
END {
	pc10="-"; pc90="-"; med="-";
	if (numrows>=10) {
		ix=int(numrows/10); pc10=arr[ix]; ix=int(numrows*9/10);pc90=arr[ix];
		if (numrows%2==1) med=arr[(numrows+1)/2]; else med=(arr[numrows/2]);
	}
	pktloss = numdrops>0 ? numdrops/(numdrops+numrows) * 100 : 0;
	printf("  Latency: [in msec, %d pings, %4.2f%% packet loss]\n",numdrops+numrows,pktloss);
	if (numrows>0) {
		fmt="%9s: %7.3f\n";
		printf(fmt fmt fmt fmt fmt fmt, "Min",arr[1],"10pct",pc10,"Median",med,"Avg",sum/numrows,"90pct",pc90,"Max",arr[numrows]);
	}
}'
}

# Summarize the contents of the load file, speedtest process stat file, cpuinfo
# file to show mean/stddev CPU utilization and netperf CPU usage.
#   input parameter ($1) file contains CPU load samples

summarize_load() {
	cat $1 /proc/$$/stat | awk -v SCRIPT_PID=$$ '
# track CPU frequencies
$1 == "cpufreq" {
	sum_freq[$2]+=$3/1000
	n_freq_samp[$2]++
}
# total CPU of speedtest processes
$1 == SCRIPT_PID {
	tot=$16+$17
	if (init_proc_cpu=="") init_proc_cpu=tot
	proc_cpu=tot-init_proc_cpu
}
# track aggregate CPU stats
$1 == "cpu" {
	tot=0; for (f=2;f<=8;f++) tot+=$f
	if (init_cpu=="") init_cpu=tot
	tot_cpu=tot-init_cpu
	n_load_samp++
}
# track per-CPU stats
$1 ~ /cpu[0-9]+/ {
	tot=0; for (f=2;f<=8;f++) tot+=$f
	usg=tot-($5+$6)
	if (init_tot[$1]=="") {
		init_tot[$1]=tot
		init_usg[$1]=usg
		cpus[n_cpus++]=$1
	}
	if (last_tot[$1]>0) {
		sum_usg_2[$1] += ((usg-last_usg[$1])/(tot-last_tot[$1]))^2
	}
	last_tot[$1]=tot
	last_usg[$1]=usg
}
END {
	printf(" CPU Load: [in %% busy (avg +/- std dev)")
	if (sum_freq[cpu0]>0) printf(" @ avg frequency")
	if (n_load_samp>0) n_load_samp--
	printf(", %d samples]\n", n_load_samp)
	for (i=0;i<n_cpus;i++) {
		c=cpus[i]
		if (n_load_samp>0) {
			avg_usg=(last_tot[c]-init_tot[c])
			avg_usg=avg_usg>0 ? (last_usg[c]-init_usg[c])/avg_usg : 0
			std_usg=sum_usg_2[c]/n_load_samp-avg_usg^2
			std_usg=std_usg>0 ? sqrt(std_usg) : 0
			printf("%9s: %5.1f%% +/- %4.1f%%", c, avg_usg*100, std_usg*100)
			avg_freq=n_freq_samp[c]>0 ? sum_freq[c]/n_freq_samp[c] : 0
			if (avg_freq>0) printf("  @ %4d MHz", avg_freq)
			printf("\n")
		}
	}
	printf(" Overhead: [in %% used of total CPU available]\n")
	printf("%9s: %5.1f%%\n", "netperf", tot_cpu>0 ? proc_cpu/tot_cpu*100 : 0)
}'
}

# Summarize the contents of the speed file to show formatted transfer rate.
#   input parameter ($1) indicates transfer direction
#   input parameter ($2) file contains speed info from netperf

summarize_speed() {
	printf "%9s: %6.2f Mbps\n" $1 $(awk '{s+=$1} END {print s}' $2)
}

# Capture process load, then per-CPU load/frequency info at 1-second intervals.

sample_load() {
	local cpus="$(find /sys/devices/system/cpu -name 'cpu[0-9]*' 2>/dev/null)"
	local f="cpufreq/scaling_cur_freq"

	cat /proc/$$/stat
	while :
	do
		sleep 1
#		egrep "^cpu[0-9]*" /proc/stat
		cat /proc/stat | grep cpu
		for c in $cpus
		do
			[ -r $c/$f ] && echo "cpufreq $(basename $c) $(cat $c/$f)"
		done
	done
}

# Start $MAXSESSIONS datastreams between netperf client and server
# netperf writes the sole output value (in Mbps) to stdout when completed

start_netperf() {
#	for i in $( seq $MAXSESSIONS ); do
	local I=1
	while [ $I -le $MAXSESSIONS ]
	do
		netperf $TESTPROTO -H $TESTHOST -t $1 -l $TESTDUR -v 0 -P 0 >> $2 &
#		echo "Starting PID $! params: $TESTPROTO -H $TESTHOST -t $1 -l $TESTDUR -v 0 -P 0 >> $2" 1>&2 1>&2
	let I++
	done
}

# Wait until each of the background netperf processes completes
# Stop the background netperf processes

wait_netperf() {
	local err=0
#	for i in $(pgrep -P $$ netperf); do
	for I in `pidof netperf`
	do
#	echo "Stopping $i" 1>&2
		[ "${1}" = "kill" ] && kill -9 $I
		wait $I 2>/dev/null || err=1
	done
	return $err
}

# Stop the current sample_load() process

kill_load() {
#	echo "Load: $LOAD_PID" 1>&2
	kill -9 $LOAD_PID
	wait $LOAD_PID 2>/dev/null
	LOAD_PID=0
}

# Stop the current ping process

kill_pings() {
#	echo "Pings: $PING_PID" 1>&2
	kill -9 $PING_PID
	wait $PING_PID 2>/dev/null
	PING_PID=0
}

# Stop the current load, pings and exit
# ping command catches and handles first Ctrl-C, so you have to hit it again...

kill_background_and_exit() {
	wait_netperf kill
	kill_load
	cleanup
	echo 1>&2
	echo "Stopped" 1>&2
	exit 1
}

# Clean temp files created for statistics

cleanup() {
	rm -f /tmp/*.${DATE}
}

# Measure speed, ping latency and cpu usage of netperf data transfers
# Called with direction parameter: "Download", "Upload", or "Bidirectional"
# The function gets other info from globals and command-line arguments.

measure_direction() {

	# Create temp files for netperf up/download results
	ULFILE=/tmp/netperfUL.${DATE} && touch $ULFILE
	DLFILE=/tmp/netperfDL.${DATE} && touch $DLFILE
	PINGFILE=/tmp/measurepings.${DATE} && touch $PINGFILE
	LOADFILE=/tmp/measureload.${DATE} && touch $LOADFILE
#	echo $ULFILE $DLFILE $PINGFILE $LOADFILE 1>&2

	local dir=$1
	local ping_cmd

	# Start Ping
	[ "${TESTPROTO}" = "-4" ] && ping_cmd=ping || ping_cmd=ping6
	$ping_cmd $PINGHOST > $PINGFILE &
	PING_PID=$!
#	echo "Ping PID: $PING_PID" 1>&2

	# Start CPU load sampling
	sample_load > $LOADFILE &
	LOAD_PID=$!
#	echo "Load PID: $LOAD_PID" 1>&2

	# Start netperf datastreams between client and server
	case ${dir} in
	Bidirectional)
	start_netperf TCP_STREAM $ULFILE
	start_netperf TCP_MAERTS $DLFILE
	;;
	Download)
	start_netperf TCP_MAERTS $DLFILE
	;;
	Upload)
	start_netperf TCP_STREAM $DLFILE
	;;
	esac

	# Wait until background netperf processes complete, check errors
	! wait_netperf && echo 1>&2 && echo "WARNING: netperf returned errors. Results may be inaccurate!" 1>&2

	# When netperf completes, stop the CPU monitor and pings
	kill_load
	kill_pings
	echo 1>&2

	# Print TCP Download/Upload speed
	if [ "${dir}" = "Bidirectional" ]; then
		summarize_speed Download $DLFILE
		summarize_speed Upload $ULFILE
	else
		summarize_speed $dir $DLFILE
	fi

	# Summarize the ping data
	summarize_pings $PINGFILE

	# Summarize the load data
	summarize_load $LOADFILE

	# Clean up
	cleanup
}

# ------- Start of the main routine --------

# set an initial values for defaults
TESTHOST="netperf.bufferbloat.net"
TESTDUR="60"
PINGHOST="gstatic.com"
MAXSESSIONS="5"
TESTPROTO="-4"
TESTSEQ="1"

# read the options

# extract options and their arguments into variables.
while [ $# -gt 0 ]
do
	case "$1" in
		-s|--sequential) TESTSEQ=1 ; shift 1 ;;
		-c|--concurrent) TESTSEQ=0 ; shift 1 ;;
		-4|-6) TESTPROTO=$1 ; shift 1 ;;
		-H|--host)
			case "$2" in
				"") echo "Missing hostname" 1>&2 ; exit 1 ;;
				*) TESTHOST=$2 ; shift 2 ;;
			esac ;;
		-t|--time)
			case "$2" in
				"") echo "Missing duration" 1>&2 ; exit 1 ;;
				*) TESTDUR=$2 ; shift 2 ;;
			esac ;;
		-p|--ping)
			case "$2" in
				"") echo "Missing ping host" 1>&2 ; exit 1 ;;
				*) PINGHOST=$2 ; shift 2 ;;
			esac ;;
		-n|--number)
			case "$2" in
				"") echo "Missing number of simultaneous streams" 1>&2 ; exit 1 ;;
				*) MAXSESSIONS=$2 ; shift 2 ;;
			esac ;;
		--) shift ; break ;;
		*) echo "Usage: $0 [ -s | -c ] [-4 | -6] [ -H netperf-server ] [ -t duration ] [ -p host-to-ping ] [ -n simultaneous-sessions ]" 1>&2 ; exit 1 ;;
	esac
done

# Start the main test

DATE=`date "+%Y-%m-%d_%H:%M:%S"`
echo "${DATE}" 1>&2
echo "Starting speedtest for $TESTDUR seconds per transfer session." 1>&2
echo "Measure speed to $TESTHOST (IPv${TESTPROTO#-}) while pinging ${PINGHOST}." 1>&2
echo -n "Download and upload sessions are " 1>&2
[ "${TESTSEQ}" -eq "1" ] && echo -n "sequential (speed test)," 1>&2 || echo -n "concurrent (stress test)," 1>&2
echo " each with $MAXSESSIONS simultaneous streams." 1>&2

# Catch a Ctl-C and stop background netperf, CPU stats and pinging
trap kill_background_and_exit HUP INT TERM

if [ "${TESTSEQ}" -eq "1" ]; then
	measure_direction "Download"
	measure_direction "Upload"
else
	measure_direction "Bidirectional"
fi

exit 0
