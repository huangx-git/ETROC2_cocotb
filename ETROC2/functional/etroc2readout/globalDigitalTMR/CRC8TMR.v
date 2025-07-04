/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ./globalDigitalTMR/CRC8TMR.v                                                           *
 *                                                                                                  *
 * user    : dtgong                                                                                 *
 * host    : sphy7asic01.smu.edu                                                                    *
 * date    : 03/04/2022 15:30:01                                                                    *
 *                                                                                                  *
 * workdir : /users/dtgong/workarea/tsmc65/ETLROC/digital/ETROC2Readout/gitlab/etroc2readout        *
 * cmd     : ../../tmrg/tmrg/bin/tmrg -c tmrgGlobal.cnf                                             *
 * tmrg rev:                                                                                        *
 *                                                                                                  *
 * src file: CRC8.v                                                                                 *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2022-03-15 14:02:01.511895                                         *
 *           File Size         : 1806                                                               *
 *           MD5 hash          : 55b5d8781de0b8020837868b7952584e                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale  1ns / 100ps
module CRC8TMR #(
  parameter WORDWIDTH=40
)(
     input [7:0] cinA,
     input [7:0] cinB,
     input [7:0] cinC,
     input  disA,
     input  disB,
     input  disC,
     input [WORDWIDTH-1:0] dinA,
     input [WORDWIDTH-1:0] dinB,
     input [WORDWIDTH-1:0] dinC,
     output [7:0] doutA,
     output [7:0] doutB,
     output [7:0] doutC
);
wire [WORDWIDTH-1:0] dA;
wire [WORDWIDTH-1:0] dB;
wire [WORDWIDTH-1:0] dC;
assign dA =  (disA==1'b1) ? { WORDWIDTH {1'b0} }  : dinA;
assign dB =  (disB==1'b1) ? { WORDWIDTH {1'b0} }  : dinB;
assign dC =  (disC==1'b1) ? { WORDWIDTH {1'b0} }  : dinC;
wire [7:0] ccA [ WORDWIDTH : 0 ] ;
wire [7:0] ccB [ WORDWIDTH : 0 ] ;
wire [7:0] ccC [ WORDWIDTH : 0 ] ;

generate
genvar i;

     for(i =  0;i<WORDWIDTH;i =  i+1)
          begin : CRCloop 
               assign ccA[i+1]  =  {ccA[i] [6] ,ccA[i] [5] ,dA[WORDWIDTH-1-i] ^ccA[i] [4] ^ccA[i] [7] ,ccA[i] [3] ,dA[WORDWIDTH-1-i] ^ccA[i] [2] ^ccA[i] [7] ,dA[WORDWIDTH-1-i] ^ccA[i] [1] ^ccA[i] [7] ,dA[WORDWIDTH-1-i] ^ccA[i] [0] ^ccA[i] [7] ,dA[WORDWIDTH-1-i] ^ccA[i] [7] };
               assign ccB[i+1]  =  {ccB[i] [6] ,ccB[i] [5] ,dB[WORDWIDTH-1-i] ^ccB[i] [4] ^ccB[i] [7] ,ccB[i] [3] ,dB[WORDWIDTH-1-i] ^ccB[i] [2] ^ccB[i] [7] ,dB[WORDWIDTH-1-i] ^ccB[i] [1] ^ccB[i] [7] ,dB[WORDWIDTH-1-i] ^ccB[i] [0] ^ccB[i] [7] ,dB[WORDWIDTH-1-i] ^ccB[i] [7] };
               assign ccC[i+1]  =  {ccC[i] [6] ,ccC[i] [5] ,dC[WORDWIDTH-1-i] ^ccC[i] [4] ^ccC[i] [7] ,ccC[i] [3] ,dC[WORDWIDTH-1-i] ^ccC[i] [2] ^ccC[i] [7] ,dC[WORDWIDTH-1-i] ^ccC[i] [1] ^ccC[i] [7] ,dC[WORDWIDTH-1-i] ^ccC[i] [0] ^ccC[i] [7] ,dC[WORDWIDTH-1-i] ^ccC[i] [7] };
          end

endgenerate
assign ccA[0]  =  cinA;
assign ccB[0]  =  cinB;
assign ccC[0]  =  cinC;
assign doutA =  ccA[WORDWIDTH] ;
assign doutB =  ccB[WORDWIDTH] ;
assign doutC =  ccC[WORDWIDTH] ;
endmodule

