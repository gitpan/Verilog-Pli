#/* -*- Mode: C -*- */
#/* $Id: Net.xs,v 1.13 2004/01/27 19:11:43 wsnyder Exp $ */
#/* Author: Wilson Snyder <wsnyder@wsnyder.org> */
#/*##################################################################### */
#/* */
#/* Copyright 1998-2004 by Wilson Snyder.  This program is free software; */
#/* you can redistribute it and/or modify it under the terms of either the GNU */
#/* General Public License or the Perl Artistic License. */
#/*  */
#/* This program is distributed in the hope that it will be useful, */
#/* but WITHOUT ANY WARRANTY; without even the implied warranty of */
#/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the */
#/* GNU General Public License for more details. */
#/*  */
#/*##################################################################### */

#include "PliStd.h"
#include <ctype.h>

typedef struct {
    char *scope;	/* Default scope for searching */
    handle net_handle;	/* Handle for keys() */
    handle mod_handle;	/* Handle for keys() */
} VlNetTie_t;

const char* format_char(int format) {
    switch (format) {
    case accDecStrVal: return "%d";
    case accHexStrVal: return "%x";
    case accBinStrVal: return "%b";
    case accStringVal: return "%s";
    default:	       return "%d";
    }
}

handle net_defaulted_handle (VlNetTie_t *nt, const char *net, int* formatp) {
    handle net_handle;

    /* Strip and decode any format prefix */
    if (formatp) *formatp = accDecStrVal;
    if (strlen(net) > 3) {
	if ((net[0] == '%') && (net[2] == ':')) {
	    switch (tolower(net[1])) {
	    case 'd': if (formatp) { *formatp = accDecStrVal; } break;
	    case 'x': if (formatp) { *formatp = accHexStrVal; } break;
	    case 'h': if (formatp) { *formatp = accHexStrVal; } break;
	    case 'b': if (formatp) { *formatp = accBinStrVal; } break;
	    case 's': if (formatp) { *formatp = accStringVal; } break;
	    default:  if (formatp) { *formatp = accDecStrVal; } break;
	    }
	    /* Skip the format */
	    net += 3;
	}
    }
	    
    /* Look up the signal */
    acc_initialize ();
    acc_configure (accDisplayWarnings, "false");
    acc_configure (accDisplayErrors, "false");
    net_handle = acc_handle_object ((char*)net);
    /*printf ("net_defaulted_handle '%s'\n", net);*/
    if (acc_error_flag && nt->scope && nt->scope[0]) {
	char *fullnetname = safemalloc (strlen(net) + strlen(nt->scope) + 5);
	strcpy (fullnetname, nt->scope);
	strcat (fullnetname, ".");
	strcat (fullnetname, net);
	net_handle = acc_handle_object (fullnetname);
	/*printf ("net_defaulted_handle '%s'\n", fullnetname);*/
	safefree (fullnetname);
	if (acc_error_flag) net_handle = NULL;
    }
    return (net_handle);
}

char *safestrdup (const char *src) {
    char *dest;
    New (0, dest, strlen(src)+1, char);
    strcpy (dest, src);
    return (dest);
}

MODULE = Verilog::Pli::Net  PACKAGE = Verilog::Pli::Net

#/**********************************************************************/
#/* class->TIEHASH() */

VlNetTie_t *
TIEHASH (CLASS, scope)
char *CLASS
char *scope
PROTOTYPE: $$
CODE:
{
    VlNetTie_t *nt;
    /*printf ("TIEHASH %s sc'%s'\n", CLASS, scope);*/
    Newz (0, nt, 1, VlNetTie_t);
    nt->scope = safestrdup(scope);
    RETVAL = nt;
}
OUTPUT: RETVAL

#/**********************************************************************/
#/* class->TIEHASH() */

void
DELETE (nt)
VlNetTie_t *nt
PROTOTYPE: $
CODE:
    safefree (nt);

#/**********************************************************************/
#/* this->scope (value) -- read/set scope */
char *
scope (nt, ...)
VlNetTie_t *nt
PROTOTYPE: $;$
CODE:
{
    if (items > 1) {
	char *value = (char *)SvPV(ST(1),PL_na);
	safefree (nt->scope);
	nt->scope = safestrdup (value);
    }
    RETVAL = nt->scope;
}
OUTPUT: RETVAL

#/**********************************************************************/
#/* this->STORE (net, value, log) -- set signal to value */
int
STORE(nt, net, value, ...)
    VlNetTie_t *nt
    char *net
    char *value
