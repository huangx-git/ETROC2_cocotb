//Verilog HDL for "ETROC_PLL_Core_feedbackDivider", "feedbackDividerTMR" "functional"


module feedbackDividerTMR ( clk2G56inA, clk2G56inB, clk2G56inC, skipA, skipB,
skipC, clk40MA, clk40MB, clk40MC, clk80MA, clk80MB, clk80MC, clk160MA, clk160MB,
clk160MC, clk320MA, clk320MB, clk320MC, clk640MA, clk640MB, clk640MC, clk1G28A,
clk1G28B, clk1G28C, clk2G56A, clk2G56B, clk2G56C, clk40MpllA, clk40MpllB, clk40MpllC,
eclk40MEnableA, eclk40MEnableB, eclk40MEnableC, eclk80MEnableA, eclk80MEnableB,
eclk80MEnableC, eclk160MEnableA, eclk160MEnableB, eclk160MEnableC, eclk320MEnableA,
eclk320MEnableB, eclk320MEnableC, eclk640MEnableA, eclk640MEnableB, eclk640MEnableC,
eclk1G28EnableA, eclk1G28EnableB, eclk1G28EnableC, eclk2G56EnableA, eclk2G56EnableB,
eclk2G56EnableC, clk40Meclk, clk80Meclk, clk160Meclk, clk320Meclk, clk640Meclk,
clk1G28eclk, clk2G56eclk, enablePhaseShifterA, enablePhaseShifterB, enablePhaseShifterC,
clk40Mps, clk80Mps, clk160Mps, clk320Mps, clk640Mps, clk1G28ps, clk2G56ps, enableDesA,
enableDesB, enableDesC, enableDesVote, clk40Mdes, clk80Mdes, clk160Mdes, clk320Mdes,
clk640Mdes, clk1G28des, clk2G56des, enableSerA, enableSerB, enableSerC, enableSerOutA,
enableSerOutB, enableSerOutC, clk40Mser, clk80Mser, clk160Mser, clk320Mser,
clk640Mser, clk1G28ser, clk2G56ser, clkTreeADisableA, clkTreeADisableB, clkTreeADisableC,
clkTreeBDisableA, clkTreeBDisableB, clkTreeBDisableC, clkTreeCDisableA, clkTreeCDisableB,
clkTreeCDisableC, clkTreeADisable_to_full_customA, clkTreeADisable_to_full_customB,
clkTreeADisable_to_full_customC, clkTreeBDisable_to_full_customA, clkTreeBDisable_to_full_customB,
clkTreeBDisable_to_full_customC, clkTreeCDisable_to_full_customA, clkTreeCDisable_to_full_customB,
clkTreeCDisable_to_full_customC, VSS, VDD );

  output clk160MC;
  input eclk40MEnableA;
  output clk640Mser;
  output clkTreeADisable_to_full_customC;
  output clk40Meclk;
  output clk160Mser;
  input eclk80MEnableC;
  output clk640MA;
  output clkTreeCDisable_to_full_customB;
  output clk640Meclk;
  output clk320Meclk;
  input eclk80MEnableB;
  input skipA;
  input eclk320MEnableB;
  output clk320Mps;
  output clk40Mps;
  input clkTreeBDisableB;
  input clkTreeCDisableA;
  output clk2G56des;
  output clk1G28A;
  output clk40MC;
  output clk40MA;
  input clkTreeBDisableA;
  input eclk640MEnableA;
  input clkTreeADisableC;
  input eclk640MEnableB;
  output clk160Mps;
  output enableSerOutC;
  input clkTreeADisableA;
  output clk2G56A;
  inout VSS;
  input eclk1G28EnableC;
  input enableSerC;
  input enableSerB;
  output clk2G56ps;
  input enableSerA;
  output clkTreeCDisable_to_full_customA;
  input eclk1G28EnableB;
  output clkTreeADisable_to_full_customA;
  input enablePhaseShifterC;
  output clk640MB;
  input eclk2G56EnableA;
  output clk1G28ser;
  output clkTreeADisable_to_full_customB;
  output enableSerOutB;
  input eclk40MEnableB;
  output clk80Mdes;
  output clk160MA;
  input skipB;
  output clk2G56ser;
  output clk1G28B;
  input skipC;
  input enablePhaseShifterB;
  input enableDesB;
  input enableDesA;
  input eclk640MEnableC;
  output clk320MA;
  output clk160Mdes;
  output clk2G56C;
  output clk320Mdes;
  output clk40Mser;
  output clk80MB;
  output clk40MpllB;
  output enableSerOutA;
  input eclk40MEnableC;
  output clk640Mdes;
  output clk80MA;
  output clk640Mps;
  output clk640MC;
  output clkTreeCDisable_to_full_customC;
  input clk2G56inA;
  output clk80Mps;
  output clk320MB;
  inout VDD;
  input eclk2G56EnableB;
  input clkTreeADisableB;
  output clk1G28eclk;
  output clk1G28C;
  output clk160Meclk;
  output clk40MpllA;
  output clk40Mdes;
  input clkTreeBDisableC;
  input eclk2G56EnableC;
  input eclk80MEnableA;
  output clkTreeBDisable_to_full_customB;
  output clk40MpllC;
  input enablePhaseShifterA;
  input clkTreeCDisableB;
  output clk1G28des;
  output clk80MC;
  output clk80Meclk;
  output clk320Mser;
  input eclk160MEnableB;
  output clk80Mser;
  input eclk320MEnableA;
  output clkTreeBDisable_to_full_customA;
  output clk1G28ps;
  input clk2G56inB;
  output clk320MC;
  output clkTreeBDisable_to_full_customC;
  input eclk160MEnableC;
  output enableDesVote;
  input eclk320MEnableC;
  output clk2G56eclk;
  input clkTreeCDisableC;
  input eclk1G28EnableA;
  input clk2G56inC;
  input enableDesC;
  input eclk160MEnableA;
  output clk2G56B;
  output clk40MB;
  output clk160MB;





