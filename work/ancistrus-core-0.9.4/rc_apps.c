#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <libgen.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/file.h>
#include <errno.h>
#include "nvram.h"
#include "ancistrus.h"
#include "common.h"
#include "rc_apps.h"

PREPOST

/*
 * CHECKPREPOST
 * Same as sh: '[ -f $cmd -a -x $cmd ]' .
 * Input: rel service name, PRE/POST flag.
 * Return: '0'=success, '1'=fail .
 */
static int checkprepost(const char *serv, const int prepost) {
char cmd[SCR_MAX_PATH];
struct stat sb;

WRITEPREPOSTPATH
DBG("Verifying script: %s ...", cmd);
if(!access(cmd, F_OK|X_OK) && !stat(cmd, &sb) && S_ISREG(sb.st_mode)) return 0;	//success
else return 1;									//fail
}

/*
 * RUNPREPOST
 * Check & run the PRE/POST script.
 * Input: rel service name, argc, argv, PRE/POST flag.
 * Return: if script checked, response of 'system(cmd)', otherwise 1 .
 */
static int runprepost(const char *serv, int argc, char **argv, const int prepost) {
char cmd[SCRPAR_MAX_PATH];
int err=1;

	if(!checkprepost(serv, prepost)) {
	DBG("... success\n");
	WRITEPREPOSTPATH									//prepare script path
	for(;err<argc;err++) snprintf(cmd, sizeof(cmd), "%s \"%s\"", cmd, argv[err]);		//append argvs
	DBG("runprepost(): executing %s\n", cmd);
	err=runsyscmd(cmd);
	}
DBG("\nrunprepost(): return code: %d\n", err);
return err;
}

/*
 * RUN
 * fork() & run rc_apps then POST script.
 * Input: rel service name, argc, argv, locked fd.
 * Exit: 2 if fork error - on parent thread: 1 if no POST script, waitpid errcode on waitpid error or runprepost() retval - on child thread 1 .
 */
static void run(const char *serv, int argc, char **argv ,int fd, const char *lock_path) __attribute__ ((noreturn));
static void run(const char *serv, int argc, char **argv, int fd, const char *lock_path) {
int pid, status, err=1;
pid_t p;

	if((pid=fork())<0) {							//fork error
	DBG("fork() error: unlocking fd %d\n", fd);
	unlock(fd, lock_path);
	exit(2);
	}
	else if(pid>0) {							//parent thread
	while(((p=waitpid(pid, &status, 0))==-1) && (errno==EINTR)) ;		//safe-wait for child exit...
	DBG("%d child exited: waitpid() released, status: %d\n", pid, status);
		if(p>=0) {							//try to run the post script
		runprepost(serv, argc, argv, POST);
		err=WIFEXITED(status) ? WEXITSTATUS(status) : 1;		//check the waitpid() release code
		}
	exit(err);
	}
	else {									//child thread
	DBG("Unlocking fd: %d on child thread\n", fd);
	unlock(fd, lock_path);							//unlock
	execvp(RCAPPS, argv);							//exec RCAPPS
	DBG("run(): child execvp() fail\n");
	exit(1);
	}
}

/*
 * MAIN RC_APPS
 */
int rc_apps(MAINARGS) {
int fd;
char *serv, lock_path[LOCK_MAX_PATH];

serv=basename(argv[0])+3;							//take the relative service name shifted of 'rc_'
DBG("rc_apps(): service is: %s\n", serv);
	if((argc==1) || !strcmp(serv, "apps") || !strcmp(serv, "init") || !strcmp(serv, "start") || *NV_SGET("anc_boot_disable")=='1') 
	execvp(RCAPPS, argv);							//avoid itself invocation, boot services, disable flag
	else if(runprepost(serv, argc, argv, PRE) > 99) return 1;		//if PRE script has a 100+ $? skip next RCAPPS service execs
	else {
	snprintf(lock_path, sizeof(lock_path), "/var/lock/%s.lock", serv);
	if((fd=lock(lock_path))>=0) run(serv, argc, argv, fd, lock_path);	//run() also includes runprepost(), unlock(), unlink()
	}
DBG("rc_apps(): execvp() fail\n");
return 1;									//here only on execvp() fail
}

