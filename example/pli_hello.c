// DESCRIPTION: Verilog::PLI: Example definition of C routine to call from within Verilog.

int hello_verilog (void)
{
    io_printf ("Hello\n");
    return 0;
}
