#ifndef _NVRAM_
#define _NVRAM_

#include <string.h>

/*
 * 2003/02/27  		             			    
 * 		       				released by Ron     
 */

/* line terminator by 0x00 
 * data terminator by two 0x00
 * subvalue divided by 0x01
 * subsubvalue separated by 0x02
 */	

/* nvram path */
#define NVRAM_PATH		"/config/nvram/nvram"		/* ex:  /dev/mtd/nvram */

#define NVRAM_TMP_PATH		"/tmp/nvram"			/* ex:  /tmp/nvram     */
#define NVRAM_BCM_PATH		"/tmp/nvram.bcm"
#define NVRAM_DEFAULT		"/etc/default"			/* ex:  /etc/default   */

/* local host debug purpose */
#ifdef LOCAL
#undef NVRAM_PATH
#define NVRAM_PATH		LROOT "/config/nvram/nvram"
#undef NVRAM_TMP_PATH
#define NVRAM_TMP_PATH		LROOT "/tmp/nvram"
#undef NVRAM_BCM_PATH
#define NVRAM_BCM_PATH		LROOT "/tmp/nvram.bcm"
#undef NVRAM_DEFAULT
#define NVRAM_DEFAULT		LROOT "/etc/default"
#endif

/* used token tags */
#define END_SYMBOL		0x00
#define DIVISION_SYMBOL		0x01
#define SEPARATION_SYMBOL	0x02

/* NVRAM_HEADER MAGIC */ 
#define NVRAM_MAGIC		0x004E4F52			/* RON */

/* used 12bytes, 28bytes reserved */
#define NVRAM_HEADER_SIZE	40       		 

/* max size in flash */
#define NVRAM_SIZE		4194303				/* nvram size 4M bytes*/

/* each line max size */
#define NVRAM_BUFF_SIZE		4096

/* each key buff size */
#define KEY_BUFF_SIZE		256

/* errorno */
#define NVRAM_SUCCESS		0
#define NVRAM_FLASH_ERR		1 
#define NVRAM_MAGIC_ERR		2
#define NVRAM_LEN_ERR		3
#define NVRAM_CRC_ERR		4
#define NVRAM_SHADOW_ERR	5
#define NVRAM_DATA_ERR		6

/*
 * nvram header struct 		            
 * magic    = 0x004E4F52 (RON)             
 * len      = 0~NVRAM_SIZE                      
 * crc      = use crc-32                    
 * reserved = reserved 	                    
 */
 
typedef struct nvram_header_s{
	unsigned long magic;
	unsigned long len;
	unsigned long crc;
	unsigned long reserved;
	
}nvram_header_t;


/* Copy data from flash to NVRAM_TMP_PATH
 * @return	0 on success and errorno on failure     
 */
int nvram_load(void);


/*
 * Write data from NVRAM_TMP_PATH to flash   
 * @return	0 on success and errorno on failure     
 */
int nvram_commit(void);

/*
 * Get the value of an NVRAM variable: value is traced, value must not be free
 * @param	name	name of variable to get
 * @return	value of variable or NULL if undefined
 */
char* nvram_get_func(const char *name,char *path);
#define nvram_get_def(name) nvram_get_func(name,NVRAM_DEFAULT)
#define nvram_bcm_get(name) nvram_get_func(name,NVRAM_BCM_PATH)
char* nvram_get(const char *name);
#define nvram_safe_get(msg) (nvram_get(msg)?:"")
#define nvram_bcm_safe_get(msg) (nvram_bcm_get(msg)?:"")

/*
 * Get the reentrant value of an NVRAM variable: value is not traced, the caller must free the value manually
 * @param	name	name of variable to get
 * @return	value of variable or NULL if undefined
 */
char* nvram_get_func_r(const char *name,char *path);
char* nvram_get_r(const char *name);
char* nvram_bcm_get_r(const char *name);
#define nvram_safe_get_r(name) (nvram_get_r(name)?:strdup(""))
#define nvram_bcm_safe_get_r(name) (nvram_bcm_get_r(name)?:strdup(""))

/*
 * Match an NVRAM variable
 * @param	name	name of variable to match
 * @param	match	value to compare against value of variable
 * @return	TRUE if variable is defined and its value is string equal to match or FALSE otherwise
 */
static inline int nvram_match(char *name, char *match) {
	const char *value = nvram_get(name);
	return (value && !strcmp(value, match));
}

/*
 * IN_Match an NVRAM variable
 * @param	name	name of variable to match
 * @param	match	value to compare against value of variable
 * @return	TRUE if variable is defined and its value is not string equal to invmatch or FALSE otherwise
 */
