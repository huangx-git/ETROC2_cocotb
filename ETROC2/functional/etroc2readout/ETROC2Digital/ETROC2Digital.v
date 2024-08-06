//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL
// Author:      Quan Sun
// 
// Create Date:    Dec. 17th, 2021
// Design Name:    ETROC2
// Module Name:    ETROC2Readout
// Project Name:   ETROC2
// Description: top-level RTL of ETROC2Readout
//
// Dependencies: ...
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////

module ETROC2Digital #(
  parameter L1ADDRWIDTH=7,
  parameter BCSTWIDTH=27
)(
     input  clk40A,
     input  clk40B,
     input  clk40C,
     input  clk1280A,
     input  clk1280B,
     input  clk1280C,
     input  clkRefA,
     input  clkRefB,
     input  clkRefC,
     input  resetA,
     input  resetB,
     input  resetC,
     input  clkTDC,
     input  strobeTDC,
     input [16:0] chipIdA,
     input [16:0] chipIdB,
     input [16:0] chipIdC,
     input [4:0] readoutClockDelayPixelA,
     input [4:0] readoutClockDelayPixelB,
     input [4:0] readoutClockDelayPixelC,
     input [4:0] readoutClockWidthPixelA,
     input [4:0] readoutClockWidthPixelB,
     input [4:0] readoutClockWidthPixelC,
     input [4:0] readoutClockDelayGlobalA,
     input [4:0] readoutClockDelayGlobalB,
     input [4:0] readoutClockDelayGlobalC,
     input [4:0] readoutClockWidthGlobalA,
     input [4:0] readoutClockWidthGlobalB,
     input [4:0] readoutClockWidthGlobalC,
     input [1:0] serRateRightA,
     input [1:0] serRateRightB,
     input [1:0] serRateRightC,
     input [1:0] serRateLeftA,
     input [1:0] serRateLeftB,
     input [1:0] serRateLeftC,
     input  linkResetSlowControlA,
     input  linkResetSlowControlB,
     input  linkResetSlowControlC,
     input  linkResetTestPatternA,
     input  linkResetTestPatternB,
     input  linkResetTestPatternC,
     input [31:0] linkResetFixedPatternA,
     input [31:0] linkResetFixedPatternB,
     input [31:0] linkResetFixedPatternC,
     input [11:0] emptySlotBCIDA,
     input [11:0] emptySlotBCIDB,
     input [11:0] emptySlotBCIDC,
     input [2:0] triggerGranularityA,
     input [2:0] triggerGranularityB,
     input [2:0] triggerGranularityC,
     input  disScramblerA,
     input  disScramblerB,
     input  disScramblerC,
     input  mergeTriggerDataA,
     input  mergeTriggerDataB,
     input  mergeTriggerDataC,
     input  singlePortA,
     input  singlePortB,
     input  singlePortC,
     input [1:0] onChipL1AConfA,
     input [1:0] onChipL1AConfB,
     input [1:0] onChipL1AConfC,
     input [11:0] BCIDoffsetA,
     input [11:0] BCIDoffsetB,
     input [11:0] BCIDoffsetC,
     input  fcSelfAlignA,
     input  fcSelfAlignB,
     input  fcSelfAlignC,
     input  fcAlignStartA,
     input  fcAlignStartB,
     input  fcAlignStartC,
     input  fcClkDelayEnA,
     input  fcClkDelayEnB,
     input  fcClkDelayEnC,
     input  fcDataDelayEnA,
     input  fcDataDelayEnB,
     input  fcDataDelayEnC,
     output  fcBitAlignErrorA,
     output  fcBitAlignErrorB,
     output  fcBitAlignErrorC,
     output [3:0] fcBitAlignStatusA,
     output [3:0] fcBitAlignStatusB,
     output [3:0] fcBitAlignStatusC,
     input  fcData,
     output [3:0] fcAlignFinalStateA,
     output [3:0] fcAlignFinalStateB,
     output [3:0] fcAlignFinalStateC,
     input [4:0] chargeInjectionDelayA,
     input [4:0] chargeInjectionDelayB,
     input [4:0] chargeInjectionDelayC,
     output  wsStartA,
     output  wsStartB,
     output  wsStartC,
     output  wsStopA,
     output  wsStopB,
     output  wsStopC,

     output  soutRight,
     output  soutLeft,

     input PORA,
     input PORB,
     input PORC,
     input softBootA,
     input softBootB,
     input softBootC,
     input  disPowerSequenceA,
     input  disPowerSequenceB,
     input  disPowerSequenceC,
     input  pllCalibrationDoneA,
     input  pllCalibrationDoneB,
     input  pllCalibrationDoneC,
     input  asyLinkResetA,
     input  asyLinkResetB,
     input  asyLinkResetC,
     input  asyPLLResetA,
     input  asyPLLResetB,
     input  asyPLLResetC,
     input  asyAlignFastcommandA,
     input  asyAlignFastcommandB,
     input  asyAlignFastcommandC,
     input  asyResetFastcommandA,
     input  asyResetFastcommandB,
     input  asyResetFastcommandC,
     input  asyStartCalibrationA,
     input  asyStartCalibrationB,
     input  asyStartCalibrationC,
     input  asyResetLockDetectA,
     input  asyResetLockDetectB,
     input  asyResetLockDetectC,
     input  asyResetGlobalReadoutA,
     input  asyResetGlobalReadoutB,
     input  asyResetGlobalReadoutC,
     input  asyResetChargeInjA,
     input  asyResetChargeInjB,
     input  asyResetChargeInjC,
     output  pllResetA,
     output  pllResetB,
     output  pllResetC,
     output  startPLLCalibrationA,
     output  startPLLCalibrationB,
     output  startPLLCalibrationC,
     output [3:0] controllerStateA,
     output [3:0] controllerStateB,
     output [3:0] controllerStateC,
     output [11:0] pllUnlockCountA,
     output [11:0] pllUnlockCountB,
     output [11:0] pllUnlockCountC,
     output [11:0] invalidFCCountA,
     output [11:0] invalidFCCountB,
     output [11:0] invalidFCCountC,
     input  PFDInstLock,
     input [3:0] lfLockThrCounterA,
     input [3:0] lfLockThrCounterB,
     input [3:0] lfLockThrCounterC,
     input [3:0] lfReLockThrCounterA,
     input [3:0] lfReLockThrCounterB,
     input [3:0] lfReLockThrCounterC,
     input [3:0] lfUnLockThrCounterA,
     input [3:0] lfUnLockThrCounterB,
     input [3:0] lfUnLockThrCounterC,

     output fc_bitErrorA,
     output fc_bitErrorB,
     output fc_bitErrorC,
     output [3:0] fc_edA,
     output [3:0] fc_edB,
     output [3:0] fc_edC,
     output [3:0] fc_state_bitAlignA,
     output [3:0] fc_state_bitAlignB,
     output [3:0] fc_state_bitAlignC
     
);

