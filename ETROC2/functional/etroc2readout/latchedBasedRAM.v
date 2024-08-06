`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Mon Jul  5 15:44:08 CDT 2021
// Module Name: latchedBasedRAM
// Project Name: ETROC2 readout
// Description: 
// Dependencies: CW_ram_r_w_a_lat
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"

// `ifndef LATCHEDBASEDRAM
// `define LATCHEDBASEDRAM
module latchedBasedRAM #(parameter data_width = 16, depth = 256, log_depth = 8, delay = 4)
(
    output [data_width-1:0] QA,
    input  CLKA,
    input  CENA,
    input [log_depth-1:0] AA,
    input  CLKB,
    input  CENB,
    input [log_depth-1:0] AB,
    input [data_width-1:0] DB,
    input [2:0] EMAA,
    input [2:0] EMAB,
    input  RET1N,
    input  COLLDISN //
);
// tmrg do_not_touch

// `ifdef ICG_LMEM ////////////////////////////////
  reg [data_width-1:0] iQ;
  reg [data_width-1:0] mem [0:depth-1];
  wire [depth-1:0] gatedWrClk;

  `ifdef INITIALIZE_MEMORY
    integer i;
    initial 
      for (i = 0; i < depth; i = i + 1)
        mem[i] = {data_width{1'b0}};
  `endif

  always @(posedge CLKA)
    if(!CENA)
      iQ <= mem[AA];
//
  assign QA = iQ;

  genvar j;
  generate
  for(j=0; j<depth; j=j+1) begin
// `ifdef pixelTMR
//     gateClockCellTMR gateWrInst 
// `else
    gateClockCell gateWrInst 
// `endif
        (
          .clk(CLKB),
          .gate((!CENB) & (AB==j)),
          .enableGate(1'b1),
          .gatedClk(gatedWrClk[j])
          );

    always @(*)
      if (gatedWrClk[j])
        mem[j] <= DB;
  end
  endgenerate

// `else ////////////////////////////////////////////
  // reg [data_width-1:0] iQ;
  // reg [data_width-1:0] mem [0:depth-1];

  // `ifdef INITIALIZE_MEMORY
  //   integer i;
  //   initial 
  //     for (i = 0; i < depth; i = i + 1)
  //       mem[i] = {data_width{1'b0}};
  // `endif
// output latch bank
//  always @(*)
//    if (CLKA)
//      if (!CENA)
//        iQ <= mem[AA];
// output flop bank
//   always @(posedge CLKA)
//     if(!CENA)
//       iQ <= mem[AA];
// //
//   assign QA = iQ;

//   always @(*)
//     if (CLKB)
//       if (!CENB)
//         mem[AB] <= DB;

// `endif

endmodule
// `endif