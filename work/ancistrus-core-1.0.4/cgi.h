#define HEADER				"Content-type: text/html; charset=utf-8\n\n"		//html header
//#define HEADER			"Content-type: text/html; charset=iso-8859-1\n\n"
//#define HEADER			"Content-type: text/html\n\n"
#define CONTENT_TYPE			"application/x-www-form-urlencoded"			//content type fixed

#ifdef DEBUG
#define CGIDBG(format, ...)		fprintf(FPTTYP, format, ##__VA_ARGS__)			//console format output message
#else
#define CGIDBG(...)
#endif

#define QUERYFORMATCONV										\
(hex[0]>'9'?(hex[0]&0xDF)-'A'+10:hex[0]-'0')*16+(hex[1]>'9'?(hex[1]&0xDF)-'A'+10:hex[1]-'0')	//query format conversion

#define QSGET(name)			qram_safe_get(name)					//not reentrant
#define QSGETR(name)			qram_safe_get_r(name)					//reentrant (return must be free)

#define VARBUF				64							//webpage variable buf size
