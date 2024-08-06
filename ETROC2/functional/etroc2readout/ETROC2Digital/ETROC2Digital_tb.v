//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL
// Author:      Quan Sun
// 
// Create Date:    Dec. 17th, 2021
// Design Name:    ETROC2
// Module Name:    ETROC2Readout_tb
// Project Name:   ETROC2
// Description: testbench of ETROC2Readout
//
// Dependencies: ...
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////

module ETROC2Digital_tb();

     wire  clkTDC;
     wire  strobeTDC;
//     wire [16:0] chipId;
     wire [4:0] readoutClockDelayPixel;
     wire [4:0] readoutClockWidthPixel;
     wire [4:0] readoutClockDelayGlobal;
     wire [4:0] readoutClockWidthGlobal;
//     wire [1:0] serRateRight;
//     wire [1:0] serRateLeft;
     wire  linkResetSlowControl;
     wire  linkResetTestPattern;
     wire [31:0] linkResetFixedPattern;
     wire [11:0] emptySlotBCID;
//     wire [2:0] triggerGranularity;
//     wire  disScrambler;
//     wire  mergeTriggerData;
//     wire  singlePort;
     wire [1:0] onChipL1AConf;
     wire [11:0] BCIDoffset;
     wire  fcSelfAlign;
     wire  fcAlignStart;
     wire  fcClkDelayEn;
     wire  fcDataDelayEn;
     wire  fcBitAlignErrorA;
     wire  fcBitAlignErrorB;
     wire  fcBitAlignErrorC;
     wire [3:0] fcBitAlignStatusA;
     wire [3:0] fcBitAlignStatusB;
     wire [3:0] fcBitAlignStatusC;
//     wire  fcData;
     wire [3:0] fcAlignFinalStateA;
     wire [3:0] fcAlignFinalStateB;
     wire [3:0] fcAlignFinalStateC;
//     wire  chargeInjection;
     wire [4:0] chargeInjectionDelay;
     wire  wsStartA;
     wire  wsStartB;
     wire  wsStartC;
     wire  wsStopA;
     wire  wsStopB;
     wire  wsStopC;

//     wire  soutRight;
//     wire  soutLeft;

     wire startPLLCalibrationA, startPLLCalibrationB, startPLLCalibrationC;
     wire [3:0] controllerStateA, controllerStateB, controllerStateC;
     wire [11:0] pllUnlockCountA, pllUnlockCountB, pllUnlockCountC;
     wire [11:0] invalidFCCountA, invalidFCCountB, invalidFCCountC;

     wire pllResetA, pllResetB, pllResetC;

     wire fc_bitErrorA, fc_bitErrorB, fc_bitErrorC;
     wire [3:0] fc_edA, fc_edB, fc_edC;
     wire [3:0] fc_state_bitAlignA, fc_state_bitAlignB, fc_state_bitAlignC;

    wire clk40;


    localparam BCSTWIDTH = `L1BUFFER_ADDRWIDTH*2+11+2;

    localparam fc_IDLE 		= 8'b1111_0000; //2'hF0 -->n_fc = 0--3'h001 
    localparam fc_L1A_CR    = 8'H66;

    reg clkRef;
    reg clk1280i;
    reg clk640i;
    reg clk320i;
    reg fccAlign;
    reg [16:0] chipId;

    reg [2:0] cnt_fc;
    reg [7:0] fc_byte;
    reg [19:0] clkCount; //count 25 ns
    always @(posedge clkRef)
    begin
        clkCount <= clkCount + 1;
    end

    always@(posedge clk320i) begin
        cnt_fc <= cnt_fc + 1;
        if(cnt_fc==3'd0)
            if(clkCount == 20'd1200)
                fc_byte <= fc_L1A_CR;
            else 
                fc_byte <= fc_IDLE; //sampling parallel 8 bits fc at 320 MHz clock
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

    wire soutRight;
    wire [2:0] triggerGranularity = 3'd1;

    wire soutLeft;
//    wire ws_start;
//    wire ws_stop;
//    wire chargeInjection;
//    wire [3:0] fc_state_bitAlign;
//    wire [3:0] fc_ed;
//    wire readoutClock;

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

    reg softBoot;
    reg POR;
    wire pllCalibrationDone;

    initial begin
        clkRef = 0;
        clk1280i = 1'b0;
        clk640i = 0;
        clk320i = 0;
        cnt_fc = 3'd0;
        chipId = 17'H1ABCD;
	    fccAlign = 0;
        initReset = 1;
        clkCount = 20'd0;
        reset2 = 1;
        ocp = 7'h02;  //2%
        disSCR = 1'b1;
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

	softBoot = 1'b0;
	POR = 1'b0;
	asyResetGlobalReadout = 1'b1; //low active

	#200 POR = 1'b1;
        #1000 POR = 1'b0;
        #16000 asyResetGlobalReadout = 1'b0;
        #100 asyResetGlobalReadout = 1'b1;


        #25 initReset = 1'b0;
        #100 initReset = 1'b1;
        #10000 reset2 = 1'b0;
	    #10100 fccAlign = 1'b1;
        #10200 reset2 = 1'b1;
        #10400 fccAlign = 1'b0;
`ifdef TEST_SCRAMBLER
        #5000 disSCR = 1'b0;
