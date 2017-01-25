#Make PID need HW_ID VER PRODUCT_ID
BOARD_ID=D7000
HW_ID=BB5
VER=1.0.1.44
SUB_VER=1.0.1
GUI_VER=1.0.1.44
HW_TYPE=D7000
PRODUCT_ID=A001
REGION=WW
MTCODE=0

#------------------------------------------------#

MODULE=Netgear
COMPANY=72
# Do we have ADSL WAN? 1-Yes 0-No
ADSL=1
ANNEX=A
WIFI=1
USB=1
EXT4=1
FLASH=128M
# define chipset vendor info here.
PROFILE=963138GW
CHIP_VENDOR=BCM
CHIP_ID=6361
BLOCKSIZE=64
#------------------------------------------------#

MULTI_PVC=0
VPN=0
ADSL2=0
BRIDGE=0
SNMP=0
DNSHJ=1
SIPALG=1
TMSS=0
VOIP=0
CA=1
POT=1
RIP=1
DPF=0
LLTD=1
IGMP=1
PPTPC=1
BCM_WPS=1
MSSID=1
WIZARD_LOG=1
SETUPWIZARD=1
DSLDIAG=0
PORTTRIGGER=1
PORTFORWARD=1
HTTPS=1
# connect track manager module, 1=yes, 0=no
CT_MGR=1
IPV6=1
IP6_6RD_CE=0
IPV6_LOGO=0
IPQOS=1
TR069=0
TRAFFIC_METER=1
TM_DEVPOLL=0
HACK_DNS=1
# Netgear Router Debugging Mode -- Spec V1.9
# adsl spec prefer to use setup.cgi?todo=debug to open telnetd
DEBUG_MODE=1
WIFI_ISOLATION=1
# Hide password in config file
HIDDEN_PASSWORD=1
#..................special feature...............#
US_ONLY=0
AUTOUPG=1
MODIFYMAC=0
OPENDNS=1
CONENAT=1
IP_ASSIGN_CHK=1
PNPX=1
DUAL_WAN=1
DUAL_BAND=1
EXTERNAL_SWITCH=1
READY_SHARE_PRINTER=1
READY_SHARE_CLOUD=0
GENIE_GUI=1
#NBTSCAN_DBG=1
#------------------------------------------------#
DEFAULT_FILE=default.wnr2500
#................. SetUpWizard 3.0...............#
SingleWIFI=0
#................. Block Site ...................#
ALL_TCP_CHECK=1
#................. Apple time machine............#
TIME_MACHINE=1
#................. dirty solution, it will be fixed later .................#
TEMP_SOLUTION=0
DLNA=1
USE_MINIDLNA=1
BOOT_NAND_FLASH=1
XML_DEFAULT_CFG=$(ROOT)/UI/default/default.xml.DGN2200
#.........iTunes server, depends on TIME_MACHINE.............#
ITUNES_SERVER=1
OPENSSL_USE=openssl-1.0.0r
#...........LED control settings..........#
LED_CONTROL=1
#eason add 3g feature
3G_FEATURE=0
# Support dynamic upgrade 3G dongle's driver&applications also ZIP it
ZIP_3G=0
RU_SPEC=1
NZ_FEATURE=1
#................. SPEEDTEST ............#
SPEEDTEST=1
#........ Enable DHCP option .......#
DHCP_OPTION=1
SMTP_SSL=1
#...............ACCESSCNTL.............#
ACCESSCNTL=1
VLAN=1
#...........SOAP V2.00............#
SOAP_V2=1
OPENVPN=1
#...........DSL logs of Wizard............#
DSL_WIZARD_LOG=1
AUTO_SEND_LOG=0
GUI_V14=1
#--------------XCLOUD: Remote Genie & Ready CLOUD-------------------------------#
XCLOUD=1
#...........Enable TCPDUMP of SDK..............#
TCPDUMP=1
#............Show Memory Log..............#
SHOW_MEM_LOG=1
#............HTTPD IPv6 support..............#
HTTPD_IPV6_SUPPORT=1
#............Green Download support..............#
GREEN_DOWNLOAD=0
TRANSMISSION=0
OPENVPN_TUN=1
GPL=1
