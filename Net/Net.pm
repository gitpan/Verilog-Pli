# Verilog::Pli::Net - Verilog PLI - %NET tied hash
# $Id: Net.pm,v 1.4 2000/01/21 15:15:44 wsnyder Exp $
# Author: Wilson Snyder <wsnyder@world.std.com>
######################################################################
#
# This program is Copyright 2000 by Wilson Snyder.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of either the GNU General Public License or the
# Perl Artistic License, with the exception that it cannot be placed
# on a CD-ROM or similar media for commercial distribution without the
# prior approval of the author.
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

Verilog::Pli::Net - Verilog PLI tied net access hash

=head1 SYNOPSIS

  use Verilog::Pli::Net;

  $NET{"hier.signal"} = 1;
  print "Signal now is ", $NET{"hier.signal"};
  foreach (keys %NET) { print "Found signal $_\n"; }
  (exists $NET{"bad"}) or die "Net 'bad' doesn't exist.";

  tie %PLINET, 'Verilog::Pli::Net', 'top.hier.submod.pli;
  print "top.hier.submod.pli.something = ", $PLINET{"something"}, "\n";

=head1 DESCRIPTION

  This package creates a tied hash %NET, that fetching from or storing to
affects the Verilog signal named the same as the hash key.  The hiearchy
may be placed in front of the signal names using standard dot notation, or
if not found, the scope from when the tie was established, or later scope()
calls is prepended to the passed signal name.

=over 4

=item scope

  Read or change the default scope used when a signal is not found with the
name passed.  Note you need to pass the class, use the tied function to
convert from the tied hash to the class name.

=back

=head1 SEE ALSO

C<Verilog::Pli>

=head1 DISTRIBUTION

The latest version is available from CPAN or
C<http://www.ultranet.com/~wsnyder/verilog-perl>.

=head1 AUTHORS

Wilson Snyder <wsnyder@world.std.com>

=cut
######################################################################

package Verilog::Pli::Net;

require Exporter;
require DynaLoader;
@ISA = qw(Exporter DynaLoader);
@EXPORT = qw(%NET);

use strict;
use vars qw($VERSION %NET $Scope);
use Carp;
use Verilog::Pli;

######################################################################
#### Configuration Section

$VERSION = '1.3';

bootstrap Verilog::Pli::Net;

tie %NET, 'Verilog::Pli::Net', "";

######################################################################
#### Implementation

sub CLEAR    {}
#sub TIEHASH	-- in C code
#sub DELETE	-- in C code
#sub STORE	-- in C code
#sub FETCH	-- in C code
#sub FIRSTKEY	-- in C code
#sub NEXTKEY	-- in C code
#sub EXISTS	-- in C code
#sub scope 	-- in C code

######################################################################
#### Package return
1;
