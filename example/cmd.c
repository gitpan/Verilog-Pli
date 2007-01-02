/* $Id: cmd.c 36 2007-01-02 15:24:59Z wsnyder $ */
/* Author: Wilson Snyder <wsnyder@wsnyder.org> */
/***********************************************************************
 *
 * Copyright 1998-2007 by Wilson Snyder.  This program is free software;
 * you can redistribute it and/or modify it under the terms of either the GNU
 * General Public License or the Perl Artistic License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 **********************************************************************
 * DESCRIPTION: Verilog::PLI: Example C PLI code that calls perl
 **********************************************************************/

#include <stdarg.h>

/***********************************************************************/
/* Verilog PLI: */
#include <acc_user.h>
#include <vcsuser.h>

/***********************************************************************/
/* Perl */
#define HAS_BOOL		/* Also defined in pli headers, so skip in perl */
#include <EXTERN.h>             /* from the Perl distribution */
#include <perl.h>               /* from the Perl distribution */

#if !defined(PL_na) && defined(na)
# define PL_sv_undef	sv_undef
# define PL_na		na
#endif

/***********************************************************************/
/* Values */

#define CMD_MAX_LINE_LEN 10000	/* Maximum command length */

/* The Verilog::Pli module looks for this: */
int pli_debug_level = 0;	/* Debugging */

/***********************************************************************/
/***********************************************************************/
/***********************************************************************/
/***********************************************************************/
/***********************************************************************/
/* Code */

void xs_init _((void));

static PerlInterpreter *cmd_perl=NULL;  /* The Perl interpreter */

void pli_debug (int level)
    /* Set debugging level */
{
    pli_debug_level = level;
    io_printf ("dbg = %d\n", level);
}

void pli_debug_pli (void)
    /* Called from pli on $pli_debug */
    /* Set debugging level */
{
    int level = tf_getp(1);
    pli_debug (level);
}

void cmd_boot_pli (void)
    /* Called from pli on $cmd_boot */
    /* Initialize the perl interpreter */
{
    char *args[] = { "perl", "-e", "exit;" };

    /* Start perl */
    if (pli_debug_level) io_printf ("Starting perl interpreter\n");
    cmd_perl = perl_alloc();
    perl_construct (cmd_perl);
    perl_parse (cmd_perl, xs_init, 3, args, (char **)NULL);

    /* Bootstrap some initial code */
    perl_eval_pv ("require 'simperl_boot.pl';", TRUE);
}

char *cmd (
    const char *linein,
    const char *filenameline
    )
    /* Parse a generic string in perl, and return the result as a string */
{
    static char *resp="";
    SV *val;	
  
    /* Fast case */
    if (linein==NULL || !*linein || *linein == '#') return("");

    if (pli_debug_level) io_printf ("$cmd(%s)\n", linein);

    val = perl_eval_pv ((char *)linein, TRUE);
    resp = SvPV (val, PL_na);

    return (resp);
}

static char *cmd_guts (const char *filenameline)
    /* Take a list of arguments from a PLI call and call cmd() on it */
{
    int param;
    char line[CMD_MAX_LINE_LEN]="";	/* Should change to strdup for real programs */
    char *resp = "";
    s_tfexprinfo info;
    
    for (param=1; param<=tf_nump(); param++) {
	tf_exprinfo (param, &info);
	if (info.expr_type==TF_STRING) {
	    char *cp = (char *)tf_getp(param);
	    strcat (line, cp);
	} else if (info.expr_vec_size > 64) {	/* assume string */
	    char *cp = tf_getcstringp (param);
	    strcat (line, cp);
	} else {
	    int v = tf_getp(param);
	    sprintf (line+strlen(line), "%d", v);
	}
    }

    if (*line) {
	resp = cmd (line, filenameline);
    }
    return (resp);
}

void cmd_pli (void)
    /* Called from pli on $cmd(...) */
{
    cmd_guts (tf_mipname());
}

void cmdval_pli (void)
    /* Called from pli on $cmdval(...) */
{
    char *resp;
    resp = cmd_guts (tf_mipname());
    tf_putp (0, atoi(resp));
}
