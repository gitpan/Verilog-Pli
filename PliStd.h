#ifndef _PLISTD_H
#define _PLISTD_H

/***********************************************************************/
/* Verilog PLI: */
#include <acc_user.h>
#include <vcsuser.h>

/***********************************************************************/
/* Perl */
#define HAS_BOOL
#define _STDARG_H
#define _VARARGS_H
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/***********************************************************************/
/* Typedefs */

typedef char VlThing_t;

/***********************************************************************/
/* Prototypes */

extern int pli_debug_level;

extern char *safestrdup (const char *src);

/***********************************************************************/
#endif /*_PLISTD_H*/
