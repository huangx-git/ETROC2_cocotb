//Verilog-AMS HDL for "ETROC2_IO", "GPDIO" "verilogams"

`timescale 1ns/1ps
module GPDIO ( padOut, pad, vdd, vdd_IO, vss, vss_IO, ds, en, padIn, pe, ud
);

  inout pad;		// IO, PAD
  output padOut;	// Z_h, schmitt output
  input pe;		// PEN, pullup/pulldown enable
  input ds;		// DS, driving strength
  input ud;		// UD, pull UP(1)/DOWN(0)
  inout vss_IO;
  inout vdd_IO;
  input padIn;	// A, CMOS input(to be outputted)
  input en;		// OUT_EN, output enable
  inout vdd;
  inout vss;

  wire error=ds ^ en ^ pe ^ ud ^ padIn;
  assign pad = (en)?padIn:1'bz;
//  assign Z=(error===1'bx)?1'bx:IO;
  assign padOut=(error===1'bx)?1'bx:pad;

endmodule
