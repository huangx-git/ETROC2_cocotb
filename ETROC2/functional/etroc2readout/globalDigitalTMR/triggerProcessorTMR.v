/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ./triggerProcessorTMR.v                                                                *
 *                                                                                                  *
 * user    : dtgong                                                                                 *
 * host    : sphy7asic01.smu.edu                                                                    *
 * date    : 10/04/2022 21:45:07                                                                    *
 *                                                                                                  *
 * workdir : /users/dtgong/workarea/tsmc65/ETLROC/digital/ETROC2Readout/gitlab/etroc2readout/tmpTMR *
 * cmd     : /users/qsun/workarea/tsmc65nm/ETROC_PLL/digital_work/tmrg/bin/tmrg ../triggerProcessor.v *
 * tmrg rev:                                                                                        *
 *                                                                                                  *
 * src file: ../triggerProcessor.v                                                                  *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2022-04-10 21:44:17.796167                                         *
 *           File Size         : 1227                                                               *
 *           MD5 hash          : ae830fad2b2b6176278b27175acecff7                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale  1ns / 1ps
module triggerProcessorTMR(
  input  clkA,
  input  clkB,
  input  clkC,
  input  resetA,
  input  resetB,
  input  resetC,
  input [15:0] trigHitsA,
  input [15:0] trigHitsB,
  input [15:0] trigHitsC,
  input [11:0] BCIDA,
  input [11:0] BCIDB,
  input [11:0] BCIDC,
  input [11:0] emptySlotBCIDA,
  input [11:0] emptySlotBCIDB,
  input [11:0] emptySlotBCIDC,
  output [15:0] encTrigHitsA,
  output [15:0] encTrigHitsB,
  output [15:0] encTrigHitsC
);
wor nextOddTmrErrorC;
wire nextOddVotedC;
wor nextOddTmrErrorB;
wire nextOddVotedB;
wor nextOddTmrErrorA;
wire nextOddVotedA;
wire emptySlotA =  BCIDA==emptySlotBCIDA;
wire emptySlotB =  BCIDB==emptySlotBCIDB;
wire emptySlotC =  BCIDC==emptySlotBCIDC;
reg  oddA;
reg  oddB;
reg  oddC;
wire nextOddA =  ~oddA;
wire nextOddB =  ~oddB;
wire nextOddC =  ~oddC;

always @( negedge clkA )
  begin
    if (~resetA)
      begin
        oddA <= 1'b0;
      end
    else
      if (emptySlotA)
        begin
          oddA <= nextOddVotedA;
        end
  end

always @( negedge clkB )
  begin
    if (~resetB)
      begin
        oddB <= 1'b0;
      end
    else
      if (emptySlotB)
        begin
          oddB <= nextOddVotedB;
        end
  end

always @( negedge clkC )
  begin
    if (~resetC)
      begin
        oddC <= 1'b0;
      end
    else
      if (emptySlotC)
        begin
          oddC <= nextOddVotedC;
        end
  end
assign encTrigHitsA =  ~emptySlotA ? trigHitsA : (oddA ? 16'H0000 : 16'HFFFF);
assign encTrigHitsB =  ~emptySlotB ? trigHitsB : (oddB ? 16'H0000 : 16'HFFFF);
assign encTrigHitsC =  ~emptySlotC ? trigHitsC : (oddC ? 16'H0000 : 16'HFFFF);

majorityVoter nextOddVoterA (
    .inA(nextOddA),
    .inB(nextOddB),
    .inC(nextOddC),
    .out(nextOddVotedA),
    .tmrErr(nextOddTmrErrorA)
    );

majorityVoter nextOddVoterB (
    .inA(nextOddA),
    .inB(nextOddB),
    .inC(nextOddC),
    .out(nextOddVotedB),
    .tmrErr(nextOddTmrErrorB)
    );

majorityVoter nextOddVoterC (
    .inA(nextOddA),
    .inB(nextOddB),
    .inC(nextOddC),
    .out(nextOddVotedC),
    .tmrErr(nextOddTmrErrorC)
    );
endmodule