wor clockDividerNextTmrErrorC;
wire [4:0] clockDividerNextVotedC;
wor clockDividerNextTmrErrorB;
wire [4:0] clockDividerNextVotedB;
wor clockDividerNextTmrErrorA;
wire [4:0] clockDividerNextVotedA;
wor clkTreeADisableTmrError;
wire clkTreeADisable;
wor eclk640MEnableTmrError;
wire eclk640MEnable;
wor clk2G56intTmrError;
wire clk2G56int;
wor clk640MintTmrError;
wire clk640Mint;
wor clk320MintTmrError;
wire clk320Mint;
wor clk160MintTmrError;
wire clk160Mint;
wor clk1G28intTmrError;
wire clk1G28int;
wor clkTreeCDisableTmrError;
wire clkTreeCDisable;
wor eclk80MEnableTmrError;
wire eclk80MEnable;
wor clkTreeBDisableTmrError;
wire clkTreeBDisable;
wor eclk40MEnableTmrError;
wire eclk40MEnable;
wor eclk1G28EnableTmrError;
wire eclk1G28Enable;
wor eclk160MEnableTmrError;
wire eclk160MEnable;
wor clk40MintTmrError;
wire clk40Mint;
wor enableSerTmrError;
wire enableSer;
wor eclk2G56EnableTmrError;
wire eclk2G56Enable;
wor eclk320MEnableTmrError;
wire eclk320MEnable;
wor clk80MintTmrError;
wire clk80Mint;
wor enableDesTmrError;
wire enableDes;
wor enablePhaseShifterTmrError;
wire enablePhaseShifter;

CKBD1_LVT_ELT CKTreeADIS_preserveA (
    .I(clkTreeADisableA),
    .Z(clkTreeADisable_to_full_customA)
    );

CKBD1_LVT_ELT CKTreeADIS_preserveB (
    .I(clkTreeADisableB),
    .Z(clkTreeADisable_to_full_customB)
    );

CKBD1_LVT_ELT CKTreeADIS_preserveC (
    .I(clkTreeADisableC),
    .Z(clkTreeADisable_to_full_customC)
    );

CKBD1_LVT_ELT CKTreeBDIS_preserveA (
    .I(clkTreeBDisableA),
    .Z(clkTreeBDisable_to_full_customA)
    );

CKBD1_LVT_ELT CKTreeBDIS_preserveB (
    .I(clkTreeBDisableB),
    .Z(clkTreeBDisable_to_full_customB)
    );

