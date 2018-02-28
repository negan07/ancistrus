#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "nvram.h"
#include "ancistrus.h"
#include "common.h"
#include "dslctl.h"

/*
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
int fd, i;
enum { MOD=2, BITSWAP, SRA, SNR, TRELLIS, SESDROP, COMINMGN, SOS, DYNAMICD, DYNAMICF, I24K, MONITORTONE, PHYREXMT, GINP, TPSTC, PROFILE, US0 };
char args[ARGNUM][PARBUF];
const char *opt[]={ DSLBIN, "configure", "--lpair i --mod ", "--snr ", "--bitswap ", "--sra ", "--trellis ", "--sesdrop ", "--CoMinMgn ", "--SOS ", "--dynamicD ", "--dynamicF ", "--i24k ", "--monitorTone ", "--phyReXmt ", "--Ginp ", "--TpsTc ", "--profile ", "--us0 " }, *nvars[]={ "", "", "wan_dsl_mode", "snr", "bitswap", "sra", "trellis", "sesdrop", "cominmgn", "sos", "dynamicd", "dynamicf", "i24k", "monitortone", "phyrexmt", "ginp", "tpstc", "profile", "us0" }, *def[]={ "", "", "MMODE", "100", "on", "on", "on", "off", "off", "on", "on", "off", "on", "on", "1", "3", "14", "17a", "on" };

DBG("dslctl(): cmd is: %s\n", argv[0]);
	if(argv[1]==NULL || strcmp(argv[1], "configure")) execvp(DSLBIN, argv);		//no parse
	else if((fd=lock(LOCK_DSL))>=0) {						//parse: avoid race condition locking	
	for(i=0;i<MOD;i++) snprintf(args[i], sizeof(args[i]), "%s", opt[i]);		//initialize args with cmd name and option
	snprintf(args[MOD], sizeof(args[MOD]), "%s%s", opt[MOD], modparse(NV_SDGET(nvars[MOD], def[MOD])));		//mod setting
	snprintf(args[SNR], sizeof(args[SNR]), "%s%d", opt[SNR], abssnr(NV_SDGET(nvars[SNR], def[SNR])));		//snr setting
	for(i=BITSWAP;i<I24K;i++) snprintf(args[i], sizeof(args[i]), "%s%s", opt[i], NV_SDGET(nvars[i], def[i]));	//settings always added
		if(*NV_SGET("anc_dsltweak_enable")=='1') {				//enable the other settings
		for(;i<PROFILE;i++) snprintf(args[i], sizeof(args[i]), "%s%s", opt[i], NV_SDGET(nvars[i], def[i]));	//normal settings
		if(!strcmp(NV_SGET("wan_traffic_type"), "ptm") && *NV_SGET("anc_dslprofile_enable")=='1')	//profile setting only for vdsl
		for(;i<US0+1;i++) snprintf(args[i], sizeof(args[i]), "%s%s", opt[i], NV_SDGET(nvars[i], def[i]));
		}
	for(;i<ARGNUM;i++) memset(&args[i], 0, sizeof(args[i]));			//safe fill to 0 the remaining args
	unlock(fd, LOCK_DSL);								//release lock
#if DEBUG
	for(i=0;i<ARGNUM;i++) if(args[i][0]!='\0') DBG("dslctl() #%d: %s\n", i, args[i]);
#endif
	execvp(DSLBIN, (char**)args);
	}
return 1;											//here only on execvp() fail
}
