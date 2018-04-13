#define LOCK_MAX_PATH		64
#define LOCK_TIMEOUT		60
#define ARGNUMMAX		40

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
 * PARTFREEPERC
 * Obtain partition percentage used space.
 * Input: mount path, destination string (caller must take care of dest allocation).
 * Return: '0' on success, '1' on failure.
 */
int partperc(const char *path, char *dest);

/*
 * CHECKNUMRANGE
 * Check if a numeric value belong to an interval.
 * Input: value as string, start, end interval delimiters.
 * Return: '0' success, '1' fail.
 */
int checknumrange(const char* value, const int start, const int end);
#define checkport(value) checknumrange(value, 1, 65534)

/*
 * CHECKPORTRANGE
 * Check tcp portstart-portend range.
 * Input: portrange value as string, delimiter character (eg '-').
 * Return: '0' success, '1' or '2' fail.
 */
int checkportrange(const char* portrange, const char separator) UNUSED;

/*
 * RUNPIPE
 * pipe(), fork() & read & write from pipe.
 * Input: cmd string.
 * Return: '0' on success, '1' on null/void cmd string or pipe()/fork() error.
 */
int runpipe(char *cmd);

/*
 * RUNEXECVE
 * Run a cmd string with execve().
 * Create the vector of arguments (tokenizing blanks) and run execve() including PATH envp.
 * Input: cmd string.
 * Return: no return on execve() success, '1' on null/void cmd string or execve() failure.
 */
int runexecve(char *cmd);

/*
 * RUNSYSCMD
 * Run a cmd string with system().
 * Input: cmd string.
 * Return: system() exit code on success, '1' on null/void cmd string.
 */
int runsyscmd(const char *cmd);
