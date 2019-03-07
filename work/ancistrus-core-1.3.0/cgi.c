#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <libgen.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include "nvram.h"
#include "ancistrus.h"
#include "common.h"
#include "cgi.h"

#ifdef DEBUG
#include <stdio.h>
static FILE *FPTTYP;
#endif

/*
 * PARSEQUERYGET
 * GET method query parser separating couples `var=value` ('&'->'\0').
 * Modified special codes & chars and finishing with '\0\0'.
 * Obtain a query with the same structure of '/tmp/nvram' .
 * Input: query data buffer, old unparsed query obtained from getenv().
 * Return: parsed query length and parsed query data on success, '0' and unparsed query data on old query or malloc() error occurred.
 */
static int parsequeryget(char **query, char *oldq) {
char hex[2], *e;
int size;											//initialize len counting the '\0\0'

if(oldq == NULL || !*oldq) return 0;								//check unparsed query string
CGIDBG("parsequeryget(): unparsed query length: %d\nparsequeryget(): %s\n", strlen(oldq), oldq);
SMALLOCSTR(*query, (size=strlen(oldq)+2)) return 0;						//allocate memory for parsed query
	for(e=*query;*oldq;oldq++) {								//analyze each single query character
		if(*oldq=='%') {								//hex-encoded char founded
		hex[0]=*(++oldq);								//extract hex code from query
		hex[1]=*(++oldq);
		*(e++)=QUERYFORMATCONV;								//format hex code conversion
		size-=2;									//final size 2 chars less because of conversion
		}
		else if(*oldq == '+') *(e++)=' ';						//'+' means ' '
		else if(*oldq == '&') *(e++)='\0';						//tokenize `&` as separator
		else *(e++)=*oldq;								//copy original character only
	}
*(e++)='\0';			//resultant query is equal/shorter than orig: to match nvram structure it must be null chopped twice at the end
*e='\0';
CGIDBG("parsequeryget(): parsed query length: %d\n", size-2);
return size;											//return new parsed query size
}

/*
 * PARSEQUERYPOST
 * POST method query parser separating couples `var=value` ('&'->'\0').
 * Modified special codes & chars and finishing with '\0\0'.
 * Obtain a query with the same structure of '/tmp/nvram' .
 * Input: query data buffer, query size obtained from getenv().
 * Return: parsed query length and parsed query data on success, '0' and no query on query size or content type or malloc() error occurred.
 */
static int parsequerypost(char **query, int size) {
char c, hex[2], *e;

if(!size) return 0;										//size check (content type checked by caller)
CGIDBG("parsequerypost(): unparsed query length: %d\nparsequerypost(): ", size);
SMALLOCSTR(*query, (size+=2)) return 0;								//allocate memory for parsed query
	for(e=*query;READCH(c);e++) {								//read each single query character from stdin
	CGIDBG("%c", c);
		if(c == '%') {									//hex-encoded char founded
		READ(hex);									//read hex code from stdin
		CGIDBG("%s", hex);
		*e=QUERYFORMATCONV;								//format hex code conversion
		size-=2;									//final size 2 chars less because of conversion
		}
		else if(c == '+') *e=' ';							//'+' means ' '
		else if(c == '&') *e='\0';							//tokenize `&` as separator
		else *e=c;									//copy original character only
	}
*(e++)='\0';			//resultant query is equal/shorter than orig: to match nvram structure it must be null chopped twice at the end
*e='\0';
CGIDBG("\nparsequerypost(): parsed query length: %d\n", size-2);
return size;											//return new parsed query size
}

/*
 * QRAWSTDINGET
 * Obtain query var from stdin multipart/form data.
 * Input: variable name, value buffer (caller must take care of buffer allocation, if buf NULL no val stored).
 * Return: '0' on success, '2' on NULL/void var, '3' on var overflow, '4' on val overflow, '5' on var not found.
 */
