
BEGIN {
    printf "Hello from perl.... Booting...\n";
    printf "  If you get a 'Can't Locate...' change the use lib in\n";
    printf "  simperl_boot_script.pl\n";
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

print "Here's a list of signals under hello_top.v:\n";
tie %NET, 'Verilog::Pli::Net', 'hello_top';
foreach (keys %NET) {
    print "   Found signal $_\n";
}
print "\n";

sub print_w_value {
    print "w is: ", $NET{w}, "\n";
}

1;
