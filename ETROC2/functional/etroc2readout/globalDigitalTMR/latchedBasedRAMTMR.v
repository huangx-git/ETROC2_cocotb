/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ./globalDigitalTMR/latchedBasedRAMTMR.v                                                *
 *                                                                                                  *
 * user    : dtgong                                                                                 *
 * host    : sphy7asic01.smu.edu                                                                    *
 * date    : 03/04/2022 15:30:08                                                                    *
 *                                                                                                  *
 * workdir : /users/dtgong/workarea/tsmc65/ETLROC/digital/ETROC2Readout/gitlab/etroc2readout        *
 * cmd     : ../../tmrg/tmrg/bin/tmrg -c tmrgGlobal.cnf                                             *
 * tmrg rev:                                                                                        *
 *                                                                                                  *
 * src file: latchedBasedRAM.v                                                                      *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2022-03-15 14:02:02.263904                                         *
 *           File Size         : 2326                                                               *
 *           MD5 hash          : 1256b4cf999d3870d57388f60cf3817d                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale  1ns / 1ps
`include  "commonDefinition.v"
module latchedBasedRAM #(
  parameter data_width=16,
  parameter depth=256,
  parameter log_depth=8,
  parameter delay=4
)(
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
     input  COLLDISN
);
reg  [data_width-1:0] iQ;
reg  [data_width-1:0] mem [ 0 : depth-1 ] ;
wire [depth-1:0] gatedWrClk;
`ifdef  INITIALIZE_MEMORY
integer i;
initial
     for(i =  0;i<depth;i =  i+1)
          mem[i]  =  {data_width{1'b0}};
`endif 

always @( posedge CLKA )
     if (!CENA)
          iQ <= mem[AA] ;
assign QA =  iQ;
genvar j;

generate
     for(j =  0;j<depth;j =  j+1)
          begin 

               gateClockCell gateWrInst (
                         .clk(CLKB),
                         .gate((! CENB )&(AB==j)),
                         .enableGate(1'b1),
                         .gatedClk(gatedWrClk[j] )
                         );

               always @( * )
                    if (gatedWrClk[j] )
                         mem[j]  <= DB;
          end

endgenerate
endmodule