static int qrawstdinget(const char *var, char *val) {
const char *s;
char c;
unsigned int i=0;

	CGIDBG("qrawstdinget(): var: %s\n", var);
	if(var==NULL || !*var) return 2;
	else if(strlen(var)>=2*VARBUF) return 3;
	for(s=var;READCH(c);) {									//find var data begin tag
	if(c==*s) s++;
	else s=var;										//tag not found: reset counter
		if(*s=='\0') {									//tag found
		if(val==NULL) return 0;								//no var fill
		for(i=0;READCH(c) && c!=LF_SYMBOL && c!=DQUOTE_SYMBOL && i<2*VARBUF;i++) val[i]=c;
		if(i>=2*VARBUF) return 4;
		val[i]='\0';
		CGIDBG("qrawstdinget(): val: %s\n", val);
		return 0;									//var filled
		}
	}
return 5;											//var not found
}

/*
 * POSTQUERYFILECONTENT
 * POST multipart/form data method downloading file from stdin and writing into /tmp/ dir.
 * Input: void (stdin).
 * Return: '0' on success, '1' on file open error, '2' on NULL/void fetching var, '3' on var overflow, '4' on val overflow, '5' on missing var.
 */
static int postqueryfilecontent(void) {
char c, bounds[2*VARBUF]="\r\n", bounde[2*VARBUF], filename[2*VARBUF+VARBUF/4]="/tmp/";
int fd, err;
unsigned int i, j=2;

i=strlen(filename);
while(READCH(c) && c!=LF_SYMBOL) bounds[j++]=c;							//fetch boundary tag
CGIDBG("postqueryfilecontent(): boundary: %s\n", bounds);
if((err=qrawstdinget(MP_CONTENTDISP "download\"; filename=\"", &filename[i]))) return err;	//fetch filename:'file' name must be 'download'
CGIDBG("postqueryfilecontent(): filename: %s\n", filename);
if((err=qrawstdinget(EOV, NULL))) return err;							//fetch file data begin tag 'LFCRLFCR'
SFDAOPEN(fd, filename, O_CREAT|O_WRONLY|O_TRUNC, S_IRWXU|S_IRGRP|S_IXGRP|S_IROTH|S_IXOTH) return 1;//open/create file with attr default: 0755
	for(i=0;READCH(c);) {									//write file data
	CGIDBG("%c", c);
		if(c==bounds[i]) bounde[i++]=c;							//search for boundary (file end)
		else {										//boundary not found: reset counter
		if(i) write(fd, bounde, i);							//if bound not found write prev stored data
		write(fd, &c, 1);
		i=0;
		}
	if(i==j) break;										//exit loop on boundary match
	}
close(fd);
CGIDBG("\n");
return err;
}

/*
 * READQUERY
 * Obtain request method & query from http daemon env vars: then parse and tokenize query.
 * Resultant query as '/tmp/query' file with the same structure of '/tmp/nvram' file.
 * Input: void.
 * Return: 'GET/POST/POSTMP' ('0/1/2') & '/tmp/query' file on success, '3' no method, '4' invalid method, '5' parse/load error & no query file.
 */
static int readquery(void) {
const char *methodstr;
char *query;
int size;

methodstr=getenv("REQUEST_METHOD");								//obtain method string from env variable
CGIDBG("\nreadquery(): request method: %s\n", methodstr);
	if(methodstr == NULL) return 3;								//not running through a web server
	else if(!strcmp(methodstr, "GET")) {							//'0' <==> GET
	if((size=parsequeryget(&query, getenv("QUERY_STRING"))) && !qram_load(query, size)) return 0;
	}
	else if(!strcmp(methodstr, "POST")) {							//'1' <==> POST
		if(!strcmp(getenv("CONTENT_TYPE"), URLENC_TYPE)) {
		if((size=parsequerypost(&query, atoi(getenv("CONTENT_LENGTH")))) && !qram_load(query, size)) return 1;
		}
		else if(!(size=postqueryfilecontent())) return 2;				//'2' <==> POSTMP
	}
	else return 4;										//invalid/unrecognized form method
return 5;											//bad parsing error
}

/*
 * SAVELIST
 * Save a list of value to nvram (add/delete).
 * Input: add/del flag, nvram compound variable name, content to add/del (separator: 'ETX=end of text').
 * Return: '0' on success, '1' on void/null variable name.
 */
