#!/bin/sh
#
# This script is the union of betterspeedtest.sh and netperfrunner.sh and it is invoked with a symlink named as each one.
# If no symlink is given, betterspeedtest.sh is run as default.
#
# Usage: [betterspeedtest.sh | netperfrunner.sh] [-4 -6] [ -H netperf-server ] [ -t duration ] [ -p host-to-ping ] [ -n simultaneous-sessions ]
#
# Options (if present):
#
# -H | --host:   	DNS or IP address of a netperf server	(default: netperf.bufferbloat.net)
#			Alternate servers are netperf-east (east coast US), netperf-west (California) and netperf-eu (Denmark)
# -4 | -6:		Enable ipv4 or ipv6 testing		(default: ipv4)
# -t | --time:		Test duration time on each direction	(default: 60 seconds)
# -p | --ping:   	Host to ping for latency measurements	(default: gstatic.com)
# -n | --number:	Number of simultaneous up/dl sessions	(default: 5 sessions with betterspeedtest, 4 sessions with netperfrunner)
#			betterspeedtest: 5 sessions chosen empirically because total didn't increase much after that number
#			netperfrunner: 4 sessions chosen to match default of RRUL test
#
# Copyright (c) 2014 - Rich Brown rich.brown@blueberryhillsoftware.com
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

