# Verilog::Pli::IO - Verilog PLI - I/O rerouting
# $Id: IO.pm,v 1.13 2004/01/27 19:11:43 wsnyder Exp $
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

Verilog::Pli::IO - Verilog PLI I/O rerouting

=head1 SYNOPSIS

  use Verilog::Pli::IO;

  tie(*VOUT,'Verilog::Pli::IO');
  print VOUT "This will go to screen and any sim logs.\n";
  Verilog::Pli::IO->tie_stdout();
  print "As will this.\n";
  printf STDERR "And %s", "this.\n";

=head1 DESCRIPTION

  This package allows a file to be outputted through the Verilog
PLI io_printf function, thus logging output on the screen as well as
in any log files.

=over 4

=item Verilog::Pli::IO::tie_stdout ()

  Connect STDOUT and STDERR to use the PLI printing handles.

=item PRINT
=item PRINTF

  Standard handle methods.

=back

=head1 SEE ALSO

C<Verilog::Pli>

=head1 DISTRIBUTION

The latest version is available from CPAN or
C<http://veripool.com/verilog-perl>.

=head1 AUTHORS

Wilson Snyder <wsnyder@wsnyder.org>

=cut
######################################################################

package Verilog::Pli::IO;

require Exporter;
require DynaLoader;
@ISA = qw(Exporter DynaLoader);

use strict;
use vars qw($VERSION);
use Verilog::Pli;

######################################################################
#### Configuration Section

$VERSION = '1.7';

######################################################################
#### Package

sub TIEHANDLE { my $class; bless \$class, shift; }

#sub WRITE {} # Verilog doesn't provide a write function, sorry.

sub PRINT {
    shift;
    Verilog::Pli::io_printf ("%s", join("",@_));
}

sub PRINTF {
    shift;
    my $fmt = shift;
    Verilog::Pli::io_printf ("%s", sprintf($fmt, @_));
}

sub tie_stdout {
    tie(*STDOUT,'Verilog::Pli::IO');
    tie(*STDERR,'Verilog::Pli::IO');
}

######################################################################
#### Package return
1;