static int savelist(const int add, const char *listname, char *listval) {
char *s, *s_listval;

if(listname==NULL || !*listname) return 1;
	TOKENIZE(listval, s, "\3", s_listval) {
	(!add ? NV_ADD(listname, s) : NV_DEL(listname, s));
	CGIDBG("savelist(): -------------------------------------------> anc nvram %s %s \"%s\"\n", !add ? "add" : "delete", listname, s);
	}
return 0;
}

/*
 * ADDJS
 * Write a javascript on stdout.
 * Input: variable content (usually a filename).
 * Return: '0' on success, '1' on void/null variable.
 */
static int addjs(const char *var) {
if(var==NULL || !*var) return 1;
TYPE("<script>location.href='");TYPE(var);TYPE("';AncdataToVisible(document.forms[0]);</script>");
return 0;
}

/*
 * GETNVLIST
 * Write an option tag list on stdout.
 * Input: compound array of variables raw content (divided by separator).
 * Return: '0' on success, '1' on void/null list.
 */
static int getnvlist(char *list) {
char *s, *s_list;

if(list==NULL || !*list) return 1;
TOKENIZE(list, s, "\1", s_list) {TYPE("<option value=\"");TYPE(s);TYPE("\">");TYPE(s);TYPE("</option>");}//chop div separator & create options
return 0;
}

/*
 * GETNVRECLIST
 * Write a record list array var.
 * Input: compound array of records raw content (divided by separator and subseparator).
 * Return: '0' on success, '1' on void/null reclist.
 */
static int getnvreclist(char *reclist) {
char *s, *s_reclist, *t, *s_subreclist;
int next=0, subnext;

if(reclist==NULL || !*reclist) return 1;
	TOKENIZE(reclist, s, "\1", s_reclist) {
	if(next) TYPECH(",");
	TYPECH("[");
	subnext=0;
		TOKENIZE(s, t, "\2", s_subreclist) {
		if(subnext) TYPECH(",");
		TYPECH("\"");TYPE(t);TYPECH("\"");
		subnext=1;
		}
	TYPECH("]");
	next=1;
	}
return 0;
}

/*
 * GETNVAR
 * Read an nvram var and print value.
 * Input: nvram var name.
 * Return: '0' on success, '1' on void/null variable.
 */
static int getnvar(const char *nvar) {
char *val, perc[5];
int fde;

if(nvar==NULL || !*nvar) return 1;
	if(!strncmp(nvar, "reclist_", 8) || !strncmp(nvar, "list_", 5)) {			//compound variable found
	BOOLLISTTYPE;
	val=NV_SGET(nvar+fde);
	CGIDBG("getnvar():      val   %s\n", val);
	if(fde==8 && getnvreclist(val)) return 1;
	else if(fde==5 && getnvlist(val)) return 1;
	}
	else if(!strncmp(nvar, "part_", 5)) {							//flash partition for % used space
	partperc(nvar+5, perc);
	CGIDBG("getnvar():      perc  %s\n", perc);
	TYPE(perc);
	}
	else {											//normal variable
	val=NV_SGET(nvar);
	CGIDBG("getnvar():      val   %s\n", val);
	TYPE(val);
	}
return 0;
}

/*
 * FETCHFORMVAR
 * Fetch set of variables from a web form page: raw (without @# delimiters), nvram var without delimiters and tags.
 * Input: raw var (mandatory), nvram var data buffers (caller must take care of buffer allocations), webpage fd.
 * Return: '0' on success, '15' on missing raw string, '20' on malformed webpage content.
 */
static int fetchformvar(char *raw, char *nvar, const int fd) {
int i;

if(raw==NULL) return 15;									//raw array cannot be null
	for(i=0;i<VARBUF;i++) {									//fill the raw content @variable# on container
	read(fd, &raw[i], 1);
	if(!raw[i] || raw[i]=='#') break;
	}
	if(i!=VARBUF) {
	raw[i]='\0';										//sanity check: if good set container end
	CGIDBG("fetchformvar(): raw   %s\n", raw);
	}
	else {											//each '@' must be followed by '#'
	CGIDBG("fetchformvar(): webpage malformed\n");
	return 20;
	}
	if(nvar!=NULL) {									//fill name of nvram var skipping the raw tags
	if(!strncmp(raw, "c4_", 3) || !strncmp(raw, "c6_", 3)) strcpy(nvar, raw+3);		//ipv4/ipv6 var tag
	else if(!strncmp(raw, "h_", 2)) strcpy(nvar, raw+2);					//hidden var tag
	else strcpy(nvar, raw);									//no var tags
	CGIDBG("fetchformvar(): qnvar %s\n", nvar);
	}
return 0;
}

