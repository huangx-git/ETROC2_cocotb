//Verilog HDL for "ETROC_PLL_Core_feedbackDivider", "freqPrescalerTMR" "functional"


module freqPrescalerTMR ( clk2G56A, clk2G56B, clk2G56C, skipA, skipB, skipC,
enableA, enableB, enableC, clk1G28A, clk1G28B, clk1G28C, p_105, p_117, clk2G56A_clone1,
p_119, clk2G56B_clone1, clk2G56C_clone1, VDD, VSS );

  input clk2G56C;
  input clk2G56B;
  input p_117;
  output clk1G28A;
  input skipB;
  input p_105;
  output clk1G28B;
  input skipC;
  input enableB;
  input clk2G56B_clone1;
  inout VDD;
  input enableC;
  input enableA;
  input skipA;
  input p_119;
  input clk2G56C_clone1;
  input clk2G56A_clone1;
  input clk2G56A;
  inout VSS;
  output clk1G28C;

wor skipReSyncTmrErrorC;
wire skipReSyncVotedC;
wor stateNextTmrErrorC;
wire [1:0] stateNextVotedC;
wor skipReSyncTmrErrorB;
wire skipReSyncVotedB;
wor stateNextTmrErrorB;
wire [1:0] stateNextVotedB;
wor skipReSyncTmrErrorA;
wire skipReSyncVotedA;
wor stateNextTmrErrorA;
wire [1:0] stateNextVotedA;
reg  skipReSyncA;
reg  skipReSyncB;
reg  skipReSyncC;
reg  skipReSync2A;
reg  skipReSync2B;
reg  skipReSync2C;
reg  [1:0] stateA;
reg  [1:0] stateB;
reg  [1:0] stateC;
reg  [1:0] stateNextA;
reg  [1:0] stateNextB;
reg  [1:0] stateNextC;

always @( stateA or skipA )
  begin
    stateNextA =  stateA;
    case (stateA)
      2'd0 : 
        begin
          if (skipReSync2A)
            stateNextA =  2'd2;
          else
            stateNextA =  2'd1;
        end
      2'd1 : stateNextA =  2'd0;
      2'd2 : stateNextA =  2'd3;
      2'd3 : 
        begin
          if (skipReSync2A)
            stateNextA =  2'd2;
          else
            stateNextA =  2'd0;
        end
      default : stateNextA =  2'd0;
    endcase
  end

always @( stateB or skipB )
  begin
    stateNextB =  stateB;
    case (stateB)
      2'd0 : 
        begin
          if (skipReSync2B)
            stateNextB =  2'd2;
          else
            stateNextB =  2'd1;
        end
      2'd1 : stateNextB =  2'd0;
      2'd2 : stateNextB =  2'd3;
      2'd3 : 
        begin
          if (skipReSync2B)
            stateNextB =  2'd2;
          else
            stateNextB =  2'd0;
        end
      default : stateNextB =  2'd0;
    endcase
  end

always @( stateC or skipC )
  begin
    stateNextC =  stateC;
    case (stateC)
      2'd0 : 
        begin
          if (skipReSync2C)
            stateNextC =  2'd2;
          else
            stateNextC =  2'd1;
        end
      2'd1 : stateNextC =  2'd0;
      2'd2 : stateNextC =  2'd3;
      2'd3 : 
        begin
          if (skipReSync2C)
            stateNextC =  2'd2;
          else
            stateNextC =  2'd0;
        end
      default : stateNextC =  2'd0;
    endcase
  end

always @( posedge clk2G56A or negedge enableA )
  if (!enableA)
    stateA <= #10 1'b0;
  else
    stateA <= #10 stateNextVotedA;

always @( posedge clk2G56B or negedge enableB )
  if (!enableB)
    stateB <= #10 1'b0;
  else
    stateB <= #10 stateNextVotedB;

always @( posedge clk2G56C or negedge enableC )
  if (!enableC)
    stateC <= #10 1'b0;
  else
    stateC <= #10 stateNextVotedC;

always @( posedge clk2G56A or negedge enableA )
  if (!enableA)
    skipReSyncA <= #10 1'b0;
  else
    skipReSyncA <= #10 skipA;

always @( posedge clk2G56B or negedge enableB )
  if (!enableB)
    skipReSyncB <= #10 1'b0;
  else
    skipReSyncB <= #10 skipB;

always @( posedge clk2G56C or negedge enableC )
  if (!enableC)
    skipReSyncC <= #10 1'b0;
  else
    skipReSyncC <= #10 skipC;

always @( posedge clk2G56A or negedge enableA )
  if (!enableA)
    skipReSync2A <= #10 1'b0;
  else
    skipReSync2A <= #10 skipReSyncVotedA;

always @( posedge clk2G56B or negedge enableB )
  if (!enableB)
    skipReSync2B <= #10 1'b0;
  else
    skipReSync2B <= #10 skipReSyncVotedB;

always @( posedge clk2G56C or negedge enableC )
  if (!enableC)
    skipReSync2C <= #10 1'b0;
  else
    skipReSync2C <= #10 skipReSyncVotedC;
assign clk1G28A =  stateA[0] ;
assign clk1G28B =  stateB[0] ;
assign clk1G28C =  stateC[0] ;
// synopsys translate_off
initial
  begin
    stateA =  $random;
  end
initial
  begin
    stateB =  $random;
  end
initial
  begin
    stateC =  $random;
  end
// synopsys translate_on

majorityVoter #(.WIDTH(2)) stateNextVoterA (
    .inA(stateNextA),
    .inB(stateNextB),
    .inC(stateNextC),
    .out(stateNextVotedA),
    .tmrErr(stateNextTmrErrorA)
    );

majorityVoter skipReSyncVoterA (
    .inA(skipReSyncA),
    .inB(skipReSyncB),
    .inC(skipReSyncC),
    .out(skipReSyncVotedA),
    .tmrErr(skipReSyncTmrErrorA)
    );

majorityVoter #(.WIDTH(2)) stateNextVoterB (
    .inA(stateNextA),
    .inB(stateNextB),
    .inC(stateNextC),
    .out(stateNextVotedB),
    .tmrErr(stateNextTmrErrorB)
    );

majorityVoter skipReSyncVoterB (
    .inA(skipReSyncA),
    .inB(skipReSyncB),
    .inC(skipReSyncC),
    .out(skipReSyncVotedB),
    .tmrErr(skipReSyncTmrErrorB)
    );

majorityVoter #(.WIDTH(2)) stateNextVoterC (
    .inA(stateNextA),
    .inB(stateNextB),
    .inC(stateNextC),
    .out(stateNextVotedC),
    .tmrErr(stateNextTmrErrorC)
    );

majorityVoter skipReSyncVoterC (
    .inA(skipReSyncA),
    .inB(skipReSyncB),
    .inC(skipReSyncC),
    .out(skipReSyncVotedC),
    .tmrErr(skipReSyncTmrErrorC)
    );

endmodule