CKBD1_LVT_ELT CKTreeBDIS_preserveC (
    .I(clkTreeBDisableC),
    .Z(clkTreeBDisable_to_full_customC)
    );

CKBD1_LVT_ELT CKTreeCDIS_preserveA (
    .I(clkTreeCDisableA),
    .Z(clkTreeCDisable_to_full_customA)
    );

CKBD1_LVT_ELT CKTreeCDIS_preserveB (
    .I(clkTreeCDisableB),
    .Z(clkTreeCDisable_to_full_customB)
    );

CKBD1_LVT_ELT CKTreeCDIS_preserveC (
    .I(clkTreeCDisableC),
    .Z(clkTreeCDisable_to_full_customC)
    );
wire enableA =  !clkTreeADisable;
wire enableB =  !clkTreeBDisable;
wire enableC =  !clkTreeCDisable;
wire clk2G56inbA;
wire clk2G56inboA;
wire clk2G56inbB;
wire clk2G56inboB;
wire clk2G56inbC;
wire clk2G56inboC;

CKBD4_LVT_ELT ckb0A (
    .I(clk2G56inA),
    .Z(clk2G56inbA)
    );

CKBD4_LVT_ELT ckb0B (
    .I(clk2G56inB),
    .Z(clk2G56inbB)
    );

CKBD4_LVT_ELT ckb0C (
    .I(clk2G56inC),
    .Z(clk2G56inbC)
    );
wire clk1G28prebA;
wire clk1G28prebB;
wire clk1G28prebC;
wire clk1G28preA;
wire clk1G28preB;
wire clk1G28preC;

freqPrescalerTMR FP (
    .clk2G56A(clk2G56inbA),
    .clk2G56B(clk2G56inbB),
    .clk2G56C(clk2G56inbC),
    .skipA(skipA),
    .skipB(skipB),
    .skipC(skipC),
    .clk1G28A(clk1G28preA),
    .clk1G28B(clk1G28preB),
    .clk1G28C(clk1G28preC),
    .enableA(enableA),
    .enableB(enableB),
    .enableC(enableC)
    );

CKBD4_LVT_ELT ck1g28b_preserveA (
    .I(clk1G28preA),
    .Z(clk1G28prebA)
    );

CKBD4_LVT_ELT ck1g28b_preserveB (
    .I(clk1G28preB),
    .Z(clk1G28prebB)
    );

CKBD4_LVT_ELT ck1g28b_preserveC (
    .I(clk1G28preC),
    .Z(clk1G28prebC)
    );
reg  [4:0] clockDividerA;
reg  [4:0] clockDividerB;
reg  [4:0] clockDividerC;
reg  [4:0] clockDividerNextA;
reg  [4:0] clockDividerNextB;
reg  [4:0] clockDividerNextC;

always @( posedge clk1G28prebA or negedge enableA )
  if (!enableA)
    clockDividerA <= #1 5'b0;
  else
    clockDividerA <= #1 clockDividerNextVotedA;

always @( posedge clk1G28prebB or negedge enableB )
  if (!enableB)
    clockDividerB <= #1 5'b0;
  else
    clockDividerB <= #1 clockDividerNextVotedB;

always @( posedge clk1G28prebC or negedge enableC )
  if (!enableC)
    clockDividerC <= #1 5'b0;
  else
    clockDividerC <= #1 clockDividerNextVotedC;

always @( clockDividerA )
  clockDividerNextA =  clockDividerA-1;

always @( clockDividerB )
  clockDividerNextB =  clockDividerB-1;

always @( clockDividerC )
  clockDividerNextC =  clockDividerC-1;
wire [5:0] dividedA =  {clockDividerA[4:0] ,clk1G28prebA};
wire [5:0] dividedB =  {clockDividerB[4:0] ,clk1G28prebB};
wire [5:0] dividedC =  {clockDividerC[4:0] ,clk1G28prebC};
wire clk1G28intA;
wire clk640MintA;
wire clk320MintA;
wire clk160MintA;
wire clk80MintA;
wire clk40MintA;
wire clk2G56intA;
wire clk1G28intB;
wire clk640MintB;
wire clk320MintB;
wire clk160MintB;
wire clk80MintB;
wire clk40MintB;
wire clk2G56intB;
wire clk1G28intC;
wire clk640MintC;
wire clk320MintC;
wire clk160MintC;
wire clk80MintC;
wire clk40MintC;
wire clk2G56intC;