summarize_pings() {			
# Process the ping times, and summarize the results.
# Summarize the contents of the ping's output file to show min, avg, median, max, etc.
# Input parameter ($1) file contains the output of the ping command.
# grep to keep lines that have "time=", then sed to isolate the time stamps, and awk bubble-sort them.
# awk builds an array of those values, and prints first & last (which are min, max) and computes average.
# If the number of samples is >= 10, also computes median, and 10th and 90th percentile readings.
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

start_ping() {
# Start Ping
if [ $TESTPROTO -eq "-4" ]; then
ping $PINGHOST > $PINGFILE &
else
ping6 $PINGHOST > $PINGFILE &
fi
ping_pid=$!
}

kill_pings() {
# Stop the current ping process
kill -9 $ping_pid 
wait $ping_pid 2>/dev/null
ping_pid=0
}

netperf_loop() {
# Start $MAXSESSIONS datastreams from netperf client to the netperf server: netperf writes the output value to $DESTFILE when completed
local TESTNAME=$1
local DESTFILE=$2
local I=1
while [ $I -le $MAXSESSIONS ]; do
netperf $TESTPROTO -H $TESTHOST -t $TESTNAME -l $TESTDUR -v 0 -P 0 >> $DESTFILE &
let I++
done
}

netperf_wait() {
# Gets a list of PIDs for processes named 'netperf'
# Wait until each of the background netperf processes completes
for I in `pidof netperf`; do wait $I; done
}

create_tmp_files() {
PINGFILE=/tmp/measurepings.${DATE} && touch $PINGFILE
DLFILE=/tmp/netperfDL.${DATE} && touch $DLFILE
ULFILE=/tmp/netperfUL.${DATE} && touch $ULFILE
SPEEDFILE=$ULFILE
}

measure_direction() {
# ------------ Measure speed and ping latency for one direction ----------------
#
# Call measure_direction() with single parameter - "Download" or "  Upload"
# The function gets other info from globals determined from command-line arguments

# Choose down/up netperf direction
[ "$1" = "  Upload" ] && DIRECTION="TCP_STREAM" || DIRECTION="TCP_MAERTS"

# Create temp files for netperf up/download results
create_tmp_files

# Start Ping
start_ping

# Start netperf streams
netperf_loop $DIRECTION $SPEEDFILE

# Wait for netperf processes termination
netperf_wait

# When netperf completes, stop the pings
kill_pings

# Print TCP Download speed
echo
echo " $1: `awk '{s+=$1} END {print s * 1024}' $SPEEDFILE` Kbps"

# Summarize the ping data
summarize_pings $PINGFILE

# Clean up
rm -f /tmp/*.${DATE}
}

betterspeedtest() {
# Betterspeedtest.sh - Script to simulate http://speedtest.net
# Start pinging, then initiate a download, let it finish, then start an upload
# Output the measured transfer rates and the resulting ping latency
# It's better than 'speedtest.net' because it measures latency *while* measuring the speed.

# Splash
echo "$DATE - Running betterspeedtest" 1>&2
echo 1>&2
echo "Testing: $TESTHOST" 1>&2
echo "Protocol: $PROTO" 1>&2
echo "Pinging: $PINGHOST" 1>&2
echo "Simultaneous sessions number: $MAXSESSIONS" 1>&2
echo "Duration: $TESTDUR seconds on each direction" 1>&2

measure_direction "Download" 
measure_direction "  Upload" 
}

netperfrunner() {
# Netperfrunner.sh - a shell script that runs several netperf commands simultaneously.
# This mimics the stress test of Flent (www.flent.org - formerly, "netperf-wrapper") 
# from Toke <toke@toke.dk> but doesn't have the nice GUI result. 
# This test is part of the CeroWrt project. To learn more, visit: http://bufferbloat.net/projects/cerowrt/
# This can live in /usr/lib/OpenWrtScripts
# 
# When you start this script, it concurrently uploads and downloads multiple
# streams (files) to a server on the Internet. This places a heavy load 
# on the bottleneck link of your network (probably your connection to the 
# Internet). It also starts a ping to a well-connected host. It displays:
#
# a) total bandwidth available 
# b) the distribution of ping latency

# Splash
echo "$DATE - Running netperfrunner" 1>&2
echo 1>&2
echo "Testing: $TESTHOST" 1>&2
echo "Protocol: $PROTO" 1>&2
echo "Pinging: $PINGHOST" 1>&2
echo "Up/Down streams number: $MAXSESSIONS" 1>&2
echo "Duration: $TESTDUR seconds" 1>&2

# Create temp files for netperf up/download results
create_tmp_files

# Start Ping
start_ping

# Start netperf upload streams
netperf_loop TCP_STREAM $ULFILE

# Start netperf download streams
netperf_loop TCP_MAERTS $DLFILE

# Wait for netperf processes termination
netperf_wait

# When netperf completes, stop the pings
kill_pings

# Sum up all the values (one line per netperf test) from $DLFILE and $ULFILE
# then summarize the ping stat's
echo " Download: `awk '{s+=$1} END {print s * 1024}' $DLFILE` Kbps"
echo "   Upload: `awk '{s+=$1} END {print s * 1024}' $ULFILE` Kbps"

# Summarize the ping data
summarize_pings $PINGFILE

# Clean up
rm -f /tmp/*.${DATE}
}

# ------- Start of the main routine --------
# set an initial values for defaults
THIS=`basename $0`
TESTHOST="netperf.bufferbloat.net"
TESTDUR="60"
PINGHOST="gstatic.com"
[ "${THIS}" = "netperfrunner.sh" ] && MAXSESSIONS="4" || MAXSESSIONS="5"
TESTPROTO="-4"
DATE=`date "+%Y-%m-%d_%H:%M:%S"`

# read the options
# extract options and their arguments into variables.
while [ $# -gt 0 ] 
do
case "$1" in
	-4|-6) TESTPROTO=$1 ; shift 1 ;;
	-H|--host)
		case "$2" in
		"") echo "Missing hostname" 1>&2; exit 1 ;;
		*) TESTHOST=$2 ; shift 2 ;;
		esac ;;
	-t|--time) 
		case "$2" in
		"") echo "Missing duration" 1>&2; exit 1 ;;
		*) TESTDUR=$2 ; shift 2 ;;
		esac ;;
	-p|--ping)
		case "$2" in
		"") echo "Missing ping host" 1>&2; exit 1 ;;
		*) PINGHOST=$2 ; shift 2 ;;
		esac ;;
	-n|--number)
		case "$2" in
		"") echo "Missing number of simultaneous sessions" 1>&2; exit 1 ;;
		*) MAXSESSIONS=$2 ; shift 2 ;;
        	esac ;;
	--) shift 1 ; break ;;
	*) echo "Usage: $0 [ -4 | -6 ] [ -H netperf-server ] [ -t duration ] [ -p host-to-ping ] [ -n simultaneous-sessions ]" 1>&2; exit 1 ;;
esac
done

# Start main test
[ $TESTPROTO -eq "-4" ] && PROTO="ipv4" || PROTO="ipv6"

# Switch to the `basename $0` test
[ "${THIS}" = "netperfrunner.sh" ] && netperfrunner || betterspeedtest

exit 0
