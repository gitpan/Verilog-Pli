#/* -*- Mode: C -*- */
#/* $Id: Pli.xs,v 1.15 2004/01/27 19:11:43 wsnyder Exp $ */
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