freqDividerSamplerTMR FDS (
    .clk2G56inA(clk2G56inbA),
    .clk2G56inB(clk2G56inbB),
    .clk2G56inC(clk2G56inbC),
    .dividedA(dividedA),
    .dividedB(dividedB),
    .dividedC(dividedC),
    .enableA(enableA),
    .enableB(enableB),
    .enableC(enableC),
    .clk1G28A(clk1G28intA),
    .clk1G28B(clk1G28intB),
    .clk1G28C(clk1G28intC),
    .clk640MA(clk640MintA),
    .clk640MB(clk640MintB),
    .clk640MC(clk640MintC),
    .clk320MA(clk320MintA),
    .clk320MB(clk320MintB),
    .clk320MC(clk320MintC),
    .clk160MA(clk160MintA),
    .clk160MB(clk160MintB),
    .clk160MC(clk160MintC),
    .clk80MA(clk80MintA),
    .clk80MB(clk80MintB),
    .clk80MC(clk80MintC),
    .clk40MA(clk40MintA),
    .clk40MB(clk40MintB),
    .clk40MC(clk40MintC),
    .clk40MpllA(clk40MpllA),
    .clk40MpllB(clk40MpllB),
    .clk40MpllC(clk40MpllC),
    .clk2G56A(clk2G56intA),
    .clk2G56B(clk2G56intB),
    .clk2G56C(clk2G56intC)
    );

CKBD1_LVT_ELT ckob0_preserveA (
    .I(clk40MintA),
    .Z(clk40MA)
    );

CKBD1_LVT_ELT ckob0_preserveB (
    .I(clk40MintB),
    .Z(clk40MB)
    );

CKBD1_LVT_ELT ckob0_preserveC (
    .I(clk40MintC),
    .Z(clk40MC)
    );

CKBD1_LVT_ELT ckob1_preserveA (
    .I(clk80MintA),
    .Z(clk80MA)
    );

CKBD1_LVT_ELT ckob1_preserveB (
    .I(clk80MintB),
    .Z(clk80MB)
    );

CKBD1_LVT_ELT ckob1_preserveC (
    .I(clk80MintC),
    .Z(clk80MC)
    );

CKBD1_LVT_ELT ckob2_preserveA (
    .I(clk160MintA),
    .Z(clk160MA)
    );

CKBD1_LVT_ELT ckob2_preserveB (
    .I(clk160MintB),
    .Z(clk160MB)
    );

CKBD1_LVT_ELT ckob2_preserveC (
    .I(clk160MintC),
    .Z(clk160MC)
    );

CKBD1_LVT_ELT ckob3_preserveA (
    .I(clk320MintA),
    .Z(clk320MA)
    );

CKBD1_LVT_ELT ckob3_preserveB (
    .I(clk320MintB),
    .Z(clk320MB)
    );

CKBD1_LVT_ELT ckob3_preserveC (
    .I(clk320MintC),
    .Z(clk320MC)
    );

CKBD1_LVT_ELT ckob4_preserveA (
    .I(clk640MintA),
    .Z(clk640MA)
    );

CKBD1_LVT_ELT ckob4_preserveB (
    .I(clk640MintB),
    .Z(clk640MB)
    );

CKBD1_LVT_ELT ckob4_preserveC (
    .I(clk640MintC),
    .Z(clk640MC)
    );

CKBD1_LVT_ELT ckob5_preserveA (
    .I(clk1G28intA),
    .Z(clk1G28A)
    );

CKBD1_LVT_ELT ckob5_preserveB (
    .I(clk1G28intB),
    .Z(clk1G28B)
    );

CKBD1_LVT_ELT ckob5_preserveC (
    .I(clk1G28intC),
    .Z(clk1G28C)
    );

CKBD1_LVT_ELT ckob6_preserveA (
    .I(clk2G56intA),
    .Z(clk2G56A)
    );

CKBD1_LVT_ELT ckob6_preserveB (
    .I(clk2G56intB),
    .Z(clk2G56B)
    );

