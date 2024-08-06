`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Mon Oct 18 22:12:58 CDT 2021
// Module Name: globalDigital
// Project Name: ETROC2 readout
// Description: 
// Dependencies: globalReadout
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
//`define DEBUG 
`include "commonDefinition.v"

module globalDigital #(
    parameter L1ADDRWIDTH = 7,
    parameter BCSTWIDTH = 27
)
(
//clock and reset signals
	input                   clk40,              //40MHz from PLL
    input                   clk1280,            //1280 MHz clock from PLL
    input                   clkRef,             //40 MHz reference clock 
    input                   POR,                //POR from external module
    input                   softBoot,        //"POR" from I2C
    input                   disPowerSequence,
    input                   pllCalibrationDone,
//control signals from I2C
    input                   asyLinkReset,
    input                   asyPLLReset,
    input                   asyAlignFastcommand,
    input                   asyResetFastcommand,
    input                   asyStartCalibration,
    input                   asyResetLockDetect,
    input                   asyResetGlobalReadout,
    input                   asyResetChargeInj,
    output                  pllReset,
    output                  startPLLCalibration,
    output [3:0]            controllerState,        //state of controller
    output [11:0]           pllUnlockCount,
    output [11:0]           invalidFCCount,
    input                   PFDInstLock,        //from PLL for lockDetect
	input  [3:0]            lfLockThrCounter,
	input  [3:0]            lfReLockThrCounter,
	input  [3:0]            lfUnLockThrCounter,

//    input                   reset,          //reset signal from slow control
    output                  readoutClock,   //readout clock for pixels, pass through H-tree
    input [16:0]            chipId,
//slow control configuration
    //readout clock 
    input [4:0]             readoutClockDelayPixel,
    input [4:0]             readoutClockWidthPixel,
    input [4:0]             readoutClockDelayGlobal,
    input [4:0]             readoutClockWidthGlobal,
    //serializer
    input [1:0]             serRateRight,        //rate of serializer.
    input [1:0]             serRateLeft,         //rate of serializer.
    // input                   linkResetSlowControl, replaced by asyLinkReset
    input                   linkResetTestPattern, //0: PRBS7, 1: fixed pattern specified by user
    input [31:0]            linkResetFixedPattern,                  
    //trigger
    input [11:0]            emptySlotBCID,       
    input [2:0]             triggerGranularity,   //3-bit            how many bits of trigger data, from 0 to 16.
    //frame builder
    input                   disScrambler,

    //data source switcher
    input                   mergeTriggerData,   //if combine data and trig when there are two ports. if there is only one port, it is meaningless.
    input                   singlePort,      //use two output ports or single port
    //on-chip L1A
	input [1:0]             onChipL1AConf,      //00 and 01, onchip L1A disable, 10, onchip L1A is periodic, 11, onchip L1A is random
    //BCID counter
    input [11:0]            BCIDoffset,     //
    //fast command  
	input                   fcSelfAlign,			// 
//	input                   fcAlignStart,		    // fast command clock align command. initialize the clock phase alignment process at its rising edge -sefAligner
	input                   fcClkDelayEn,			// enable signal of the clock delay -manual
	input                   fcDataDelayEn,			// enable signal of the command delay  -manual

//slow control status
	output                  fcBitAlignError,	// error indicator of the bit alignment -sefAligner
	output [3:0]            fcBitAlignStatus,			// detailed error indicator of the bit alignment -sefAligner
//fast command interface
	input                   fcData,					// fast command input
	output [3:0]            fcAlignFinalState,// state of the bit alignment state machine -sefAligner
//frontend
	output                  chargeInjection,   //charge injection signal
    input  [4:0]            chargeInjectionDelay,
//fast commands for waveform sampler
    output                  wsStart,
    output                  wsStop,

//pixel interface
	input [735:0]           colDataChain,         //46*16
	input [15:0]            colHitChain,
    input [63:0]            trigHitsColumn,       //output to global readout
	output [15:0]           colReadChain,
	output [BCSTWIDTH*16-1:0] colBCSTChain,

//output to serializer
    output                  soutRight,  //serializer output
    output                  soutLeft  //serializer output
);
// tmrg default triplicate
// tmrg do_not_triplicate readoutClock
// tmrg do_not_triplicate wsStart
// tmrg do_not_triplicate wsStop
// tmrg do_not_triplicate fcData
// tmrg do_not_triplicate PFDInstLock 
// tmrg do_not_triplicate chargeInjection
// tmrg do_not_triplicate colDataChain
// tmrg do_not_triplicate colHitChain
// tmrg do_not_triplicate trigHitsColumn
// tmrg do_not_triplicate colReadChain
// tmrg do_not_triplicate colBCSTChain
// tmrg do_not_triplicate soutRight
// tmrg do_not_triplicate soutLeft

// tmrg do_not_triplicate dnDataToLeftGlobal
// tmrg do_not_triplicate dnUnreadHitToLeftGlobal
// tmrg do_not_triplicate dnReadFromLeftGlobal
// tmrg do_not_triplicate dnBCSTFromLeftGlobal
// tmrg do_not_triplicate trigHitsToLeftGlobal

// tmrg do_not_triplicate dnDataToRightGlobal
// tmrg do_not_triplicate dnUnreadHitToRightGlobal
// tmrg do_not_triplicate dnReadFromRightGlobal
// tmrg do_not_triplicate dnBCSTFromRightGlobal
// tmrg do_not_triplicate trigHitsToRightGlobal
// tmrg do_not_triplicate leftTrigHits
// tmrg do_not_triplicate rightTrigHits

// tmrg do_not_triplicate dnDataRight
// tmrg do_not_triplicate dnUnreadHitRight
// tmrg do_not_triplicate dnReadRight
// tmrg do_not_triplicate dnBCSTRight

// tmrg do_not_triplicate dnDataLeft
// tmrg do_not_triplicate dnUnreadHitLeft
// tmrg do_not_triplicate dnReadLeft
// tmrg do_not_triplicate dnBCSTLeft
// tmrg do_not_triplicate trigHits

wire [9:0] decodedFastcommand; //from fastcommand
wire fastcommandAligned;
wire invalidFastcommand;
wire fcL1A;
wire fcL1ARst;
wire fcBCR;
wire fcChargeInjCmd;
wire synLinkReset;
wire synAlignFastcommand;
wire synResetFastcommand;
wire synResetLockdetect;
wire synResetGlobalReadout;
wire synResetChargeInj;
wire pllLocked;

globalController globalControllerInst
(
    .clk40Ref(clkRef),
    .POR(POR),
    .softBoot(softBoot),
    .disPowerSequence(disPowerSequence),
    .decodedFastcommand(decodedFastcommand),
    .pllCalibrationDone(pllCalibrationDone),
    .pllLocked(pllLocked),
    .fastcommandAligned(fastcommandAligned),
    .invalidFastcommand(invalidFastcommand),
    .fcL1A(fcL1A),
    .fcSelfAlign(fcSelfAlign),
    .fcL1ARst(fcL1ARst),
    .fcBCR(fcBCR),
    .fcWSStart(wsStart),
    .fcWSStop(wsStop),
    .fcChargeInjCmd(fcChargeInjCmd),
    .state(controllerState),
    .pllUnlockCount(pllUnlockCount),
    .invalidFCCount(invalidFCCount),
    .asyLinkReset(asyLinkReset),
    .synLinkReset(synLinkReset),
    .asyPLLReset(asyPLLReset),
    .synPLLReset(pllReset),
    .asyAlignFastcommand(asyAlignFastcommand),
    .synAlignFastcommand(synAlignFastcommand),
    .asyStartCalibration(asyStartCalibration),
    .synStartCalibration(startPLLCalibration),
    .asyResetFastcommand(asyResetFastcommand),
    .synResetFastcommand(synResetFastcommand),
    .asyResetLockDetect(asyResetLockDetect),
    .synResetLockdetect(synResetLockdetect),
    .asyResetGlobalReadout(asyResetGlobalReadout),
    .synResetGlobalReadout(synResetGlobalReadout),
    .asyResetChargeInj(asyResetChargeInj),
    .synResetChargeInj(synResetChargeInj)
);

wire [1:0] lockState;   //not used
wire instantLock;       //not used
wire [7:0] lossOfLockCount;

ljCDRlockFilterDetector ljCDRlockFilterDetectorInst
(
    .smClock(clk40),
    .reset(~synResetLockdetect),    
    .selectFD_PFD(1'b1),            //PFD
    .PFDInstLock(PFDInstLock),
    .FDInstLock(1'b1),              //locked
    .lfLockThrCounter(lfLockThrCounter),
    .lfReLockThrCounter(lfReLockThrCounter),
    .lfUnLockThrCounter(lfUnLockThrCounter),
    .state(lockState),
    .instantLock(instantLock),
    .locked(pllLocked),
    .lossOfLockCount(lossOfLockCount)
);

wire readoutClockGlobal;
digitalPhaseshifter dgpInst
(
    .clk40(clk40),
    .clk1280(clk1280),
    .clockDelay1(readoutClockDelayPixel),
    .pulseWidth1(readoutClockWidthPixel),
    .clockDelay2(readoutClockDelayGlobal),
    .pulseWidth2(readoutClockWidthGlobal),
    .clkout1(readoutClock),
    .clkout2(readoutClockGlobal)  
);

// reg resetSync;  //reset signal from slow control, synchronized to readout clock.
// reg resetSync1D;
// always @(negedge readoutClockGlobal) 
// begin
//     resetSync1D <= reset;
//     resetSync   <= resetSync1D;   //synchize the reset   
// end


// wire [9:0] fcDecodedCommand;
fastCommandDecoderTop fastCommandDecoderTop_inst
(
    .clk40(clk40),
    .clk1280(clk1280),
    .reset(synResetFastcommand),
    // .rstn40(resetFastcommand40), 
    // .rstn1280(resetFastcommand1280),
    .fccAlign(synAlignFastcommand),
    .fc(fcData),
    .selfAlignEn(fcSelfAlign),
    .clkDelayEn(fcClkDelayEn),
    .fcDelayEn(fcDataDelayEn),
    .state_bitAlign(fcAlignFinalState),
    .bitError(fcBitAlignError),
    .ed(fcBitAlignStatus),
    .invalidCmd(invalidFastcommand),
    .aligned(fastcommandAligned),
    .fcd(decodedFastcommand)
);


// reg                    fc_link_reset;
// reg                    fc_BCIDRst;         //periodic BCID reset
// reg                    fc_L1A;             //input L1A signal
// reg                    fc_Idle;            //not used
// reg                    fc_L1ARst;
// reg                    fc_chargeInjection;
// reg                    fc_WS_Start;
// reg                    fc_WS_Stop;

// always@(posedge readoutClockGlobal) begin
//     fc_Idle             <= fcDecodedCommand[0];
//     fc_link_reset       <= fcDecodedCommand[1];
//     fc_BCIDRst          <= fcDecodedCommand[2]|fcDecodedCommand[7];
//     fc_L1ARst           <= fcDecodedCommand[4];
//     fc_chargeInjection  <= fcDecodedCommand[5];
//     fc_L1A              <= fcDecodedCommand[6]|fcDecodedCommand[7];
//     fc_WS_Start         <= fcDecodedCommand[8];
//     fc_WS_Stop          <= fcDecodedCommand[9];
// end

// assign chargeInjection  = fc_chargeInjection;
chargeInjectionPulseGen cpgInst
(
    .clk40(clk40),
    .clk1280(clk1280),
    .reset(synResetChargeInj),
    .delay(chargeInjectionDelay),
    .chargeInjectionCmd(fcChargeInjCmd),
    .pulse(chargeInjection)  
);

// assign wsStart          = fc_WS_Start;
// assign wsStop           = fc_WS_Stop;

wire [45:0]             dnDataRight;
wire                    dnUnreadHitRight;    //if exist unread hit
wire                    dnReadRight;         //
wire [BCSTWIDTH-1:0]    dnBCSTRight;         //load,L1A,Reset

wire [45:0]             dnDataLeft; //TDC data 29 b, E2A, E1A, Pixel ID 8b
wire                    dnUnreadHitLeft;    //if exist unread hit
wire                    dnReadLeft;         //
wire [BCSTWIDTH-1:0]    dnBCSTLeft;         //load,L1A,Reset
wire [15:0]             trigHits;

columnConnecter #(.BCSTWIDTH(BCSTWIDTH)) columnConnecterInst
( 
    .colDataChain(colDataChain),
    .colHitChain(colHitChain),
    .trigHitsColumn(trigHitsColumn),
    .colReadChain(colReadChain),
    .colBCSTChain(colBCSTChain),
    .trigHits(trigHits),
    .dnDataRight(dnDataRight),
    .dnUnreadHitRight(dnUnreadHitRight),
    .dnReadRight(dnReadRight),
    .dnBCSTRight(dnBCSTRight),
    .dnDataLeft(dnDataLeft),
    .dnUnreadHitLeft(dnUnreadHitLeft),
    .dnReadLeft(dnReadLeft),
    .dnBCSTLeft(dnBCSTLeft)
);

wire [45:0] dnDataToLeftGlobal;
wire dnUnreadHitToLeftGlobal;
wire dnReadFromLeftGlobal;
wire [BCSTWIDTH-1:0]   dnBCSTFromLeftGlobal;
wire [15:0] trigHitsToLeftGlobal;

wire [45:0] dnDataToRightGlobal;
wire dnUnreadHitToRightGlobal;
wire dnReadFromRightGlobal;
wire [BCSTWIDTH-1:0] dnBCSTFromRightGlobal;
wire [15:0] trigHitsToRightGlobal;
wire [4:0] trigDataSizeLeft;
wire [4:0] trigDataSizeRight;
wire [7:0] leftTrigHits = trigHits[15:8];
wire [7:0] rightTrigHits = trigHits[7:0];

dataSourceSwitcher #(.BCSTWIDTH(BCSTWIDTH)) dataSourceSwitcherInst 
(
    .dataFromLeftPixel(dnDataLeft),
    .unreadHitFromLeftPixel(dnUnreadHitLeft),
    .readToLeftPixel(dnReadLeft), 
    .BCSTToLeftPixel(dnBCSTLeft),
    .trigHitsFromLeftPixel(leftTrigHits),
    //right
    .dataFromRightPixel(dnDataRight),
    .unreadHitFromRightPixel(dnUnreadHitRight),
    .readToRightPixel(dnReadRight), 
    .BCSTToRightPixel(dnBCSTRight),
    .trigHitsFromRightPixel(rightTrigHits),

    //global interface
    //left port
    .dnDataToLeftGlobal(dnDataToLeftGlobal),
    .dnUnreadHitToLeftGlobal(dnUnreadHitToLeftGlobal),
    .dnReadFromLeftGlobal(dnReadFromLeftGlobal),
	.dnBCSTFromLeftGlobal(dnBCSTFromLeftGlobal),
    .trigDataSizeLeft(trigDataSizeLeft),
    .trigHitsToLeftGlobal(trigHitsToLeftGlobal),
    //right port
    .dnDataToRightGlobal(dnDataToRightGlobal),
    .dnUnreadHitToRightGlobal(dnUnreadHitToRightGlobal),
    .dnReadFromRightGlobal(dnReadFromRightGlobal),
	.dnBCSTFromRightGlobal(dnBCSTFromRightGlobal),
    .trigDataSizeRight(trigDataSizeRight),
    .trigHitsToRightGlobal(trigHitsToRightGlobal),
    //configure
    .triggerGranularity(triggerGranularity),
    .mergeTrigData(mergeTriggerData),
    .singlePort(singlePort)
);

wire [31:0] dout32Right;
globalReadout #(.L1ADDRWIDTH(L1ADDRWIDTH),.BCSTWIDTH(BCSTWIDTH)) rightGlobalReadout
(
	.clk(readoutClockGlobal),            //40MHz
    .clk1280(clk1280),        //1280 MHz clock
    .serRate(serRateRight),        //rate of serializer.
    .chipId(chipId),
    .dis(1'b0),       // never disable right port
    .emptySlotBCID(emptySlotBCID),
    .L1A_Rst(fcL1ARst),             
    .trigHits(trigHitsToRightGlobal),
    .trigDataSize(trigDataSizeRight), //how many bits of trigger data, from 0 to 16.
    .reset(synResetGlobalReadout),        //
	.onChipL1AConf(onChipL1AConf),      //00: normal, 01: self test, periodic trigger fixed TDC data, 10: self test, random TDC data, 11: reserved
    .disSCR(disScrambler),
    .BCIDoffset(BCIDoffset),
    .BCIDRst(~fcBCR),       //periodic BCID reset
    .inL1A(fcL1A),        //input L1A signal

//SW network    
    .dnData(dnDataToRightGlobal), //TDC data 29 b, E2A, E1A, Pixel ID 8b
    .dnUnreadHit(dnUnreadHitToRightGlobal),    //if exist unread hit
    .dnRead(dnReadFromRightGlobal),         //
    .dnBCST(dnBCSTFromRightGlobal),         //load,L1A,Reset
//output to serializer
    .dout32(dout32Right) 
);

serializer serInstRight(
    .link_reset_ref(synLinkReset),
    .link_reset_testPatternSel(linkResetTestPattern), //0: PRBS7, 1: fixed pattern specified by user
    .link_reset_fixedTestPattern(linkResetFixedPattern),  
    .dis(1'b0),
    .clk1280(clk1280),
    .rate(serRateRight),
    .clk40syn(clk40),
    .din(dout32Right),     //from global readout
    .sout(soutRight)
);


wire [31:0] dout32Left;
globalReadout #(.L1ADDRWIDTH(L1ADDRWIDTH),.BCSTWIDTH(BCSTWIDTH)) leftGlobalReadout
(
	.clk(readoutClockGlobal),            //40MHz
    .clk1280(clk1280),        //1280 MHz clock
    .serRate(serRateLeft),        //rate of serializer.
    .chipId(chipId),
    .dis(singlePort),       //if single Port, disable readout
    .emptySlotBCID(emptySlotBCID),
    .L1A_Rst(fcL1ARst),                             
    .trigHits(trigHitsToLeftGlobal),
    .trigDataSize(trigDataSizeLeft), //how many bits of trigger data, from 0 to 16.
    .reset(synResetGlobalReadout),        //
	.onChipL1AConf(onChipL1AConf),      //00: normal, 01: self test, periodic trigger fixed TDC data, 10: self test, random TDC data, 11: reserved
    .disSCR(disScrambler),
    .BCIDoffset(BCIDoffset),
    .BCIDRst(~fcBCR),       //periodic BCID reset
    .inL1A(fcL1A),        //input L1A signal

//SW network    
    .dnData(dnDataToLeftGlobal), //TDC data 29 b, E2A, E1A, Pixel ID 8b
    .dnUnreadHit(dnUnreadHitToLeftGlobal),    //if exist unread hit
    .dnRead(dnReadFromLeftGlobal),         //
    .dnBCST(dnBCSTFromLeftGlobal),         //load,L1A,Reset
//output to serializer
    .dout32(dout32Left)
);

serializer serInstLeft(
    .link_reset_ref(synLinkReset),
    .link_reset_testPatternSel(linkResetTestPattern), //0: PRBS7, 1: fixed pattern specified by user
    .link_reset_fixedTestPattern(linkResetFixedPattern),  
    .dis(singlePort),
    .clk1280(clk1280),
    .rate(serRateLeft),
    .clk40syn(clk40),
    .din(dout32Left),     //from global readout
    .sout(soutLeft)
);


endmodule
