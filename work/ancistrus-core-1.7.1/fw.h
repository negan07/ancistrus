#define FWARGS enum { MAIN=2, ADDRM, FWTYPE, NAME, PROT, REMPORT, LOCPORT };					/* aliases for main params */

#define SRVNAMEMAXLENGTH 32											/* aliases for limits */

#define RULESNAME "ancfw"											/* aliases for paths */
#define RULES "/tmp/" RULESNAME
#define LOCK_FW "/var/lock/" RULESNAME ".lock"

#define IPT "/usr/sbin/iptables"										/* aliases for bins */
#define CPM "/usr/sbin/cpm_cmd"

#define getgatewayip(name) getipaddr("lan_if", name)								/* aliases for funcs */
#define getoldgatewayip() NV_SGET("old_gateway")
#define getwanip(name) getipaddr("wan_ifname", name)
#define getoldwanip() NV_SGET("old_wanip")
#define getoldport(name1, name2, name3, name4) getsetoldport(name1, name2, name3, name4, GET)
#define setoldport(name1, name2, name3) getsetoldport(name1, name2, NULL, name3, SET)

#ifdef DEBUG
#define SHOWRULES do { system("cat " RULES ";cat /proc/cnapt_serv"); } while(0);
#else
#define SHOWRULES
#endif
