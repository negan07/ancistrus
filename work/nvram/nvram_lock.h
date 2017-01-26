
#ifndef __NVRAM_LOCK_H
#define __NVRAM_LOCK_H

extern int nvram_lock(const char *path);
extern void nvram_unlock(int fd);

#endif
