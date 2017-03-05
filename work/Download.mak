NVRAM			:= nvram
UTELNETD		:= utelnetd-0.1.11
IPROUTE2		:= iproute2-4.10.0
QOS			:= qos-0.0.0

DL_$(NVRAM)		:= $(shell echo ../$(PROJECT_TARGET)*_src)/Source/apps
TAR_$(NVRAM)		:= nvram

DL_$(UTELNETD)		:= http://public.pengutronix.de/software/utelnetd
TAR_$(UTELNETD)		:= utelnetd-0.1.11.tar.gz

DL_$(IPROUTE2)		:= https://www.kernel.org/pub/linux/utils/net/iproute2
TAR_$(IPROUTE2)		:= iproute2-4.10.0.tar.gz

DL_$(QOS)		:= void
TAR_$(QOS)		:= void

#DL_$():=
#TAR_$():=

#DL_$():=
#TAR_$():=

#DL_$():=
#TAR_$():=

#DL_$():=
#TAR_$():=

