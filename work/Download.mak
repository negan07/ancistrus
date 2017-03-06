NVRAM			:= nvram
UTELNETD		:= utelnetd-0.1.11
IPROUTE2		:= iproute2-4.10.0
QOS_SQM			:= qos-sqm-scripts-0.0.0
QOS_NG_36_42N		:= qos-netgear-36_42n

DL_$(NVRAM)		:= $(shell echo ../*_src)/Source/apps
TAR_$(NVRAM)		:= nvram

DL_$(UTELNETD)		:= http://public.pengutronix.de/software/utelnetd
TAR_$(UTELNETD)		:= utelnetd-0.1.11.tar.gz

DL_$(IPROUTE2)		:= https://www.kernel.org/pub/linux/utils/net/iproute2
TAR_$(IPROUTE2)		:= iproute2-4.10.0.tar.gz

DL_$(QOS_SQM)		:= void
TAR_$(QOS_SQM)		:= void

DL_$(QOS_NG_36_42N)	:= void
TAR_$(QOS_NG_36_42N)	:= void

#DL_$():=
#TAR_$():=

#DL_$():=
#TAR_$():=

#DL_$():=
#TAR_$():=

