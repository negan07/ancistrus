#!/bin/sh
#
# This script consolidates functionality of the original CeroWrt scripts
# betterspeedtest.sh and netperfrunner.sh written by Rich Brown.
#
# Script betterspeedtest.sh simulated http://speedtest.net by initiating
# a download followed by an upload, while measuring ping latency and data
# transfer rates.
#
# Script netperfrunner.sh ran several simultaneous uploads and downloads, to
# mimic the stress test of Flent (www.flent.org - formerly, "netperf-wrapper")
# from Toke <toke@toke.dk> but without the nice GUI results.
#
# This speedtest.sh script merges both scripts above and allows selection
# of either sequential or concurrent upload and download tests. It also
# measures processor usage during testing to help identify being CPU-bound.
#
# Usage: network-test.sh [ -s | -c ] [-4 | -6] [ -H netperf-server ] [ -t duration ] [ -p host-to-ping ] [ -n simultaneous-streams ]
#
# Options (if present):
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
	sed 's/^.*time=\([^ ]*\) ms/\1/' < $1 | grep -v "PING" | \
	awk '{
	  line[NR] = $0
	}
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
	}' | \
	awk 'BEGIN {numdrops=0; numrows=0;} \
		{ \
			if ( $0 ~ /timeout/ ) { \
			   	numdrops += 1; \
			} else { \
				numrows += 1; \
				arr[numrows]=$1; sum+=$1; \
			} \
		} \
		END { \
			pc10="-"; pc90="-"; med="-"; \
			if (numrows == 0) {numrows=1} \
			if (numrows>=10) \
			{ 	ix=int(numrows/10); pc10=arr[ix]; ix=int(numrows*9/10);pc90=arr[ix]; \
				if (numrows%2==1) med=arr[(numrows+1)/2]; else med=(arr[numrows/2]); \
			}; \
			pktloss = numdrops/(numdrops+numrows) * 100; \
			printf("  Latency: (in msec, %d pings, %4.2f%% packet loss)\n      Min: %4.3f \n    10pct: %4.3f \n   Median: %4.3f \n      Avg: %4.3f \n    90pct: %4.3f \n      Max: %4.3f\n", numrows, pktloss, arr[1], pc10, med, sum/numrows, pc90, arr[numrows] )\
		 }'
}

# Summarize the contents of the load file and speedtest process stat file
# to show mean/stddev CPU utilization, and script CPU usage.
#   input parameter ($1) file contains CPU load samples from /proc/stat

summarize_load() {
	cat $1 /proc/$$/stat | awk '
# total CPU of speedtest processes
$1 !~ /cpu/ {
	tot=$16+$17
	if (init_proc_cpu=="") init_proc_cpu=tot
	proc_cpu=tot-init_proc_cpu
}
# track aggregate CPU stats
$1 == "cpu" {
	tot=0; for (f=2;f<=NF;f++) tot+=$f
	if (init_cpu=="") init_cpu=tot
	tot_cpu=tot-init_cpu
}
# track per-CPU stats
$1 ~ /cpu[0-9]+/ {
	tot=0; for (f=2;f<=NF;f++) tot+=$f
	usg = tot - $5
	if (init_tot[$1]=="") {
		init_tot[$1]=tot
		init_usg[$1]=usg
		cpus[num_cpus++]=$1
	}
	if (last_tot[$1]>0) {
		sum_usg_2[$1] += ((usg-last_usg[$1])/(tot-last_tot[$1]))^2
	}
	last_tot[$1]=tot
	last_usg[$1]=usg
}
END {
	num_samp=(NR-2)/(num_cpus+1)-1
	printf("Processor: (in %% busy, avg +/- stddev, %d samples)\n", num_samp)
	for (i=0;i<num_cpus;i++) {
		c=cpus[i]
		if (num_samp>0) {
			avg_usg=(last_tot[c]-init_tot[c])
			avg_usg=avg_usg>0 ? (last_usg[c]-init_usg[c])/avg_usg : 0
			std_usg=sum_usg_2[c]/num_samp-avg_usg^2
			std_usg=std_usg>0 ? sqrt(std_usg) : 0
			printf("%9s: %2.f +/- %2.f\n", c, avg_usg*100, std_usg*100)
		}
	}
	printf(" Overhead: (in %% total CPU used)\n")
	printf("%9s: %2.f\n", "netperf", tot_cpu>0 ? proc_cpu/tot_cpu*100 : 0)
}'
}

# Summarize the contents of the speed file to show formatted transfer rate.
#   input parameter ($1) indicates transfer direction
#   input parameter ($2) file contains speed info from netperf

summarize_speed() {
	printf "%9s: %6.2f Mbps\n" $1 $(awk '{s+=$1} END {print s}' $2)
}

# Capture per-CPU and process load info at 1-second intervals.

sample_load() {
	cat /proc/$$/stat
	while : ; do
		sleep 1
#		egrep "^cpu[0-9]*" /proc/stat
		cat /proc/stat | grep cpu
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

# Stop the background netperf processes

wait_netperf() {
	# gets a list of PIDs for processes named 'netperf'
	# Wait until each of the background netperf processes completes
#	echo "Process is $$" 1>&2
#	echo $(pgrep -P $$ netperf) 1>&2
#	for i in $(pgrep -P $$ netperf); do
	for I in `pidof netperf`
	do
#	echo "Stopping $i" 1>&2
		[ -n "$1" ] && kill -9 $I
		wait $I 2>/dev/null
	done
}

# Stop the current sample_load() process

kill_load() {
#	echo "Load: $load_pid" 1>&2
	kill -9 $load_pid
	wait $load_pid 2>/dev/null
	load_pid=0
}

# Stop the current ping process

kill_pings() {
#	echo "Pings: $ping_pid" 1>&2
	kill -9 $ping_pid
	wait $ping_pid 2>/dev/null
	ping_pid=0
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

	DIRECTION=$1

	# Start Ping
	if [ "${TESTPROTO}" -eq "-4" ]; then
		ping  $PINGHOST > $PINGFILE &
	else
		ping6 $PINGHOST > $PINGFILE &
	fi
	ping_pid=$!
#	echo "Ping PID: $ping_pid" 1>&2

	# Start CPU load sampling
	sample_load > $LOADFILE &
	load_pid=$!
#	echo "Load PID: $load_pid" 1>&2

	# Start netperf datastreams between client and server
	if [ "${DIRECTION}" = "Bidirectional" ]; then
		start_netperf TCP_STREAM $ULFILE
		start_netperf TCP_MAERTS $DLFILE
	else
		# Start unidirectional netperf with the proper direction
		case $DIRECTION in
			Download) spd_test="TCP_MAERTS";;
			Upload) spd_test="TCP_STREAM";;
		esac
		start_netperf $spd_test $DLFILE
	fi

	# Wait until each background netperf processes completes
	wait_netperf

	# When netperf completes, stop the CPU monitor and pings
	kill_load
	kill_pings
	echo 1>&2

	# Print TCP Download/Upload speed
	if [ "${DIRECTION}" = "Bidirectional" ]; then
		summarize_speed Download $DLFILE
		summarize_speed Upload $ULFILE
	else
		summarize_speed $DIRECTION $DLFILE
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
