#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <errno.h>
#include "nvram.h"
#include "ancistrus.h"
#include "common.h"
#include "dslctl.h"

/*
XDSLCTL HELP
xdslctl configure/configure1 
[--mod <a|d|l|t|2|p|e|m|M3|M5|v>]
[--lpair <(i)nner|(o)uter>] -
[--trellis <on|off>] *
[--snr <snrQ4>] *
[--bitswap <on|off>] *
[--sesdrop <on|off>]*
[--sra <on|off>] *
[--CoMinMgn <on|off>] *
[--i24k <on|off>] *
[--phyReXmt <0xBitMap-UsDs>] *
[--Ginp <0xBitMap-UsDs>] 
[--TpsTc <0xBitMap-AvPvAaPa>] 
[--monitorTone <on|off>] *
[--profile <0x00 - 0xFF>|<"8a |8b |8c |8d |12a |12b |17a |30a (|35b)">] *
[--us0 <on|off>]
[--dynamicD <on|off>] *
[--dynamicF <on|off>] *
[--SOS <on|off>] *
[--maxDataRate <maxDsDataRateKbps maxUsDataRateKbps maxAggrDataRateKbps>] 
[--forceJ43 <on|off>] 
[--toggleJ43B43 <on|off>]

XDSLCTL PROFILE --SHOW <NETGEAR'S DEFAULT>
Modulations:
	G.Dmt	Enabled
	G.lite	Enabled
	T1.413	Enabled
	ADSL2	Enabled
	AnnexL	Enabled
	ADSL2+	Enabled
	AnnexM	Enabled
	VDSL2	Enabled
VDSL2 profiles:
	8a	Enabled
	8b	Enabled
	8c	Enabled
	8d	Enabled
	12a	Enabled
	12b	Enabled
	17a	Enabled
	30a	Enabled
	US0	Enabled
Phone line pair:
	Inner pair
Capability:
	bitswap		On
	sra		On
	trellis		On
	sesdrop		Off
	CoMinMgn	Off
	24k		On
	phyReXmt(Us/Ds)	Off/On (1)
	Ginp(Us/Ds)	On/On (3)
	TpsTc		AvPvAa (14)
	monitorTone:	On
	dynamicD:	On
	dynamicF:	Off
	SOS:		On
	Training Margin(Q4 in dB):	-1(DEFAULT)

XDSLCTL PROFILE --SHOW <DRIVER'S DEFAULT> ( 'xdslctl --configure' )
Modulations:
	G.Dmt	Enabled
	G.lite	Enabled
	T1.413	Enabled
	ADSL2	Enabled
	AnnexL	Enabled
	ADSL2+	Enabled
	AnnexM	Disabled
	VDSL2	Enabled
VDSL2 profiles:
	8a	Enabled
	8b	Enabled
	8c	Enabled
	8d	Enabled
	12a	Enabled
	12b	Enabled
	17a	Enabled
	30a	Enabled
	US0	Enabled
Phone line pair:
	Inner pair
Capability:
	bitswap		On
	sra		Off
	trellis		On
	sesdrop		Off
	CoMinMgn	Off
	24k		On
	phyReXmt(Us/Ds)	Off/On
	Ginp(Us/Ds)	On/On
	TpsTc		AvPvAa
	monitorTone:	On
	dynamicD:	On
	dynamicF:	Off
	SOS:		On
	Training Margin(Q4 in dB):	-1(DEFAULT)
*/

/*
 * ABSSNR
 * Obtain absolute snr value.
 * Value > 100 increase the snr.
 * Value < 100 decrease the snr.
 * Value is stored as a 16b signed (-32768 to +32767).
 * But 'xdslctl configure --snr X' accepts 16b unsigned X value only ('0' excluded): so this workaround for signed.
 * snr retrain: [ min -136 = 65400 ] ... [ -1 = 65535 ] [ 0 = 65536 ] 1 ... [ 100 = default ] ... [ 32767 max ]
 * snr interval: [ 65400 -> 65536 -> 1 -> 32767 ]
 * Input: snr nvram stored value as char string. String not checked for num: in case of no num, atoi() failure exit '0' (65536) is set.
 * Return: snr unsigned num value if success, '100' (default) if failure.
 */
static int abssnr(const char* nvsnr) {
int snrnum;

if(nvsnr==NULL || !*nvsnr || (snrnum=atoi(nvsnr))<-136 || snrnum>32767) return 100;	//no string or out of range set default
else if(snrnum>0) return snrnum;							//positive value so return unchanged
else return 65536+snrnum;								//negative value return max + (-value)
}

/*
 * MODPARSE
 * Parse dsl transmission mode string from nvram value to valid string for 'xdslctl configure' .
 * Nvram value is originally stored as <A2PMOD|A2MOD|GDMT|MMODE> .
 * A2PMOD="--lpair i -mod vp"
 * A2MOD="--lpair i -mod 2v"
 * GDMT"--lpair i -mod dmv"
 * MMODE"--lpair i -mod dlt2pemv"
 * Input: nvram mod value as originally stored. Value not checked.
 * Return: char string 'S' usable with 'xdslctl configure --mod S' if success, 'dlt2pemv' (MMODE=default) if failure.
 */
