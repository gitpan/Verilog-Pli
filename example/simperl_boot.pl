# $Id: simperl_boot.pl,v 1.5 2003/07/22 15:39:01 wsnyder Exp $
# DESCRIPTION: Verilog::PLI: Example perl code booted in verilog initial block
######################################################################

use Test;  BEGIN { plan tests => 11 }

BEGIN {
    printf "Hello from perl.... Booting...\n";
    printf "  If you get a 'Can't Locate...' change the use lib in\n";
    printf "  simperl_boot.pl\n";
}

# This needs to point to where Verilog::Pli lives
# If it is installed globably it doesn't matter.
use lib '..';
use lib '../blib/lib';
use lib '../blib/arch';
		
use Verilog::Pli;
use Verilog::Pli::Net;
use Verilog::Pli::IO;

# Make sure STDOUT goes through verilog I/O calls so ends up in sim.log
Verilog::Pli::IO->tie_stdout();

print "PERL PROGRAM RAN!\n";
ok(1);

print "Here's a list of signals under hello_top.v:\n";
tie %NET, 'Verilog::Pli::Net', 'hello_top';
foreach (keys %NET) {
    print "   Found signal $_\n";
}
print "\n";

# Test out the format specifiers
ok (exists $NET{int});
ok (exists $NET{'%x:int'});
$NET{'%b:int'} = 10; ok ($NET{int}==2);
$NET{'%x:int'} = 10; ok ($NET{int}==16);
$NET{'%h:int'} = 10; ok ($NET{int}==16);
$NET{'%d:int'} = 10; ok ($NET{int}==10);
$NET{int} = 10; ok ($NET{'%b:int'}==1010);
$NET{int} = 10; ok ($NET{'%d:int'}==10);
$NET{int} = '0x10'; ok ($NET{int}==16);
$NET{int} = '0b10'; ok ($NET{int}==2);

1;
