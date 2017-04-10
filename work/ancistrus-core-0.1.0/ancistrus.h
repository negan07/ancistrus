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

#define NAME name
#define PROC procedure
#define OPT action_struct
#define PNUM parameters_number
#define PMIN minimal_parameters_number
#define PAR cmd_line_parameter
#define EXECNAME PAR[0]
#define OPTION PAR[1]
#define ACTION PAR[2]

#define MAINARGS int PNUM, const char** PAR				/* main() arguments */

#define OPTIONS			/* option list: start from case 1, usage option case 0 (default) not needed */	\
const struct {													\
const char *NAME;							/* function option name */		\
const int PMIN;								/* min num of param needed */		\
const int PNUMFOREACH;							/* num of param needed when looping */	\
}														\
OPT[]
#define OPTLOOP for(i=sizeof(OPT)/sizeof(OPT[0]);i;i--)			/* loop from end to begin */
#define SEARCHOPT							/* search for a procedure option */	\
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

#define USAGE								/* show procedure help usage */		\
if(3) {														\
ERR("Usage: %s %s <", EXECNAME, OPTION);									\
OPTLOOP ERR(" %s", OPT[i-1].NAME);										\
ERR(" > < val ... val >\n");											\
exit(3);													\
}

#define SFREE(...) if(var) free(var)					/* sort of safe free() */

#define NV_GET nvram_get						/* various nvram get redefs */
#define NV_SGET nvram_safe_get
#define NV_GETR nvram_get_r
#define NV_SGETR nvram_safe_get_r
#define NV_BSGET nvram_bcm_safe_get
#define NV_BSGETR nvram_bcm_safe_get_r

