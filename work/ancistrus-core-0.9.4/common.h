#define LOCK_MAX_PATH 64
#define LOCK_TIMEOUT 60

/*
 * LOCK
 * Try to lock the lock_path for 'timeout' times.
 * Input: lock_path .
 * Return: file descriptor locked or -1 if error.
 * Caller must unlock the file descriptor.
 */
int lock(const char *lock_path);

/*
 * UNLOCK
 * Unlock the fd & unlink (remove) the related lock_path .
 * Input: locked file descriptor, lock_path .
 * Return: 0 on unlock success, 1 if fd is already closed.
 */
int unlock(int fd, const char *lock_path);

/*
 * CHECKNUMRANGE
 * Check if a numeric value belong to an interval.
 * Input: value as string, start, end interval delimiters.
 * Return: '0' success, '1' fail.
 */
int checknumrange(const char* value, int start, int end);

/*
 * CHECKPORTRANGE
 * Check tcp portstart-portend range.
 * Input: portrange value as string, delimiter character (eg '-').
 * Return: '0' success, '1' or '2' fail.
 */
int checkportrange(char* portrange, char separator) UNUSED;
#define checkport(value) checknumrange(value, 1, 65534)