wire readoutClock;
wire [255:0] strobeTDC_inPix;
wire [255:0] clkTDC_inPix;
wire [255:0] clkRO_inPix;
wire [255:0] QInj_inPix;

wire [735:0] colDataChain;
wire [15:0] colHitChain;
wire [63:0] trigHitsColumn;
wire [15:0] colReadChain;
wire [BCSTWIDTH*16-1:0] colBCSTChain;



wire clk40;
wire clk1280;
wire synStartCalibration;
wire pllCalibrationDone;
wire instantLock;
wire synPLLReset;



sixteenCols sixteenCols_Inst(
	.clkRO(clkRO_inPix),
	.clkTDC(clkTDC_inPix),
	.strobeTDC(strobeTDC_inPix),
	.QInj(QInj_inPix),
	.colDataChain(colDataChain),         //46*16
	.colHitChain(colHitChain),
    	.trigHitsColumn(trigHitsColumn),       //output to global readout
	.colReadChain(colReadChain),
	.colBCSTChain(colBCSTChain)
);


clockTreeModel clockTreeModel_INST(
	.TDC_Strobe_IN(strobeTDC),			// TDC strobe input signal at 320 MHz from clock generator.
	.CLK40TDC_IN(clkTDC),				// TDC 40 MHz input clock from clock generator.
	.CLK40RO_IN(readoutClock),				// 40 MHz readout input clock from clock generator.
	.ChargeInj_IN(chargeInjection),				// Charge injection input from QInj module.

	.TDC_Strobe_OUT(strobeTDC_inPix),	// TDC strobe fan out to pixel.
	.CLK40TDC_OUT(clkTDC_inPix),	// TDC 40 MHz fan out to pixel.
	.CLK40RO_OUT(clkRO_inPix),		// 40 MHz readout fan out to pixel.
	.ChargeInj_OUT(QInj_inPix)	// Charge injection fan out to pixel.
);







