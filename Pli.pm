# Verilog::Pli - Verilog PLI
# $Id: Pli.pm,v 1.17 2004/01/27 19:11:43 wsnyder Exp $
# Author: Wilson Snyder <wsnyder@wsnyder.org>
######################################################################
#
# Copyright 1998-2004 by Wilson Snyder.  This program is free software;
# you can redistribute it and/or modify it under the terms of either the GNU
# General Public License or the Perl Artistic License.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
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

=over 4

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

=back

=head1 SEE ALSO

C<Verilog::Pli::IO>, C<Verilog::Pli::Net>

=head1 DISTRIBUTION

The latest version is available from CPAN or
C<http://veripool.com/verilog-perl>.

=head1 AUTHORS

Wilson Snyder <wsnyder@wsnyder.org>

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

$VERSION = '1.7';

bootstrap Verilog::Pli;

######################################################################
#### Package return
1;
