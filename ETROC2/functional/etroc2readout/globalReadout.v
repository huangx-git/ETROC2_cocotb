`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 23 16:00:43 CST 2021
// Module Name: globalReadout
// Project Name: ETROC2 readout
// Description: 
// Dependencies: BCIDCounter,BCIDBuffer,FIFOWRCtrler,globalReadoutController
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
//`define DEBUG 
`include "commonDefinition.v"

module globalReadout #(
    parameter L1ADDRWIDTH = 7,
    parameter BCSTWIDTH = 27
)
(
	input                   clk,            //40MHz
    input                   clk1280,        //1280 MHz clock
    input [1:0]             serRate,        //rate of serializer.
    input [16:0]            chipId,
    input                   dis,            //disable readout channel
    // input                   link_reset_fastCommand,
    // input                   link_reset_slowControl,
    //input                 linkReset,                  //from either slow control or fast control
    //input                 link_reset_testPatternSel, //0: PRBS7, 1: fixed pattern specified by user
    //input [31:0]          link_reset_fixedTestPattern,   
    input                   L1A_Rst,               
    input [15:0]            trigHits,
    input [4:0]             trigDataSize, //how many bits of trigger data, from 0 to 16.
    input [11:0]            emptySlotBCID,
    input                   reset,        //
	input [1:0]             onChipL1AConf,      
    input                   disSCR,
    input [11:0]            BCIDoffset,
    input                   BCIDRst,       //periodic BCID reset
    input                   inL1A,        //input L1A signal

//SW network    
    input [45:0]            dnData, //TDC data 29 b, E2A, E1A, Pixel ID 8b
    input                   dnUnreadHit,    //if exist unread hit
    output                  dnRead,         //
    output [BCSTWIDTH-1:0]    dnBCST,         //load,L1A,Reset

//  for DEBUG only
//`ifdef DEBUG
//    output [11:0]   dbBCID, //to pixel for debug only
//`endif 
//output to serializer
    output [31:0]           dout32
//    output                  sout  //serializer output
);
// tmrg default triplicate
// tmrg do_not_triplicate sout 

    reg rstn40;
    always @(negedge clk) 
    begin
        rstn40 <= reset;
    end    
    wire dnReset = rstn40 & ~dis;

    wire trigScrOn;
    assign trigScrOn = ~disSCR;
    wire emulatorL1A;
    wire dnL1A;
    wire onChipL1AEn = onChipL1AConf[1];
    wire disL1Gen = ~onChipL1AEn | dis;
// onChipL1AConf definition:   
//00 and 01, onchip L1A disable, 10, onchip L1A is periodic, 11, onchip L1A is random
    wire L1Mode = onChipL1AConf[0];
    TestL1Generator TestL1GeneratorInst(
        .clkTMR(clk),
        .disTMR(disL1Gen),
        .modeTMR(L1Mode),
        .resetTMR(dnReset),
        .L1ATMR(emulatorL1A) //
    );

    wire actualL1A;
    assign actualL1A        = ~dis & (onChipL1AEn ? emulatorL1A        : inL1A);

    wire [11:0] genBCID;
    wire [11:0] actualOffset;
    assign actualOffset = onChipL1AEn ? 12'H000 : BCIDoffset;
    wire actualBCR = onChipL1AEn ? 1'b1 : BCIDRst;
    BCIDCounter BC(
	    .clkTMR(clk), 
        .disTMR(dis),
        .resetTMR(dnReset),                 //40MHz
        .rstBCIDTMR(actualBCR),    //BCID reset signal 
        .offsetTMR(actualOffset),        //value when it is reset
        .BCIDTMR(genBCID)
    );

//    wire L1BufFull;
    wire dnLoad;
    wire [11:0] gbrcBCID;              //to readout controller
    wire [L1ADDRWIDTH-1:0] wrAddr;
    wire [L1ADDRWIDTH-1:0] rdAddr;
 //   assign L1BufFull     = dnBCST[L1ADDRWIDTH*2+3];
    assign wrAddr           = dnBCST[L1ADDRWIDTH*2+2:L1ADDRWIDTH+3];
    assign rdAddr           = dnBCST[L1ADDRWIDTH+2:3];
    assign dnL1A            = dnBCST[1];
    assign dnLoad           = dnBCST[2];
//    assign dnReset          = dnBCST[0];
    wire BCBE1A;
    wire BCBE2A;
    // wire resetBCIDBuffer = dnReset&~dis; 
    BCIDBuffer #(.ADDRWIDTH(L1ADDRWIDTH))BCB (
	    .clk(clk),                      //40MHz
        .reset(dnReset),                  //buffer reset signal 
        .inBCID(genBCID),               //current BCID
 //       .L1BufFull(L1BufFull),   //from overflow buffer,
        .rdEn(dnLoad),           //from global readout controller, read BCID from buffer
        .L1A(dnL1A),                //used to read BCID from BCID counter
        .wrAddr(wrAddr),
        .rdAddr(rdAddr),
        .E1A(BCBE1A),
        .E2A(BCBE2A),
        .outBCID(gbrcBCID)             //read BCID to global controller.
    );

    wire [L1ADDRWIDTH-1:0] wordCount;
    wire          eventStart;         //start a new event
    wire          hit;             //hitted data or not
    wire [28:0]   outTDCData;
    wire [7:0]    outPixelID;
    wire [11:0]   outBCID;
    wire [1:0]    EA;
    wire          outL1BufFull; //
    wire          outL1BufHalfFull; 
    wire          outL1BufOverflow; 
    wire          streamBufAlmostFull;
