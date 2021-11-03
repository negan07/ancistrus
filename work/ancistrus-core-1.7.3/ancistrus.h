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
#define PROJPLOT	"Netgear's " PROJTARGET " (V1) Nighthawk Router Experience Distributed Project"
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
#define DBG fprintf(stderr, "%s(%d): ", __FUNCTION__, __LINE__); ERR
//#define DBG(format, ...) printf(format, ##__VA_ARGS__)
//#define DBG(...) printf
//#define DBG printf
#else
#define DBG(...)
#endif

#define ME "anc"							/* some alias redefs */
#define CGI ME ".cgi"
#define DSLCMD "dslctl"

#define EXECNAME argv[0]
#define OPTION argv[1]
#define ACTION argv[2]

#define UNUSED __attribute((unused))					/* attributes */
#define NORETURN __attribute__ ((noreturn))

#define MAINARGS int argc, char** argv					/* main() arguments */
#define MAINUNUSEDARGS int argc UNUSED, char** argv UNUSED		/* unused args */

#define OPTIONS			/* option list: start from case 1, usage option case 0 (default) not needed */	\
const struct {													\
const char *name;							/* function option name */		\
const int pmin;								/* min num of param needed */		\
const int FOREACHARGC;							/* num of param needed when looping */	\
}														\
opt[]
#define OPTLOOP for(i=sizeof(opt)/sizeof(opt[0]);i;i--)			/* loop from end to begin */
#define SEARCHOPT							/* search for a func option */		\
if(argc>2) OPTLOOP 												\
if(!strcmp(ACTION, opt[i-1].name) && (argc>=opt[i-1].pmin) && 							\
(!opt[i-1].FOREACHARGC || !((argc-3)%opt[i-1].FOREACHARGC))) break;
#define PARLOOP for(j=3;argv[j]!=NULL;j+=opt[i-1].FOREACHARGC)		/* loop the params shifting for each block */

#define MAIN_USAGE(err)							/* show main() help usage */		\
if(err) {													\
ERR("%sUsage: %s <", COPYRIGHT, argv[0]);									\
OPTLOOP ERR(" %s", opt[i-1].name);										\
ERR(" >\n");													\
exit(err);													\
}

#define USAGE								/* show function help usage */		\
if(3) {														\
ERR("Usage: %s %s <", EXECNAME, OPTION);									\
OPTLOOP ERR(" %s", opt[i-1].name);										\
ERR(" > < val ... val >\n");											\
exit(3);													\
}

#define CR_SYMBOL 10							/* ASCII symbols definitions */
#define LF_SYMBOL 13
#define DQUOTE_SYMBOL 34

#define PATH 								/* system PATH */			\
"PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/sbin/scripts:/usr/sbin/rc_app"

#define SFDOPEN(fd, path, flags) if((fd=open(path, flags))<0)		/* sort of secure open() */
#define _SFDOPEN(fd, path, flags) if((fd=open(path, flags))>=0)		/* complementary of SFDOPEN */
#define SFDAOPEN(fd, path, flags, att) if((fd=open(path, flags, att))<0)/* same above with attribute permissions */
#define _SFDAOPEN(fd, path, flags, att) if((fd=open(path, flags, att))>=0)/* complementary of SFDAOPEN */
#define SFPOPEN(FP, path, flags) if((FP=(fopen(path, flags)))==NULL)	/* sort of secure fopen() */
#define SMALLOCSTR(data, size) if((data=(char*)malloc(size))==NULL)	/* sort of safe malloc() for strings */
#define SFREE(var) if(var) free(var)					/* sort of safe free() */
#define READCH(ch) read(0, &ch, 1)					/* low-level read a char from stdin */
#define TYPECH(ch) write(1, &ch, 1)					/* low-level write a char to stdout */
#define READ(str) read(0, str, sizeof(str))				/* low-level read a string from stdin */
#define TYPE(str) write(1, str, strlen(str))				/* low-level write a string to stdout */
#define TOKENIZE(str, tok, tag, s_str) for(tok=(char*)strtok_r(str, tag, &s_str);tok!=NULL;tok=(char*)strtok_r(NULL, tag, &s_str))/* tokens */
#define NULLRED " >/dev/null 2>&1;"					/* null output redirections */

#define NV_GET nvram_get						/* various nvram redefs */
#define NV_SGET nvram_safe_get
#define NV_SDGET nvram_safedef_get
#define NV_GETR nvram_get_r
#define NV_SGETR nvram_safe_get_r
#define NV_SDGETR nvram_safedef_get_r
#define NV_BSGET nvram_bcm_safe_get
#define NV_BSGETR nvram_bcm_safe_get_r
#define NV_SET nvram_set
#define NV_USET nvram_unset
#define NV_ADD nvram_append
#define NV_DEL nvram_delete
#define NV_INS nvram_insert
#define NV_CHA nvram_change
#define NV_SAVE nvram_commit

#define FUNCAVAIL							/* array of args functions */		\
{"oldwanip", oldwanip},												\
{"wanip", wanip},												\
{"oldgateway", oldgateway},											\
{"gateway", gateway},												\
{"fw", fw},													\
{"nvtotxt", nvtotxt},												\
{"redir", redir},												\
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
 * REDIR
 * Redirect from 'rc_<service> argv' script to 'rc_apps argv' with <service> name as argv[0] .
 * Used to mantain some original <service> instances on new service scripts.
 * Input: argc, argv.
 * Return: rc_apps() cmd exit code, '1' if argv[2]=NULL, invalid argv[0] or RCAPPS exec fail.
 */
int redir(MAINARGS);

/*
 * RC_APPS
 * Run: prescript if any, 'rc_apps argv' with service name as argv[0], then postscript if any.
 * Input: argc, argv .
 * Return: last executed cmd exit code or '1' in case of pre-script inhibition, invalid argv[0] or RCAPPS exec fail.
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
 * Example: 'anc fw remote add ls SSH tcp 8222 22' .
 * Input: argc, argv .
 * Return: '0' if success, '1' if error occurred.
 */
int fw(MAINARGS);

/*
 * DSLCTL
 * 'xdslctl.bin configure' options parser.
 * Other options remain unchanged.
 * It ends invoking 'xdslctl.bin' with the parsed/unparsed parameters.
 * Input: argv .
 * Return: '0' if cmd running success, '1' if cmd exec error occurred.
 */
int dslctl(char** argv);

/*
 * CGI
 * Common Gateway Interface web parser.
 * Print dynamic form based webpages, save settings and execute services.
 * Methods available: GET, POST.
 * Input: void as arguments come from stdin or env vars read by getenv() .
 * Return: '0', 'void' (exec()) or system() return value if success, != '0' if error occurred.
 */
int cgi(void);
