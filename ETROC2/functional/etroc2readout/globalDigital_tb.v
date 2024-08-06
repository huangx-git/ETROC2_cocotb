`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Tue Oct 19 10:30:06 CDT 2021
// Module Name: globalDigital_tb
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"
//`define TEST_SERRIALIZER_1280
//`define TEST_SERRIALIZER_640
//`define TEST_SERRIALIZER_320
`define TEST_SCRAMBLER
//`define GLOBALTMR
`define NTC
module globalDigital_tb;

    localparam BCSTWIDTH = `L1BUFFER_ADDRWIDTH*2+11+2;

    localparam fc_IDLE 		= 8'b1111_0000; //2'hF0 -->n_fc = 0--3'h001 
    localparam fc_L1A_CR    = 8'H66;

	reg clkRef;
    reg clk1280i;           //idea clock
    reg clk640i;             //idea clock
    reg clk320i;             //idea clock
    // reg fccAlign;
    reg [16:0] chipId;

    reg [2:0] cnt_fc;
    reg [7:0] fc_byte;
    reg [19:0] clkCount; //count 25 ns
    wire [3:0] controllerState;
    reg [3:0] controllerStateReg1;
    reg [3:0] controllerStateReg2;
    wire initializeDone = (controllerStateReg1 == 4'd11 && controllerStateReg2 !=4'd11);
    reg [15:0] initializeDoneDelay;
    always @(posedge clkRef)
    begin
        clkCount <= clkCount + 1;
        controllerStateReg1 <= controllerState;
        controllerStateReg2 <= controllerStateReg1;
        initializeDoneDelay <= {initializeDoneDelay[14:0],initializeDone};
    end


    always@(posedge clk320i) begin
        cnt_fc <= cnt_fc + 1;
        if(cnt_fc==3'd0)
            //  if(clkCount == 20'd1200)
             if(initializeDoneDelay[14] == 1'b1)
                fc_byte <= fc_L1A_CR;
            else if (initializeDoneDelay[15] == 1'b1)
                fc_byte <= 8'HF7; //an invalid command
            else 
                fc_byte <= fc_IDLE;
        else
            fc_byte[7:0] <= {fc_byte[6:0],fc_byte[7]}; //shift 8-bit parallel fc in 40 MHz period, serializing to 1 bit
    end

    wire fc_fc;
    assign fc_fc = fc_byte[7];

    reg initReset;
    reg reset2;
    reg dnReset;
    reg [1:0] rateRight; //serializer speed
    reg [1:0] rateLeft; //serializer speed
    reg [6:0] ocp;
    reg disSCR;
    reg mergeTrigData;
    reg singlePort;
    reg asyResetGlobalReadout;

    wire clk40;
    wire clk1280;
    wire synStartCalibration;
    wire pllCalibrationDone;
    wire instantLock;
    wire synPLLReset;
    simplePLL pll
    (
        .clk40Ref(clkRef),
        .asynReset(synPLLReset),
        .clk1280In(clk1280i),
        .calibrationTime(12'd23),
        .lockTime(12'd35),
        .pllCalibrationDone(pllCalibrationDone),
        .startCalibration(synStartCalibration),
        .clk1280(clk1280),
        .clk40(clk40),
        .instantLock(instantLock)
    );

    // wire [1:0] rate;

    wire [735:0] colDataChain;
    wire [15:0] colHitChain;
    wire [63:0] trigHitsColumn;
    wire [15:0] colReadChain;
    wire [BCSTWIDTH*16-1:0] colBCSTChain;

    wire readoutClock;  //readout clock from globalDigital
    wire pixelReadoutClock;
`ifndef HTreeDLY_ON
    assign pixelReadoutClock = readoutClock;
`else
    assign #(`HTREE_MIN_DELAY : `HTREE_TYP_DELAY :`HTREE_MAX_DELAY) pixelReadoutClock = readoutClock;
`endif
    reg [255:0] disDataReadoutArray;
    reg [255:0] disDataTriggerArray;

    sixteenColPixels #(.L1ADDRWIDTH(`L1BUFFER_ADDRWIDTH),.BCSTWIDTH(BCSTWIDTH))sixteenColPixelsInst(
        .clk(pixelReadoutClock),            //40MHz
	    .workMode(2'b10),          //selfTest or not
        .L1ADelay(9'd501),
        .TDCDataArray({8448{1'b0}}),  
	    .selfTestOccupancy(ocp),  //0.1%, 1%, 2%, 5%, 10% etc
        .disDataReadout(disDataReadoutArray),
        .disTrigPath(disDataTriggerArray),
        .upperTOATrig(10'h3FF),
        .lowerTOATrig(10'h000),
        .upperTOTTrig(9'h1FF),
        .lowerTOTTrig(9'h000),
        .upperCalTrig(10'h3FF),
        .lowerCalTrig(10'h000),
        .upperTOA(10'h3FF),
        .lowerTOA(10'h000),
        .upperTOT(9'h1FF),
        .lowerTOT(9'h000),
        .upperCal(10'h3FF),
        .lowerCal(10'h000),
        .addrOffset(1'b1),
        .colDataChain(colDataChain),
        .colHitChain(colHitChain),
        .trigHitsColumn(trigHitsColumn),
        .colReadChain(colReadChain),
        .colBCSTChain(colBCSTChain)
    );

    wire soutRight;
    wire [2:0] triggerGranularity = 3'd2;

    wire soutLeft;
    wire ws_start;
    wire ws_stop;
    wire chargeInjection;
    wire [3:0] fc_state_bitAlign;    

    wire [3:0] fc_ed;
    wire fc_bitError;
    wire [11:0] pllUnlockCount;
    wire [11:0] invalidFCCount;

    reg POR;
    reg softBoot;
`ifdef GLOBALTMR
//   wire pllCalibrationDoneB;
//   wire pllCalibrationDoneC;
   wire synPLLResetB;
   wire synPLLResetC;
   wire synStartCalibrationB;
   wire synStartCalibrationC; 
   wire [3:0] controllerStateB;
   wire [3:0] controllerStateC;
   wire [11:0] pllUnlockCountB;
   wire [11:0] pllUnlockCountC;
    wire [11:0] invalidFCCountB;
    wire [11:0] invalidFCCountC;
    wire fc_bitErrorB;
    wire fc_bitErrorC;
    wire [3:0] fc_edB;
    wire [3:0] fc_edC;
    wire [3:0] fc_state_bitAlignB;    
    wire [3:0] fc_state_bitAlignC;    
`ifdef GLOBAL_POST_SIM
   globalDigitalTMR globalDigitalTMRInst(
`else
   globalDigitalTMR #(.L1ADDRWIDTH(`L1BUFFER_ADDRWIDTH),.BCSTWIDTH(BCSTWIDTH))globalDigitalTMRInst(
`endif
     .clk40A(clk40),
     .clk40B(clk40),
     .clk40C(clk40),
     .clk1280A(clk1280),
     .clk1280B(clk1280),
     .clk1280C(clk1280),
     .clkRefA(clkRef),
     .clkRefB(clkRef),
     .clkRefC(clkRef),
     .PORA(POR),
     .PORB(POR),
     .PORC(POR),
     .softBootA(softBoot),
     .softBootB(softBoot),
     .softBootC(softBoot),
     .disPowerSequenceA(1'b0),
     .disPowerSequenceB(1'b0),
     .disPowerSequenceC(1'b0),
     .pllCalibrationDoneA(pllCalibrationDone),
     .pllCalibrationDoneB(pllCalibrationDone),
     .pllCalibrationDoneC(pllCalibrationDone),
     .asyLinkResetA(1'b0),
     .asyLinkResetB(1'b0),
     .asyLinkResetC(1'b0),
     .asyPLLResetA(1'b1),
     .asyPLLResetB(1'b1),
     .asyPLLResetC(1'b1),
     .asyAlignFastcommandA(1'b1),
     .asyAlignFastcommandB(1'b1),
     .asyAlignFastcommandC(1'b1),
     .asyResetFastcommandA(1'b1),
     .asyResetFastcommandB(1'b1),
     .asyResetFastcommandC(1'b1),
     .asyStartCalibrationA(1'b0),
     .asyStartCalibrationB(1'b0),
     .asyStartCalibrationC(1'b0),
     .asyResetLockDetectA(1'b1),
     .asyResetLockDetectB(1'b1),
     .asyResetLockDetectC(1'b1),
     .asyResetGlobalReadoutA(asyResetGlobalReadout),
     .asyResetGlobalReadoutB(asyResetGlobalReadout),
     .asyResetGlobalReadoutC(asyResetGlobalReadout),
     .asyResetChargeInjA(1'b1),
     .asyResetChargeInjB(1'b1),
     .asyResetChargeInjC(1'b1),
     .pllResetA(synPLLReset),
     .pllResetB(synPLLResetB),
     .pllResetC(synPLLResetC),
     .startPLLCalibrationA(synStartCalibration),
     .startPLLCalibrationB(synStartCalibrationB),
     .startPLLCalibrationC(synStartCalibrationC),
     .controllerStateA(controllerState),
     .controllerStateB(controllerStateB),
     .controllerStateC(controllerStateC),
     .pllUnlockCountA(pllUnlockCount),
     .pllUnlockCountB(pllUnlockCountB),
     .pllUnlockCountC(pllUnlockCountC),
     .invalidFCCountA(invalidFCCount),
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
     .chipIdA(chipId),
     .chipIdB(chipId),
     .chipIdC(chipId),
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
     .serRateRightA(rateRight),
     .serRateRightB(rateRight),
     .serRateRightC(rateRight),
     .serRateLeftA(rateLeft),
     .serRateLeftB(rateLeft),
     .serRateLeftC(rateLeft),
     .linkResetTestPatternA(1'b1),
     .linkResetTestPatternB(1'b1),
     .linkResetTestPatternC(1'b1),
     .linkResetFixedPatternA(32'h3C5C3C5A),
     .linkResetFixedPatternB(32'h3C5C3C5A),
     .linkResetFixedPatternC(32'h3C5C3C5A),
     .emptySlotBCIDA(12'd1177),
     .emptySlotBCIDB(12'd1177),
     .emptySlotBCIDC(12'd1177),
     .triggerGranularityA(triggerGranularity),
     .triggerGranularityB(triggerGranularity),
     .triggerGranularityC(triggerGranularity),
     .disScramblerA(disSCR),
     .disScramblerB(disSCR),
     .disScramblerC(disSCR),
     .mergeTriggerDataA(mergeTrigData),
     .mergeTriggerDataB(mergeTrigData),
     .mergeTriggerDataC(mergeTrigData),
     .singlePortA(singlePort),
     .singlePortB(singlePort),
     .singlePortC(singlePort),
     .onChipL1AConfA(2'b11),
     .onChipL1AConfB(2'b11),
     .onChipL1AConfC(2'b11),
     .BCIDoffsetA(12'h000),
     .BCIDoffsetB(12'h000),
     .BCIDoffsetC(12'h000),
     .fcSelfAlignA(1'b0),
     .fcSelfAlignB(1'b0),
     .fcSelfAlignC(1'b0),
     .fcClkDelayEnA(1'b0),
     .fcClkDelayEnB(1'b0),
     .fcClkDelayEnC(1'b0),
     .fcDataDelayEnA(1'b1),
     .fcDataDelayEnB(1'b1),
     .fcDataDelayEnC(1'b1),
     .fcBitAlignErrorA(fc_bitError),
     .fcBitAlignErrorB(fc_bitErrorB),
     .fcBitAlignErrorC(fc_bitErrorC),
     .fcBitAlignStatusA(fc_ed),
     .fcBitAlignStatusB(fc_edB),
     .fcBitAlignStatusC(fc_edC),
     .fcData(fc_fc),
     .fcAlignFinalStateA(fc_state_bitAlign),
     .fcAlignFinalStateB(fc_state_bitAlignB),
     .fcAlignFinalStateC(fc_state_bitAlignC),
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
        .asyLinkReset(1'b0), 
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
        .fcSelfAlign(1'b0),
        // .fcAlignStart(fccAlign),
        .fcClkDelayEn(1'b0),
        .fcDataDelayEn(1'b1),
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

    wire [4:0] trigDataSizeRight;
    wire [4:0] trigDataSizeLeft;
    wire [4:0] trigDataSize;
    assign trigDataSize =    triggerGranularity == 3'd1 ? 5'd1 : 
                            (triggerGranularity == 3'd2 ? 5'd2 :
                            (triggerGranularity == 3'd3 ? 5'd4 :
                            (triggerGranularity == 3'd4 ? 5'd8 :
                            (triggerGranularity == 3'd5 ? 5'd16 : 5'd0))));
    assign trigDataSizeRight =  singlePort ? trigDataSize : 
                                (mergeTrigData ? trigDataSize >> 1 : 5'd0); 
    assign trigDataSizeLeft =  singlePort ? 5'd0 : 
                                (mergeTrigData ? trigDataSize >> 1 : trigDataSize);      


    wire right_aligned;
    wire [9:0] RC_right_goodEventRate;
    wire [1:0] RC_right_dataType;
    wire [19:0] RC_right_BCIDErrorCount;
    wire [19:0] RC_right_nullEventCount;
    wire [19:0] RC_right_goodEventCount;
    wire [19:0] RC_right_notHitEventCount;
    wire [19:0] RC_right_L1OverlfowEventCount;
    wire [19:0] RC_right_totalHitsCount;
    wire [19:0] RC_right_dataErrorCount;
    wire [19:0] RC_right_missedHitsCount;
    wire [8:0]  RC_right_hittedPixelCount;
    wire [19:0] RC_right_frameErrorCount;
    wire [19:0] RC_right_mismatchBCIDCount;
    wire [19:0] RC_right_L1FullEventCount;
    wire [19:0] RC_right_L1HalfFullEventCount;
    wire [19:0] RC_right_SEUEventCount;
    wire [19:0] RC_right_hitCountMismatchEventCount;
    wire [15:0] RC_right_triggerDataOut;

    wire [11:0] RC_right_matchedBCIDCount;
    wire [11:0] RC_right_syncBCID;

    fullChainDataCheck fullChainDataCheckInstRight
    (
        .clk320(clk320i),
        .clk640(clk640i),
        .clk1280(clk1280i),
        .dataRate(rateRight),
        .chipId(chipId),
        .triggerDataSize(trigDataSizeRight),
        .reset(dnReset),
        .reset2(reset2),
        .aligned(right_aligned),
        .disSCR(disSCR),
        .emptySlotBCID(12'd1177),
        .serialIn(soutRight),
        .matchedBCIDCount(RC_right_matchedBCIDCount),
        .syncBCID(RC_right_syncBCID),
        .RC_BCIDErrorCount(RC_right_BCIDErrorCount),
        .RC_dataType(RC_right_dataType),
        .RC_nullEventCount(RC_right_nullEventCount),
        .RC_goodEventCount(RC_right_goodEventCount),
        .RC_notHitEventCount(RC_right_notHitEventCount),
        .RC_L1OverlfowEventCount(RC_right_L1OverlfowEventCount),
        .RC_totalHitsCount(RC_right_totalHitsCount),
        .RC_dataErrorCount(RC_right_dataErrorCount),
        .RC_missedHitsCount(RC_right_missedHitsCount),
        .RC_hittedPixelCount(RC_right_hittedPixelCount),
        .RC_frameErrorCount(RC_right_frameErrorCount),
        .RC_L1FullEventCount(RC_right_L1FullEventCount),
        .RC_L1HalfFullEventCount(RC_right_L1HalfFullEventCount),
        .RC_SEUEventCount(RC_right_SEUEventCount),
        .RC_goodEventRate(RC_right_goodEventRate),
        .RC_hitCountMismatchEventCount(RC_right_hitCountMismatchEventCount),
        .RC_mismatchBCIDCount(RC_right_mismatchBCIDCount),
        .RC_triggerDataOut(RC_right_triggerDataOut)
    );

    wire left_aligned;
    wire [9:0] RC_left_goodEventRate;
    wire [1:0] RC_left_dataType;
    wire [19:0] RC_left_BCIDErrorCount;
    wire [19:0] RC_left_nullEventCount;
    wire [19:0] RC_left_goodEventCount;
    wire [19:0] RC_left_notHitEventCount;
    wire [19:0] RC_left_L1OverlfowEventCount;
    wire [19:0] RC_left_totalHitsCount;
    wire [19:0] RC_left_dataErrorCount;
    wire [19:0] RC_left_missedHitsCount;
    wire [8:0]  RC_left_hittedPixelCount;
    wire [19:0] RC_left_frameErrorCount;
    wire [19:0] RC_left_mismatchBCIDCount;
    wire [19:0] RC_left_L1FullEventCount;
    wire [19:0] RC_left_L1HalfFullEventCount;
    wire [19:0] RC_left_SEUEventCount;
    wire [19:0] RC_left_hitCountMismatchEventCount;
    wire [15:0] RC_left_triggerDataOut;

    wire [11:0] RC_left_matchedBCIDCount;
    wire [11:0] RC_left_syncBCID;
    fullChainDataCheck fullChainDataCheckInstLeft
    (
        .clk320(clk320i),
        .clk640(clk640i),
        .clk1280(clk1280i),
        .dataRate(rateLeft),
        .chipId(chipId),
        .triggerDataSize(trigDataSizeLeft),
        .reset(dnReset),
        .reset2(reset2),
        .aligned(left_aligned),
        .disSCR(disSCR),
        .emptySlotBCID(12'd1177),
        .serialIn(soutLeft),
        .matchedBCIDCount(RC_left_matchedBCIDCount),
        .syncBCID(RC_left_syncBCID),
        .RC_BCIDErrorCount(RC_left_BCIDErrorCount),
        .RC_dataType(RC_left_dataType),
        .RC_nullEventCount(RC_left_nullEventCount),
        .RC_goodEventCount(RC_left_goodEventCount),
        .RC_notHitEventCount(RC_left_notHitEventCount),
        .RC_L1OverlfowEventCount(RC_left_L1OverlfowEventCount),
        .RC_totalHitsCount(RC_left_totalHitsCount),
        .RC_dataErrorCount(RC_left_dataErrorCount),
        .RC_missedHitsCount(RC_left_missedHitsCount),
        .RC_hittedPixelCount(RC_left_hittedPixelCount),
        .RC_frameErrorCount(RC_left_frameErrorCount),
        .RC_L1FullEventCount(RC_left_L1FullEventCount),
        .RC_L1HalfFullEventCount(RC_left_L1HalfFullEventCount),
        .RC_SEUEventCount(RC_left_SEUEventCount),
        .RC_goodEventRate(RC_left_goodEventRate),
        .RC_hitCountMismatchEventCount(RC_left_hitCountMismatchEventCount),
        .RC_mismatchBCIDCount(RC_left_mismatchBCIDCount),
        .RC_triggerDataOut(RC_left_triggerDataOut)
    );

`ifdef PIXEL_POST_SIM
genvar r,c;
generate 
    for(c =  0; c<16; c =  c+1) begin : pixrd_col_annotation
	    for(r =  0; r<16; r =  r+1) begin : pixrd_row_annotation
           initial begin
		     $sdf_annotate("pixelReadoutImp/pixelReadoutWithSWCell_av_setup_wc_tempus_signoff.sdf", globalDigital_tb.sixteenColPixelsInst.colLoop[c].pixelReadoutColInst.pixelLoop[r].pixelReadoutInst, ,"sdf_pd_pix.log",,,);
            //$sdf_annotate("pixelReadoutImp/pixelReadoutWithSWCell_av_setup_wclt_tempus_signoff.sdf", ETROC2Digital_tb.ETROC2Digital_Inst.sixteenCols_Inst.colLoop[c].pixelCol_Inst.pixelLoop[r].pixel_Inst.pixelReadoutInst, ,"sdf_pd_pix.log",,,);
		    //  $sdf_annotate("pixelReadoutImp/pixelReadoutWithSWCell_av_hold_bc_tempus_signoff.sdf", globalDigital_tb.sixteenColPixelsInst.colLoop[c].pixelReadoutColInst.pixelLoop[r].pixelReadoutInst, ,"sdf_pd_pix.log",,,);
		    //  $sdf_annotate("pixelReadoutImp/pixelReadoutWithSWCell_av_hold_tc_tempus_signoff.sdf", globalDigital_tb.sixteenColPixelsInst.colLoop[c].pixelReadoutColInst.pixelLoop[r].pixelReadoutInst, ,"sdf_pd_pix.log",,,);
 //$sdf_annotate("pixelReadoutImp/pixelReadoutWithSWCell_av_hold_wc_tempus_signoff.sdf", ETROC2Digital_tb.ETROC2Digital_Inst.sixteenCols_Inst.colLoop[c].pixelCol_Inst.pixelLoop[r].pixel_Inst.pixelReadoutInst, ,"sdf_pd_pix.log",,,);
           end 
        end
    end
endgenerate
`endif


    initial begin
        `ifdef GLOBAL_POST_SIM
        $sdf_annotate("/users/dtgong/workarea/tsmc65/ETLROC/digital/ETROC2Readout/gitlab/etroc2readout/testGlobalDigital/tmpfile4/globalDigitalTMR_av_setup_wc_tempus_signoff.sdf", globalDigital_tb.globalDigitalTMRInst, ,"sdf_pd_gbl.log",,,);
        // $sdf_annotate("/users/dtgong/workarea/tsmc65/ETLROC/digital/ETROC2Readout/gitlab/etroc2readout/testGlobalDigital/tmpfile4/globalDigitalTMR_av_hold_bc_tempus_signoff.sdf", globalDigital_tb.globalDigitalTMRInst, ,"sdf_pd_gbl.log",,,);
        // $sdf_annotate("/users/dtgong/workarea/tsmc65/ETLROC/digital/ETROC2Readout/gitlab/etroc2readout/testGlobalDigital/tmpfile4/globalDigitalTMR_av_hold_tc_tempus_signoff.sdf", globalDigital_tb.globalDigitalTMRInst, ,"sdf_pd_gbl.log",,,);


        // $sdf_annotate("from_LBNL/par/globalDigitalTMR_GC/globalDigitalTMR_av_setup_wc_tempus_signoff.sdf", globalDigital_tb.globalDigitalTMRInst, ,"sdf_pd_gbl.log",,,);
//    $sdf_annotate("from_LBNL/par/globalDigitalTMR_GC/globalDigitalTMR_av_setup_wclt_tempus_signoff.sdf", globalDigital_tb.globalDigitalTMRInst, ,"sdf_pd_gbl.log",,,);
//    $sdf_annotate("from_LBNL/par/globalDigitalTMR_GC/globalDigitalTMR_av_hold_tc_tempus_signoff.sdf", globalDigital_tb.globalDigitalTMRInst, ,"sdf_pd_gbl.log",,,);
//    $sdf_annotate("from_LBNL/par/globalDigitalTMR_GC/globalDigitalTMR_av_hold_bc_tempus_signoff.sdf", globalDigital_tb.globalDigitalTMRInst, ,"sdf_pd_gbl.log",,,);
//    $sdf_annotate("from_LBNL/par/globalDigitalTMR_GC/globalDigitalTMR_av_hold_wc_tempus_signoff.sdf", globalDigital_tb.globalDigitalTMRInst, ,"sdf_pd_gbl.log",,,);
`endif

        POR         = 0;
        softBoot    = 0;
        asyResetGlobalReadout = 1'b1; //low active
        disDataReadoutArray = {256{1'b0}};
        disDataTriggerArray = {256{1'b0}};
        clkRef = 0;
        clk1280i = 1'b0;
        clk640i = 1;
        clk320i = 1;
        cnt_fc = 3'd0;
        chipId = 17'H1ABCD;
	    // fccAlign = 0;
        initReset = 1;
        clkCount = 20'd0;
        reset2 = 1;
        ocp = 7'h02;  //2%
        disSCR = 1'b0;
        mergeTrigData = 1'b1;
        singlePort = 1'b0;

// `ifdef TEST_SERRIALIZER_1280
//         rateRight = 2'b11; //high speed readout
//         rateLeft = 2'b11; //high speed readout
// `elsif TEST_SERRIALIZER_640
//         rateRight = 2'b01; 
//         rateLeft = 2'b01; 
// `elsif TEST_SERRIALIZER_320
//         rateRight = 2'b00; 
//         rateLeft = 2'b00; 
// `endif

        rateRight = 2'b01; 
        rateLeft  = 2'b01; 
        #200 POR = 1'b1;
        // disDataReadoutArray[0*16+15] = 1'b1;
        // disDataReadoutArray[0*16+14] = 1'b1;
        // disDataReadoutArray[1*16+15] = 1'b1;
        // disDataReadoutArray[2*16+15] = 1'b1;
        // disDataReadoutArray[3*16+15] = 1'b1;

        disDataReadoutArray[16*5+5] = 1'b1;
        disDataTriggerArray[16*5+5] = 1'b1;

        // disDataReadoutArray[8*16+0] = 1'b1;
        // disDataReadoutArray[8*16+1] = 1'b1;
        // disDataReadoutArray[8*16+2] = 1'b1;
        // disDataReadoutArray[9*16+0] = 1'b1;
        // disDataReadoutArray[10*16+0] = 1'b1;
        // disDataReadoutArray[7*16+0] = 1'b1;

//index 16*c+r
        // disDataReadoutArray[16*0+15] = 1'b1;
        // disDataReadoutArray[16*1+15] = 1'b1;
        // disDataReadoutArray[16*2+15] = 1'b1;
        // disDataReadoutArray[16*3+15] = 1'b1;
        // disDataReadoutArray[16*4+15] = 1'b1;
        // disDataReadoutArray[16*5+15] = 1'b1;
        // disDataReadoutArray[16*6+15] = 1'b1;
        // disDataReadoutArray[16*7+15] = 1'b1;
        // disDataReadoutArray[16*8+15] = 1'b1;
        // disDataReadoutArray[16*9+15] = 1'b1;
        // disDataReadoutArray[16*10+15] = 1'b1;
        // disDataReadoutArray[16*11+15] = 1'b1;
        // disDataReadoutArray[16*12+15] = 1'b1;
        // disDataReadoutArray[16*13+15] = 1'b1;
        // disDataReadoutArray[16*14+15] = 1'b1;
        // disDataReadoutArray[16*15+15] = 1'b1;

        // disDataReadoutArray[16*0+14] = 1'b1;
        // disDataReadoutArray[16*1+14] = 1'b1;
        // disDataReadoutArray[16*2+14] = 1'b1;
        // disDataReadoutArray[16*3+14] = 1'b1;
        // disDataReadoutArray[16*4+14] = 1'b1;
        // disDataReadoutArray[16*5+14] = 1'b1;
        // disDataReadoutArray[16*6+14] = 1'b1;
        // disDataReadoutArray[16*7+14] = 1'b1;
        // disDataReadoutArray[16*8+14] = 1'b1;
        // disDataReadoutArray[16*9+14] = 1'b1;
        // disDataReadoutArray[16*10+14] = 1'b1;
        // disDataReadoutArray[16*11+14] = 1'b1;
        // disDataReadoutArray[16*12+14] = 1'b1;
        // disDataReadoutArray[16*13+14] = 1'b1;
        // disDataReadoutArray[16*14+14] = 1'b1;
        // disDataReadoutArray[16*15+14] = 1'b1;

        // disDataReadoutArray[16*0+13] = 1'b1;
        // disDataReadoutArray[16*1+13] = 1'b1;
        // disDataReadoutArray[16*2+13] = 1'b1;
        // disDataReadoutArray[16*3+13] = 1'b1;
        // disDataReadoutArray[16*4+13] = 1'b1;
        // disDataReadoutArray[16*5+13] = 1'b1;
        // disDataReadoutArray[16*6+13] = 1'b1;
        // disDataReadoutArray[16*7+13] = 1'b1;
        // disDataReadoutArray[16*8+13] = 1'b1;
        // disDataReadoutArray[16*9+13] = 1'b1;
        // disDataReadoutArray[16*10+13] = 1'b1;
        // disDataReadoutArray[16*11+13] = 1'b1;
        // disDataReadoutArray[16*12+13] = 1'b1;
        // disDataReadoutArray[16*13+13] = 1'b1;
        // disDataReadoutArray[16*14+13] = 1'b1;
        // disDataReadoutArray[16*15+13] = 1'b1;


        #1000 POR = 1'b0;
        #16000 asyResetGlobalReadout = 1'b0;
        #100 asyResetGlobalReadout = 1'b1;
        // #25 initReset = 1'b0;
        // #100 initReset = 1'b1;
        #1000 initReset = 1'b0;
        #100 initReset = 1'b1;
        #10000 reset2 = 1'b0;
	    // #10100 fccAlign = 1'b1;
        #1000 reset2 = 1'b1;



        // #10400 fccAlign = 1'b0;
`ifdef TEST_SCRAMBLER
        #5000 disSCR = 1'b0;
`else
        #5000 disSCR = 1'b1; 
`endif
        #40000 ocp = 7'h04;
        #40000 ocp = 7'h30;
        #40000 ocp = 7'h06;
        #40000 ocp = 7'h02; 
        #2000000
        $stop;
    end
    always 
        #12.48 clkRef = ~clkRef; //25 ns clock period
    
    always
        #0.390 clk1280i = ~clk1280i;

    always
        #0.780  clk640i = ~clk640i;

    always
        #1.56   clk320i = ~clk320i;

   always @(posedge clkRef) 
   begin
        dnReset <= initReset;        
   end
endmodule
