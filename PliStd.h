#ifndef _PLISTD_H
#define _PLISTD_H

/***********************************************************************/
/* Verilog PLI: */

#ifdef __linux__
# include <stdarg.h>
# define _VARARGS_H	/* Stdarg conflicts! */
# ifdef bool
#  undef bool	/* Redefined by VCS (none of their business IMHO.) */
# endif
#endif

#include <acc_user.h>
#include <vcsuser.h>

/***********************************************************************/
/* Perl */

#ifndef __linux__
# define HAS_BOOL
#endif

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
