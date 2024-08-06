//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Mon Mar  1 00:16:56 CST 2021
// Module Name: commonDefinition
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////

module b2g #(
  parameter   N = 9
) (
  output  [N-1:0]   g,
  input   [N-1:0]   b
);
 
  assign g = b ^ (b >> 1);
 
endmodule

module g2b #(
  parameter   N = 9
) (
  output  [N-1:0]   b,
  input   [N-1:0]   g
);
  generate genvar i;
    for (i=0; i<N; i=i+1) begin : gen_bin
      assign b[i] = ^g[N-1:i];
    end
  endgenerate
 
endmodule