CODE:
{
    int/*boolean*/ logen = FALSE;
    static char high_impedence[] = "z";
    static s_setval_delay accdelay = {{accRealTime},accNoDelay};
    static s_setval_value accvalue = {accDecStrVal};
    int format;
    handle net_handle = net_defaulted_handle (nt,net,&format);

    if (items > 3) {
	logen = SvIV(ST(3));
    }
    RETVAL = 0;

    if (net_handle) {
	acc_initialize ();
	acc_configure (accDisplayWarnings, "true");

        /* First determine the set flag */
        if (acc_fetch_type(net_handle) == accNet) {
	    if ((*value == 0) || (tolower(*value)=='z')) {
		/* Release the wire if the value is undefined or Z */
		accdelay.model = accReleaseFlag;
	    }
	    else {
		/* Force the wire otherwise */
		accdelay.model = accForceFlag;
	    }
        }
        else {
	    /* For registers, just use NoDelay */
	    accdelay.model = accNoDelay;
        }

        /* Now allow the value to override the key's data type */
	/* This allows users to specify $NET{reg} = "0xabcd", which is */
	/* more intuitive than $NET{"%x:reg"} = "abcd" */
        if ((value[0] == 0) || (tolower(value[0])=='z')) {
	    /* Make the register high impedence */
	    accvalue.format = accBinStrVal;
	    accvalue.value.str = high_impedence;
        }
        else if ((value[0] == '0') && (tolower(value[1])=='x')) {
	    /* Set the hex value */
	    accvalue.format = accHexStrVal;
	    accvalue.value.str = &value[2];
        }
        else if ((value[0] == '0') && (tolower(value[1])=='b')) {
	    /* Set the binary value */
	    accvalue.format = accBinStrVal;
	    accvalue.value.str = &value[2];
        }
        else {
	    /* Don't change the format type by default.  The key will define it */
	    accvalue.format = format;
	    accvalue.value.str = value;
        }

	acc_set_value (net_handle, &accvalue, &accdelay);
	if (!acc_error_flag) {
	    RETVAL = TRUE;
	    if (logen || pli_debug_level>=8) {
		pli_info (0, "%-25s set to: %10s\n",
			  acc_fetch_name (net_handle),
			  acc_fetch_value (net_handle, "%d", NULL));
	    }
	}
	acc_close ();
    }
}
OUTPUT: RETVAL

#/**********************************************************************/
#/* this->EXISTS (net) -- return true if net exists */
int
EXISTS(nt,net)
    VlNetTie_t *nt
    char *net
CODE:
{
    handle net_handle = net_defaulted_handle (nt, net, NULL);
    RETVAL = (net_handle!=NULL);
}
OUTPUT: RETVAL

#/**********************************************************************/
#/* this->FETCH (net) -- get value of net */
SV *
FETCH(nt,net)
    VlNetTie_t *nt
    char *net
CODE:
{
    int format;
    handle net_handle = net_defaulted_handle (nt,net,&format);
  
    ST(0) = sv_newmortal();
    if (net_handle != NULL) {
	char *val = acc_fetch_value (net_handle, (char*)format_char(format), NULL);
	if (val != NULL) {
	    while (*val == ' ') val++;	/* Else '  0' will return true */
	    sv_setpv (ST(0), val);
	}
    }
}

#/**********************************************************************/
#/* this->FIRSTKEY() -- tied hash -- return first key in list of nets */

SV *
FIRSTKEY(nt, ...)
    VlNetTie_t *nt
CODE:
{
    static regs[4] = {accRegister, accIntegerVar, accWire, 0};
    ST(0) = sv_newmortal();
    nt->net_handle = NULL;
    nt->mod_handle = acc_handle_object (nt->scope);
    if (nt->mod_handle) {
	nt->net_handle = acc_next (regs, nt->mod_handle, nt->net_handle);
	if (nt->net_handle) {
	    sv_setpv (ST(0), acc_fetch_name (nt->net_handle));
	}
    }
}

#/**********************************************************************/
#/* this->NEXTKEY (lastkey) -- Tied hash -- return next key in list of nets */
SV *
NEXTKEY(nt, ...)
    VlNetTie_t *nt
CODE:
{
    static regs[4] = {accRegister, accIntegerVar, accWire, 0};
    ST(0) = sv_newmortal();
    if (nt->net_handle) {
	nt->net_handle = acc_next (regs, nt->mod_handle, nt->net_handle);
	if (nt->net_handle) {
	    sv_setpv (ST(0), acc_fetch_name (nt->net_handle));
	}
    }
}

