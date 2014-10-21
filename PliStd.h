#ifndef _PLISTD_H
#define _PLISTD_H

/* $Id: PliStd.h,v 1.10 2001/02/09 15:43:51 wsnyder Exp $ */
/* DESCRIPTION: Header to include PLI headers needed by the .xs routines  */
/***********************************************************************/
/* Verilog PLI: */

/* Avoid constants, they make a typemap mess */
#define PLI_CONST 

#include <stdarg.h>
#define _VARARGS_H	/* Stdarg conflicts! */
#ifdef bool
# undef bool	/* Redefined by VCS (none of their business IMHO.) */
#endif

#ifdef vmc
#include <vmc_pli.h>
#endif
#ifdef pcli
#include <pcli_pli.h>
#endif

#include <acc_user.h>
#include <vcsuser.h>

/***********************************************************************/
/* Perl */

#ifndef __linux__
# define HAS_BOOL
#endif

#ifdef __linux__
# ifdef MIN
#  undef MIN
#  undef MAX
# endif
#endif

#define _STDARG_H
#define _VARARGS_H
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef PL_na
# define PL_sv_undef	sv_undef
# define PL_na		na
#endif

/***********************************************************************/
/* Typedefs */

typedef char VlThing_t;

/***********************************************************************/
/* Prototypes */

extern int pli_debug_level;

extern char *safestrdup (const char *src);

/***********************************************************************/
#endif /*_PLISTD_H*/
