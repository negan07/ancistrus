#ifndef DSLBIN						/* main binary */
#define DSLBIN "/usr/sbin/xdslctl.bin"
#endif

#define LOCK_DSL "/var/lock/dslctl.lock"

#define ARGNUM 39					/* dsl configure param num */
#define PARBUF 32					/* parameter buffer */

#define SETOPTIONNAME snprintf(args[i], sizeof(char)*PARBUF, "%s", opt[i]);				/* some redefs */
#define SETMODULATIONVAL snprintf(args[MOD+1], sizeof(char)*PARBUF, "%s", modparse(NV_SDGET(nvars[MOD], opt[MOD+1])));