`else
        #5000 disSCR = 1'b1; 
`endif
        #40000 ocp = 7'h04;
        #40000 ocp = 7'h30;
        #40000 ocp = 7'h06;
        #40000 ocp = 7'h02; 
        #1000000
        $stop;
    end
    always 
        #12.48 clkRef = ~clkRef; //25 ns clock period
    
    always
//        #0.390625 clk1280 = ~clk1280;
        #0.390 clk1280i = ~clk1280i;

    always
//        #0.78125  clk640 = ~clk640;
        #0.780  clk640i = ~clk640i;

    always
//        #1.5625   clk320 = ~clk320;
        #1.56   clk320i = ~clk320i;

   always @(posedge clk40) 
   begin
        dnReset <= initReset;        
   end


wire clkDLY1, clkDLY2, clkDLY3;
wire strobePul1, strobePul2;
assign #1.56 clkDLY1 = clk40;
assign #1.56 clkDLY2 = clkDLY1;
assign #1.56 clkDLY3 = clkDLY2;
assign strobePul1 = clk40 & (~clkDLY1);
assign strobePul2 = clkDLY2 & (~clkDLY3);
assign strobeTDC = strobePul1 | strobePul2;


assign readoutClockDelayPixel = 5'd0;
assign readoutClockWidthPixel = 5'd16;
assign readoutClockDelayGlobal = 5'd0;
assign readoutClockWidthGlobal = 5'd16;
assign linkResetSlowControl = 1'b0;
assign linkResetTestPattern = 1'b1;
assign linkResetFixedPattern = 32'h3C5C3C5A;
assign emptySlotBCID = 12'd1177;
assign onChipL1AConf = 2'b11;
assign BCIDoffset = 12'h000;
assign fcSelfAlign = 1'b1;
assign fcClkDelayEn = 1'b0;
assign fcDataDelayEn = 1'b0;
assign chargeInjectionDelay = 5'd24;

