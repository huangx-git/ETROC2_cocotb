/**
 *  File  : DELWRAPPER.v
 *  Author: Szymon Kulis (CERN)
 **/

`timescale 1ns / 1ps
`define SIM
module DELWRAPPER(
  input I,
  output Z
);
  // tmrg do_not_touch

`ifdef SIM
  assign #(0.1:0.15:0.28) Z = I;
`else
  DEL01 DL(.I(I), .Z(Z));
`endif


endmodule

