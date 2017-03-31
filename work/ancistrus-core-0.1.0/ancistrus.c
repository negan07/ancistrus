#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "nvram.h"
#include "ancistrus.h"

/*
 * NVRAM
 * Use the nvram shared obj lib routines: useful on bash scripts.
 * Act as /usr/sbin/nvram with some differences & all the enhancement modifications made on nvram-x.x.x-anc scnvram lib.
 */
void nvram(MAINARGS);

void nvram(MAINARGS) {
enum { HELP, SHOW, DEFSHOW, BCMSHOW, RGET, GET, BCMRGET, BCMGET, SET, BCMSET, UNSET, BCMUNSET, ADD, APPEND, DELETE, INSERT, CHANGE, RESET, INIT, COMMIT };
OPTIONS = { {"show", 3, 0}, {"defshow", 3, 0}, {"bcmshow", 3, 0}, {"rget", 4, 1}, {"get", 4, 1}, {"bcmrget", 4, 1}, {"bcmget", 4, 1}, {"set", 5, 2}, {"bcmset", 5, 2}, {"unset", 4, 1}, {"bcmunset", 4, 1}, {"add", 5, 1}, {"append", 5, 1}, {"delete", 5, 1}, {"insert", 5, 1}, {"change", 6, 1}, {"reset", 3, 0}, {"init", 3, 0}, {"commit", 3, 0} };
unsigned int i=0, j=0;
char *var;

SEARCHOPT
	switch(i) {
	case SHOW:  //nvram name=value list & status
	nvram_tmp_show();
	break;
	case DEFSHOW:  //default nvram name=value list
	nvram_def_show();
	break;
	case BCMSHOW:  //nvram.bcm name=value list
	nvram_bcm_show();
	break;
	case RGET:  //get a var (in reentrant safe mode): no loop for this, use EVGET instead
	var=NV_SGETR(PAR[3]);
	puts(var);
	SFREE(var);
	break;
	case GET:  //get a var series (name=val): output is ready for `eval` cmd
	PARLOOP printf("%s=%s\n", PAR[j], NV_SGET(PAR[j]));
	break;
	case BCMRGET:  //get a bcmvar (in reentrant safe mode): no loop for this, use EVBCMGET instead
	var=NV_BSGETR(PAR[3]);
	puts(var);
	SFREE(var);
	break;
	case BCMGET:  //eval get a bcmvar series (name=val): output is ready for `eval` cmd
	PARLOOP printf("%s=%s\n", PAR[j], NV_BSGET(PAR[j]));
	break;
	case SET:  //set vars (on ram only)
	PARLOOP nvram_set(PAR[j], PAR[j+1]);  //if PAR[j+1]=="" set nvram value to void ('var=')
	break;
	case BCMSET:  //set bcmvars (on ram only)
	PARLOOP nvram_set(PAR[j], PAR[j+1]);  //if PAR[j+1]=="" set nvram value to void ('var=')
	break;
	case UNSET:  //unset vars (on ram only)
	PARLOOP nvram_unset(PAR[j]);
	break;
	case BCMUNSET:  //unset bcmvars (on ram only)
	PARLOOP nvram_bcm_unset(PAR[j]);
	break;
	case ADD:  //append a subvar (on ram only): if var not existing, create it, if val already existing shift at last
	case APPEND:
	PARLOOP if(PAR[j+1]!=NULL) nvram_append(PAR[3], PAR[j+1]);
	break;
	case DELETE:  //delete a subvar (on ram only): if not existing, do nothing
	PARLOOP if(PAR[j+1]!=NULL) nvram_delete(PAR[3], PAR[j+1]);
	break;
	case INSERT:  //insert a subvar (on ram only): if var not existing, create it, if val already existing, shift as first
	PARLOOP if(PAR[j+1]!=NULL) nvram_insert(PAR[3], PAR[j+1]);
	break;
	case CHANGE:  //change a subvar with a new one (on ram only): if var or val1 not existing or val1==val2, do nothing
		PARLOOP {
		if(PAR[j+1]!=NULL && PAR[j+2]!=NULL) nvram_change(PAR[3], PAR[j+1], PAR[j+2]);
		else break;
		j++;
		}
	break;
	case RESET:  //reset to default settings (on ram only)
	nvram_reset();
	break;
	case INIT:  //load nvram from flash: use with caution, will delete all settings not already committed
	nvram_load();
	break;
	case COMMIT:  //commit nvram to flash
	nvram_commit();
	break;
	default:  //show usage help (case 0:)
	USAGE
	}
}

int main(int argc, const char** argv) {
const struct {						//procedure list
const char *NAME;					//name called as argv[x] string
void (*PROC)(MAINARGS);					//prototype
} OPT[] = { {"nvram", nvram} };
unsigned int i;

if(argc < 2) MAIN_USAGE(1)
OPTLOOP if(!strcmp(argv[1], OPT[i-1].NAME)) break;
if(i) OPT[i-1].PROC(argc, argv);			//reflection simulation: run argv[1]() procedure
else MAIN_USAGE(2)
return 0;
}