assign clkTDC = clk40;
assign fcAlignStart = fccAlign;

    simplePLL pll
    (
        .clk40Ref(clkRef),
        .asynReset(pllResetA),
        .clk1280In(clk1280i),
        .calibrationTime(12'd23),
        .lockTime(12'd35),
        .pllCalibrationDone(pllCalibrationDone),
        .startCalibration(startPLLCalibrationA),
        .clk1280(clk1280),
        .clk40(clk40),
        .instantLock(instantLock)
    );

ETROC2Digital ETROC2Digital_Inst(
	.clk40A(clk40),
	.clk40B(clk40),
	.clk40C(clk40),
	.clk1280A(clk1280),
	.clk1280B(clk1280),
	.clk1280C(clk1280),
	.clkRefA(clkRef),
	.clkRefB(clkRef),
	.clkRefC(clkRef),
	.resetA(dnReset),
	.resetB(dnReset),
	.resetC(dnReset),
	.clkTDC(clkTDC),
	.strobeTDC(strobeTDC),
	.chipIdA(chipId),
	.chipIdB(chipId),
	.chipIdC(chipId),
	.readoutClockDelayPixelA(readoutClockDelayPixel),
	.readoutClockDelayPixelB(readoutClockDelayPixel),
	.readoutClockDelayPixelC(readoutClockDelayPixel),
	.readoutClockWidthPixelA(readoutClockWidthPixel),
	.readoutClockWidthPixelB(readoutClockWidthPixel),
	.readoutClockWidthPixelC(readoutClockWidthPixel),
	.readoutClockDelayGlobalA(readoutClockDelayGlobal),
	.readoutClockDelayGlobalB(readoutClockDelayGlobal),
	.readoutClockDelayGlobalC(readoutClockDelayGlobal),
	.readoutClockWidthGlobalA(readoutClockWidthGlobal),
	.readoutClockWidthGlobalB(readoutClockWidthGlobal),
	.readoutClockWidthGlobalC(readoutClockWidthGlobal),
	.serRateRightA(rateRight),
	.serRateRightB(rateRight),
	.serRateRightC(rateRight),
	.serRateLeftA(rateLeft),
 	.serRateLeftB(rateLeft),
	.serRateLeftC(rateLeft),
	.linkResetSlowControlA(linkResetSlowControl),
	.linkResetSlowControlB(linkResetSlowControl),
	.linkResetSlowControlC(linkResetSlowControl),
	.linkResetTestPatternA(linkResetTestPattern),
	.linkResetTestPatternB(linkResetTestPattern),
	.linkResetTestPatternC(linkResetTestPattern),
	.linkResetFixedPatternA(linkResetFixedPattern),
	.linkResetFixedPatternB(linkResetFixedPattern),
	.linkResetFixedPatternC(linkResetFixedPattern),
	.emptySlotBCIDA(emptySlotBCID),
	.emptySlotBCIDB(emptySlotBCID),
	.emptySlotBCIDC(emptySlotBCID),
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
	.onChipL1AConfA(onChipL1AConf),
	.onChipL1AConfB(onChipL1AConf),
	.onChipL1AConfC(onChipL1AConf),
	.BCIDoffsetA(BCIDoffset),
	.BCIDoffsetB(BCIDoffset),
	.BCIDoffsetC(BCIDoffset),
	.fcSelfAlignA(fcSelfAlign),
	.fcSelfAlignB(fcSelfAlign),
	.fcSelfAlignC(fcSelfAlign),
	.fcAlignStartA(fccAlign),
	.fcAlignStartB(fccAlign),
	.fcAlignStartC(fccAlign),
	.fcClkDelayEnA(fcClkDelayEn),
	.fcClkDelayEnB(fcClkDelayEn),
	.fcClkDelayEnC(fcClkDelayEn),
	.fcDataDelayEnA(fcDataDelayEn),
	.fcDataDelayEnB(fcDataDelayEn),
	.fcDataDelayEnC(fcDataDelayEn),
	.fcBitAlignErrorA(fcBitAlignErrorA),
	.fcBitAlignErrorB(fcBitAlignErrorB),
	.fcBitAlignErrorC(fcBitAlignErrorC),
	.fcBitAlignStatusA(fcBitAlignStatusA),
	.fcBitAlignStatusB(fcBitAlignStatusB),
	.fcBitAlignStatusC(fcBitAlignStatusC),
	.fcData(fc_fc),
	.fcAlignFinalStateA(fcAlignFinalStateA),
	.fcAlignFinalStateB(fcAlignFinalStateB),
	.fcAlignFinalStateC(fcAlignFinalStateC),
	.chargeInjectionDelayA(chargeInjectionDelay),
	.chargeInjectionDelayB(chargeInjectionDelay),
	.chargeInjectionDelayC(chargeInjectionDelay),
	.wsStartA(wsStartA),
	.wsStartB(wsStartB),
	.wsStartC(wsStartC),
	.wsStopA(wsStopA),
	.wsStopB(wsStopB),
	.wsStopC(wsStopC),

	.soutRight(soutRight),
	.soutLeft(soutLeft),

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
     	.asyLinkResetA(1'b1),
     	.asyLinkResetB(1'b1),
     	.asyLinkResetC(1'b1),
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
     	.pllResetA(pllResetA),
     	.pllResetB(pllResetB),
     	.pllResetC(pllResetC),
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
 
	.fc_bitErrorA(fc_bitErrorA),
     	.fc_bitErrorB(fc_bitErrorB),
     	.fc_bitErrorC(fc_bitErrorC),
     	.fc_edA(fc_edA),
     	.fc_edB(fc_edB),
     	.fc_edC(fc_edC),
     	.fc_state_bitAlignA(fc_state_bitAlignA),
     	.fc_state_bitAlignB(fc_state_bitAlignB),
     	.fc_state_bitAlignC(fc_state_bitAlignC)
);

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


endmodule
