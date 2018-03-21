#ifndef DSLBIN														/* main binary */
#define DSLBIN 			"/usr/sbin/xdslctl.bin"
#endif

#define LOCK_DSL 		"/var/lock/dslctl.lock"									/* lock path */

#define DSLCMDBUF		320

#define SETOPTIONVAL 		snprintf(cmd, sizeof(cmd), "%s %s %s", cmd, opt[i], NV_SDGET(nvar[i], def[i]));		/* some redefs */
#define SETMODULATIONVAL 	snprintf(cmd, sizeof(cmd), "%s %s %s", cmd, opt[MOD], modparse(NV_SDGET(nvar[MOD], def[MOD])));
#define SETSNRVAL 		snprintf(cmd, sizeof(cmd), "%s %s %d", cmd, opt[SNR], abssnr(NV_SDGET(nvar[SNR], def[SNR])));
