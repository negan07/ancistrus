#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <net/if.h>
#include <netinet/in.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include "nvram.h"
#include "ancistrus.h"
#include "common.h"
#include "fw.h"

FWARGS

/*
 * GETIPADDR
 * Obtain interface name stored into nvram then ipaddr assigned to a network interface.
 * Input: interface nvram name, ip address (caller must take care of ip string allocation).
 * Return: interface ip address or "" if interface or ip not present.
 */
static void getipaddr(const char *intf, char *ip) {
struct ifreq ifr;
int sd, addr;
char *intfval;

	if(!*(intfval=NV_SGET(intf)) || ((sd=socket(AF_INET, SOCK_DGRAM, 0))<0)) strcpy(ip, "");		//interface unassigned
	else {
	DBG("intf %s\n", intfval);
	ifr.ifr_addr.sa_family=AF_INET;
	snprintf(ifr.ifr_name, IFNAMSIZ-1, "%s", intfval);							//assing interface name
		if(!ioctl(sd, SIOCGIFADDR, &ifr)) {								//fetching the addr/ip
		addr=((struct sockaddr_in *)(&ifr.ifr_addr))->sin_addr.s_addr;
		sprintf(ip, "%d.%d.%d.%d", (addr & 0xFF), (addr >> 8 & 0xFF), (addr >> 16 & 0xFF), (addr >> 24 & 0xFF));
		}
		else strcpy(ip, "");										//ip unassigned
	DBG("ip %s\n", ip);
	close(sd);
	}
}

/*
 * GETSETOLDPORT
 * Obtain old local service port stored into nvram or current port num if old port num not present (GET).
 * Nvram set current port as old port for future nat rule removal (SET).
 * Input: service name, current port num, old port num (caller must take care of oldport string allocation), port type string tag, set flag.
 */
static void getsetoldport(const char *servname, const char *port, char* oldport, const char *ptype, const int setflag) {
int i;
char nvservname[SRVNAMEMAXLENGTH*2];

snprintf(nvservname, sizeof(nvservname), "old_%s_%s_port", servname, ptype);					//switch local or remote port
for(i=0;nvservname[i]!='\0';i++) if(nvservname[i]>=65 && nvservname[i]<=90) nvservname[i]+=32;			//tolower(nvservname)
	if(!setflag) {												//get old port
	strcpy(oldport, NV_SGET(nvservname));
	if(!*oldport) strcpy(oldport, port);									//old port not present
	}
	else NV_SET(nvservname, port);										//set old port
}

int gateway(MAINUNUSEDARGS) {
char ip[256];

getgatewayip(ip);
puts(ip);
return 0;
}

int oldgateway(MAINUNUSEDARGS) {

puts(getoldgatewayip());
return 0;
}

int wanip(MAINUNUSEDARGS) {
char ip[256];

getwanip(ip);
puts(ip);
return 0;
}

int oldwanip(MAINUNUSEDARGS) {

puts(getoldwanip());
return 0;
}

/*
 * FWREMADD
 * Create rules for remote router service basing on web gui http 'remote' wan ip restriction rules.
 * Input: argc, argv, FILE pointer to writing rule tmp file, wan ip, gateway ip, protocol tcp/udp.
 * Return: '0' success, '1' or more fail.
 */
static int fwremadd(char** argv, FILE *FP, const char* wan, const char* lan, const char* prot, const int remtype) {
enum { SINGLE=1, RANGE, ALL, LIST };
int i, err=1;
char list[30], *ip1, *ip2;

		switch(remtype ? atoi(NV_SGET("fw_remote_type")) : ALL) {	//remote management type
		case SINGLE:  							//single ip address has remote access
		ip1=NV_SGET("fw_remote_single");
			if(*ip1) {
			err=0;
			fprintf(FP,
			IPT " -t nat -A %s_NAT -s %s -d %s/32 -p %s -m %s --dport %s -j DNAT --to-destination %s:%s\n"
			IPT " -A %s -d %s/32 -p %s -m %s --dport %s -j ACCEPT\n"
			, argv[NAME], ip1, wan, prot, prot, argv[REMPORT], lan, argv[LOCPORT]
			, argv[NAME], lan, prot, prot, argv[LOCPORT]);
			}
		break;
		case RANGE:							//range ip interval has remote access
		ip1=NV_SGET("fw_remote_range_start");
		ip2=NV_SGET("fw_remote_range_end");
			if(*ip1 && *ip2) {
			err=0;
			fprintf(FP,
			IPT " -t nat -A %s_NAT -m iprange --src-range %s-%s -d %s/32 -p %s -m %s --dport %s -j DNAT --to-destination %s:%s\n"
			IPT " -A %s -d %s/32 -p %s -m %s --dport %s -j ACCEPT\n"
			, argv[NAME], ip1, ip2, wan, prot, prot, argv[REMPORT], lan, argv[LOCPORT]
			, argv[NAME], lan, prot, prot, argv[LOCPORT]);
			}
		break;
		case ALL:							//all remote ip have remote access (default)
		err=0;
		fprintf(FP,
		IPT " -t nat -A %s_NAT -d %s/32 -p %s -m %s --dport %s -j DNAT --to-destination %s:%s\n"
		IPT " -A %s -d %s/32 -p %s -m %s --dport %s -j ACCEPT\n"
		, argv[NAME], wan, prot, prot, argv[REMPORT], lan, argv[LOCPORT]
		, argv[NAME], lan, prot, prot, argv[LOCPORT]);
		break;
		case LIST:							//discret ip list
			for(i=1;i<10;i++) {
			snprintf(list, sizeof(list), "fw_remote_list1_ip%d", i);
			ip1=NV_SGET(list);
				if(*ip1) {
				err=0;
				fprintf(FP,
				IPT " -t nat -A %s_NAT -s %s -d %s/32 -p %s -m %s --dport %s -j DNAT --to-destination %s:%s\n"
				, argv[NAME], ip1, wan, prot, prot, argv[REMPORT], lan, argv[LOCPORT]);
				}
			}
		if(!err) fprintf(FP,
		IPT " -A %s -d %s/32 -p %s -m %s --dport %s -j ACCEPT\n"
		, argv[NAME], lan, prot, prot, argv[LOCPORT]);
		break;
		default:							//no valid parameter
		break;
		}
return err;
}

