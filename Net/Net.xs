#/* -*- Mode: C -*- */

#include "PliStd.h"

typedef struct {
    char *scope;	/* Default scope for searching */
    handle net_handle;	/* Handle for keys() */
    handle mod_handle;	/* Handle for keys() */
} VlNetTie_t;

handle net_defaulted_handle (VlNetTie_t *nt, char *net)
{
    handle net_handle;

    acc_initialize ();
    acc_configure (accDisplayWarnings, "false");
    acc_configure (accDisplayErrors, "false");
    net_handle = acc_handle_object (net);
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

char *safestrdup (const char *src)
{
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
    static s_setval_delay accdelay = {{accRealTime},accNoDelay};
    static s_setval_value accvalue = {accDecStrVal};
    handle net_handle = net_defaulted_handle (nt,net);
    if (items > 3) {
	logen = SvIV(ST(3));
    }
    RETVAL = 0;
    if (net_handle) {
	acc_initialize ();
	acc_configure (accDisplayWarnings, "true");

	accvalue.value.str = value;
	acc_set_value (net_handle, &accvalue, &accdelay);
	if (!acc_error_flag) {
	    RETVAL = TRUE;
	    if (logen || pli_debug_level>=8) {
		pli_info (0, "%-25s set to: %10s\n",
			  acc_fetch_name (net_handle),
			  acc_fetch_value (net_handle, "%d"));
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
    handle net_handle = net_defaulted_handle (nt, net);
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
    handle net_handle = net_defaulted_handle (nt,net);
    ST(0) = sv_newmortal();
    if (net_handle != NULL) {
	char *val = acc_fetch_value (net_handle, "%d");
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
    static regs[3] = {accRegister, accIntegerVar, 0};
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
    static regs[3] = {accRegister, accIntegerVar, 0};
    ST(0) = sv_newmortal();
    if (nt->net_handle) {
	nt->net_handle = acc_next (regs, nt->mod_handle, nt->net_handle);
	if (nt->net_handle) {
	    sv_setpv (ST(0), acc_fetch_name (nt->net_handle));
	}
    }
}