/*
 * FETCHFORMMPVAR
 * Fetch variables from a web multipart/form.
 * Input: raw var (mandatory), nvram var.
 * Return: '0' on success, '1' on pipe() error, '2' on NULL/void var, '3' on var ovflow, '4' on val ovflow, '5' on miss var, '15' on miss raw.
 */
static int fetchformmpvar(const char *raw, const char *nvar) {
char buf[2*VARBUF];
int err=0;

if(raw==NULL) return 15;									//raw array cannot be null
	if(!strcmp(raw, "pipe_cmd")) {								//retrieve pipe_cmd to show refresh gui button
	if((err=qrawstdinget(MP_CONTENTDISP "pipe_cmd\"" EOV, buf))) return err;
	TYPE(buf);
	}
	else if(!strcmp(raw, "pipe_output")) {							//execute pipe command
	if((err=qrawstdinget(MP_CONTENTDISP "pipe_output\"" EOV, buf))) return err;
	if((err=runpipe(buf))) return err;
	}
	else getnvar(nvar);
return err;
}

/*
 * POPULATEPAGE
 * Populate webpage.
 * Preliminarly run a system() cmd if needed before printing page, then print page, then execute some instructions if needed
 * Input: webpage file descriptor, job & todo actions.
 * Return: '0' on success, '1' on pipe()/system() error, '10' on open() error, '15' on missing raw string, '20' on malformed webpage content.
 */
static int populatepage(const int fd, const char *job, const char *todo) {
enum { ADD=0, DELETE=1 };
const char *val;
char c, raw[VARBUF], nvar[VARBUF];
int fde, err;

if((!strcmp(job, "upload") || !strcmp(job, "home") || !strcmp(job, "opkg")) && *todo && (err=runsyscmd(todo))) return err;//run todo then print
	while(read(fd, &c, 1)) {								//read each page char
		if(c=='@') {									//search for raw var initalizer ('@')
		if((err=fetchformvar(raw, nvar, fd))) return err;				//fetch vars & check if webpage is malformed
			if(!*job || !strcmp(job, "upload")||!strcmp(job, "home")) getnvar(nvar);//### GET METHOD || HOME/UPLOAD FILE ###
			else if(!strcmp(job, "save") || !strcmp(job, "savesys")) {		//### POST METHOD - SAVE ###
			if(*(val=QSGET(raw))!='@' && strncmp(nvar, "list_", 5) && strncmp(nvar, "reclist_", 8)) NV_SET(nvar, val);//store value
			CGIDBG("populatepage(): ----------------------------------------> anc nvram set %s \"%s\"\n", nvar, val);
			getnvar(nvar);								//retrieve nvram value like GET
			}
			else if(!strcmp(job, "add") || !strcmp(job, "del")) {			//### ADD/DELETE ###
			val=QSGET(job);
			BOOLLISTTYPE;								//choose between list or reclist
			if(!strcmp(raw, val))							//add/del nvram subvalue(s)
			(!strcmp(job, "add") ? savelist(ADD, val+fde, QSGET(val+fde)) : savelist(DELETE, val+fde, QSGET("selected")));
			getnvar(nvar);								//retrieve nvram value like GET
			}			
			else if(!strcmp(job, "clear")) {					//### CLEAR ###
			val=QSGET(job);								//fetch list name to clear
			BOOLLISTTYPE;								//switch between list or reclist
			(!strcmp(raw, val) ? NV_SET(val+fde, "") : getnvar(nvar));		//void list on nvram (skip '(rec)list_') or GET
			}
			else if(!strcmp(job, "edit") && !strcmp(raw, "file_content")) {		//### EDIT FILE ###
			SFDOPEN(fde, QSGET("edit_file"), O_RDONLY) return 10;
			while(read(fde, &c, 1)) TYPECH(c);					//read each ch from file then stdout it
			close(fde);
			}
			else if(!strcmp(job, "pipe") && !strcmp(raw, "pipe_output") && (err=runpipe(QSGET("pipe_cmd")))) return err;//### PIPE
			else if(!strcmp(job, "pipemp") && (err=fetchformmpvar(raw, nvar))) return err;			//### PIPEMULTIPART ###
			else {									//load normal var
			val=QSGET(raw);
			TYPE(val);
			}
		}
		else TYPECH(c);									//write normal char
	}
if(!strcmp(job, "save") || !strcmp(job, "add") || !strcmp(job, "del") || !strcmp(job, "clear") || !strcmp(job, "nvram")) nvram_commit();
else if(!strcmp(job, "upload") && (err=addjs(QSGET("gen_file")))) return err;			//append javascript to page on upload job
return 0;
}