CKBD1_LVT_ELT ckob6_preserveC (
    .I(clk2G56intC),
    .Z(clk2G56C)
    );
// synopsys translate_off
initial
  begin
    #2 clockDividerA =  $random;
  end
initial
  begin
    #2 clockDividerB =  $random;
  end
initial
  begin
    #2 clockDividerC =  $random;
  end
// synopsys translate_on
wire clk40Mseint;
wire clk80Mseint;
wire clk160Mseint;
wire clk320Mseint;
wire clk640Mseint;
wire clk1G28seint;
wire clk2G56seint;
assign clk40Mseint =  clk40Mint;
assign clk80Mseint =  clk80Mint;
assign clk160Mseint =  clk160Mint;
assign clk320Mseint =  clk320Mint;
assign clk640Mseint =  clk640Mint;
assign clk1G28seint =  clk1G28int;
assign clk2G56seint =  clk2G56int;
wire enableSerSE =  enableSer;

CKBD1_LVT_ELT enSerBuf_preserveA (
    .I(enableSerA),
    .Z(enableSerOutA)
    );

CKBD1_LVT_ELT enSerBuf_preserveB (
    .I(enableSerB),
    .Z(enableSerOutB)
    );

CKBD1_LVT_ELT enSerBuf_preserveC (
    .I(enableSerC),
    .Z(enableSerOutC)
    );

ND2D1_LVT_ELT clk40MserGate_preserve (
    .A1(clk40Mseint),
    .A2(enableSerSE),
    .ZN(clk40MserBar)
    );

ND2D1_LVT_ELT clk80MserGate_preserve (
    .A1(clk80Mseint),
    .A2(enableSerSE),
    .ZN(clk80MserBar)
    );

ND2D1_LVT_ELT clk160MserGate_preserve (
    .A1(clk160Mseint),
    .A2(enableSerSE),
    .ZN(clk160MserBar)
    );

ND2D1_LVT_ELT clk320MserGate_preserve (
    .A1(clk320Mseint),
    .A2(enableSerSE),
    .ZN(clk320MserBar)
    );

ND2D1_LVT_ELT clk640MserGate_preserve (
    .A1(clk640Mseint),
    .A2(enableSerSE),
    .ZN(clk640MserBar)
    );

ND2D1_LVT_ELT clk1G28serGate_preserve (
    .A1(clk1G28seint),
    .A2(enableSerSE),
    .ZN(clk1G28serBar)
    );

ND2D1_LVT_ELT clk2G56serGate_preserve (
    .A1(clk2G56seint),
    .A2(enableSerSE),
    .ZN(clk2G56serBar)
    );

INVD1_LVT_ELT clk40MserInv_preserve (
    .I(clk40MserBar),
    .ZN(clk40Mser)
    );

INVD1_LVT_ELT clk80MserInv_preserve (
    .I(clk80MserBar),
    .ZN(clk80Mser)
    );

INVD1_LVT_ELT clk160MserInv_preserve (
    .I(clk160MserBar),
    .ZN(clk160Mser)
    );

INVD1_LVT_ELT clk320MserInv_preserve (
    .I(clk320MserBar),
    .ZN(clk320Mser)
    );

INVD1_LVT_ELT clk640MserInv_preserve (
    .I(clk640MserBar),
    .ZN(clk640Mser)
    );

INVD1_LVT_ELT clk1G28serInv_preserve (
    .I(clk1G28serBar),
    .ZN(clk1G28ser)
    );

INVD1_LVT_ELT clk2G56serInv_preserve (
    .I(clk2G56serBar),
    .ZN(clk2G56ser)
    );
wire enableDesSE =  enableDes;
assign enableDesVote =  enableDesSE;

ND2D1_LVT_ELT clk40MdesGate_preserve (
    .A1(clk40Mseint),
    .A2(enableDesSE),
    .ZN(clk40MdesBar)
    );

ND2D1_LVT_ELT clk80MdesGate_preserve (
    .A1(clk80Mseint),
    .A2(enableDesSE),
    .ZN(clk80MdesBar)
    );

ND2D1_LVT_ELT clk160MdesGate_preserve (
    .A1(clk160Mseint),
    .A2(enableDesSE),
    .ZN(clk160MdesBar)
    );

