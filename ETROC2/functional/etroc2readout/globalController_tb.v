`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Tue Nov 16 15:49:54 CST 2021
// Module Name: globalController_tb
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module globalController_tb;

	reg clk40Ref;
    reg clk1280In;
    reg [11:0] calibrationTime;
    reg [11:0] lockTime;
    reg POR;
    wire clk40;
    wire clk1280;
    wire synStartCalibration;
    wire pllCalibrationDone;
    wire instantLock;
    wire synPLLReset;
    simplePLL pll
    (
        .clk40Ref(clk40Ref),
        .asynReset(synPLLReset),
        .clk1280In(clk1280In),
        .calibrationTime(calibrationTime),
        .lockTime(lockTime),
        .pllCalibrationDone(pllCalibrationDone),
        .startCalibration(synStartCalibration),
        .clk1280(clk1280),
        .clk40(clk40),
        .instantLock(instantLock)
    );

    wire synResetLockdetect;
    wire [1:0] lkState;
    wire lkInstantLock;
    wire pllLocked;
    wire [7:0] lossOfLockCount;
    ljCDRlockFilterDetector lockdetectInst
    (
        .smClock(clk40),
        .reset(~synResetLockdetect), //reset active high
        .selectFD_PFD(1'b1),
        .PFDInstLock(instantLock),
        .FDInstLock(1'b0),
        .lfLockThrCounter(4'd8),
        .lfReLockThrCounter(4'd8),
        .lfUnLockThrCounter(4'd8),
        .state(lkState),
        .instantLock(lkInstantLock),
        .locked(pllLocked),
        .lossOfLockCount(lossOfLockCount)
    );

    wire [9:0] decodedFastcommand;
    reg softBoot;
    wire fastcommandAligned;
    wire invalidFastcommand;
    wire fcL1A;
    wire fcL1ARst;
    wire fcBCR;
    wire fcWSStart;
    wire fcWSStop;
    wire fcChargeInjCmd;
    wire [3:0] state;
    wire [11:0] pllUnlockCount;
    wire [11:0] invalidFCCount;
    reg asyLinkReset;
    reg asyPLLReset;
    reg asyAlignFastcommand;
    reg asyStartCalibration;
    reg asyResetFastcommand;
    reg asyResetLockDetect;
    reg asyResetGlobalReadout;
    reg asyResetChargeInj;
    wire synLinkReset;
    wire synAlignFastcommand;
    wire synResetFastcommand;
    wire synResetGlobalReadout;
    wire synResetChargeInj;

    reg disPowerSequence;
    globalController globalControllerInst
    (
        .clk40Ref(clk40Ref),
        .POR(POR),
        .softBoot(softBoot),
        .disPowerSequence(disPowerSequence),
        .decodedFastcommand(decodedFastcommand),
        .pllCalibrationDone(pllCalibrationDone),
        .pllLocked(pllLocked),
        .fastcommandAligned(fastcommandAligned),
        .invalidFastcommand(invalidFastcommand),
        .fcL1A(fcL1A),
        .fcL1ARst(fcL1ARst),
        .fcBCR(fcBCR),
        .fcWSStart(fcWSStart),
        .fcWSStop(fcWSStop),
        .fcChargeInjCmd(fcChargeInjCmd),
        .state(state),
        .pllUnlockCount(pllUnlockCount),
        .invalidFCCount(invalidFCCount),
        .asyLinkReset(asyLinkReset),
        .synLinkReset(synLinkReset),
        .asyPLLReset(asyPLLReset),
        .synPLLReset(synPLLReset),
        .asyAlignFastcommand(asyAlignFastcommand),
        .synAlignFastcommand(synAlignFastcommand),
        .asyStartCalibration(asyStartCalibration),
        .synStartCalibration(synStartCalibration),
        .asyResetFastcommand(asyResetFastcommand),
        .synResetFastcommand(synResetFastcommand),
        .asyResetLockDetect(asyResetLockDetect),
        .synResetLockdetect(synResetLockdetect),
        .asyResetGlobalReadout(asyResetGlobalReadout),
        .synResetGlobalReadout(synResetGlobalReadout),
        .asyResetChargeInj(asyResetChargeInj),
        .synResetChargeInj(synResetChargeInj)
    );

    wire glbClk;
    wire pixClk;
    digitalPhaseshifter digitalPhaseshifterInst
    (
        .clk40(clk40),
        .clk1280(clk1280),
        .clockDelay1(5'd0),
        .pulseWidth1(5'd16),
        .clockDelay2(5'd0),
        .pulseWidth2(5'd16),
        .clkout1(glbClk),
        .clkout2(pixClk)
    );

    wire [2:0] flipError = 3'd0;
    wire [9:0] fcd_ref;
    wire fcData;
    fastCommandGenerator fcGenInst
    (
        .clk40(clk40Ref),
        .clk1280(clk1280),
        .jitterHigh(500),  //+500 ps
        .jitterLow(-500),  //-500 ps
        .reset(synResetFastcommand),
        .start(synAlignFastcommand),  //start here
        .randomMode(1'b0),
        .flipError(flipError),
        .fcd_ref(fcd_ref),
        .fcData(fcData)
    );


    wire [3:0] ed;
    wire bitError;
    wire [3:0] state_bitAlign;

    fastCommandDecoderTop fastCommandDecoderTop_inst
    (
        .fccAlign(synAlignFastcommand),
        .clk1280(clk1280),
        .clk40(glbClk),
        .rstn(synResetFastcommand),
        .fc(fcData),
        .selfAlignEn(1'b1),
        .clkDelayEn(1'b0),
        .fcDelayEn(1'b0),
        .state_bitAlign(state_bitAlign),
        .bitError(bitError),
        .ed(ed),
        .aligned(fastcommandAligned),
        .invalidCmd(invalidFastcommand),
        .fcd(decodedFastcommand)
    );

    wire chargePulse;
    chargeInjectionPulseGen chargeInjectionPulseGenInst
    (
        .clk40(glbClk),
        .clk1280(clk1280),
        .reset(synResetChargeInj),
        .chargeInjectionCmd(fcChargeInjCmd),
        .delay(5'd11),
        .pulse(chargePulse)
    );

    initial begin
        POR         = 0;
        softBoot    = 0;
        clk40Ref    = 0;
        clk1280In   = 1;
        disPowerSequence = 0;
        calibrationTime     = 12'd123;
        lockTime            = 12'd235;
        asyLinkReset        = 0;
        asyPLLReset         = 1;
        asyAlignFastcommand = 0;
        asyStartCalibration = 0;
        asyResetFastcommand = 1;
        asyResetLockDetect  = 1;
        asyResetGlobalReadout       = 1;
        asyResetChargeInj           = 1;

        #200 POR = 1'b1;
        #1000 POR = 1'b0;
    
        #200000 $stop;
    end

    always 
        #12.48 clk40Ref = ~clk40Ref; //25 ns clock period
    
    always
        #0.390 clk1280In = ~clk1280In;


endmodule
