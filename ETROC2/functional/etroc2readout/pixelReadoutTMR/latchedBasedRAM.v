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

`ifdef CW_MEM1
    wire rst_n;
    wire cs_n;
    wire wr_n;
    wire [log_depth-1:0] rd_addr;
    wire [log_depth-1:0] wr_addr;
    wire [data_width-1:0] data_in;
    wire [data_width-1:0] data_out;

    CW_ram_r_w_a_lat #(.data_width(data_width),.depth(depth),.rst_mode(1)) CW_ram_r_w_a_lat_inst
    (
        .rst_n(rst_n),
        .cs_n(cs_n), 
        .wr_n(wr_n), 
        .rd_addr(rd_addr), 
        .wr_addr(wr_addr), 
        .data_in(data_in), 
        .data_out(data_out)        
    );

    assign cs_n = 1'b0; //use wr_n control write operation only
    assign rst_n = 1'b1; //not reset mode, it is useless.
i
    assign wr_n = ~CLKB;

    assign wr_addr = AB;
    assign data_in = DB;

    assign rd_addr = AA;
    reg [data_width-1:0] iQ;
    always @(posedge CLKA)
    begin
        if(!CENA)
        begin
            iQ <= data_out;
        end
    end
    assign QA = iQ;
`elsif ICG_LMEM ////////////////////////////////
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
`ifdef pixelTMR
    gateClockCellTMR gateWrInst 
`else
    gateClockCell gateWrInst 
`endif
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

`else ////////////////////////////////////////////
  reg [data_width-1:0] iQ;
  reg [data_width-1:0] mem [0:depth-1];

  `ifdef INITIALIZE_MEMORY
    integer i;
    initial 
      for (i = 0; i < depth; i = i + 1)
        mem[i] = {data_width{1'b0}};
  `endif
// output latch bank
//  always @(*)
//    if (CLKA)
//      if (!CENA)
//        iQ <= mem[AA];
// output flop bank
  always @(posedge CLKA)
    if(!CENA)
      iQ <= mem[AA];
//
  assign QA = iQ;

  always @(*)
    if (CLKB)
      if (!CENB)
        mem[AB] <= DB;

`endif

endmodule