`ifdef GLOBALTMR
//   wire pllCalibrationDoneB;
//   wire pllCalibrationDoneC;
   wire synPLLResetB;
   wire synPLLResetC;
   wire synStartCalibrationB;
   wire synStartCalibrationC; 
   //wire [3:0] controllerStateB;
   //wire [3:0] controllerStateC;
   //wire [11:0] pllUnlockCountB;
   //wire [11:0] pllUnlockCountC;
    //wire [11:0] invalidFCCountB;
    //wire [11:0] invalidFCCountC;
    //wire fc_bitErrorB;
    //wire fc_bitErrorC;
    //wire [3:0] fc_edB;
    //wire [3:0] fc_edC;
    //wire [3:0] fc_state_bitAlignB;    
    //wire [3:0] fc_state_bitAlignC;    

	

   globalDigitalTMR #(.L1ADDRWIDTH(`L1BUFFER_ADDRWIDTH),.BCSTWIDTH(BCSTWIDTH))globalDigitalTMRInst(
     .clk40A(clk40A),
     .clk40B(clk40B),
     .clk40C(clk40C),
     .clk1280A(clk1280A),
     .clk1280B(clk1280B),
     .clk1280C(clk1280C),
     .clkRefA(clkRefA),
     .clkRefB(clkRefB),
     .clkRefC(clkRefC),
     .PORA(PORA),
     .PORB(PORB),
     .PORC(PORC),
     .softBootA(softBootA),
     .softBootB(softBootA),
     .softBootC(softBootA),
     .disPowerSequenceA(disPowerSequenceA),
     .disPowerSequenceB(disPowerSequenceB),
     .disPowerSequenceC(disPowerSequenceC),
     .pllCalibrationDoneA(pllCalibrationDone),
     .pllCalibrationDoneB(pllCalibrationDone),
     .pllCalibrationDoneC(pllCalibrationDone),
     .asyLinkResetA(asyLinkResetA),
     .asyLinkResetB(asyLinkResetB),
     .asyLinkResetC(asyLinkResetC),
     .asyPLLResetA(asyPLLResetA),
     .asyPLLResetB(asyPLLResetB),
     .asyPLLResetC(asyPLLResetC),
     .asyAlignFastcommandA(asyAlignFastcommandA),
     .asyAlignFastcommandB(asyAlignFastcommandB),
     .asyAlignFastcommandC(asyAlignFastcommandC),
     .asyResetFastcommandA(asyResetFastcommandA),
     .asyResetFastcommandB(asyResetFastcommandB),
     .asyResetFastcommandC(asyResetFastcommandC),
     .asyStartCalibrationA(asyStartCalibrationA),
     .asyStartCalibrationB(asyStartCalibrationB),
     .asyStartCalibrationC(asyStartCalibrationC),
     .asyResetLockDetectA(asyResetLockDetectA),
     .asyResetLockDetectB(asyResetLockDetectB),
     .asyResetLockDetectC(asyResetLockDetectC),
     .asyResetGlobalReadoutA(asyResetGlobalReadoutA),
     .asyResetGlobalReadoutB(asyResetGlobalReadoutB),
     .asyResetGlobalReadoutC(asyResetGlobalReadoutC),
     .asyResetChargeInjA(asyResetChargeInjA),
     .asyResetChargeInjB(asyResetChargeInjB),
     .asyResetChargeInjC(asyResetChargeInjC),
     .pllResetA(pllResetA),
     .pllResetB(pllResetB),
     .pllResetC(pllResetB),
     .startPLLCalibrationA(startPLLCalibrationA),
     .startPLLCalibrationB(startPLLCalibrationB),
     .startPLLCalibrationC(startPLLCalibrationC),
     .controllerStateA(controllerStateA),
     .controllerStateB(controllerStateB),
     .controllerStateC(controllerStateC),
     .pllUnlockCountA(pllUnlockCountA),
     .pllUnlockCountB(pllUnlockCountB),
     .pllUnlockCountC(pllUnlockCountC),
     .invalidFCCountA(invalidFCCountA),
     .invalidFCCountB(invalidFCCountB),
     .invalidFCCountC(invalidFCCountC),
     .PFDInstLock(instantLock),
     .lfLockThrCounterA(4'd8),
     .lfLockThrCounterB(4'd8),
     .lfLockThrCounterC(4'd8),
     .lfReLockThrCounterA(4'd8),
     .lfReLockThrCounterB(4'd8),
     .lfReLockThrCounterC(4'd8),
     .lfUnLockThrCounterA(4'd8),
     .lfUnLockThrCounterB(4'd8),
     .lfUnLockThrCounterC(4'd8),
     .readoutClock(readoutClock),
     .chipIdA(chipIdA),
     .chipIdB(chipIdB),
     .chipIdC(chipIdC),
     .readoutClockDelayPixelA(5'd0),
     .readoutClockDelayPixelB(5'd0),
     .readoutClockDelayPixelC(5'd0),
     .readoutClockWidthPixelA(5'd16),
     .readoutClockWidthPixelB(5'd16),
     .readoutClockWidthPixelC(5'd16),
     .readoutClockDelayGlobalA(5'd0),
     .readoutClockDelayGlobalB(5'd0),
     .readoutClockDelayGlobalC(5'd0),
     .readoutClockWidthGlobalA(5'd16),
     .readoutClockWidthGlobalB(5'd16),
     .readoutClockWidthGlobalC(5'd16),
     .serRateRightA(serRateRightA),
     .serRateRightB(serRateRightB),
     .serRateRightC(serRateRightC),
     .serRateLeftA(serRateLeftA),
     .serRateLeftB(serRateLeftB),
     .serRateLeftC(serRateLeftC),
     .linkResetTestPatternA(1'b1),
     .linkResetTestPatternB(1'b1),
     .linkResetTestPatternC(1'b1),
     .linkResetFixedPatternA(32'h3C5C3C5A),
     .linkResetFixedPatternB(32'h3C5C3C5A),
     .linkResetFixedPatternC(32'h3C5C3C5A),
     .emptySlotBCIDA(12'd1177),
     .emptySlotBCIDB(12'd1177),
     .emptySlotBCIDC(12'd1177),
     .triggerGranularityA(triggerGranularityA),
     .triggerGranularityB(triggerGranularityB),
     .triggerGranularityC(triggerGranularityC),
     .disScramblerA(disScramblerA),
     .disScramblerB(disScramblerB),
     .disScramblerC(disScramblerC),
     .mergeTriggerDataA(mergeTriggerDataA),
     .mergeTriggerDataB(mergeTriggerDataB),
     .mergeTriggerDataC(mergeTriggerDataC),
     .singlePortA(singlePortA),
     .singlePortB(singlePortB),
     .singlePortC(singlePortC),
     .onChipL1AConfA(2'b11),
     .onChipL1AConfB(2'b11),
     .onChipL1AConfC(2'b11),
     .BCIDoffsetA(12'h000),
     .BCIDoffsetB(12'h000),
     .BCIDoffsetC(12'h000),
     .fcSelfAlignA(1'b1),
     .fcSelfAlignB(1'b1),
     .fcSelfAlignC(1'b1),
     .fcClkDelayEnA(1'b0),
     .fcClkDelayEnB(1'b0),
     .fcClkDelayEnC(1'b0),
     .fcDataDelayEnA(1'b0),
     .fcDataDelayEnB(1'b0),
     .fcDataDelayEnC(1'b0),
     .fcBitAlignErrorA(fcBitAlignErrorA),
     .fcBitAlignErrorB(fcBitAlignErrorB),
     .fcBitAlignErrorC(fcBitAlignErrorC),
     .fcBitAlignStatusA(fcBitAlignStatusA),
     .fcBitAlignStatusB(fcBitAlignStatusB),
     .fcBitAlignStatusC(fcBitAlignStatusC),
     .fcData(fcData),
     .fcAlignFinalStateA(fcAlignFinalStateA),
     .fcAlignFinalStateB(fcAlignFinalStateB),
     .fcAlignFinalStateC(fcAlignFinalStateC),
     .chargeInjection(chargeInjection),
     .chargeInjectionDelayA(5'd24),
     .chargeInjectionDelayB(5'd24),
     .chargeInjectionDelayC(5'd24),
     .wsStart(ws_start),
     .wsStop(ws_stop),
     .colDataChain(colDataChain),
     .colHitChain(colHitChain),
     .trigHitsColumn(trigHitsColumn),
     .colReadChain(colReadChain),
     .colBCSTChain(colBCSTChain),
     .soutRight(soutRight),
     .soutLeft(soutLeft)
);
`else 
   globalDigital #(.L1ADDRWIDTH(`L1BUFFER_ADDRWIDTH),.BCSTWIDTH(BCSTWIDTH))globalDigitalTMRInst(
 //use same instance name 
 //clock and reset signals
	    .clk40(clk40),            //40MHz
        .clk1280(clk1280),
        .clkRef(clkRef),
        .POR(POR),
        .softBoot(softBoot),
        .disPowerSequence(1'b0),
        .pllCalibrationDone(pllCalibrationDone),
        // .reset(dnReset),        //reset by slow control? 
        .readoutClock(readoutClock),
        .chipId(chipId),
//input I2C reset/start, no asyn reset, need to test later.
        .asyLinkReset(1'b1), 
        .asyPLLReset(1'b1),
        .asyAlignFastcommand(1'b1),
        .asyResetFastcommand(1'b1),
        .asyStartCalibration(1'b0),
        .asyResetLockDetect(1'b1),
        .asyResetGlobalReadout(asyResetGlobalReadout),
        .asyResetChargeInj(1'b1),
//output sync 
        .pllReset(synPLLReset),
        .startPLLCalibration(synStartCalibration),
        .controllerState(controllerState),
        .pllUnlockCount(pllUnlockCount),
        .invalidFCCount(invalidFCCount),

//
        .PFDInstLock(instantLock),
        .lfLockThrCounter(4'd8),
        .lfReLockThrCounter(4'd8),
        .lfUnLockThrCounter(4'd8),
//slow control configuration
    //serializer
        .readoutClockDelayPixel(5'd0),
        .readoutClockWidthPixel(5'd16),
        .readoutClockDelayGlobal(5'd0),
        .readoutClockWidthGlobal(5'd16),
        .serRateRight(rateRight),
        .serRateLeft(rateLeft),
        // .linkResetSlowControl(1'b0),
        .linkResetTestPattern(1'b1),
        .linkResetFixedPattern(32'h3C5C3C5A),
    //trigger
        .emptySlotBCID(12'd1177),
        .triggerGranularity(triggerGranularity),
    //frame builder
        .disScrambler(disSCR),
    //data source switcher
        .mergeTriggerData(mergeTrigData),
        .singlePort(singlePort),
    //test pattern
	    .onChipL1AConf(2'b11),          
    //BCID counter
        .BCIDoffset(12'h000),
//fast command  
        .fcSelfAlign(1'b1),
        // .fcAlignStart(fccAlign),
        .fcClkDelayEn(1'b0),
        .fcDataDelayEn(1'b0),
    //slow control status
        .fcBitAlignError(fc_bitError),
        .fcBitAlignStatus(fc_ed),
//fast command interface
        .fcData(fc_fc),
        .fcAlignFinalState(fc_state_bitAlign),
//frontend
        .chargeInjection(chargeInjection),
        .chargeInjectionDelay(5'd24),
//waveform sampler
        .wsStart(ws_start),
        .wsStop(ws_stop),
//pixel interface over SW network
        .colDataChain(colDataChain),
        .colHitChain(colHitChain),
        .trigHitsColumn(trigHitsColumn),
        .colReadChain(colReadChain),
        .colBCSTChain(colBCSTChain),
//output to serializer
        .soutRight(soutRight),   //serializer output
        .soutLeft(soutLeft)   //serializer output
    );       
`endif



endmodule
