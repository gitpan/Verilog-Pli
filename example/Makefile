#
# Example of trivial PLI use in VCS.
#

# This section may need tuning

# Path to VCS
VCS = $(VCS_HOME)/bin/vcs
CFLAGS += -I$(VCS_HOME)/sun_sparc_solaris_5.4/lib \
	-I$(VCS_HOME)/sun_sparc_solaris_5.5.1/lib

# Which compiler
CC = gcc

# Use this command to get the libraries to put here:
#	perl -MExtUtils::Embed -e ldopts
# We should be able to use a rule like:
# PERL_OPTS = $(shell perl -MExtUtils::Embed -e ldopts)
# But VCS has a brain damaged linker specification.
# Also note we cheat and statically link in the dynamic Verilog library
# this is not strictly needed, but makes packaging simpler
PERL_OPTS = \
	/usr/local/lib/perl5/5.00503/sun4-solaris/auto/DynaLoader/DynaLoader.a \
	/usr/local/lib/perl5/5.00503/sun4-solaris/CORE/libperl.a \
	-lsocket -lnsl -ldl -lm -lc -lcrypt

#	../blib/arch/auto/Verilog/Pli/Pli.so \

VERILOG_TOP_FILE = hello.v

######################################################################

MODEL = simv

CLI_OPTS = +cli
CFLAGS += `perl -MExtUtils::Embed -e ccopts`
# Below is needed only for solaris 5.6's GCC and newer:
PLI_LINK_FLAGS += -Wl,-export-dynamic
PLI_SRC_FILES = pli_hello.c cmd.c perlxsi.c
PLI_TABLE = pli.tab

all:	run

$(MODEL):	$(VERILOG_TOP_FILE) $(PLI_SRC_FILES) $(PLI_TABLE)
	$(VCS) -ld "$(CC) $(PLI_LINK_FLAGS)" -cc $(CC) $(CLI_OPTS) -CFLAGS "$(CFLAGS)" \
		$(VERILOG_TOP_FILE) -P $(PLI_TABLE) $(PLI_SRC_FILES) \
		-Mupdate $(PERL_OPTS) -o $(MODEL)

run:	$(MODEL)
	$(MODEL)

perlxsi.c:
	perl -MExtUtils::Embed -e xsinit -- -o perlxsi.c

clean::
	rm -f -r $(MODEL) *.o *.daidir perlxsi.c csrc