ND2D1_LVT_ELT clk320MdesGate_preserve (
    .A1(clk320Mseint),
    .A2(enableDesSE),
    .ZN(clk320MdesBar)
    );

ND2D1_LVT_ELT clk640MdesGate_preserve (
    .A1(clk640Mseint),
    .A2(enableDesSE),
    .ZN(clk640MdesBar)
    );

ND2D1_LVT_ELT clk1G28desGate_preserve (
    .A1(clk1G28seint),
    .A2(enableDesSE),
    .ZN(clk1G28desBar)
    );

ND2D1_LVT_ELT clk2G56desGate_preserve (
    .A1(clk2G56seint),
    .A2(enableDesSE),
    .ZN(clk2G56desBar)
    );

INVD1_LVT_ELT clk40MdesInv_preserve (
    .I(clk40MdesBar),
    .ZN(clk40Mdes)
    );

INVD1_LVT_ELT clk80MdesInv_preserve (
    .I(clk80MdesBar),
    .ZN(clk80Mdes)
    );

INVD1_LVT_ELT clk160MdesInv_preserve (
    .I(clk160MdesBar),
    .ZN(clk160Mdes)
    );

INVD1_LVT_ELT clk320MdesInv_preserve (
    .I(clk320MdesBar),
    .ZN(clk320Mdes)
    );

INVD1_LVT_ELT clk640MdesInv_preserve (
    .I(clk640MdesBar),
    .ZN(clk640Mdes)
    );

INVD1_LVT_ELT clk1G28desInv_preserve (
    .I(clk1G28desBar),
    .ZN(clk1G28des)
    );

INVD1_LVT_ELT clk2G56desInv_preserve (
    .I(clk2G56desBar),
    .ZN(clk2G56des)
    );

ND2D1_LVT_ELT clk40MeclkGate_preserve (
    .A1(clk40Mseint),
    .A2(eclk40MEnable),
    .ZN(clk40MeclkBar)
    );

ND2D1_LVT_ELT clk80MeclkGate_preserve (
    .A1(clk80Mseint),
    .A2(eclk80MEnable),
    .ZN(clk80MeclkBar)
    );

ND2D1_LVT_ELT clk160MeclkGate_preserve (
    .A1(clk160Mseint),
    .A2(eclk160MEnable),
    .ZN(clk160MeclkBar)
    );

ND2D1_LVT_ELT clk320MeclkGate_preserve (
    .A1(clk320Mseint),
    .A2(eclk320MEnable),
    .ZN(clk320MeclkBar)
    );

ND2D1_LVT_ELT clk640MeclkGate_preserve (
    .A1(clk640Mseint),
    .A2(eclk640MEnable),
    .ZN(clk640MeclkBar)
    );

ND2D1_LVT_ELT clk1G28eclkGate_preserve (
    .A1(clk1G28seint),
    .A2(eclk1G28Enable),
    .ZN(clk1G28eclkBar)
    );

ND2D1_LVT_ELT clk2G56eclkGate_preserve (
    .A1(clk2G56seint),
    .A2(eclk2G56Enable),
    .ZN(clk2G56eclkBar)
    );

INVD1_LVT_ELT clk40MeclkInv_preserve (
    .I(clk40MeclkBar),
    .ZN(clk40Meclk)
    );

INVD1_LVT_ELT clk80MeclkInv_preserve (
    .I(clk80MeclkBar),
    .ZN(clk80Meclk)
    );

INVD1_LVT_ELT clk160MeclkInv_preserve (
    .I(clk160MeclkBar),
    .ZN(clk160Meclk)
    );

INVD1_LVT_ELT clk320MeclkInv_preserve (
    .I(clk320MeclkBar),
    .ZN(clk320Meclk)
    );

INVD1_LVT_ELT clk640MeclkInv_preserve (
    .I(clk640MeclkBar),
    .ZN(clk640Meclk)
    );

INVD1_LVT_ELT clk1G28eclkInv_preserve (
    .I(clk1G28eclkBar),
    .ZN(clk1G28eclk)
    );

INVD1_LVT_ELT clk2G56eclkInv_preserve (
    .I(clk2G56eclkBar),
    .ZN(clk2G56eclk)
    );
wire enablePSSE =  enablePhaseShifter;

