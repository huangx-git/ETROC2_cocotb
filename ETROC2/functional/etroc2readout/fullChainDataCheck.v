`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Wed Feb  3 10:14:24 CST 2021
// Module Name: fullChainDataCheck
// Project Name: ETROC2 readout
// Description: 
// Dependencies: PRBS9
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"

module fullChainDataCheck
(
	input  			    clk320,
	input  			    clk640,
	input  			    clk1280,
    input [16:0]        chipId,
    input [1:0]         dataRate,
    input [4:0]         triggerDataSize,
	input  			    reset,    
	input  			    reset2, 
    input               disSCR,             
    input               serialIn,
    input [11:0]        emptySlotBCID,
    output              aligned,
    output [11:0]    matchedBCIDCount,
    output [11:0]    syncBCID,
    output  [19:0]   RC_BCIDErrorCount,
    output  [1:0]    RC_dataType,
    output  [19:0]   RC_nullEventCount, //idle count
    output  [19:0]   RC_goodEventCount, 
    output  [19:0]   RC_notHitEventCount, 
    output  [19:0]   RC_L1OverlfowEventCount,
    output  [19:0]   RC_L1FullEventCount,
    output  [19:0]   RC_L1HalfFullEventCount,
    output  [19:0]   RC_SEUEventCount,
    output  [19:0]   RC_hitCountMismatchEventCount,
    output [19:0]       RC_totalHitsCount,
    output [19:0]       RC_dataErrorCount,
    output [19:0]       RC_missedHitsCount,
    output [8:0]        RC_hittedPixelCount,
    output [19:0]       RC_frameErrorCount,
    output [9:0]        RC_goodEventRate, //CRCError for every 64 frame
    output [19:0]       RC_mismatchBCIDCount,
    output [15:0]       RC_triggerDataOut
);
// tmrg default do_not_triplicate

    wire wordCK;
    wire [39:0] word40b;
    wire deserClk;

    assign deserClk = (dataRate == 2'b00) ? clk320 : 
                      ((dataRate == 2'b01) ? clk640 : clk1280);

    wire dlSout;
    delayLine dlInst(
        .bitClk(deserClk),
        .delay(6'd1),
        .sin(serialIn),
        .sout(dlSout)
    );

    wire [4:0] wordAddr;
    wire wordTrigClk;
    deserializerWithTriggerData dser40T(
        .bitCK(deserClk),
        .reset(reset),
        .disSCR(disSCR),
        .rate(dataRate),
        .delay(wordAddr),
    //    .delay(6'h02),
        .sin(dlSout),
        .trigData(RC_triggerDataOut),
        .trigDataSize(triggerDataSize),
        .wordTrigClk(wordTrigClk),
        .word40CK(wordCK),
        .dout(word40b)
    );

    reg [19:0] delayReset;
    always @(posedge clk320) begin
        delayReset <= {delayReset[18:0],reset};
    end

    triggerSynchronizer triggerSynchronizerInst
    (
        .reset(delayReset[19]),
        .clk40(wordTrigClk),
        .trigData(RC_triggerDataOut),
        .trigDataSize(triggerDataSize),
        .emptySlotBCID(emptySlotBCID),
        .syncBCID(syncBCID),
        .matchedCount(matchedBCIDCount)
    );

    wire [39:0] receivedDataFrame;
    dataExtract dataExtractInst
    (
        .clk(wordCK),
        .reset(reset2),
        .chipId(chipId),
        .wordAddr(wordAddr),
        .din(word40b),
        .aligned(aligned),
        .goodEventRate(RC_goodEventRate),
        .dout(receivedDataFrame)
    );

    wire noError;
    dataStreamCheck dsk
    (
        .clk(wordCK),
        .reset(reset2),
        .chipId(chipId),
        .din(receivedDataFrame),
        .noError(noError)
    );

    dataRecordCheck dataRecordCheckReceiver
    (
        .clk(wordCK),
        .reset(reset2),
        .dataRecord(receivedDataFrame),
        .BCIDErrorCount(RC_BCIDErrorCount),
        .dataType(RC_dataType),
        .nullEventCount(RC_nullEventCount),
        .goodEventCount(RC_goodEventCount),
        .notHitEventCount(RC_notHitEventCount),
        .L1OverlfowEventCount(RC_L1OverlfowEventCount),
        .totalHitsCount(RC_totalHitsCount),
        .dataErrorCount(RC_dataErrorCount),
        .missedHitsCount(RC_missedHitsCount),
        .hittedPixelCount(RC_hittedPixelCount),
        .frameErrorCount(RC_frameErrorCount),
        .L1FullEventCount(RC_L1FullEventCount),
        .L1HalfFullEventCount(RC_L1HalfFullEventCount),
        .SEUEventCount(RC_SEUEventCount),
        .goodEventRate(RC_goodEventRate),
        .hitCountMismatchEventCount(RC_hitCountMismatchEventCount),
        .mismatchBCIDCount(RC_mismatchBCIDCount)
    );


endmodule
