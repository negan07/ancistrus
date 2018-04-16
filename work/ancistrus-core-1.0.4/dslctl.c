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
[--profile <0x00 - 0xFF>|<"8a |8b |8c |8d |12a |12b |17a |30a (|35b/BrcmPriv1)">] *
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
else if(!strcmp(NV_SGET("wan_traffic_type"), "ptm")) return "v";			//tweak for vdsl only: try to negotiate link faster
else return "dlt2pemv";
}

int dslctl(char** argv) {
enum { MOD=0, BITSWAP=1, I24K=9, SNR=14, PROFILE=15, END=17 };
int fd, i;
char *profile, cmd[DSLCMDBUF]=DSLBIN " configure --lpair i";
const char 
*opt[]={ "--mod", "--bitswap", "--sra", "--trellis", "--sesdrop", "--CoMinMgn", "--SOS", "--dynamicD", "--dynamicF", "--i24k", "--monitorTone", "--phyReXmt", "--Ginp", "--TpsTc", "--snr", "--profile", "--us0" }, 
*nvar[]={ "wan_dsl_mode", "bitswap", "sra", "trellis", "sesdrop", "cominmgn", "sos", "dynamicd", "dynamicf", "i24k", "monitortone", "phyrexmt", "ginp", "tpstc", "snr", "profile", "us0" }, 
*def[]={ "MMODE", "on", "on", "on", "off", "off", "on", "on", "off", "on", "on", "1", "3", "14", "100", "17a", "on" };

DBG("dslctl(): cmd is: %s\n", argv[0]);
	if(argv[1]==NULL || strcmp(argv[1], "configure")) execvp(DSLBIN, argv);		//no parse
	else if((fd=lock(LOCK_DSL))>=0) {						//parse: avoid race condition locking
	profile=NV_SGET("anc_dslconfprofile");
	DBG("dslctl(): dslconfprofile: %s\n", profile);
		if(!strcmp(profile, "own")) {						//own profile settings
		SETMODULATIONVAL							//modulation setting
		for(i=BITSWAP;i<SNR;i++) SETOPTIONVAL					//common setting
		if(*NV_SGET("anc_snrtweak_enable")=='1') SETSNRVAL			//snr setting
		if(!strcmp(NV_SGET("wan_traffic_type"), "ptm") && *NV_SGET("anc_dslprofile_enable")=='1') for(i=PROFILE;i<END;i++) SETOPTIONVAL
		}
		else if(!strcmp(profile, "broadcom")) snprintf(cmd, sizeof(cmd), "%s configure", DSLBIN);//broadcom setting (xdslctl configure)
		else {									//netgear settings as default
		SETMODULATIONVAL
		for(i=BITSWAP;i<I24K;i++) SETOPTIONVAL
		}
	DBG("dslctl(): cmd to exec: %s\ndslctl(): cmd length: %d\n", cmd, strlen(cmd));
	unlock(fd, LOCK_DSL);								//release lock
	runexecve(cmd);									//run parsed xdslctl command
	}
DBG("dslctl(): execvp(e)() fail\n");
return 1;										//here only on execvp(e)() fail
}