static inline int nvram_invmatch(char *name, char *invmatch) {
	const char *value = nvram_get(name);
	return (value && strcmp(value, invmatch));
}

/*
 * Set the value of an NVRAM variable
 * @param	name	name of variable to set
 * @param	value	value of variable
 * @return	0 on success and errorno on failure
 * NOTE: use nvram_commit to commit this change to flash.
 */
int nvram_set(const char* name,const char* value);
int nvram_bcm_set(const char* name,const char* value);

/*
 * Unset an NVRAM variable
 * @param	name	name of variable to unset
 * @return	0 on success and errorno on failure
 * NOTE: use nvram_commit to commit this change to flash.
 */
int nvram_unset(const char* name);
int nvram_bcm_unset(const char* name);

/*
 * Reset NVRAM to default variables: copy NVRAM_DEFAULT to NVRAM_TMP_PATH (destroying previous NVRAM_TMP_PATH content)
 * @return	0 on success and errorno on failure
 * NOTE: use nvram_commit to commit this change to flash.
 */
int nvram_reset(void);

/*
 * Show NVRAM path variables in list order: name=value\nname=value\n... ...name=value\n
 * @param	path	nvram file path to show
 * @return	0 on success and errorno on failure
 */
int nvram_show(char* path);
#define nvram_tmp_show() nvram_show(NVRAM_TMP_PATH)
#define nvram_def_show() nvram_show(NVRAM_DEFAULT)
#define nvram_bcm_show() nvram_show(NVRAM_BCM_PATH)

/*
 * Find an NVRAM (sub)variable
 * @param	name	name of variable containing (sub)vars
 * @param	match	(sub)value to compare against (sub)values of variable
 * @return	TRUE if variable is defined and one of its (sub)values is string equal to find or FALSE otherwise
 */
int nvram_sub_find(const char *name, const char *find);

/*
 * Append the (sub)value of an NVRAM variable at the end ( name=foo1\1foo2\1foo3\0 --> name=foo1\1foo2\1foo3\1value\0 )
 * The same behaviour of "/usr/sbin/nvram add" with safe initialization of variable in case of void value/not present and duplicate check.
 * Act as nvram_set if no previous variables are present.
 * If (sub)value to be appended is already present move it as last.
 * @param	name	name of variable to set
 * @param	value	subvalue of variable
 * @return	0 on success and errorno on failure
 * NOTE: use nvram_commit to commit this change to flash.
 */
int nvram_append(const char* name,const char* value);

/*
 * Delete the (sub)value of an NVRAM variable ( name=foo1\1foo2\1value\1foo3\0 --> name=foo1\1foo2\1foo3\0 )
 * Act as nvram_set of void variable if only one (sub)value is present.
 * @param	name	name of variable to set
 * @param	value	subvalue of variable
 * @return	0 on success and errorno on failure
 * NOTE: use nvram_commit to commit this change to flash.
 */
int nvram_delete(const char* name,const char* value);

/*
 * Insert the (sub)value of an NVRAM variable at the beginning ( name=foo1\1foo2\1foo3\0 --> name=value\1foo1\1foo2\1foo3\0 )
 * Act as nvram_set if no previous variables are present.
 * If (sub)value to be inserted is already present move as first.
 * @param	name	name of variable to set
 * @param	value	subvalue of variable
 * @return	0 on success and errorno on failure
 * NOTE: use nvram_commit to commit this change to flash.
 */
int nvram_insert(const char* name,const char* value);

/*
 * Change the old (sub)value of an NVRAM variable with a new (sub)value ( name=foo1\1foo2\1old\1foo3\0 --> name=foo1\1foo2\1new\1foo3\0 )
 * If oldval and newval (sub)values are equal leave variable content unchanged.
 * If oldval (sub)value to be changed is missed leave variable content unchanged.
 * If newval (sub)value is already present change will be done as expected and the other newval duplicate removed.
 * @param	name	name of variable to set
 * @param	oldval  old subvalue to delete
 * @param	newval	new subvalue to add
 * @return	0 on success and errorno on failure
 * NOTE: use nvram_commit to commit this change to flash.
 */
int nvram_change(const char* name,const char* oldval,const char* newval);

/*
	get or set the value of a key
*/
int nv_set(const char* category, const char* key, int key_idx, const char* value);
int nv_setFX(const char* category, const char* key, int key_idx, const char *value_format, ...);

char* nv_get(const char* category, const char* key, int key_idx);
char* nv_get_r(const char* category, const char* key, int key_idx);
/*
	get or set the value of a key as an integer
*/
int nv_set_int(const char* category, const char* key, int key_idx, int value);
int nv_get_int(const char* category, const char* key, int key_idx);

#endif
