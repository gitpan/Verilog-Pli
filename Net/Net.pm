# Verilog::Pli::Net - Verilog PLI - %NET tied hash
# $Id: Net.pm,v 1.17 2005/05/05 20:18:40 wsnyder Exp $
# Author: Wilson Snyder <wsnyder@wsnyder.org>
######################################################################
#
# Copyright 1998-2005 by Wilson Snyder.  This program is free software;
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

Signal names may have a leading %b: %d: %x: or %s: to return or set the
value in the binary, decimal, hex, or string format respectively.  Values
may have a leading 0b or 0x to set the value in binary or hex format
respectively.

=over 4

=item scope

Read or change the default scope used when a signal is not found with the
name passed.  Note you need to pass the class, use the tied function to
convert from the tied hash to the class name.

=back

=head1 DISTRIBUTION

The latest version is available from CPAN or L<http://www.veripool.com/>.

Copyright 1998-2005 by Wilson Snyder.  This package is free software; you
can redistribute it and/or modify it under the terms of either the GNU
Lesser General Public License or the Perl Artistic License.

=head1 AUTHORS

Wilson Snyder <wsnyder@wsnyder.org>

=head1 SEE ALSO

L<Verilog::Pli>

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

$VERSION = '1.702';

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
