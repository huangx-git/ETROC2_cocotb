`timescale 1ns/1ps
module DELWRAPPER_HTree(
  input I,
  output Z
);
  // tmrg do_not_touch

assign #(0.7:1:1.3) Z = I;

endmodule

