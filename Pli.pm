# Verilog::Pli - Verilog PLI
# $Id: Pli.pm,v 1.6 1999/06/02 17:30:22 wsnyder Exp $
# Author: Wilson Snyder <wsnyder@ultranet.com>
######################################################################
#
# This package provides PLI access routines
# 
# This program is Copyright 1998 by Wilson Snyder.
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# If you do not have a copy of the GNU General Public License write to
# the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, 
# MA 02139, USA.
######################################################################

=head1 NAME

Verilog::Pli - Verilog PLI routine calls

=head1 SYNOPSIS

  use Verilog::Pli;


=head1 DESCRIPTION

  This package allows access to Verilog PLI routines from perl.
See the Verilog PLI Reference Manual for more information on these
functions.

  This package has only been tested with VCS.  It should work with other
simulators, though different header files may need to be included.

=over 

=item mc_scan_plusargs (switch)
  Return string if switch is set on command line.

=item Verilog::Pli::io_printf (format, arg1)
  Print a string using Verilog I/O.  Try to use C<Verilog::Pli::IO>
instead of this routine.

=item tf_dofinish
  Finish the simulation.

=item tf_dostop
  Stop the simulation.

=item tf_gettime
  Return simulation time.

=item tf_igettime
  Return simulation time for the passed instance.

=item tf_getinstance
  Return the current instance.

=over 

=head1 SEE ALSO

C<Verilog::Pli::IO>, C<Verilog::Pli::Net>

=head1 DISTRIBUTION

The latest version is available from CPAN or
C<http://www.ultranet.com/~wsnyder/verilog-perl>.

=head1 AUTHORS

Wilson Snyder <wsnyder@ultranet.com>

=cut

package Verilog::Pli;

require Exporter;
require DynaLoader;
@ISA = qw(Exporter DynaLoader);
@EXPORT = qw( mc_scan_plusargs
	      tf_dofinish tf_dostop tf_gettime tf_igettime tf_getinstance );

use strict;
use vars qw($VERSION);

######################################################################
#### Configuration Section

$VERSION = "1.1";

bootstrap Verilog::Pli;

######################################################################
#### Package return
1;