static const char* modparse(const char* nvmod) {

if(nvmod==NULL || !*nvmod || !strcmp(nvmod, "MMODE")) return "dlt2pemv";		//no string or MMODE set default
else if(!strcmp(nvmod, "A2PMOD")) return "vp";						//vdsl & adsl2+
else if(!strcmp(nvmod, "A2MOD")) return "2v";						//vdsl & adsl2
else if(!strcmp(nvmod, "GDMT")) return "dmv";						//vdsl & adsl
else return "v";									//tweak for vdsl only: try to negotiate link faster
}

int dslctl(int argc UNUSED, char** argv) {
int fd, i, j, pid;
enum { LPAIR=2, MOD=4, BITSWAP=6, I24K=22, SNR=32, PROFILE=34, US0=36 };
char **args;
const char *opt[]={ DSLBIN, "configure", "--lpair", "i", "--mod", "MMODE", "--bitswap", "on", "--sra", "on", "--trellis", "on", "--sesdrop", "off", "--CoMinMgn", "off", "--SOS", "on", "--dynamicD", "on", "--dynamicF", "off", "--i24k", "on", "--monitorTone", "on", "--phyReXmt", "1", "--Ginp", "3", "--TpsTc", "14", "--snr", "100", "--profile", "17a", "--us0", "on", NULL }, *nvars[]={ "", "", "", "", "wan_dsl_mode", "", "bitswap", "", "sra", "", "trellis", "", "sesdrop", "", "cominmgn", "", "sos", "", "dynamicd", "", "dynamicf", "", "i24k", "", "monitortone", "", "phyrexmt", "", "ginp", "", "tpstc", "", "snr", "", "profile", "", "us0" };

DBG("dslctl(): cmd is: %s\n", argv[0]);
	if(argv[1]==NULL || strcmp(argv[1], "configure")) execvp(DSLBIN, argv);		//no parse
	else if((fd=lock(LOCK_DSL))>=0) {						//parse: avoid race condition locking
	DBG("dslctl(): dslconfprofile: %s\n", NV_SGET("anc_dslconfprofile"));
	if((args=(char**)malloc(sizeof(char*)*ARGNUM))==NULL) return 98;
	for(i=0;i<ARGNUM;i++) if((args[i]=(char*)malloc(sizeof(char)*PARBUF))==NULL) return 99;
		if(!strcmp(NV_SGET("anc_dslconfprofile"), "own")) {			//own profile settings
		for(i=0;i<MOD;i++) SETOPTIONNAME					//initialize args with cmd name option and lpair
		snprintf(args[MOD], sizeof(char)*PARBUF, "%s", opt[MOD]);		//mod setting
		SETMODULATIONVAL
			for(i=BITSWAP;i<SNR;i+=2) {					//common settings
			SETOPTIONNAME
			snprintf(args[i+1], sizeof(char)*PARBUF, "%s", NV_SDGET(nvars[i], opt[i+1]));
			}
			if(*NV_SGET("anc_snrtweak_enable")=='1') {
			snprintf(args[i], sizeof(char)*PARBUF, "%s", opt[SNR]);		//snr setting
			snprintf(args[i+1], sizeof(char)*PARBUF, "%d", abssnr(NV_SDGET(nvars[i], opt[i+1])));
			i+=2;
			}
			if(!strcmp(NV_SGET("wan_traffic_type"), "ptm") && *NV_SGET("anc_dslprofile_enable")=='1') {	//vdsl profile only
				for(j=PROFILE;j<US0+1;j+=2) {
				snprintf(args[i], sizeof(char)*PARBUF, "%s", opt[j]);
				snprintf(args[i+1], sizeof(char)*PARBUF, "%s", NV_SDGET(nvars[j], opt[j+1]));
				i+=2;
				}
			}
		}
		else if(!strcmp(NV_SGET("anc_dslconfprofile"), "broadcom")) 		//broadcom settings='xdslctl configure'
		for(i=0;i<LPAIR;i++) SETOPTIONNAME
		else {									//netgear settings as default
		for(i=0;i<I24K;i++) SETOPTIONNAME					//fill all the interested args
		SETMODULATIONVAL							//parse mod value only
		}
	for(;i<ARGNUM;i++) args[i]=NULL;						//set last args to NULL
#if DEBUG
	for(i=0;i<ARGNUM;i++) if(args[i]!=NULL) DBG("dslctl() #%d: %s\n", i, args[i]);
#endif
		if((pid=fork())<0) {							//fork error
		DBG("fork() error: unlocking fd %d\n", fd);
		unlock(fd, LOCK_DSL);
		exit(2);
		}
		else if(pid>0) {							//parent thread
		while((waitpid(pid, NULL, 0)==-1) && (errno==EINTR)) ;			//safe-wait for child exit...
		for(i=0;i<ARGNUM;i++) SFREE(args[i]);					//free args
		SFREE(args);
		DBG("dslctl(): free args\n");
		exit(0);
		}
		else {									//child thread
		unlock(fd, LOCK_DSL);							//release lock
		execvp(DSLBIN, args);
		}
	}
DBG("dslctl(): execvp() fail\n");
return 1;										//here only on execvp() fail
}
