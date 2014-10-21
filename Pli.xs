#/* -*- Mode: C -*- */
#/* $Id: Pli.xs,v 1.9 1999/10/25 19:25:50 wsnyder Exp $ */
#/* Author: Wilson Snyder <wsnyder@ultranet.com> */
#/*##################################################################### */
#/* */
#/* This program is Copyright 1998 by Wilson Snyder. */
#/* This program is free software; you can redistribute it and/or */
#/* modify it under the terms of the GNU General Public License */
#/* as published by the Free Software Foundation; either version 2 */
#/* of the License, or (at your option) any later version. */
#/*  */
#/* This program is distributed in the hope that it will be useful, */
#/* but WITHOUT ANY WARRANTY; without even the implied warranty of */
#/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the */
#/* GNU General Public License for more details. */
#/*  */
#/* If you do not have a copy of the GNU General Public License write to */
#/* the Free Software Foundation, Inc., 675 Mass Ave, Cambridge,  */
#/* MA 02139, USA. */
#/*##################################################################### */

#include "PliStd.h"

int pli_debug_level = 0;

MODULE = Verilog::Pli  PACKAGE = Verilog::Pli
PROTOTYPES: ENABLE

#/**********************************************************************/
#/* mc_scan_plusargs (switch) -- return string if set, undef if isn't */
SV *
mc_scan_plusargs(sw)
    char *sw
CODE:
{
    char *out;
    ST(0) = sv_newmortal();
    out = (mc_scan_plusargs (sw));
    if (out) {
	sv_setpv (ST(0), out);
    }
}

#/**********************************************************************/
#/* io_printf (format, ...) -- print to mcd files */
#/* FIX: non-variable argument list.  For now 1 arg, assuming Verilog::Pli::IO is used */
void
io_printf(format, arg1)
    char *format
    char *arg1

#/**********************************************************************/
#/* tf_dofinish -- call command finish */
void
tf_dofinish()

#/**********************************************************************/
#/* tf_dostop -- call command stop */
void
tf_dostop()

#/**********************************************************************/
#/* tf_gettime -- get the current simulation time as a integer */
int
tf_gettime()

#/**********************************************************************/
#/* tf_igettime -- get the current simulation time as a integer (from instance) */
int
tf_igettime(instance_p)
    VlThing_t * instance_p
CODE:
    RETVAL = tf_igettime(instance_p);
OUTPUT: RETVAL

#/**********************************************************************/
#/* tf_getinstance -- get the current instance */
VlThing_t *
tf_getinstance()
CODE:
    static char *CLASS = "Verilog::Pli::Instance";
    RETVAL = tf_getinstance();
OUTPUT: RETVAL

