/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ./globalDigitalTMR/serializerBlockTMR.v                                                *
 *                                                                                                  *
 * user    : dtgong                                                                                 *
 * host    : sphy7asic01.smu.edu                                                                    *
 * date    : 03/04/2022 15:30:09                                                                    *
 *                                                                                                  *
 * workdir : /users/dtgong/workarea/tsmc65/ETLROC/digital/ETROC2Readout/gitlab/etroc2readout        *
 * cmd     : ../../tmrg/tmrg/bin/tmrg -c tmrgGlobal.cnf                                             *
 * tmrg rev:                                                                                        *
 *                                                                                                  *
 * src file: serializerBlock.v                                                                      *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2022-03-15 14:02:02.670909                                         *
 *           File Size         : 1099                                                               *
 *           MD5 hash          : 54f41e38e0c90955d2ca9a39f8c90fbc                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale  10ps / 1ps
module serializerBlockTMR #(
  parameter WORDWIDTH=8
)(
     input  enableA,
     input  enableB,
     input  enableC,
     input  loadA,
     input  loadB,
     input  loadC,
     input  bitCKA,
     input  bitCKB,
     input  bitCKC,
     input [WORDWIDTH-1:0] dinA,
     input [WORDWIDTH-1:0] dinB,
     input [WORDWIDTH-1:0] dinC,
     output  soutA,
     output  soutB,
     output  soutC
);
reg  [WORDWIDTH-1:0] rA;
reg  [WORDWIDTH-1:0] rB;
reg  [WORDWIDTH-1:0] rC;

always @( posedge bitCKA )
     begin
          if (enableA)
               begin
                    if (loadA)
                         begin
                              rA <= dinA;
                         end
                    else
                         begin
                              rA <= {rA[WORDWIDTH-1] ,rA[WORDWIDTH-1:1] };
                         end
               end
     end

always @( posedge bitCKB )
     begin
          if (enableB)
               begin
                    if (loadB)
                         begin
                              rB <= dinB;
                         end
                    else
                         begin
                              rB <= {rB[WORDWIDTH-1] ,rB[WORDWIDTH-1:1] };
                         end
               end
     end

always @( posedge bitCKC )
     begin
          if (enableC)
               begin
                    if (loadC)
                         begin
                              rC <= dinC;
                         end
                    else
                         begin
                              rC <= {rC[WORDWIDTH-1] ,rC[WORDWIDTH-1:1] };
                         end
               end
     end
assign soutA =  rA[0] ;
assign soutB =  rB[0] ;
assign soutC =  rC[0] ;
endmodule

