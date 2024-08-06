`timescale 1ps / 1ps
`include "commonDefinition.v"
module DELWRAPPER(
  input I,
  output Z
);
// tmrg do_not_touch
// tmrg do_not_triplicate DL

`ifndef SYNTHESIS
  assign #(700:1000:1300) Z = I;
`else
  DEL1 DL(.I(I), .Z(Z));
`endif


endmodule
