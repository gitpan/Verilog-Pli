#include <EXTERN.h>               /* from the Perl distribution */
#include <perl.h>                 /* from the Perl distribution */

static PerlInterpreter *cmd_perl=NULL;  /* The Perl interpreter */

void perl_boot (void)
{
    char *args[] = { "perl", "-e", "exit;" };

    /* Start perl */
    cmd_perl = perl_alloc();
    perl_construct (cmd_perl);
    perl_parse (cmd_perl, xs_init, 3, args, (char **)NULL);

    /* Bootstrap some initial code */
    perl_eval_pv ("require 'some_boot_script.pl';", TRUE);
}
