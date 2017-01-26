
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <linux/limits.h>

int nvram_lock(const char *path)
{
	char lock_path[PATH_MAX];
	char *p;
	int fd;
#ifndef LOCAL
	sprintf(lock_path, "/var/lock/%s.lock", path);
	p = lock_path + sizeof("/var/lock/");
#else
	sprintf(lock_path, "%s/var/lock/%s.lock", LROOT, path);
	p = lock_path + sizeof(LROOT) + sizeof("/var/lock/");
#endif
	while (*p) {
		if (*p == '/') *p = '_';
		p++;
	}

	fd = open(lock_path, O_CREAT|O_WRONLY|O_TRUNC,S_IRUSR|S_IWUSR);
	if (fd < 0)
		return -1;
	if (lockf(fd,F_LOCK,0) < 0) {
		close(fd);
		return -1;
	}
	return fd;
}

void nvram_unlock(int fd)
{
	if (fd >= 0) {
		lockf(fd,F_ULOCK,0);
		close(fd);
	}
}

//broadcom new added in wifi impl18
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#if 0
#define DBG_INFO(fmt, arg...) \
        do { printf("%s@%d: "fmt , __FUNCTION__ , __LINE__, ##arg); } while(0)

#define DBG_ERROR(fmt, arg...) \
        do { printf("%s@%d: "fmt , __FUNCTION__ , __LINE__, ##arg); } while(0)

#else
#define DBG_INFO(fmt, arg...)
#define DBG_ERROR(fmt, arg...)
#endif

static int _generic_lock(char *name)
{
	char lockfile[30];
	int fd;
	sprintf(lockfile,"/var/%s_lock",name);
	fd = open(lockfile,O_WRONLY|O_CREAT|O_EXCL,0644);
	if (fd < 0 && errno == EEXIST) {
		DBG_INFO("%s is already locked\n",lockfile);
		return 0;		
	} else if (fd < 0){
		DBG_ERROR("unexpected error checking lock");			
		return 0;
	}
	DBG_INFO(" nvram : %s created\n",lockfile);
	close(fd);
	return 1;
}

int brcm_get_lock(char *name, int timeout) 
{
	int loop=0;
	while(!_generic_lock(name))
	{
		usleep(1000000);
		if(++loop  >timeout) {
		 DBG_INFO("%s:%d pid:%d timeouted,but still did not get lock:%s  \r\n",__FUNCTION__,__LINE__,getpid(),name );
		 return 0;
		}
		DBG_INFO("%s:%d pid:%d is waiting for %s lock  \r\n",__FUNCTION__,__LINE__,getpid(),name );
	}
	DBG_INFO("%s:%d  process:%d get %s lock done######  \r\n",__FUNCTION__,__LINE__,getpid(),name);
	return 1;
}

int brcm_release_lock(char* name)
{
	char lockfile[30];
	sprintf(lockfile,"/var/%s_lock",name);
	if (unlink(lockfile) < 0) {
		
		DBG_ERROR("III cannot remove lock file,%s",lockfile);
		DBG_INFO(":%s:%d  process:%d release %s lock failed######  \r\n",__FUNCTION__,__LINE__,getpid(),name);
		return 0;
	}		
	DBG_INFO(":%s:%d  process:%d release %s	 lock ok!!!!!!!!!!!!!!  \r\n",__FUNCTION__,__LINE__,getpid(),name);
	return 1;
}


