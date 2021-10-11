# LIST OF WORK DIRS & TARS
DIRLIST				:=
TARLIST				:=
# NVRAM
NVRAM_NAME			:= nvram
VER_$(NVRAM_NAME)		:= 0.1.4
NVRAM				:= $(NVRAM_NAME)-$(VER_$(NVRAM_NAME))
NAME_$(NVRAM)			:= $(NVRAM_NAME)$(DBG)
SUBVER_$(NVRAM)			:= 
VER_$(NVRAM)			:= $(VER_$(NVRAM_NAME))$(SUBVER_$(NVRAM))
DL_$(NVRAM)			:= $(SRC_APPS_REL_DIR)
TAR_$(NVRAM)			:= nvram
HOME_$(NVRAM)			:= http://www.sercomm.com/
LIC_$(NVRAM)			:= Sercomm Corporation
SEC_$(NVRAM)			:= libs
PRIO_$(NVRAM)			:= required
DEP_$(NVRAM)			:= 
DESC_$(NVRAM)			:= Enhanced shared libscnvram
DIRLIST				+= $(NVRAM)
# CORE
CORE_WORK_NAME			:= $(PROJECT_NAME)-core
VER_$(CORE_WORK_NAME)		:= 1.7.1
CORE_WORK			:= $(CORE_WORK_NAME)-$(VER_$(CORE_WORK_NAME))
NAME_$(CORE_WORK)		:= $(CORE_WORK_NAME)$(DBG)
SUBVER_$(CORE_WORK)		:= 
VER_$(CORE_WORK)		:= $(VER_$(CORE_WORK_NAME))$(SUBVER_$(CORE_WORK))
DL_$(CORE_WORK)			:= void
TAR_$(CORE_WORK)		:= void
HOME_$(CORE_WORK)		:= $(GITHUB_DIR)
LIC_$(CORE_WORK)		:= $(LICENSE_NAME)
SEC_$(CORE_WORK)		:= core
PRIO_$(CORE_WORK)		:= required
DEP_$(CORE_WORK)		:= 
DESC_$(CORE_WORK)		:= Main work tool & enhanced nvram lib
# BUSYBOX
BUSYBOX_NAME			:= busybox
VER_$(BUSYBOX_NAME)		:= 1.34.1
BUSYBOX				:= $(BUSYBOX_NAME)-$(VER_$(BUSYBOX_NAME))
NAME_$(BUSYBOX)			:= $(BUSYBOX_NAME)$(DBG)
SUBVER_$(BUSYBOX)		:= 
VER_$(BUSYBOX)			:= $(VER_$(BUSYBOX_NAME))$(SUBVER_$(BUSYBOX))
DL_$(BUSYBOX)			:= https://busybox.net/downloads
TAR_$(BUSYBOX)			:= $(BUSYBOX).tar.bz2
HOME_$(BUSYBOX)			:= https://busybox.net/
LIC_$(BUSYBOX)			:= GPLv2
SEC_$(BUSYBOX)			:= base
PRIO_$(BUSYBOX)			:= required
DEP_$(BUSYBOX)			:= 
DESC_$(BUSYBOX)			:= The Swiss Army Knife of Embedded Linux
DIRLIST				+= $(BUSYBOX)
TARLIST				+= $(TAR_$(BUSYBOX))
# UTELNETD
UTELNETD_NAME			:= utelnetd
VER_$(UTELNETD_NAME)		:= 0.1.11
UTELNETD			:= $(UTELNETD_NAME)-$(VER_$(UTELNETD_NAME))
NAME_$(UTELNETD)		:= $(UTELNETD_NAME)$(DBG)
SUBVER_$(UTELNETD)		:= -114
VER_$(UTELNETD)			:= $(VER_$(UTELNETD_NAME))$(SUBVER_$(UTELNETD))
DL_$(UTELNETD)			:= http://public.pengutronix.de/software/utelnetd
TAR_$(UTELNETD)			:= $(UTELNETD).tar.gz
HOME_$(UTELNETD)		:= http://public.pengutronix.de/software/utelnetd
LIC_$(UTELNETD)			:= GPLv2
SEC_$(UTELNETD)			:= base
PRIO_$(UTELNETD)		:= standard
DEP_$(UTELNETD)			:= 
DESC_$(UTELNETD)		:= Small telnet daemon for standalone use
DIRLIST				+= $(UTELNETD)
TARLIST				+= $(TAR_$(UTELNETD))
# IPROUTE2
IPROUTE2_NAME			:= iproute2
VER_$(IPROUTE2_NAME)		:= 3.5.1
IPROUTE2			:= $(IPROUTE2_NAME)-$(VER_$(IPROUTE2_NAME))
NAME_$(IPROUTE2)		:= $(IPROUTE2_NAME)$(DBG)
SUBVER_$(IPROUTE2)		:= 
VER_$(IPROUTE2)			:= $(VER_$(IPROUTE2_NAME))$(SUBVER_$(IPROUTE2))
DL_$(IPROUTE2)			:= https://www.kernel.org/pub/linux/utils/net/iproute2
TAR_$(IPROUTE2)			:= $(IPROUTE2).tar.gz
HOME_$(IPROUTE2)		:= https://wiki.linuxfoundation.org/networking/iproute2
LIC_$(IPROUTE2)			:= GPLv2
SEC_$(IPROUTE2)			:= aux
PRIO_$(IPROUTE2)		:= standard
DEP_$(IPROUTE2)			:= 
DESC_$(IPROUTE2)		:= Set of utilities for Linux networking
DIRLIST				+= $(IPROUTE2)
TARLIST				+= $(TAR_$(IPROUTE2))
# NETPERF
NETPERF_NAME			:= netperf
VER_$(NETPERF_NAME)		:= 2.7.1
NETPERF				:= $(NETPERF_NAME)-bcb868bde7f0203bbab69609f65d4088ba7398db
NAME_$(NETPERF)			:= $(NETPERF_NAME)$(DBG)
SUBVER_$(NETPERF)		:= -703
VER_$(NETPERF)			:= $(VER_$(NETPERF_NAME))$(SUBVER_$(NETPERF))
DL_$(NETPERF)			:= https://github.com/HewlettPackard/netperf/archive
TAR_$(NETPERF)			:= bcb868bde7f0203bbab69609f65d4088ba7398db.zip
HOME_$(NETPERF)			:= https://hewlettpackard.github.io/netperf/
LIC_$(NETPERF)			:= Hewlett-Packard
SEC_$(NETPERF)			:= aux
PRIO_$(NETPERF)			:= optional
DEP_$(NETPERF)			:= 
DESC_$(NETPERF)			:= TCP/UDP/sockets/etc performance benchmark
DIRLIST				+= $(NETPERF)
TARLIST				+= $(TAR_$(NETPERF))
# NETWORK TEST
NETWORKTEST_NAME		:= network-test
VER_$(NETWORKTEST_NAME)		:= 1.0.1
NETWORKTEST			:= $(NETWORKTEST_NAME)-$(VER_$(NETWORKTEST_NAME))
NAME_$(NETWORKTEST)		:= $(NETWORKTEST_NAME)$(DBG)
SUBVER_$(NETWORKTEST)		:= 
VER_$(NETWORKTEST)		:= $(VER_$(NETWORKTEST_NAME))$(SUBVER_$(NETWORKTEST))
DL_$(NETWORKTEST)		:= void
TAR_$(NETWORKTEST)		:= void
HOME_$(NETWORKTEST)		:= https://github.com/richb-hanover/CeroWrtScripts
LIC_$(NETWORKTEST)		:= GPLv2
SEC_$(NETWORKTEST)		:= net
PRIO_$(NETWORKTEST)		:= optional
DEP_$(NETWORKTEST)		:= 
DESC_$(NETWORKTEST)		:= Enhanced network speed & stress test script based on netperf
# SPEEDTEST NET
SPEEDTESTNET_NAME		:= speedtest-net
VER_$(SPEEDTESTNET_NAME)	:= 1.0.5
SPEEDTESTNET			:= $(SPEEDTESTNET_NAME)-$(VER_$(SPEEDTESTNET_NAME))
NAME_$(SPEEDTESTNET)		:= $(SPEEDTESTNET_NAME)$(DBG)
SUBVER_$(SPEEDTESTNET)		:= 
VER_$(SPEEDTESTNET)		:= $(VER_$(SPEEDTESTNET_NAME))$(SUBVER_$(SPEEDTESTNET))
DL_$(SPEEDTESTNET)		:= void
TAR_$(SPEEDTESTNET)		:= void
HOME_$(SPEEDTESTNET)		:= https://www.speedtest.net
LIC_$(SPEEDTESTNET)		:= https://www.speedtest.net/about/eula
SEC_$(SPEEDTESTNET)		:= net
PRIO_$(SPEEDTESTNET)		:= optional
DEP_$(SPEEDTESTNET)		:= $(NAME_$(BUSYBOX))
DESC_$(SPEEDTESTNET)		:= Official Ookla Speedtest CLI for personal, non-commercial use
# XDSL DRIVER ORIG
XDSL_042N_D26B_NAME		:= xdsl-driver-orig
VER_$(XDSL_042N_D26B_NAME)	:= 042n.d26b
XDSL_042N_D26B			:= $(XDSL_042N_D26B_NAME)-$(VER_$(XDSL_042N_D26B_NAME))
NAME_$(XDSL_042N_D26B)		:= $(XDSL_042N_D26B_NAME)$(DBG)
SUBVER_$(XDSL_042N_D26B)	:= -001
VER_$(XDSL_042N_D26B)		:= $(VER_$(XDSL_042N_D26B_NAME))$(SUBVER_$(XDSL_042N_D26B))
DL_$(XDSL_042N_D26B)		:= void
TAR_$(XDSL_042N_D26B)		:= void
HOME_$(XDSL_042N_D26B)		:= http://www.broadcom.com
LIC_$(XDSL_042N_D26B)		:= Broadcom inc
SEC_$(XDSL_042N_D26B)		:= dsl
PRIO_$(XDSL_042N_D26B)		:= required
DEP_$(XDSL_042N_D26B)		:= 
DESC_$(XDSL_042N_D26B)		:= Install the original XDSL driverset
# XDSL DRIVER AGTEF DGA4130
XDSL_042U_D26O_NAME		:= xdsl-driver-agtef
VER_$(XDSL_042U_D26O_NAME)	:= 042u.d26o
XDSL_042U_D26O			:= $(XDSL_042U_D26O_NAME)-$(VER_$(XDSL_042U_D26O_NAME))
NAME_$(XDSL_042U_D26O)		:= $(XDSL_042U_D26O_NAME)$(DBG)
SUBVER_$(XDSL_042U_D26O)	:= -001
VER_$(XDSL_042U_D26O)		:= $(VER_$(XDSL_042U_D26O_NAME))$(SUBVER_$(XDSL_042U_D26O))
DL_$(XDSL_042U_D26O)		:= void
TAR_$(XDSL_042U_D26O)		:= void
HOME_$(XDSL_042U_D26O)		:= http://www.broadcom.com
LIC_$(XDSL_042U_D26O)		:= Broadcom inc
SEC_$(XDSL_042U_D26O)		:= dsl
PRIO_$(XDSL_042U_D26O)		:= required
DEP_$(XDSL_042U_D26O)		:= 
DESC_$(XDSL_042U_D26O)		:= Install the Agtef DGA4130 XDSL driverset
# QOS NG
QOS_NG_NAME			:= qos-netgear
VER_$(QOS_NG_NAME)		:= 36_42n
QOS_NG				:= $(QOS_NG_NAME)-$(VER_$(QOS_NG_NAME))
NAME_$(QOS_NG)			:= $(QOS_NG_NAME)$(DBG)
SUBVER_$(QOS_NG)		:= 
VER_$(QOS_NG)			:= $(VER_$(QOS_NG_NAME))$(SUBVER_$(QOS_NG))
DL_$(QOS_NG)			:= void
TAR_$(QOS_NG)			:= void
HOME_$(QOS_NG)			:= http://www.netgear.com
LIC_$(QOS_NG)			:= Netgear inc
SEC_$(QOS_NG)			:= base
PRIO_$(QOS_NG)			:= standard
DEP_$(QOS_NG)			:= 
DESC_$(QOS_NG)			:= Quality Of Service tool from Netgear firmware 36_42n
# QOS SQM
QOS_SQM_NAME			:= qos-sqm
VER_$(QOS_SQM_NAME)		:= 2.1.4
QOS_SQM				:= $(QOS_SQM_NAME)-$(VER_$(QOS_SQM_NAME))
NAME_$(QOS_SQM)			:= $(QOS_SQM_NAME)$(DBG)
SUBVER_$(QOS_SQM)		:= -005
VER_$(QOS_SQM)			:= $(VER_$(QOS_SQM_NAME))$(SUBVER_$(QOS_SQM))
DL_$(QOS_SQM)			:= void
TAR_$(QOS_SQM)			:= void
HOME_$(QOS_SQM)			:= https://github.com/tohojo/sqm-scripts
LIC_$(QOS_SQM)			:= GPLv2
SEC_$(QOS_SQM)			:= net
PRIO_$(QOS_SQM)			:= standard
DEP_$(QOS_SQM)			:= $(NAME_$(CORE_WORK))
DESC_$(QOS_SQM)			:= Quality Of Service SQM scripts traffic shaper tool
# ZLIB
ZLIB_NAME			:= zlib
VER_$(ZLIB_NAME)		:= 1.2.11.1-motley
ZLIB				:= $(ZLIB_NAME)-develop
NAME_$(ZLIB)			:= $(ZLIB_NAME)$(DBG)
SUBVER_$(ZLIB)			:= -469
VER_$(ZLIB)			:= $(VER_$(ZLIB_NAME))$(SUBVER_$(ZLIB))
DL_$(ZLIB)			:= https://github.com/madler/zlib/archive
TAR_$(ZLIB)			:= develop.zip
HOME_$(ZLIB)			:= http://zlib.net
LIC_$(ZLIB)			:= GPLv2
SEC_$(ZLIB)			:= libs
PRIO_$(ZLIB)			:= required
DEP_$(ZLIB)			:= 
DESC_$(ZLIB)			:= A Massively Spiffy Yet Delicately Unobtrusive Compression Library
DIRLIST				+= $(ZLIB)
TARLIST				+= $(TAR_$(ZLIB))
# OPENSSL
OPENSSL_NAME			:= openssl
VER_$(OPENSSL_NAME)		:= 1.0.2u
OPENSSL				:= $(OPENSSL_NAME)-$(VER_$(OPENSSL_NAME))
NAME_$(OPENSSL)			:= $(OPENSSL_NAME)$(DBG)
SUBVER_$(OPENSSL)		:= 
VER_$(OPENSSL)			:= $(VER_$(OPENSSL_NAME))$(SUBVER_$(OPENSSL))
DL_$(OPENSSL)			:= http://artfiles.org/openssl.org/source
DL_$(OPENSSL)			:= http://artfiles.org/openssl.org/source/old/1.0.2
TAR_$(OPENSSL)			:= $(OPENSSL).tar.gz
HOME_$(OPENSSL)			:= https://www.openssl.org/
LIC_$(OPENSSL)			:= GPLv2
SEC_$(OPENSSL)			:= libs
PRIO_$(OPENSSL)			:= required
DEP_$(OPENSSL)			:= 
DESC_$(OPENSSL)			:= Cryptography and SSL/TLS Toolkit
DIRLIST				+= $(OPENSSL)
TARLIST				+= $(TAR_$(OPENSSL))
# ARES
ARES_NAME			:= c-ares
VER_$(ARES_NAME)		:= 1.17.2
ARES				:= $(ARES_NAME)-$(VER_$(ARES_NAME))
NAME_$(ARES)			:= $(ARES_NAME)$(DBG)
SUBVER_$(ARES)			:= 
VER_$(ARES)			:= $(VER_$(ARES_NAME))$(SUBVER_$(ARES))
DL_$(ARES)			:= https://c-ares.haxx.se/download
TAR_$(ARES)			:= $(ARES).tar.gz
HOME_$(ARES)			:= https://c-ares.haxx.se/
LIC_$(ARES)			:= MIT/X
SEC_$(ARES)			:= libs
PRIO_$(ARES)			:= optional
DEP_$(ARES)			:= 
DESC_$(ARES)			:= Library for asyncronous DNS Requests (including name resolves)
DIRLIST				+= $(ARES)
TARLIST				+= $(TAR_$(ARES))
# CURL
CURL_NAME			:= curl
VER_$(CURL_NAME)		:= 7.79.1
CURL				:= $(CURL_NAME)-$(VER_$(CURL_NAME))
NAME_$(CURL)			:= $(CURL_NAME)$(DBG)
SUBVER_$(CURL)			:= 
VER_$(CURL)			:= $(VER_$(CURL_NAME))$(SUBVER_$(CURL))
DL_$(CURL)			:= https://curl.haxx.se/download
TAR_$(CURL)			:= $(CURL).tar.gz
HOME_$(CURL)			:= https://curl.haxx.se/
LIC_$(CURL)			:= MIT/X
SEC_$(CURL)			:= libs
PRIO_$(CURL)			:= required
DEP_$(CURL)			:= $(NAME_$(ZLIB)),$(NAME_$(OPENSSL))
DESC_$(CURL)			:= Command line tool and library for transferring data with URLs
DIRLIST				+= $(CURL)
TARLIST				+= $(TAR_$(CURL))
# ARCHIVE
ARCHIVE_NAME			:= libarchive
VER_$(ARCHIVE_NAME)		:= 3.5.2
ARCHIVE				:= $(ARCHIVE_NAME)-$(VER_$(ARCHIVE_NAME))
NAME_$(ARCHIVE)			:= $(ARCHIVE_NAME)$(DBG)
SUBVER_$(ARCHIVE)		:= 
VER_$(ARCHIVE)			:= $(VER_$(ARCHIVE_NAME))$(SUBVER_$(ARCHIVE))
DL_$(ARCHIVE)			:= http://www.libarchive.org/downloads
TAR_$(ARCHIVE)			:= $(ARCHIVE).tar.gz
HOME_$(ARCHIVE)			:= http://www.libarchive.org/
LIC_$(ARCHIVE)			:= GPLv2
SEC_$(ARCHIVE)			:= libs
PRIO_$(ARCHIVE)			:= required
DEP_$(ARCHIVE)			:= 
DESC_$(ARCHIVE)			:= Portable efficient C library for many streaming archive formats
DIRLIST				+= $(ARCHIVE)
TARLIST				+= $(TAR_$(ARCHIVE))
# OPKGUTILS
OPKG_UTILS_NAME			:= opkg-utils
VER_$(OPKG_UTILS_NAME)		:= 0.4.3
OPKG_UTILS			:= $(OPKG_UTILS_NAME)-$(VER_$(OPKG_UTILS_NAME))
NAME_$(OPKG_UTILS)		:= $(OPKG_UTILS_NAME)$(DBG)
SUBVER_$(OPKG_UTILS)		:= -001
VER_$(OPKG_UTILS)		:= $(VER_$(OPKG_UTILS_NAME))$(SUBVER_$(OPKG_UTILS))
DL_$(OPKG_UTILS)		:= http://git.yoctoproject.org/cgit/cgit.cgi/opkg-utils/snapshot
TAR_$(OPKG_UTILS)		:= $(OPKG_UTILS).tar.gz
HOME_$(OPKG_UTILS)		:= http://git.yoctoproject.org/cgit/cgit.cgi/opkg-utils
LIC_$(OPKG_UTILS)		:= GPLv2
SEC_$(OPKG_UTILS)		:= base
PRIO_$(OPKG_UTILS)		:= required
DEP_$(OPKG_UTILS)		:= 
DESC_$(OPKG_UTILS)		:= Lightweight package prepare and build management system
DIRLIST				+= $(OPKG_UTILS)
TARLIST				+= $(TAR_$(OPKG_UTILS))
# OPKG
OPKG_NAME			:= opkg
VER_$(OPKG_NAME)		:= 0.4.4
OPKG				:= $(OPKG_NAME)-$(VER_$(OPKG_NAME))
NAME_$(OPKG)			:= $(OPKG_NAME)$(DBG)
SUBVER_$(OPKG)			:= -010
VER_$(OPKG)			:= $(VER_$(OPKG_NAME))$(SUBVER_$(OPKG))
DL_$(OPKG)			:= https://git.yoctoproject.org/cgit/cgit.cgi/opkg/snapshot
TAR_$(OPKG)			:= $(OPKG).tar.gz
HOME_$(OPKG)			:= https://git.yoctoproject.org/cgit/cgit.cgi/opkg/
LIC_$(OPKG)			:= GPLv2
SEC_$(OPKG)			:= base
PRIO_$(OPKG)			:= required
DEP_$(OPKG)			:= $(NAME_$(ZLIB)),$(NAME_$(OPENSSL))
DESC_$(OPKG)			:= Lightweight package management system
DIRLIST				+= $(OPKG)
TARLIST				+= $(TAR_$(OPKG))
# HDPARM
HDPARM_NAME			:= hdparm
VER_$(HDPARM_NAME)		:= 9.62
HDPARM				:= $(HDPARM_NAME)-$(VER_$(HDPARM_NAME))
NAME_$(HDPARM)			:= $(HDPARM_NAME)$(DBG)
SUBVER_$(HDPARM)		:= -001
VER_$(HDPARM)			:= $(VER_$(HDPARM_NAME))$(SUBVER_$(HDPARM))
DL_$(HDPARM)			:= https://sourceforge.net/projects/hdparm/files/hdparm
TAR_$(HDPARM)			:= $(HDPARM).tar.gz
HOME_$(HDPARM)			:= https://sourceforge.net/projects/hdparm/
LIC_$(HDPARM)			:= BSD
SEC_$(HDPARM)			:= base
PRIO_$(HDPARM)			:= required
DEP_$(HDPARM)			:= 
DESC_$(HDPARM)			:= Get/set ATA/SATA drive parameters under Linux
DIRLIST				+= $(HDPARM)
TARLIST				+= $(TAR_$(HDPARM))
# HDIDLE
HDIDLE_NAME			:= hd-idle
VER_$(HDIDLE_NAME)		:= 1.05
HDIDLE				:= $(HDIDLE_NAME)
NAME_$(HDIDLE)			:= $(HDIDLE_NAME)$(DBG)
SUBVER_$(HDIDLE)		:= -006
VER_$(HDIDLE)			:= $(VER_$(HDIDLE_NAME))$(SUBVER_$(HDIDLE))
DL_$(HDIDLE)			:= https://sourceforge.net/projects/hd-idle/files
TAR_$(HDIDLE)			:= $(HDIDLE)-1.05.tgz
HOME_$(HDIDLE)			:= http://hd-idle.sourceforge.net/
LIC_$(HDIDLE)			:= GPLv2
SEC_$(HDIDLE)			:= base
PRIO_$(HDIDLE)			:= required
DEP_$(HDIDLE)			:= $(NAME_$(CORE_WORK)),$(NAME_$(HDPARM))
DESC_$(HDIDLE)			:= Utility for spinning-down external disks after a period of time
DIRLIST				+= $(HDIDLE)
TARLIST				+= $(TAR_$(HDIDLE))
# SMARTMONTOOLS
SMONTOOLS_NAME			:= smartmontools
VER_$(SMONTOOLS_NAME)		:= 7.3
SMONTOOLS			:= $(SMONTOOLS_NAME)-$(VER_$(SMONTOOLS_NAME))
NAME_$(SMONTOOLS)		:= $(SMONTOOLS_NAME)$(DBG)
SUBVER_$(SMONTOOLS)		:= -r5236
VER_$(SMONTOOLS)		:= $(VER_$(SMONTOOLS_NAME))$(SUBVER_$(SMONTOOLS))
DL_$(SMONTOOLS)			:= https://1311-105252244-gh.circle-artifacts.com/0/builds
TAR_$(SMONTOOLS)		:= smartmontools-$(VER_$(SMONTOOLS)).src.tar.gz
HOME_$(SMONTOOLS)		:= https://www.smartmontools.org/
LIC_$(SMONTOOLS)		:= GPLv2
SEC_$(SMONTOOLS)		:= storage
PRIO_$(SMONTOOLS)		:= optional
DEP_$(SMONTOOLS)		:= $(NAME_$(CORE_WORK)),$(NAME_$(HDPARM)),$(NAME_$(HDIDLE))
DESC_$(SMONTOOLS)		:= Control and Monitor Utility for S.M.A.R.T. Disks
DIRLIST				+= $(SMONTOOLS)
TARLIST				+= $(TAR_$(SMONTOOLS))
# LZO
LZO_NAME			:= lzo
VER_$(LZO_NAME)			:= 2.10
LZO				:= $(LZO_NAME)-$(VER_$(LZO_NAME))
NAME_$(LZO)			:= $(LZO_NAME)$(DBG)
SUBVER_$(LZO)			:= 
VER_$(LZO)			:= $(VER_$(LZO_NAME))$(SUBVER_$(LZO))
DL_$(LZO)			:= http://www.oberhumer.com/opensource/lzo/download
TAR_$(LZO)			:= $(LZO).tar.gz
HOME_$(LZO)			:= http://www.oberhumer.com/opensource/lzo/
LIC_$(LZO)			:= GPLv2
SEC_$(LZO)			:= libs
PRIO_$(LZO)			:= required
DEP_$(LZO)			:= 
DESC_$(LZO)			:= A portable lossless data compression library
DIRLIST				+= $(LZO)
TARLIST				+= $(TAR_$(LZO))
# EASYRSA
EASYRSA_NAME			:= easy-rsa
VER_$(EASYRSA_NAME)		:= 3.0.8
EASYRSA				:= $(EASYRSA_NAME)-$(VER_$(EASYRSA_NAME))
NAME_$(EASYRSA)			:= $(EASYRSA_NAME)$(DBG)
SUBVER_$(EASYRSA)		:= 
VER_$(EASYRSA)			:= $(VER_$(EASYRSA_NAME))$(SUBVER_$(EASYRSA))
DL_$(EASYRSA)			:= https://github.com/OpenVPN/easy-rsa/archive
TAR_$(EASYRSA)			:= v$(VER_$(EASYRSA_NAME)).tar.gz
HOME_$(EASYRSA)			:= https://github.com/OpenVPN/easy-rsa
LIC_$(EASYRSA)			:= GPLv2
SEC_$(EASYRSA)			:= base
PRIO_$(EASYRSA)			:= required
DEP_$(EASYRSA)			:= 
DESC_$(EASYRSA)			:= Simple shell based CA utility
DIRLIST				+= $(EASYRSA)
TARLIST				+= $(TAR_$(EASYRSA))
# OPENVPN
OPEN_VPN_NAME			:= openvpn
VER_$(OPEN_VPN_NAME)		:= 2.5.4
OPEN_VPN			:= $(OPEN_VPN_NAME)-$(VER_$(OPEN_VPN_NAME))
NAME_$(OPEN_VPN)		:= $(OPEN_VPN_NAME)$(DBG)
SUBVER_$(OPEN_VPN)		:= 
VER_$(OPEN_VPN)			:= $(VER_$(OPEN_VPN_NAME))$(SUBVER_$(OPEN_VPN))
DL_$(OPEN_VPN)			:= https://build.openvpn.net/downloads/releases
TAR_$(OPEN_VPN)			:= $(OPEN_VPN).tar.gz
HOME_$(OPEN_VPN)		:= https://www.openvpn.net/
LIC_$(OPEN_VPN)			:= GPLv2
SEC_$(OPEN_VPN)			:= admin
PRIO_$(OPEN_VPN)		:= required
DEP_$(OPEN_VPN)			:= $(NAME_$(CORE_WORK))
DESC_$(OPEN_VPN)		:= Your private path to access network resources and services securely
DIRLIST				+= $(OPEN_VPN)
TARLIST				+= $(TAR_$(OPEN_VPN))
# ICONV
ICONV_NAME			:= libiconv
VER_$(ICONV_NAME)		:= 1.16
ICONV				:= $(ICONV_NAME)-$(VER_$(ICONV_NAME))
NAME_$(ICONV)			:= $(ICONV_NAME)$(DBG)
SUBVER_$(ICONV)			:= -002
VER_$(ICONV)			:= $(VER_$(ICONV_NAME))$(SUBVER_$(ICONV))
DL_$(ICONV)			:= https://ftp.gnu.org/pub/gnu/libiconv
TAR_$(ICONV)			:= $(ICONV).tar.gz
HOME_$(ICONV)			:= https://www.gnu.org/software/libiconv
LIC_$(ICONV)			:= GPLv2
SEC_$(ICONV)			:= base
PRIO_$(ICONV)			:= required
DEP_$(ICONV)			:= 
DESC_$(ICONV)			:= Character set conversion
DIRLIST				+= $(ICONV)
TARLIST				+= $(TAR_$(ICONV))
# MINIHTTPD
MINIHTTPD_NAME			:= mini_httpd
VER_$(MINIHTTPD_NAME)		:= 1.30
MINIHTTPD			:= $(MINIHTTPD_NAME)-$(VER_$(MINIHTTPD_NAME))
NAME_$(MINIHTTPD)		:= $(MINIHTTPD_NAME)$(DBG)
SUBVER_$(MINIHTTPD)		:= -133
VER_$(MINIHTTPD)		:= $(VER_$(MINIHTTPD_NAME))$(SUBVER_$(MINIHTTPD))
DL_$(MINIHTTPD)			:= https://acme.com/software/mini_httpd
TAR_$(MINIHTTPD)		:= $(MINIHTTPD).tar.gz
HOME_$(MINIHTTPD)		:= https://acme.com/software/mini_httpd
LIC_$(MINIHTTPD)		:= BSD-2-Clause
SEC_$(MINIHTTPD)		:= base
PRIO_$(MINIHTTPD)		:= required
DEP_$(MINIHTTPD)		:= 
DESC_$(MINIHTTPD)		:= Small HTTP(S) server
DIRLIST				+= $(MINIHTTPD)
TARLIST				+= $(TAR_$(MINIHTTPD))
# OPENSSH
OPEN_SSH_NAME			:= openssh
VER_$(OPEN_SSH_NAME)		:= 8.8p1
OPEN_SSH			:= $(OPEN_SSH_NAME)-$(VER_$(OPEN_SSH_NAME))
NAME_$(OPEN_SSH)		:= $(OPEN_SSH_NAME)$(DBG)
SUBVER_$(OPEN_SSH)		:= 
VER_$(OPEN_SSH)			:= $(VER_$(OPEN_SSH_NAME))$(SUBVER_$(OPEN_SSH))
DL_$(OPEN_SSH)			:= https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable
TAR_$(OPEN_SSH)			:= $(OPEN_SSH).tar.gz
HOME_$(OPEN_SSH)		:= https://www.openssh.com/
LIC_$(OPEN_SSH)			:= BSD, ISC
SEC_$(OPEN_SSH)			:= admin
PRIO_$(OPEN_SSH)		:= optional
DEP_$(OPEN_SSH)			:= $(NAME_$(ZLIB)),$(NAME_$(CORE_WORK))
DESC_$(OPEN_SSH)		:= Free SSH protocol suite providing encryption for network services
DIRLIST				+= $(OPEN_SSH)
TARLIST				+= $(TAR_$(OPEN_SSH))
# MINI_SNMPD
MINI_SNMPD_NAME			:= mini-snmpd
VER_$(MINI_SNMPD_NAME)		:= 1.6
MINI_SNMPD			:= $(MINI_SNMPD_NAME)-$(VER_$(MINI_SNMPD_NAME))
NAME_$(MINI_SNMPD)		:= $(MINI_SNMPD_NAME)$(DBG)
SUBVER_$(MINI_SNMPD)		:= -010
VER_$(MINI_SNMPD)		:= $(VER_$(MINI_SNMPD_NAME))$(SUBVER_$(MINI_SNMPD))
DL_$(MINI_SNMPD)		:= ftp://ftp.troglobit.com/mini-snmpd
TAR_$(MINI_SNMPD)		:= $(MINI_SNMPD).tar.gz
HOME_$(MINI_SNMPD)		:= http://troglobit.com/projects/mini-snmpd/
LIC_$(MINI_SNMPD)		:= GPLv2
SEC_$(MINI_SNMPD)		:= misc
PRIO_$(MINI_SNMPD)		:= optional
DEP_$(MINI_SNMPD)		:= $(NAME_$(CORE_WORK))
DESC_$(MINI_SNMPD)		:= SNMP server for small and embedded systems
DIRLIST				+= $(MINI_SNMPD)
TARLIST				+= $(TAR_$(MINI_SNMPD))
# DNRD
DNRD_NAME			:= dnrd
VER_$(DNRD_NAME)		:= 2.20.4
DNRD				:= $(DNRD_NAME)-$(VER_$(DNRD_NAME))
NAME_$(DNRD)			:= $(DNRD_NAME)$(DBG)
SUBVER_$(DNRD)			:= -001
VER_$(DNRD)			:= $(VER_$(DNRD_NAME))$(SUBVER_$(DNRD))
DL_$(DNRD)			:= https://github.com/benjaminpetrin/dnrd/archive
TAR_$(DNRD)			:= $(VER_$(DNRD_NAME)).tar.gz
HOME_$(DNRD)			:= https://github.com/benjaminpetrin/dnrd
LIC_$(DNRD)			:= GPLv2
SEC_$(DNRD)			:= base
PRIO_$(DNRD)			:= required
DEP_$(DNRD)			:= 
DESC_$(DNRD)			:= Caching, forwarding DNS proxy server
DIRLIST				+= $(DNRD)
TARLIST				+= $(TAR_$(DNRD))
# DNSMASQ
DNSMASQ_NAME			:= dnsmasq
VER_$(DNSMASQ_NAME)		:= 2.80
DNSMASQ				:= $(DNSMASQ_NAME)-$(VER_$(DNSMASQ_NAME))
NAME_$(DNSMASQ)			:= $(DNSMASQ_NAME)$(DBG)
SUBVER_$(DNSMASQ)		:= 
VER_$(DNSMASQ)			:= $(VER_$(DNSMASQ_NAME))$(SUBVER_$(DNSMASQ))
DL_$(DNSMASQ)			:= http://www.thekelleys.org.uk/dnsmasq
TAR_$(DNSMASQ)			:= $(DNSMASQ).tar.gz
HOME_$(DNSMASQ)			:= http://thekelleys.org.uk/dnsmasq/doc.html
LIC_$(DNSMASQ)			:= GPLv2
SEC_$(DNSMASQ)			:= base
PRIO_$(DNSMASQ)			:= optional
DEP_$(DNSMASQ)			:= 
DESC_$(DNSMASQ)			:= A lightweight DHCP and caching DNS server
DIRLIST				+= $(DNSMASQ)
TARLIST				+= $(TAR_$(DNSMASQ))
# E2FSPROGS
E2FSPROGS_NAME			:= e2fsprogs
VER_$(E2FSPROGS_NAME)		:= 1.46.2
E2FSPROGS			:= $(E2FSPROGS_NAME)-$(VER_$(E2FSPROGS_NAME))
NAME_$(E2FSPROGS)		:= $(E2FSPROGS_NAME)$(DBG)
SUBVER_$(E2FSPROGS)		:= -001
VER_$(E2FSPROGS)		:= $(VER_$(E2FSPROGS_NAME))$(SUBVER_$(E2FSPROGS))
DL_$(E2FSPROGS)			:= https://mirrors.edge.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v$(VER_$(E2FSPROGS_NAME))
TAR_$(E2FSPROGS)		:= $(E2FSPROGS).tar.gz
HOME_$(E2FSPROGS)		:= http://e2fsprogs.sourceforge.net
LIC_$(E2FSPROGS)		:= GPLv2
SEC_$(E2FSPROGS)		:= storage
PRIO_$(E2FSPROGS)		:= required
DEP_$(E2FSPROGS)		:= $(NAME_$(ICONV))
DESC_$(E2FSPROGS)		:= Ext2/3/4 Filesystem Utilities
DIRLIST				+= $(E2FSPROGS)
TARLIST				+= $(TAR_$(E2FSPROGS))
# NTFSPROGS
NTFSPROGS_NAME			:= ntfs-3g_ntfsprogs
VER_$(NTFSPROGS_NAME)		:= 2017.3.23
NTFSPROGS			:= $(NTFSPROGS_NAME)-$(VER_$(NTFSPROGS_NAME))
NAME_$(NTFSPROGS)		:= $(NTFSPROGS_NAME)$(DBG)
SUBVER_$(NTFSPROGS)		:= -5082
VER_$(NTFSPROGS)		:= $(VER_$(NTFSPROGS_NAME))$(SUBVER_$(NTFSPROGS))
DL_$(NTFSPROGS)			:= https://tuxera.com/opensource
TAR_$(NTFSPROGS)		:= $(NTFSPROGS).tgz
HOME_$(NTFSPROGS)		:= https://www.tuxera.com/community/open-source-ntfs-3g
LIC_$(NTFSPROGS)		:= GPLv2
SEC_$(NTFSPROGS)		:= storage
PRIO_$(NTFSPROGS)		:= optional
DEP_$(NTFSPROGS)		:= 
DESC_$(NTFSPROGS)		:= Ntfs Fix Filesystem Utilities
DIRLIST				+= $(NTFSPROGS)
TARLIST				+= $(TAR_$(NTFSPROGS))
# SAMBA
SAMBA_NAME			:= samba
VER_$(SAMBA_NAME)		:= 3.6.25
SAMBA				:= $(SAMBA_NAME)-$(VER_$(SAMBA_NAME))
NAME_$(SAMBA)			:= $(SAMBA_NAME)$(DBG)
SUBVER_$(SAMBA)			:= -001
VER_$(SAMBA)			:= $(VER_$(SAMBA_NAME))$(SUBVER_$(SAMBA))
DL_$(SAMBA)			:= https://download.samba.org/pub/samba/stable
TAR_$(SAMBA)			:= $(SAMBA).tar.gz
HOME_$(SAMBA)			:= https://www.samba.org/
LIC_$(SAMBA)			:= GPLv3
SEC_$(SAMBA)			:= base
PRIO_$(SAMBA)			:= required
DEP_$(SAMBA)			:= $(NAME_$(ZLIB)),$(NAME_$(ICONV))
DESC_$(SAMBA)			:= SMB/CIFS protocol for UNIX systems
DIRLIST				+= $(SAMBA)
TARLIST				+= $(TAR_$(SAMBA))
# BFTPD
BFTPD_NAME			:= bftpd
VER_$(BFTPD_NAME)		:= 6.0
BFTPD				:= $(BFTPD_NAME)
NAME_$(BFTPD)			:= $(BFTPD_NAME)$(DBG)
SUBVER_$(BFTPD)			:=
VER_$(BFTPD)			:= $(VER_$(BFTPD_NAME))$(SUBVER_$(BFTPD))
DL_$(BFTPD)			:= https://sourceforge.net/projects/bftpd/files
TAR_$(BFTPD)			:= $(BFTPD)-$(VER_$(BFTPD_NAME)).tar.gz
HOME_$(BFTPD)			:= http://bftpd.sourceforge.net/
LIC_$(BFTPD)			:= GPLv2
SEC_$(BFTPD)			:= base
PRIO_$(BFTPD)			:= standard
DEP_$(BFTPD)			:= 
DESC_$(BFTPD)			:= Small, easy-to-configure FTP server
DIRLIST				+= $(BFTPD)
TARLIST				+= $(TAR_$(BFTPD))
# FFMPEG
FFMPEG_NAME			:= ffmpeg
VER_$(FFMPEG_NAME)		:= 4.4
FFMPEG				:= $(FFMPEG_NAME)-$(VER_$(FFMPEG_NAME))
NAME_$(FFMPEG)			:= $(FFMPEG_NAME)$(DBG)
SUBVER_$(FFMPEG)		:= 
VER_$(FFMPEG)			:= $(VER_$(FFMPEG_NAME))$(SUBVER_$(FFMPEG))
DL_$(FFMPEG)			:= https://ffmpeg.org/releases
TAR_$(FFMPEG)			:= $(FFMPEG).tar.gz
HOME_$(FFMPEG)			:= https://ffmpeg.org/
LIC_$(FFMPEG)			:= LGPLv2.1+,GPLv2
SEC_$(FFMPEG)			:= aux
PRIO_$(FFMPEG)			:= required
DEP_$(FFMPEG)			:= $(NAME_$(ZLIB)),$(NAME_$(ICONV))
DESC_$(FFMPEG)			:= A/V stream digital package in numerous formats
DIRLIST				+= $(FFMPEG)
TARLIST				+= $(TAR_$(FFMPEG))
# SQLITE
SQLITE_NAME			:= sqlite
VER_$(SQLITE_NAME)		:= src-3360000
SQLITE				:= $(SQLITE_NAME)-$(VER_$(SQLITE_NAME))
NAME_$(SQLITE)			:= $(SQLITE_NAME)$(DBG)
SUBVER_$(SQLITE)		:= -100
VER_$(SQLITE)			:= $(VER_$(SQLITE_NAME))$(SUBVER_$(SQLITE))
DL_$(SQLITE)			:= https://www.sqlite.org/2021
TAR_$(SQLITE)			:= $(SQLITE).zip
HOME_$(SQLITE)			:= http://www.sqlite.org/
LIC_$(SQLITE)			:= Public Domain
SEC_$(SQLITE)			:= aux
PRIO_$(SQLITE)			:= required
DEP_$(SQLITE)			:= $(NAME_$(ZLIB))
DESC_$(SQLITE)			:= SQLite (v3.x) database engine
DIRLIST				+= $(SQLITE)
TARLIST				+= $(TAR_$(SQLITE))
# ID3TAG
ID3TAG_NAME			:= libid3tag
VER_$(ID3TAG_NAME)		:= 0.15.1b
ID3TAG				:= $(ID3TAG_NAME)-$(VER_$(ID3TAG_NAME))
NAME_$(ID3TAG)			:= $(ID3TAG_NAME)$(DBG)
SUBVER_$(ID3TAG)		:= -105
VER_$(ID3TAG)			:= $(VER_$(ID3TAG_NAME))$(SUBVER_$(ID3TAG))
DL_$(ID3TAG)			:= ftp://ftp.mars.org/pub/mpeg
TAR_$(ID3TAG)			:= $(ID3TAG).tar.gz
HOME_$(ID3TAG)			:= https://sourceforge.net/projects/mad/files/libid3tag/
LIC_$(ID3TAG)			:= GPLv2
SEC_$(ID3TAG)			:= aux
PRIO_$(ID3TAG)			:= required
DEP_$(ID3TAG)			:= $(NAME_$(ZLIB))
DESC_$(ID3TAG)			:= ID3 tag manipulation library
DIRLIST				+= $(ID3TAG)
TARLIST				+= $(TAR_$(ID3TAG))
# EXIF
EXIF_NAME			:= libexif
VER_$(EXIF_NAME)		:= 0.6.22
EXIF				:= $(EXIF_NAME)-$(VER_$(EXIF_NAME))
NAME_$(EXIF)			:= $(EXIF_NAME)$(DBG)
SUBVER_$(EXIF)			:= 
VER_$(EXIF)			:= $(VER_$(EXIF_NAME))$(SUBVER_$(EXIF))
DL_$(EXIF)			:= https://github.com/libexif/libexif/releases/download/libexif-0_6_22-release
TAR_$(EXIF)			:= $(EXIF).tar.gz
HOME_$(EXIF)			:= https://github.com/libexif/libexif/
LIC_$(EXIF)			:= LGPLv2.1
SEC_$(EXIF)			:= aux
PRIO_$(EXIF)			:= required
DEP_$(EXIF)			:= $(NAME_$(ICONV))
DESC_$(EXIF)			:= A library for parsing, editing, and saving EXIF data
DIRLIST				+= $(EXIF)
TARLIST				+= $(TAR_$(EXIF))
# JPEG
JPEG_NAME			:= jpeg
VER_$(JPEG_NAME)		:= 9d
JPEG				:= $(JPEG_NAME)-$(VER_$(JPEG_NAME))
NAME_$(JPEG)			:= $(JPEG_NAME)$(DBG)
SUBVER_$(JPEG)			:= 
VER_$(JPEG)			:= $(VER_$(JPEG_NAME))$(SUBVER_$(JPEG))
DL_$(JPEG)			:= http://jpegclub.org/reference/wp-content/uploads/2020/01
TAR_$(JPEG)			:= $(JPEG_NAME)src.v$(VER_$(JPEG_NAME)).tar.gz
HOME_$(JPEG)			:= https://jpegclub.org/
LIC_$(JPEG)			:= https://jpegclub.org/reference/libjpeg-license/
SEC_$(JPEG)			:= aux
PRIO_$(JPEG)			:= required
DEP_$(JPEG)			:= 
DESC_$(JPEG)			:= Still image codec
DIRLIST				+= $(JPEG)
TARLIST				+= $(TAR_$(JPEG))
# OGG
OGG_NAME			:= libogg
VER_$(OGG_NAME)			:= 1.3.4
OGG				:= $(OGG_NAME)-$(VER_$(OGG_NAME))
NAME_$(OGG)			:= $(OGG_NAME)$(DBG)
SUBVER_$(OGG)			:= 
VER_$(OGG)			:= $(VER_$(OGG_NAME))$(SUBVER_$(OGG))
DL_$(OGG)			:= https://downloads.xiph.org/releases/ogg/
TAR_$(OGG)			:= $(OGG).tar.gz
HOME_$(OGG)			:= https://xiph.org/ogg
LIC_$(OGG)			:= BSD-3-Clause
SEC_$(OGG)			:= aux
PRIO_$(OGG)			:= required
DEP_$(OGG)			:= 
DESC_$(OGG)			:= The ogg container format
DIRLIST				+= $(OGG)
TARLIST				+= $(TAR_$(OGG))
# VORBIS
VORBIS_NAME			:= libvorbis
VER_$(VORBIS_NAME)		:= 1.3.7
VORBIS				:= $(VORBIS_NAME)-$(VER_$(VORBIS_NAME))
NAME_$(VORBIS)			:= $(VORBIS_NAME)$(DBG)
SUBVER_$(VORBIS)		:= 
VER_$(VORBIS)			:= $(VER_$(VORBIS_NAME))$(SUBVER_$(VORBIS))
DL_$(VORBIS)			:= https://downloads.xiph.org/releases/vorbis
TAR_$(VORBIS)			:= $(VORBIS).tar.gz
HOME_$(VORBIS)			:= https://xiph.org/vorbis
LIC_$(VORBIS)			:= BSD-3-Clause
SEC_$(VORBIS)			:= aux
PRIO_$(VORBIS)			:= required
DEP_$(VORBIS)			:= $(NAME_$(OGG))
DESC_$(VORBIS)			:= Vorbis audio compression
DIRLIST				+= $(VORBIS)
TARLIST				+= $(TAR_$(VORBIS))
# FLAC
FLAC_NAME			:= flac
VER_$(FLAC_NAME)		:= 1.3.3
FLAC				:= $(FLAC_NAME)-$(VER_$(FLAC_NAME))
NAME_$(FLAC)			:= $(FLAC_NAME)$(DBG)
SUBVER_$(FLAC)			:= 
VER_$(FLAC)			:= $(VER_$(FLAC_NAME))$(SUBVER_$(FLAC))
DL_$(FLAC)			:= https://downloads.xiph.org/releases/flac
TAR_$(FLAC)			:= $(FLAC).tar.xz
HOME_$(FLAC)			:= https://xiph.org/flac
LIC_$(FLAC)			:= BSD-3-Clause
SEC_$(FLAC)			:= aux
PRIO_$(FLAC)			:= required
DEP_$(FLAC)			:= $(NAME_$(ICONV))
DESC_$(FLAC)			:= Free lossless audio codec
DIRLIST				+= $(FLAC)
TARLIST				+= $(TAR_$(FLAC))
# MINIDLNA
MINIDLNA_NAME			:= minidlna
VER_$(MINIDLNA_NAME)		:= 1.3.0
MINIDLNA			:= $(MINIDLNA_NAME)-$(VER_$(MINIDLNA_NAME))
NAME_$(MINIDLNA)		:= $(MINIDLNA_NAME)$(DBG)
SUBVER_$(MINIDLNA)		:= -017
VER_$(MINIDLNA)			:= $(VER_$(MINIDLNA_NAME))$(SUBVER_$(MINIDLNA))
DL_$(MINIDLNA)			:= https://downloads.sourceforge.net/project/minidlna/minidlna/$(VER_$(MINIDLNA_NAME))
TAR_$(MINIDLNA)			:= $(MINIDLNA).tar.gz
HOME_$(MINIDLNA)		:= http://minidlna.sourceforge.net/
LIC_$(MINIDLNA)			:= GPLv2+,BSD-3-Clause
SEC_$(MINIDLNA)			:= storage
PRIO_$(MINIDLNA)		:= optional
DEP_$(MINIDLNA)			:= $(NAME_$(ZLIB)),$(NAME_$(ICONV)),$(NAME_$(SQLITE)),$(NAME_$(CORE_WORK))
DESC_$(MINIDLNA)		:= UPnP A/V & DLNA Media Server
DIRLIST				+= $(MINIDLNA)
TARLIST				+= $(TAR_$(MINIDLNA))
# EVENT
EVENT_NAME			:= libevent
VER_$(EVENT_NAME)		:= 2.1.12-stable
EVENT				:= $(EVENT_NAME)-$(VER_$(EVENT_NAME))
NAME_$(EVENT)			:= $(EVENT_NAME)$(DBG)
SUBVER_$(EVENT)			:= 
VER_$(EVENT)			:= $(VER_$(EVENT_NAME))$(SUBVER_$(EVENT))
DL_$(EVENT)			:= https://github.com/libevent/libevent/releases/download/release-$(VER_$(EVENT_NAME))
TAR_$(EVENT)			:= $(EVENT).tar.gz
HOME_$(EVENT)			:= https://libevent.org/
LIC_$(EVENT)			:= BSD-3-Clause
SEC_$(EVENT)			:= libs
PRIO_$(EVENT)			:= required
DEP_$(EVENT)			:= $(NAME_$(ZLIB))
DESC_$(EVENT)			:= An event notification library
DIRLIST				+= $(EVENT)
TARLIST				+= $(TAR_$(EVENT))
# TRANSMISSION
TRANSM_NAME			:= transmission
VER_$(TRANSM_NAME)		:= 3.00
TRANSM				:= $(TRANSM_NAME)-$(VER_$(TRANSM_NAME))
NAME_$(TRANSM)			:= $(TRANSM_NAME)$(DBG)
SUBVER_$(TRANSM)		:= -001
VER_$(TRANSM)			:= $(VER_$(TRANSM_NAME))$(SUBVER_$(TRANSM))
DL_$(TRANSM)			:= https://github.com/transmission/transmission-releases/raw/master
TAR_$(TRANSM)			:= $(TRANSM).tar.xz
HOME_$(TRANSM)			:= https://www.transmissionbt.com/
LIC_$(TRANSM)			:= GPLv2+
SEC_$(TRANSM)			:= storage
PRIO_$(TRANSM)			:= optional
DEP_$(TRANSM)			:= $(NAME_$(ZLIB)),$(NAME_$(ICONV)),$(NAME_$(EVENT)),$(NAME_$(CORE_WORK))
DESC_$(TRANSM)			:= Simple BitTorrent client
DIRLIST				+= $(TRANSM)
TARLIST				+= $(TAR_$(TRANSM))
# INITIALIZE CATEGORIES
BUILTINLIB			:=
BUILTIN				:=
THIRDPARTYLIB			:=
THIRDPARTY			:=
# SUBGROUPS
USBSTORAGE			:= $(SAMBA) $(BFTPD) $(E2FSPROGS) $(HDPARM) $(HDIDLE) $(SMONTOOLS) $(NTFSPROGS) $(TRANSM)
MEDIASERVER			:= $(FFMPEG) $(ID3TAG) $(EXIF) $(JPEG) $(OGG) $(VORBIS) $(FLAC)
SPEEDTESTS			:= $(NETPERF) $(NETWORKTEST) $(SPEEDTESTNET)
# ADDING IPK TO CATEGORIES
BUILTINLIB 			+= $(NVRAM)
#BUILTINLIB			+= $(LZO)
BUILTINLIB			+= $(ZLIB)
BUILTINLIB			+= $(OPENSSL)
BUILTINLIB			+= $(ARES)
BUILTINLIB			+= $(CURL)
BUILTINLIB			+= $(ICONV)
BUILTINLIB			+= $(SQLITE)
BUILTINLIB			+= $(EVENT)
THIRDPARTYLIB			+= $(ARCHIVE)
BUILTIN				+= $(CORE_WORK)
BUILTIN				+= $(UTELNETD)
BUILTIN				+= $(MINIHTTPD)
BUILTIN				+= $(BUSYBOX)
BUILTIN				+= $(DNRD)
BUILTIN				+= $(IPROUTE2)
BUILTIN				+= $(EASYRSA)
BUILTIN				+= $(OPEN_VPN)
THIRDPARTY			+= $(OPKG_UTILS)
THIRDPARTY			+= $(OPKG)
THIRDPARTY			+= $(OPEN_SSH)
THIRDPARTY			+= $(MINI_SNMPD)
THIRDPARTY			+= $(QOS_SQM)
# USBSTORAGE
ifdef USBSTORAGE
BUILTIN				+= $(SAMBA)
BUILTIN				+= $(BFTPD)
BUILTIN				+= $(HDPARM)
BUILTIN				+= $(HDIDLE)
THIRDPARTY			+= $(SMONTOOLS)
THIRDPARTY			+= $(TRANSM)
endif
# MEDIASERVER
ifdef MEDIASERVER
BUILTINLIB			+= $(FFMPEG)
BUILTINLIB			+= $(ID3TAG)
BUILTINLIB			+= $(EXIF)
BUILTINLIB			+= $(JPEG)
BUILTINLIB			+= $(OGG)
BUILTINLIB			+= $(VORBIS)
BUILTINLIB			+= $(FLAC)
BUILTIN				+= $(MINIDLNA)
endif
# SPEEDTESTS
ifdef SPEEDTESTS
THIRDPARTY			+= $(NETPERF)
THIRDPARTY			+= $(NETWORKTEST)
THIRDPARTY			+= $(SPEEDTESTNET)
endif
# EXCLUDED FROM MONOLITHIC
ifndef MONOLITHIC
BUILTIN				+= $(E2FSPROGS)
BUILTIN				+= $(XDSL_042N_D26B)
BUILTIN				+= $(XDSL_042U_D26O)
THIRDPARTY			+= $(NTFSPROGS)
THIRDPARTY			+= $(QOS_NG)
#THIRDPARTY			+= $(DNSMASQ)
endif
# SUM OF THE ABOVES
SUBDIRS				:=
SUBDIRS				+= $(BUILTINLIB)
SUBDIRS				+= $(THIRDPARTYLIB)
SUBDIRS				+= $(BUILTIN)
SUBDIRS				+= $(THIRDPARTY)
# SKIP FROM IPK CREATION
PKG_RM_LIST			:= $(NVRAM) $(ARES) $(ARCHIVE) $(OPKG_UTILS) $(LZO) $(IPROUTE2) $(NETPERF) $(EASYRSA) $(MEDIASERVER)

