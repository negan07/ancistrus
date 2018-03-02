#ifndef PROJNAME
#define PROJNAME	"ancistrus"
#endif
#ifndef PROJTARGET
#define PROJTARGET	"D7000"
#endif
#ifndef PROJFOUNDER
#define PROJFOUNDER	"negan07"
#endif
#ifndef PROJPLOT
#define PROJPLOT	"Netgear's " PROJTARGET " Nighthawk Router Experience Distributed Project"
#endif
#ifndef HOMEPAGE
#define HOMEPAGE	"https://github.com/" PROJFOUNDER "/" PROJNAME
#endif
#ifndef LICENSE
#define LICENSE		"License: GPLv2"
#endif
#define COPYRIGHT												\
"################################################################################"				\
"\n# \n# " PROJNAME "\n# \n# " PROJPLOT "\n# \n# " HOMEPAGE "\n# \n# " LICENSE "\n# \n# \n"

#define ERR(format, ...) fprintf(stderr, format, ##__VA_ARGS__)		/* stderr format output message */
//#define ERR(...) fprintf(stderr, __VA_ARGS__)

#ifdef DEBUG
#define DBG ERR
//#define DBG(format, ...) printf(format, ##__VA_ARGS__)
//#define DBG(...) printf
//#define DBG printf
#else
#define DBG(...)
#endif

#define ME "anc"
#define CGI ME ".cgi"
#define DSLCMD "dslctl"

#define NAME name
#define FUNC function
#define OPT action_struct
#define PNUM parameters_number
#define PMIN minimal_parameters_number
#define PAR cmd_line_parameter
#define EXECNAME PAR[0]
#define OPTION PAR[1]
#define ACTION PAR[2]

#define UNUSED __attribute((unused))				/* attributes */
#define NORETURN __attribute__ ((noreturn)

#define MAINARGS int PNUM, char** PAR				/* main() arguments */
#define MAINUNUSEDARGS int PNUM UNUSED, char** PAR UNUSED	/* unused args */

#define OPTIONS			/* option list: start from case 1, usage option case 0 (default) not needed */	\
const struct {													\
const char *NAME;							/* function option name */		\
const int PMIN;								/* min num of param needed */		\
const int PNUMFOREACH;							/* num of param needed when looping */	\
}														\
OPT[]
#define OPTLOOP for(i=sizeof(OPT)/sizeof(OPT[0]);i;i--)			/* loop from end to begin */
#define SEARCHOPT							/* search for a func option */		\
if(PNUM>2) OPTLOOP 												\
if(!strcmp(ACTION, OPT[i-1].NAME) && (PNUM>=OPT[i-1].PMIN) && 							\
(!OPT[i-1].PNUMFOREACH || !((PNUM-3)%OPT[i-1].PNUMFOREACH))) break;
#define PARLOOP for(j=3;PAR[j]!=NULL;j+=OPT[i-1].PNUMFOREACH)	/* loop the params shifting for each block */

#define MAIN_USAGE(err)							/* show main() help usage */		\
if(err) {													\
ERR("%sUsage: %s <", COPYRIGHT, argv[0]);									\
OPTLOOP ERR(" %s", OPT[i-1].NAME);										\
ERR(" >\n");													\
exit(err);													\
}

#define USAGE								/* show function help usage */		\
if(3) {														\
ERR("Usage: %s %s <", EXECNAME, OPTION);									\
OPTLOOP ERR(" %s", OPT[i-1].NAME);										\
ERR(" > < val ... val >\n");											\
exit(3);													\
}

#define SFREE(...) if(var) free(var)					/* sort of safe free() */

#define NV_GET nvram_get						/* various nvram redefs */
#define NV_SGET nvram_safe_get
#define NV_SDGET nvram_safedef_get
#define NV_GETR nvram_get_r
#define NV_SGETR nvram_safe_get_r
#define NV_BSGET nvram_bcm_safe_get
#define NV_BSGETR nvram_bcm_safe_get_r
#define NV_SET nvram_set
#define NV_USET nvram_unset
#define NV_ADD nvram_append
#define NV_DEL nvram_delete
#define NV_INS nvram_insert
#define NV_CHA nvram_change
#define NV_SAVE nvram_commit

#define NULLRED " >/dev/null 2>&1;"					/* null output redirections */

#define CR_SYMBOL 10							/* ASCII symbols definitions */
#define LF_SYMBOL 13

#define FUNCAVAIL							/* array of args functions */		\
{"oldwanip", oldwanip},												\
{"wanip", wanip},												\
{"oldgateway", oldgateway},											\
{"gateway", gateway},												\
{"fw", fw},													\
{"nvtotxt", nvtotxt},												\
{"nvram", nvram}

/*
 * NVRAM
 * Use the nvram shared obj lib routines: useful on bash scripts.
 * Act as /usr/sbin/nvram with some differences & all the enhancement modifications made on scnvram lib.
 * Input: argc, argv .
 * Return: a number referring to the case block executed.
 */
int nvram(MAINARGS);

/*
 * NVTOTXT
 * Convert an nvram value (if any) into a text and print it (if any) to stdout: a line for each nvram subvalue.
 * Input: argc, argv (argv[2]=nvram var name) .
 * Return: '0' if success, '1' if argv[2]=NULL.
 */
int nvtotxt(MAINARGS);

/*
 * RC_APPS
 * Run: prescript if any, 'rc_apps argv' with service name as argv[0], then postscript if any.
 * Input: argc, argv .
 * Return: last executed cmd exit code or '1' in case of pre-script inhibition or RCAPPS exec fail.
 */
int rc_apps(MAINARGS);

/*
 * GATEWAY
 * Print the internal lan ip address of the router.
 * Input: argc, argv .
 * Return: '0' .
 */
int gateway(MAINARGS);

/*
 * OLDGATEWAY
 * Print the previous internal lan ip address of the router.
 * Input: argc, argv .
 * Return: '0' .
 */
int oldgateway(MAINARGS);

/*
 * WANIP
 * Print the public ip address of the router.
 * Input: argc, argv .
 * Return: '0' .
 */
int wanip(MAINARGS);

/*
 * OLDWANIP
 * Print the previous public ip address of the router, before lcp down.
 * Input: argc, argv .
 * Return: '0' .
 */
int oldwanip(MAINARGS);

/*
 * FW
 * Add/delete a firewall ruleset.
 * Usage: 'anc fw <router|remote> <add|del> <ls|pf> <chainname> <udp|tcp|tcp/udp> <remport> <locport>' .
 * Example: 'anc fw add ls tcp SSH 8222-8222 22-22' .
 * Input: argc, argv .
 * Return: '0' if success, '1' if error occurred.
 */
int fw(MAINARGS);

/*
 * DSLCTL
 * 'xdslctl.bin configure' options parser.
 * Other options remain unchanged.
 * It ends invoking 'xdslctl.bin' with the parsed/unparsed parameters.
 * Input: argc, argv .
 * Return: '0' if cmd running success, '1' if error occurred.
 */
int dslctl(MAINARGS);

