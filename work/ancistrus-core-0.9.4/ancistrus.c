#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libgen.h>
#include "nvram.h"
#include "ancistrus.h"

int nvram(MAINARGS) {
enum { HELP, SHOW, DEFSHOW, BCMSHOW, RGET, GET, BCMRGET, BCMGET, SET, BCMSET, UNSET, BCMUNSET, ADD, APPEND, DELETE, INSERT, CHANGE, RESET, INIT, COMMIT };
OPTIONS = { {"show", 3, 0}, {"defshow", 3, 0}, {"bcmshow", 3, 0}, {"rget", 4, 1}, {"get", 4, 1}, {"bcmrget", 4, 1}, {"bcmget", 4, 1}, {"set", 5, 2}, {"bcmset", 5, 2}, {"unset", 4, 1}, {"bcmunset", 4, 1}, {"add", 5, 1}, {"append", 5, 1}, {"delete", 5, 1}, {"insert", 5, 1}, {"change", 6, 1}, {"reset", 3, 0}, {"init", 3, 0}, {"commit", 3, 0} };
unsigned int i=0, j=0;
char *var;

SEARCHOPT
	switch(i) {
	case SHOW:						//nvram name=value list & status
	nvram_tmp_show();
	break;
	case DEFSHOW:						//default nvram name=value list
	nvram_def_show();
	break;
	case BCMSHOW:						//nvram.bcm name=value list
	nvram_bcm_show();
	break;
	case RGET:						//get a var (in reentrant safe mode): no loop for this, use GET instead
	var=NV_SGETR(argv[3]);
	puts(var);
	SFREE(var);
	break;
	case GET:						//get a var series (name=val)
	PARLOOP printf("%s=%s\n", argv[j], NV_SGET(argv[j]));
	break;
	case BCMRGET:						//get a bcmvar (in reentrant safe mode): no loop for this, use BCMGET instead
	var=NV_BSGETR(argv[3]);
	puts(var);
	SFREE(var);
	break;
	case BCMGET:						//eval get a bcmvar series (name=val)
	PARLOOP printf("%s=%s\n", argv[j], NV_BSGET(argv[j]));
	break;
	case SET:						//set vars (on ram only)
	PARLOOP nvram_set(argv[j], argv[j+1]);			//if argv[j+1]=="" set nvram value to void ('var=')
	break;
	case BCMSET:						//set bcmvars (on ram only)
	PARLOOP nvram_bcm_set(argv[j], argv[j+1]);		//if argv[j+1]=="" set nvram.bcm value to void ('var=')
	break;
	case UNSET:						//unset vars (on ram only)
	PARLOOP nvram_unset(argv[j]);
	break;
	case BCMUNSET:						//unset bcmvars (on ram only)
	PARLOOP nvram_bcm_unset(argv[j]);
	break;
	case ADD:		//append a subvar (on ram only): if var not existing, create it, if val already existing shift at last
	case APPEND:
	PARLOOP if(argv[j+1]!=NULL) nvram_append(argv[3], argv[j+1]);
	break;
	case DELETE:		//delete a subvar (on ram only): if not existing, do nothing
	PARLOOP if(argv[j+1]!=NULL) nvram_delete(argv[3], argv[j+1]);
	break;
	case INSERT:		//insert a subvar (on ram only): if var not existing, create it, if val already existing, shift as first
	PARLOOP if(argv[j+1]!=NULL) nvram_insert(argv[3], argv[j+1]);
	break;
	case CHANGE:		//change a subvar with a new one (on ram only): if var or val1 not existing or val1==val2, do nothing
		PARLOOP {
		if(argv[j+1]!=NULL && argv[j+2]!=NULL) nvram_change(argv[3], argv[j+1], argv[j+2]);
		else break;
		j++;
		}
	break;
	case RESET:		//reset to default settings (on ram only)
	nvram_reset();
	break;
	case INIT:		//load nvram from flash: use with caution, will delete all settings not already committed
	nvram_load();
	break;
	case COMMIT:		//commit nvram to flash
	nvram_commit();
	break;
	default:		//show usage help (case 0:)
	USAGE
	}
return i;
}

int nvtotxt(MAINARGS) {
char *nv, *s;

if(argc<3) return 1;
nv=NV_SGET(argv[2]);
for(s=nv;*s;s++) if(*s==DIVISION_SYMBOL) *s=CR_SYMBOL;		//substitute 'division' with 'carriage return'
if(*nv) puts(nv);
return 0;
}

int main(MAINARGS) {
const struct {
const char *name;						//name called as argv[x] string
int (*func)(MAINARGS);						//prototype function (same as 'name' without brackets)
} opt[] = { FUNCAVAIL };					//function list
char *corename;
unsigned int i;

DBG("main(): my name is %s\n", argv[0]);
corename=basename(argv[0]);
//if(!strcmp(corename, CGI)) return i=cgi();			//core working as 'anc.cgi' web gui
if(!strcmp(corename+1, DSLCMD)) return i=dslctl(argv);		//core working as 'adslctl' or 'xdslctl'
if(strcmp(corename, ME)) return i=rc_apps(argc, argv);		//core working as 'rc_apps'
if(argc < 2) MAIN_USAGE(1)
OPTLOOP if(!strcmp(argv[1], opt[i-1].name)) break;
if(i) i=opt[i-1].func(argc, argv);				//reflection simulation: run argv[1]() function
else MAIN_USAGE(2)
return 0;
}

