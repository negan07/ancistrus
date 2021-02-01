#define HEADER				"Content-type: text/html; charset=utf-8\n\n"		//html header
//#define HEADER			"Content-type: text/html; charset=iso-8859-1\n\n"
//#define HEADER			"Content-type: text/html\n\n"

#define URLENC_TYPE			"application/x-www-form-urlencoded"			//urlencoded content type (default)
#define MP_CONTENTDISP			"Content-Disposition: form-data; name=\""		//multipart url var fetch tag
#define EOV				"\r\n\r\n"						//multipart url end of var tag

#ifdef DEBUG
#include <stdio.h>
#define TTYDEV				"/dev/ttyp0"						//stdout text terminal used
#define CGIDBG(format, ...)		do {							\
					static FILE *FPTTYP;					\
					SFPOPEN(FPTTYP, TTYDEV, "w") break;			\
					else {							\
					fprintf(FPTTYP, "%s(%d): ", __FUNCTION__, __LINE__);	\
					fprintf(FPTTYP, format, ##__VA_ARGS__);			\
					fclose(FPTTYP); }					\
					} while(0)						//console format output message
#define CGIQDBG(format, ...)		do {							\
					static FILE *FPTTYP;					\
					SFPOPEN(FPTTYP, TTYDEV, "w") break;			\
					else {							\
					fprintf(FPTTYP, format, ##__VA_ARGS__);			\
					fclose(FPTTYP); }					\
					} while(0)						//console format output query message
#else
#define CGIDBG(...)
#define CGIQDBG(...)
#endif

#define QUERYFORMATCONV										\
(hex[0]>'9'?(hex[0]&0xDF)-'A'+10:hex[0]-'0')*16+(hex[1]>'9'?(hex[1]&0xDF)-'A'+10:hex[1]-'0')	//query format conversion
#define BOOLLISTTYPE			(!strncmp(nvar, "reclist_", 8) ? (fde=8) : (fde=5))	//choose between list or reclist

#define QSGET(name)			qram_safe_get(name)					//not reentrant
#define QSGETR(name)			qram_safe_get_r(name)					//reentrant (return must be free)

#define VARBUF				64							//webpage variable buf size