ND2D1_LVT_ELT clk40MpsGate_preserve (
    .A1(clk40Mseint),
    .A2(enablePSSE),
    .ZN(clk40MpsBar)
    );

ND2D1_LVT_ELT clk80MpsGate_preserve (
    .A1(clk80Mseint),
    .A2(enablePSSE),
    .ZN(clk80MpsBar)
    );

ND2D1_LVT_ELT clk160MpsGate_preserve (
    .A1(clk160Mseint),
    .A2(enablePSSE),
    .ZN(clk160MpsBar)
    );

ND2D1_LVT_ELT clk320MpsGate_preserve (
    .A1(clk320Mseint),
    .A2(enablePSSE),
    .ZN(clk320MpsBar)
    );

ND2D1_LVT_ELT clk640MpsGate_preserve (
    .A1(clk640Mseint),
    .A2(enablePSSE),
    .ZN(clk640MpsBar)
    );

ND2D1_LVT_ELT clk1G28psGate_preserve (
    .A1(clk1G28seint),
    .A2(enablePSSE),
    .ZN(clk1G28psBar)
    );

ND2D1_LVT_ELT clk2G56psGate_preserve (
    .A1(clk2G56seint),
    .A2(enablePSSE),
    .ZN(clk2G56psBar)
    );

INVD1_LVT_ELT clk40MpsInv_preserve (
    .I(clk40MpsBar),
    .ZN(clk40Mps)
    );

INVD1_LVT_ELT clk80MpsInv_preserve (
    .I(clk80MpsBar),
    .ZN(clk80Mps)
    );

INVD1_LVT_ELT clk160MpsInv_preserve (
    .I(clk160MpsBar),
    .ZN(clk160Mps)
    );

INVD1_LVT_ELT clk320MpsInv_preserve (
    .I(clk320MpsBar),
    .ZN(clk320Mps)
    );

INVD1_LVT_ELT clk640MpsInv_preserve (
    .I(clk640MpsBar),
    .ZN(clk640Mps)
    );

INVD1_LVT_ELT clk1G28psInv_preserve (
    .I(clk1G28psBar),
    .ZN(clk1G28ps)
    );

INVD1_LVT_ELT clk2G56psInv_preserve (
    .I(clk2G56psBar),
    .ZN(clk2G56ps)
    );

majorityVoterBalanced enablePhaseShifterVoter (
    .inA(enablePhaseShifterA),
    .inB(enablePhaseShifterB),
    .inC(enablePhaseShifterC),
    .out(enablePhaseShifter),
    .tmrErr(enablePhaseShifterTmrError)
    );

majorityVoterBalanced enableDesVoter (
    .inA(enableDesA),
    .inB(enableDesB),
    .inC(enableDesC),
    .out(enableDes),
    .tmrErr(enableDesTmrError)
    );

majorityVoterBalanced clk80MintVoter (
    .inA(clk80MintA),
    .inB(clk80MintB),
    .inC(clk80MintC),
    .out(clk80Mint),
    .tmrErr(clk80MintTmrError)
    );

majorityVoterBalanced eclk320MEnableVoter (
    .inA(eclk320MEnableA),
    .inB(eclk320MEnableB),
    .inC(eclk320MEnableC),
    .out(eclk320MEnable),
    .tmrErr(eclk320MEnableTmrError)
    );

majorityVoterBalanced eclk2G56EnableVoter (
    .inA(eclk2G56EnableA),
    .inB(eclk2G56EnableB),
    .inC(eclk2G56EnableC),
    .out(eclk2G56Enable),
    .tmrErr(eclk2G56EnableTmrError)
    );

majorityVoterBalanced enableSerVoter (
    .inA(enableSerA),
    .inB(enableSerB),
    .inC(enableSerC),
    .out(enableSer),
    .tmrErr(enableSerTmrError)
    );

majorityVoterBalanced clk40MintVoter (
    .inA(clk40MintA),
    .inB(clk40MintB),
    .inC(clk40MintC),
    .out(clk40Mint),
    .tmrErr(clk40MintTmrError)
    );

majorityVoterBalanced eclk160MEnableVoter (
    .inA(eclk160MEnableA),
    .inB(eclk160MEnableB),
    .inC(eclk160MEnableC),
    .out(eclk160MEnable),
    .tmrErr(eclk160MEnableTmrError)
    );

