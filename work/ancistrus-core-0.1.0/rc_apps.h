#ifndef RCAPPS						/* main binary */
#define RCAPPS "/usr/sbin/rc_app/rc_apps"
#endif

#ifndef TMPETC						/* path */
#define TMPETC "/etc"
#endif

#ifndef INITD
#define INITD "init.d"
#endif

#ifndef ETCINITD
#define ETCINITD TMPETC "/" INITD
#endif

#define SCR_MAX_PATH 64					/* limiters */
#define SCRPAR_MAX_PATH 128

#define PREPOST enum { PRE=0, POST };			/* PRE/POST tag flags */ 

#define BOOLPREPOST prepost==PRE ? "pre" : "post"	/* choice of PRE/POST tag */

#define WRITEPREPOSTPATH 				/* prepare the PRE/POST abs path string */		\
snprintf(cmd, sizeof(cmd), "%s/rc.%s/%s_%s", ETCINITD, BOOLPREPOST, serv, BOOLPREPOST);

