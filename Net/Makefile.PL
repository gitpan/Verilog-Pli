# DESCRIPTION: Perl ExtUtils: Automatically called by upper Makefile.PL
#
# Copyright 1998-2005 by Wilson Snyder.  This program is free software;
# you can redistribute it and/or modify it under the terms of either the GNU
# General Public License or the Perl Artistic License.

use Verilog::Pli::MMutil;

Verilog::Pli::MMutil::WriteMakefile
    (
     VERSION_FROM => 'Net.pm',
     NAME => "Verilog::Pli::Net",
     );
