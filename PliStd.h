#ifndef _PLISTD_H
#define _PLISTD_H

/* $Id: PliStd.h 36 2007-01-02 15:24:59Z wsnyder $ */
/* DESCRIPTION: Header to include PLI headers needed by the .xs routines  */
/* */
/* Copyright 1998-2007 by Wilson Snyder.  This program is free software; */
/* you can redistribute it and/or modify it under the terms of either the GNU */
/* General Public License or the Perl Artistic License. */
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
#include <veriuser.h>

/***********************************************************************/
/* Perl */

#define HAS_BOOL

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

#if !defined(PL_na) && (PERL_API_REVISION < 5)
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
