/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ./globalDigitalTMR/CircularBufferAddrTMR.v                                             *
 *                                                                                                  *
 * user    : dtgong                                                                                 *
 * host    : sphy7asic01.smu.edu                                                                    *
 * date    : 03/04/2022 15:30:01                                                                    *
 *                                                                                                  *
 * workdir : /users/dtgong/workarea/tsmc65/ETLROC/digital/ETROC2Readout/gitlab/etroc2readout        *
 * cmd     : ../../tmrg/tmrg/bin/tmrg -c tmrgGlobal.cnf                                             *
 * tmrg rev:                                                                                        *
 *                                                                                                  *
 * src file: CircularBufferAddr.v                                                                   *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2022-03-15 14:02:01.517892                                         *
 *           File Size         : 1122                                                               *
 *           MD5 hash          : 6b92230be75a353175263bd0d96d3e77                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale  1ns / 100ps

module CircularBufferAddrTMR(
     input  clkA,
     input  clkB,
     input  clkC,
     input  resetA,
     input  resetB,
     input  resetC,
     output [8:0] wrAddrA,
     output [8:0] wrAddrB,
     output [8:0] wrAddrC
);
wor CBwrAddrNextTmrErrorC;
wire [8:0] CBwrAddrNextVotedC;
wor CBwrAddrNextTmrErrorB;
wire [8:0] CBwrAddrNextVotedB;
wor CBwrAddrNextTmrErrorA;
wire [8:0] CBwrAddrNextVotedA;
reg  [8:0] CBwrAddrA;
reg  [8:0] CBwrAddrB;
reg  [8:0] CBwrAddrC;
wire [8:0] CBwrAddrNextA =  CBwrAddrA+9'd1;
wire [8:0] CBwrAddrNextB =  CBwrAddrB+9'd1;
wire [8:0] CBwrAddrNextC =  CBwrAddrC+9'd1;

always @( negedge clkA )
     begin
          if (!resetA)
               begin
                    CBwrAddrA <= 9'h000;
               end
          else
               begin
                    CBwrAddrA <= CBwrAddrNextVotedA;
               end
     end

always @( negedge clkB )
     begin
          if (!resetB)
               begin
                    CBwrAddrB <= 9'h000;
               end
          else
               begin
                    CBwrAddrB <= CBwrAddrNextVotedB;
               end
     end

always @( negedge clkC )
     begin
          if (!resetC)
               begin
                    CBwrAddrC <= 9'h000;
               end
          else
               begin
                    CBwrAddrC <= CBwrAddrNextVotedC;
               end
     end
assign wrAddrA =  CBwrAddrA;
assign wrAddrB =  CBwrAddrB;
assign wrAddrC =  CBwrAddrC;

majorityVoter #(.WIDTH(9)) CBwrAddrNextVoterA (
          .inA(CBwrAddrNextA),
          .inB(CBwrAddrNextB),
          .inC(CBwrAddrNextC),
          .out(CBwrAddrNextVotedA),
          .tmrErr(CBwrAddrNextTmrErrorA)
          );

majorityVoter #(.WIDTH(9)) CBwrAddrNextVoterB (
          .inA(CBwrAddrNextA),
          .inB(CBwrAddrNextB),
          .inC(CBwrAddrNextC),
          .out(CBwrAddrNextVotedB),
          .tmrErr(CBwrAddrNextTmrErrorB)
          );

majorityVoter #(.WIDTH(9)) CBwrAddrNextVoterC (
          .inA(CBwrAddrNextA),
          .inB(CBwrAddrNextB),
          .inC(CBwrAddrNextC),
          .out(CBwrAddrNextVotedC),
          .tmrErr(CBwrAddrNextTmrErrorC)
          );
endmodule

