/* DESCRIPTION: Verilog::PLI: Example definition of C routine to call from within Verilog. */
/* This file ONLY is placed into the Public Domain, for any use, */
/* without warranty, 2003 by Wilson Snyder. */

int hello_verilog (void)
{
    io_printf ("Hello\n");
    return 0;
}