//    wire resetController = reset&~dis;
    globalReadoutController #(.L1ADDRWIDTH(L1ADDRWIDTH),.BCSTWIDTH(BCSTWIDTH)) gbrcInst(
	    .clk(clk),              //40MHz
        .reset(dnReset),          //reset by slow control or disable
        .L1A(actualL1A),
//SW network
        .dnData(dnData),                //TDC data ,
        .dnUnreadHit(dnUnreadHit),    //if exist unread hit
        .dnRead(dnRead),       //
        .dnBCST(dnBCST),
//BCID buffer
        .inBCID(gbrcBCID),                  //read BCID to global controller
        .BCBE1A(BCBE1A),
        .BCBE2A(BCBE2A),
// for check
        .wordCount(wordCount),
//stream buffer
        .streamBufAlmostFull(streamBufAlmostFull),
//output to frame builder
        .hit(hit),
        .eventStart(eventStart),
        .outTDCData(outTDCData),
        .outPixelID(outPixelID),
        .outBCID(outBCID),
        .outEA(EA),
        .outL1BufFull(outL1BufFull), //
        .outL1BufOverflow(outL1BufOverflow),
        .outL1BufHalfFull(outL1BufHalfFull) //BCID overflow error
    );

// `ifdef CHECK_DATA_BEFORE_FRAME
//     wire [19:0] totalHitEvent;
//     wire [8:0] hittedPixelCount;
//     wire [19:0] missedCount; 
//     wire [19:0] mismatchedBCIDCount;
//     wire [19:0] dataErrorCount;
//     wire [19:0] emptyEventCount;
//     wire [19:0] totalClockCount;
//     wire [19:0] totalGoodEventCount;
//     wire [19:0]  BCIDErrorCount;

//     finalPixelDataCheck finalcheck(
//         .clk(clk),
//         .reset(dnReset),
//         .TDCData(outTDCData),
//         .hit(hit),
//         .eventStart(eventStart),
//         .pixelID(outPixelID),
//         .BCID(outBCID),
//         .totalHitEvent(totalHitEvent),
//         .totalClockCount(totalClockCount),
//         .totalGoodEventCount(totalGoodEventCount),
//         .dataErrorCount(dataErrorCount),
//         .missedCount(missedCount),
//         .hittedPixelCount(hittedPixelCount),
//         .mismatchedBCIDCount(mismatchedBCIDCount),
//         .BCIDErrorCount(BCIDErrorCount),
//         .emptyEventCount(emptyEventCount)
//     );
// `endif 

    wire [1:0] DBS;
    assign DBS = {outL1BufOverflow, outL1BufHalfFull};
    reg [7:0] L1Counter;
    wire [7:0] nextL1Count = L1Counter + 1;
    wire [7:0] nextL1CountVoted = nextL1Count;
    always @(negedge clk) begin
        if(~dnReset | L1A_Rst)
        begin
            L1Counter <= 8'd0;
        end
        else if(actualL1A)
        begin
            L1Counter <= nextL1CountVoted;
        end
    end

    wire [39:0] dataFrame;
    wire [1:0] frameType;