/*
 * TODORUN
 * Run 'todo' query val, cmd or instruction.
 * Input: job & todo action query vals.
 * Return: '0' on success or no return on runexecve() success, '1' on runexecve() failure, '-1' on error opening edit file.
 */
static int todorun(const char *job, char *todo) {
const char *text;
int fd;

	if(!strcmp(todo, "edit")) {								//### EDIT FILE ###
	CGIDBG("todorun(): edit file: \"%s\"\n", QSGET("edit_file"));
	SFDAOPEN(fd, QSGET("edit_file"), O_CREAT|O_WRONLY|O_TRUNC, S_IRWXU|S_IRGRP|S_IXGRP|S_IROTH|S_IXOTH) return -1;	//attr default: 0755
	for(text=QSGET("text");*text;text++) if(*text!=LF_SYMBOL) write(fd, text, 1);		//update file skipping '0D' char
	close(fd);
	}
	else if(!strcmp(job, "savesys")) return runsyscmd(todo);				//exec save job with todo cmd system() call
	else if(strcmp(job, "opkg") && strcmp(job, "home")) return runexecve(todo);		//exec todo cmd if not done before
return 0;
}

int cgi(void) {
enum { GET=0, POST, POSTMP };									//method flag identifiers
enum { JOB=0, TODO, NEXT_FILE };								//qvars identifiers
typedef struct {
const char *name;
char *val;
const char *mpname;
char mpval[2*VARBUF];
} qvar;
qvar qvars[]={ { "job", NULL, MP_CONTENTDISP "job\"" EOV, "" }, { "todo", NULL, MP_CONTENTDISP "todo\"" EOV, "" }, { "next_file", NULL, MP_CONTENTDISP "next_file\"" EOV, "" } };
int method, err, fd;

TYPE(HEADER);											//write html header on stdout for first

#ifdef DEBUG
SFPOPEN(FPTTYP, "/dev/ttyp0", "w") SFPOPEN(FPTTYP, "/dev/ttyp1", "w") TYPE("\ncgi(): tty console debug not open\n");
#endif

	switch(method=readquery()) {								//retrieve method, query file & query vars
	case GET:										//urlencoded form
	case POST:
	for(fd=JOB;fd<NEXT_FILE+1;fd++) qvars[fd].val=QSGET(qvars[fd].name);
	break;
	case POSTMP:										//multipart/form
		for(fd=JOB;fd<NEXT_FILE+1;fd++) {
		if((err=qrawstdinget(qvars[fd].mpname, qvars[fd].mpval))) return err;
		qvars[fd].val=qvars[fd].mpval;
		}
	break;
	default:
	return method;
	}
CGIDBG("cgi(): job: \"%s\"\ncgi(): todo: \"%s\"\ncgi(): next_file: \"%s\"\n", qvars[JOB].val, qvars[TODO].val, qvars[NEXT_FILE].val);
SFDOPEN(fd, qvars[NEXT_FILE].val, O_RDONLY) return 10;						//open webpage file descriptor
err=populatepage(fd, qvars[JOB].val, qvars[TODO].val);						//populate webpage
close(fd);											//close webpage file descriptor
if(!err && method>GET && *qvars[TODO].val) err=todorun(qvars[JOB].val, qvars[TODO].val);	//run 'todo' cmd/instr (if any) on POSTs only
CGIDBG("cgi(): returning code: %d\n", err);

#ifdef DEBUG
fclose(FPTTYP);
#endif

return err;
}
