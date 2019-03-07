#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/file.h>
#include <sys/wait.h>
#include <sys/statvfs.h>
#include <errno.h>
#include "ancistrus.h"
#include "common.h"

int lock(const char *lock_path) {
int fd, i;

SFDAOPEN(fd, lock_path, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR|S_IWUSR) return -1;
	for(i=0;i<LOCK_TIMEOUT;i++) {								//give a termination tryout time loop
		if(!lockf(fd, F_LOCK, 0)) {							//lock success
		DBG("Lock file: %s succeeded at cycle: %d, fd lock: %d\n", lock_path, i+1, fd);
		return fd;
		}
		else usleep(1000000);								//delay for another cycle
	}
close(fd);											//can't lock: close fd & return fail code
return -1;
}

int unlock(int fd, const char *lock_path) {
int err=1;

	if(fd>=0) {
	err=lockf(fd, F_ULOCK, 0);
	close(fd);
	unlink(lock_path);
	DBG("fd: %d unlock() returning code: %d\n", fd, err);
	}
return err;
}

int partperc(const char *path, char *dest) {
struct statvfs vfs;

if(path==NULL || *path!='/' || statvfs(path, &vfs) || !vfs.f_blocks) return 1;
sprintf(dest, "%lld%%", ((vfs.f_blocks-vfs.f_bfree)*100ULL+vfs.f_blocks/2)/(vfs.f_blocks));
return 0;
}

int checknumrange(const char* value, const int start, const int end) {
char num[20];

if(value != NULL) snprintf(num, sizeof(num), "%d", atoi(value));
if(value == NULL || strcmp(value, num) || atoi(value)<start || atoi(value)>end) return 1;
else return 0;
}

int checkportrange(const char* portrange, const char separator) {
char ports[12], *startport, *endport;
int err=0;

	if(portrange == NULL) err=1;
	else {
	strncpy(ports, portrange, sizeof(ports));						//save orig portrange
	startport=ports;
		if((endport=strchr(ports, separator)) == NULL) err=1;				//separate start & end port: separ miss=error
		else {
		*(endport++)='\0';								//chop separator & point to end port
			if(atoi(startport) > atoi(endport)) err=1;				//avoid inverted interval
			else {
			err+=checkport(startport);						//check ports
			err+=checkport(endport);
			}
		}
	}
return err;
}

int runpipe(char *cmd) {
int fd[2], err=1;
pid_t pid;
char c;

	if(cmd!=NULL && *cmd && !pipe(fd)) {							//avoid null/void string passed & check pipe()
		if((pid=fork())<0) exit(1);							//fork error
	        else if(pid>0) {								//parent thread
		close(fd[1]);									//close output side of pipe
		while(read(fd[0], &c, 1)) TYPECH(c);						//read from the pipe and write to stdout
		err=0;
		}
		else {										//child thread
		close(fd[0]);									//close input side of pipe
		runsyscmd(cmd);
		DBG("runpipe(): child execve() fail\n");
		exit(1);
		}
	}
return err;
}

int runexecve(char *cmd) {
char *const envp[]={PATH, NULL};
char *exargs[ARGNUMMAX], *s, *s_cmd;
int i=0;

	if(cmd!=NULL && *cmd) {									//avoid null/void string passed
	TOKENIZE(cmd, s, " ", s_cmd) exargs[i++]=s;						//assign an argument for each token
	exargs[i]=NULL;										//set last arg as null
	execve(*exargs, exargs, envp);
	DBG("runexecve(): execve() fail, cmd: %s, error number: %d\n", cmd, errno);
	}
return 1;
}

int runsyscmd(const char *cmd) {
int err=1;

	if(cmd!=NULL && *cmd) {
	putenv(PATH);										//set the env PATH var
	err=system(cmd);
	if(WIFEXITED(err)) err=WEXITSTATUS(err);						//grab system() '$?'
	}
return err;
}