/*
 * FWROUTER
 * Create local service iptables rules.
 * Input: argc, argv, remote mode nat chain flag.
 * Return: '0' success, '1' or more fail.
 */
static int fwrouter(char** argv, const int fwtype) {
enum { GET=0, SET };
FILE *FP;
int err=0;
char gw[256], wan[256], *oldgw, *oldwan, oldlocport[10], oldremport[10];

	SFPOPEN(FP, RULES, "w") err=1;
	else {									//### DEL ###
	oldgw=getoldgatewayip();						//obtain old wan ip, gw ip and local/remote ports involved
	oldwan=getoldwanip();
	getoldport(argv[NAME], argv[LOCPORT], oldlocport, "loc");
	getoldport(argv[NAME], argv[REMPORT], oldremport, "rem");
	DBG("Old gateway ip: %s, old wan ip: %s, old local port: %s, old remote port: %s\n", oldgw, oldwan, oldlocport, oldremport);
	fprintf(FP,
	IPT " -t nat -D PREROUTING -j %s_NAT\n"					//always delete rules first at any time
	IPT " -t nat -F %s_NAT\n"
	IPT " -t nat -X %s_NAT\n"
	IPT " -D INPUT -j %s\n"
	IPT " -F %s\n"
	IPT " -X %s\n"
	CPM " del %s:1:%s:%s:%s-%s:%s:%s-%s\n"
	, argv[NAME], argv[NAME], argv[NAME], argv[NAME], argv[NAME], argv[NAME]
	, argv[FWTYPE], argv[PROT], oldgw, oldlocport, oldlocport, oldwan, oldremport, oldremport);
		if(!strcmp(argv[ADDRM], "del")) err=0;				//avoid rule creation if del
		else {
		getgatewayip(gw);						//obtain current wan ip and gw ip
		getwanip(wan);
		DBG("Gateway ip: %s, wan ip: %s\n", gw, wan);
			if(!*gw || !*wan) err=1;				//avoid rule creation if no lan/wan ip is available
			else {							//### ADD ###
			fprintf(FP,						//create new chains
			IPT " -t nat -N %s_NAT\n"
			IPT " -t nat -A PREROUTING -j %s_NAT\n"
			IPT " -N %s\n"
			IPT " -A INPUT -j %s\n"
			, argv[NAME], argv[NAME], argv[NAME], argv[NAME]);
				if(!strcmp(argv[PROT], "tcp/udp")) {		//populate nat chain with or without the 'remote' restrictions
				err+=fwremadd(argv, FP, wan, gw, "udp", fwtype);
				err+=fwremadd(argv, FP, wan, gw, "tcp", fwtype);
				}
				else err+=fwremadd(argv, FP, wan, gw, argv[PROT], fwtype);
				if(!err) {
				fprintf(FP,					//add napt rule to /proc/cnapt_serv & nvram set port nums
				CPM " add %s:1:%s:%s:%s-%s:%s:%s-%s\n"
				, argv[FWTYPE], argv[PROT], gw, argv[LOCPORT], argv[LOCPORT], wan, argv[REMPORT], argv[REMPORT]);
				setoldport(argv[NAME], argv[LOCPORT], "loc");
				setoldport(argv[NAME], argv[REMPORT], "rem");
				}
			}
		}
	}
fclose(FP);
DBG("return code %d\n", err);
return err;
}

int fw(MAINARGS) {
enum { ROUTER=0, REMOTE };
int i=0, fd;

if(argc!=9) return 1;								//arg num check
DBG("main:%s addrm:%s type:%s name:%s prot:%s remport:%s locport:%s\n", argv[2], argv[3], argv[4], argv[5], argv[6], argv[7], argv[8]);
	for(i=2;i<argc;i++) {							//arg string check
	DBG("checking arg: %d, ", i);
		switch(i) {
		case MAIN: if(strcmp(argv[i], "router") && strcmp(argv[i], "remote")) i=argc+1;
		break;
		case ADDRM: if(strcmp(argv[i], "add") && strcmp(argv[i], "del")) i=argc+1;
		break;
		case FWTYPE: if(strcmp(argv[i], "ls") && strcmp(argv[i], "pf")) i=argc+1;
		break;
		case NAME: if(strlen(argv[i])>SRVNAMEMAXLENGTH) i=argc+1;			//safety limit for chain name
		break;
		case PROT: if(strcmp(argv[i], "udp") && strcmp(argv[i], "tcp") && strcmp(argv[i], "tcp/udp")) i=argc+1;
		break;
		case REMPORT: 
		case LOCPORT: if(checkport(argv[i])) i=argc+1;
		break;
		}
	DBG("Argcount: %d\n", i);
	}
if(i>argc) return 1;
	if((fd=lock(LOCK_FW))>=0) {						//avoid race condition locking
	(!strcmp(argv[MAIN], "router") ? (i=fwrouter(argv, ROUTER)) : (i=fwrouter(argv, REMOTE)));
	if(!i) runsyscmd(". " RULES NULLRED);					//if no error above execute the created rulescript
	unlock(fd, LOCK_FW);							//release lock
	}
SHOWRULES
return i;
}
