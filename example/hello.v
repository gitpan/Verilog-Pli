// DESCRIPTION: Verilog::PLI: Example Verilog code that will call perl

module hello_top;

   initial begin
      // Set debug level
      $pli_debug(0);	// Set to 7 for more verbosity
      // Setup the perl interpeter
      $cmd_boot;
   end

   // invoke user-defined pli routine
   initial $hello_verilog;	

   integer int;
   reg w;
   wire z = w;

   initial begin
      // You must wait some time (or #0) to make sure perl_boot is done!
      # 10;
      // $cmd can do any perl function
      // Each argument is concated together,
      // Numeric arguments (those <= 32 bits) are converted to numbers
      $cmd ("print 'This is inside perl, called on ', `date`, \"\\n\";");
      # 10;
      // $cmdv will return a value
      $display (" 1 + 2 = %x\n", $cmdval("1+2"));
      # 10;
      // Need a sparse array?  (Slow, so don't use in place of sparse C code!)
      $cmd ("$Sparse{", 230000, "}", "=", 32'hfeed);
      # 10;
      $display (" Sparse array [230000] = %x\n", $cmdval("$Sparse{230000}"));
      # 100;
      w = 1;
      $display ("waited 100 and then printed");
      $display ("z is %d", z);
      $display ("setting w = 0 using perl");
      $cmd ("$NET{w} = 0;");
      # 1;	// Need transport delay from w to z
      $display ("z is %d", z);
      
   end

endmodule
