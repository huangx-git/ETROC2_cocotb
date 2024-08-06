`timescale 1ps/100fs
`define SIM
module pulseGenerator_DELWRAPPER(
  input I,
  output Z
);
  // tmrg do_not_touch

`ifdef SIM
  assign #(700:1000:1300) Z = I;
`else
  DEL1 DL(.I(I), .Z(Z));
`endif


endmodule