//    assign frameType = 2'b00; //need to be change
//  onChipL1AConf: 00 and 01, onchip L1A disable, 10, onchip L1A is periodic, 11, onchip L1A is random
//  frameType : 00--data, 01, random test pattern, 10, periodic test pattern, 11, reserved
    assign frameType = onChipL1AConf == 2'b11 ? 2'b01 : (onChipL1AConf == 2'b10 ? 2'b10 : 2'b00);
    wire holdFrameBuilder = streamBufAlmostFull|dis;
    frameBuilder fbInst
    (
        .clk(clk),
        .reset(dnReset),
        .TDCData(outTDCData),
        .type(frameType),
        .hit(hit),
        .chipID(chipId),
        .eventStart(eventStart),
        .pixelID(outPixelID),
        .EA(EA),
        .BCID(outBCID),
        .L1Counter(L1Counter),
        .L1BufFull(outL1BufFull),
        .L1BufHalfFull(outL1BufHalfFull),
        .L1BufOverflow(outL1BufOverflow),
        .streamBufAlmostFull(holdFrameBuilder),
        .dataFrame(dataFrame)
    );

    // wire noError;
    // dataStreamCheck dsk
    // (
    //     .clk(clk),
    //     .reset(dnReset),
    //     .chipId(chipId),
    //     .din(dataFrame),
    //     .noError(noError)
    // );
// `ifdef CHECK_DATA_AFTER_FRAME
//     wire [1:0] FB_dataType;
//     wire [19:0] FB_BCIDErrorCount;
//     wire [19:0] FB_nullEventCount;
//     wire [19:0] FB_goodEventCount;
//     wire [19:0] FB_notHitEventCount;
//     wire [19:0] FB_totalHitsCount;
//     wire [19:0] FB_dataErrorCount;
//     wire [19:0] FB_missedHitsCount;
//     wire [8:0] FB_hittedPixelCount;
//     wire [19:0] FB_frameErrorCount;
//     wire [19:0] FB_mismatchBCIDCount; 
//     wire [19:0] FB_L1OverlfowEventCount;
//     dataRecordCheck dataRecordCheckAfterFB
//     (
//         .clk(clk),
//         .reset(dnReset),
//         .dataRecord(dataFrame),
//         .BCIDErrorCount(FB_BCIDErrorCount),
//         .dataType(FB_dataType),
//         .nullEventCount(FB_nullEventCount),
//         .goodEventCount(FB_goodEventCount),
//         .notHitEventCount(FB_notHitEventCount),
//         .totalHitsCount(FB_totalHitsCount),
//         .dataErrorCount(FB_dataErrorCount),
//         .missedHitsCount(FB_missedHitsCount),
//         .hittedPixelCount(FB_hittedPixelCount),
//         .frameErrorCount(FB_frameErrorCount),
//         .L1OverlfowEventCount(FB_L1OverlfowEventCount),
//         .mismatchBCIDCount(FB_mismatchBCIDCount)
//     );
// `endif 

// `ifdef ALIGNMENT_TEST
//     reg [39:0] fakeDataFrame;
//     reg [15:0] fakeTrigHits;
//     always @(posedge clk)
//     begin
//         if(!dnReset)
//         begin
//             fakeDataFrame <= 40'd0;
//             fakeTrigHits <= 16'd0;
//         end
//         else
//         begin
//            fakeDataFrame <= fakeDataFrame + 40'H43E15AFB1F;
//            fakeTrigHits  <= fakeTrigHits + 16'H0E21;
//         end
        
//     end
// `endif     

//    wire rdClk;
    wire [31:0] dout;
    wire [15:0] encTrigHits;
//    wire resetTriggerProcess = dnReset&~dis;
    triggerProcessor TPInst
    (
        .clk(clk),   
        .reset(dnReset),
        .trigHits(trigHits),
        .BCID(genBCID),
        .emptySlotBCID(emptySlotBCID),
        .encTrigHits(encTrigHits)
    );

//    wire resetStreamBuffer = dnReset&~dis;
    wire [31:0] triggerData = {16'd0,encTrigHits};
    streamBuffer #(.FIFODEPTH(2))streamBufferInst(
	  	.clk(clk),            //40MHz
	  	.reset(dnReset),         //
        .rate(serRate),
        .triggerDataSize(trigDataSize),
// 'ifdef ALIGNMENT_TEST
//         .triggerData({16'd0,fakeTrigHits}),
// 	    .dataFrame(fakeDataFrame),
// `else
        .triggerData(triggerData),
//        .triggerData({16'd0,16'd15}),
//	    .dataFrame(dataFrame),
// `endif
	    .dataFrame(dataFrame),
//        .dataFrame({16'h3C5C,2'b10,22'h2AAAAA}), //test
//        .disSCR(disSCR),        //disable scrambler
        .RT_BCID(genBCID),
        .DBS(DBS),
        .RT_L1Counter(L1Counter),
//        .rdClk(rdClk),           //input load signal from serializer
//        .lowLevel(streamBufLowLevel),
//        .highLevel(streamBufHighLevel),
        .almostFull(streamBufAlmostFull),
        .dout(dout)            //output data to serializer         
    );

    wire [1:0] dataWidth;
    assign dataWidth = serRate;
    wire [31:0] scr;
//    wire resetScrambler = dnReset&~dis; 
    Scrambler scrInst
    (
        .clk(clk),
        .reset(dnReset),
        .dataWidth(dataWidth),
        .din(dout),
        .bypass(disSCR),
        .dout(scr)
    );

    assign dout32 = scr;

    // reg [1:0] slow_ctrl_link_reset_delay;
    // reg link_reset_reg;
    // always @(negedge clk) 
    // begin
    //     if(~dis)
    //     begin
    //         slow_ctrl_link_reset_delay <= {slow_ctrl_link_reset_delay[0],link_reset_slowControl};        
    //         link_reset_reg <= slow_ctrl_link_reset_delay[1] | link_reset_fastCommand;
    //         link_reset_reg  <= linkReset;
    //     end
    // end

    // serializer serInst(
    //     .link_reset(link_reset_reg),
    //     .dis(dis),
    //     .testPatternSel(link_reset_testPatternSel),
    //     .fixedTestPattern(link_reset_fixedTestPattern),
    //     .clk1280(clk1280),
    //     .rate(serRate),
    //     .clk40syn(clk),
    //     .din(scr),     //from global readout
    //     .sout(sout)
    // );


endmodule