majorityVoterBalanced eclk1G28EnableVoter (
    .inA(eclk1G28EnableA),
    .inB(eclk1G28EnableB),
    .inC(eclk1G28EnableC),
    .out(eclk1G28Enable),
    .tmrErr(eclk1G28EnableTmrError)
    );

majorityVoterBalanced eclk40MEnableVoter (
    .inA(eclk40MEnableA),
    .inB(eclk40MEnableB),
    .inC(eclk40MEnableC),
    .out(eclk40MEnable),
    .tmrErr(eclk40MEnableTmrError)
    );

majorityVoterBalanced clkTreeBDisableVoter (
    .inA(clkTreeBDisableA),
    .inB(clkTreeBDisableB),
    .inC(clkTreeBDisableC),
    .out(clkTreeBDisable),
    .tmrErr(clkTreeBDisableTmrError)
    );

majorityVoterBalanced eclk80MEnableVoter (
    .inA(eclk80MEnableA),
    .inB(eclk80MEnableB),
    .inC(eclk80MEnableC),
    .out(eclk80MEnable),
    .tmrErr(eclk80MEnableTmrError)
    );

majorityVoterBalanced clkTreeCDisableVoter (
    .inA(clkTreeCDisableA),
    .inB(clkTreeCDisableB),
    .inC(clkTreeCDisableC),
    .out(clkTreeCDisable),
    .tmrErr(clkTreeCDisableTmrError)
    );

majorityVoterBalanced clk1G28intVoter (
    .inA(clk1G28intA),
    .inB(clk1G28intB),
    .inC(clk1G28intC),
    .out(clk1G28int),
    .tmrErr(clk1G28intTmrError)
    );

majorityVoterBalanced clk160MintVoter (
    .inA(clk160MintA),
    .inB(clk160MintB),
    .inC(clk160MintC),
    .out(clk160Mint),
    .tmrErr(clk160MintTmrError)
    );

majorityVoterBalanced clk320MintVoter (
    .inA(clk320MintA),
    .inB(clk320MintB),
    .inC(clk320MintC),
    .out(clk320Mint),
    .tmrErr(clk320MintTmrError)
    );

majorityVoterBalanced clk640MintVoter (
    .inA(clk640MintA),
    .inB(clk640MintB),
    .inC(clk640MintC),
    .out(clk640Mint),
    .tmrErr(clk640MintTmrError)
    );

majorityVoterBalanced clk2G56intVoter (
    .inA(clk2G56intA),
    .inB(clk2G56intB),
    .inC(clk2G56intC),
    .out(clk2G56int),
    .tmrErr(clk2G56intTmrError)
    );

majorityVoterBalanced eclk640MEnableVoter (
    .inA(eclk640MEnableA),
    .inB(eclk640MEnableB),
    .inC(eclk640MEnableC),
    .out(eclk640MEnable),
    .tmrErr(eclk640MEnableTmrError)
    );

majorityVoterBalanced clkTreeADisableVoter (
    .inA(clkTreeADisableA),
    .inB(clkTreeADisableB),
    .inC(clkTreeADisableC),
    .out(clkTreeADisable),
    .tmrErr(clkTreeADisableTmrError)
    );

majorityVoterBalanced #(.WIDTH(5)) clockDividerNextVoterA (
    .inA(clockDividerNextA),
    .inB(clockDividerNextB),
    .inC(clockDividerNextC),
    .out(clockDividerNextVotedA),
    .tmrErr(clockDividerNextTmrErrorA)
    );

majorityVoterBalanced #(.WIDTH(5)) clockDividerNextVoterB (
    .inA(clockDividerNextA),
    .inB(clockDividerNextB),
    .inC(clockDividerNextC),
    .out(clockDividerNextVotedB),
    .tmrErr(clockDividerNextTmrErrorB)
    );

majorityVoterBalanced #(.WIDTH(5)) clockDividerNextVoterC (
    .inA(clockDividerNextA),
    .inB(clockDividerNextB),
    .inC(clockDividerNextC),
    .out(clockDividerNextVotedC),
    .tmrErr(clockDividerNextTmrErrorC)
    );

endmodule
