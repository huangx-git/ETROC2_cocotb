`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Tue Sep  7 22:32:30 CDT 2021
// Module Name: dataSourceSwitcher
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
//`define DEBUG 
`include "commonDefinition.v"

module dataSourceSwitcher #(
    parameter BCSTWIDTH = 27
)
(
 //   input                   clk,            //latch trigger hits for more timing margin
    //pixel interface
    //left
    input [45:0]            dataFromLeftPixel,
    input                   unreadHitFromLeftPixel,
    output                  readToLeftPixel, 
    output [BCSTWIDTH-1:0]  BCSTToLeftPixel,
    input [7:0]             trigHitsFromLeftPixel,
    //right
    input [45:0]            dataFromRightPixel,
    input                   unreadHitFromRightPixel,
    output                  readToRightPixel, 
    output [BCSTWIDTH-1:0]  BCSTToRightPixel,
    input [7:0]             trigHitsFromRightPixel,

    //global interface
    //left port
    output [45:0]           dnDataToLeftGlobal,
    output                  dnUnreadHitToLeftGlobal,
    input                   dnReadFromLeftGlobal,
	input [BCSTWIDTH-1:0]   dnBCSTFromLeftGlobal,
    output [4:0]            trigDataSizeLeft,
    output [15:0]           trigHitsToLeftGlobal,
    //right port
    output [45:0]           dnDataToRightGlobal,
    output                  dnUnreadHitToRightGlobal,
    input                   dnReadFromRightGlobal,
	input [BCSTWIDTH-1:0]   dnBCSTFromRightGlobal,
    output [4:0]            trigDataSizeRight,
    output [15:0]           trigHitsToRightGlobal,

    //configuration
    //output trigger data size:16,8,4,2,1. If trigDataSize is 0, disabled
    input [2:0]     triggerGranularity,   
    input mergeTrigData,   //if combine data and trig when there are two ports. if there is only one port, it is meaningless.
    input singlePort   //use two output ports or single port
    //{ mergeTrigData, singlePort } == 2'b00, two ports, left port for trigger, right port for data
    //{ mergeTrigData, singlePort } == 2'bx1, one ports, data/trigger are merged in one port
    //{ mergeTrigData, singlePort } == 2'b10, two split ports, data/trigger are merged in each port
);
//tmrg default do_not_triplicate 
//tmrg triplicate triplicate singlePort
//tmrg triplicate triplicate mergeTrigData
//tmrg triplicate triplicate triggerGranularity
//tmrg triplicate triplicate trigDataSizeLeft
//tmrg triplicate triplicate trigDataSizeRight

// atmrg do_not_triplicate SWCellInstCenter
// atmrg do_not_triplicate dataFromLeftPixel
// atmrg do_not_triplicate unreadHitFromLeftPixel
// atmrg do_not_triplicate readToLeftPixel
// atmrg do_not_triplicate BCSTToLeftPixel
// atmrg do_not_triplicate trigHitsFromLeftPixel
// atmrg do_not_triplicate dataFromRightPixel
// atmrg do_not_triplicate unreadHitFromRightPixel
// atmrg do_not_triplicate readToRightPixel
// atmrg do_not_triplicate BCSTToRightPixel
// atmrg do_not_triplicate trigHitsFromRightPixel

// atmrg do_not_triplicate dnDataToLeftGlobal
// atmrg do_not_triplicate dnUnreadHitToLeftGlobal
// atmrg do_not_triplicate dnReadFromLeftGlobal
// atmrg do_not_triplicate dnBCSTFromLeftGlobal
// atmrg do_not_triplicate trigHitsToLeftGlobal
// atmrg do_not_triplicate dnDataToRightGlobal
// atmrg do_not_triplicate dnUnreadHitToRightGlobal
// atmrg do_not_triplicate dnReadFromRightGlobal
// atmrg do_not_triplicate dnBCSTFromRightGlobal
// atmrg do_not_triplicate trigHitsToRightGlobal


    wire readToRightPixelCombine;
    wire readToLeftPixelCombine;
    wire [BCSTWIDTH-1:0] BCSTToRightPixelCombine;
    wire [BCSTWIDTH-1:0] BCSTToLeftPixelCombine;
    wire [45:0] dnDataToGlobalCombine;
    // wire dnUnreadHitToRightGlobalCombine;
    wire dnUnreadHitToGlobalCombine;
    // wire dnReadFromRightGlobalCombine;
    // wire [BCSTWIDTH-1:0] dnBCSTFromRightGlobalCombine;

    SWCell #(.DATAWIDTH(46),.BCSTWIDTH(BCSTWIDTH),.HITSWIDTH(1))SWCellInstCenter(
//ct  higher prioriaty to left
        .ctData(dataFromLeftPixel),
        .ctHits(unreadHitFromLeftPixel),
        .ctRead(readToLeftPixelCombine),
        .ctBCST(BCSTToLeftPixelCombine),
//up  
        .upData(dataFromRightPixel),
        .upHits(unreadHitFromRightPixel),
        .upRead(readToRightPixelCombine),
        .upBCST(BCSTToRightPixelCombine),
//dn
        .dnData(dnDataToGlobalCombine),
        .dnHits(dnUnreadHitToGlobalCombine),
        .dnRead(dnReadFromRightGlobal),
        .dnBCST(dnBCSTFromRightGlobal)
    );

//data and hit
    assign dnDataToLeftGlobal      = (singlePort | ~mergeTrigData) ? 46'd0 : dataFromLeftPixel;
    assign dnUnreadHitToLeftGlobal = (singlePort | ~mergeTrigData) ? 1'b0  : unreadHitFromLeftPixel;

    assign dnDataToRightGlobal      = (singlePort | ~mergeTrigData) ? dnDataToGlobalCombine       : dataFromRightPixel;
    assign dnUnreadHitToRightGlobal = (singlePort | ~mergeTrigData) ? dnUnreadHitToGlobalCombine  : unreadHitFromRightPixel;

//control signals
    assign BCSTToLeftPixel  = (singlePort | ~mergeTrigData) ? BCSTToLeftPixelCombine : dnBCSTFromLeftGlobal;
    assign readToLeftPixel  = (singlePort | ~mergeTrigData) ? readToLeftPixelCombine : dnReadFromLeftGlobal;

    assign BCSTToRightPixel  = (singlePort | ~mergeTrigData) ? BCSTToRightPixelCombine : dnBCSTFromRightGlobal;
    assign readToRightPixel  = (singlePort | ~mergeTrigData) ? readToRightPixelCombine : dnReadFromRightGlobal;

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
    wire [7:0] rightTrigHits;
    wire [7:0] leftTrigHits;

    assign rightTrigHits = trigHitsFromRightPixel;
    assign leftTrigHits = trigHitsFromLeftPixel;
    // always @(posedge clk)
    // begin
    //     rightTrigHits   <=  trigHitsFromRightPixel;
    //     leftTrigHits    <=  trigHitsFromLeftPixel;
    // end                   

    wire [15:0] combineTrigHits;
    assign combineTrigHits = (triggerGranularity == 3'd1) ? {15'd0,  (|rightTrigHits)|(|leftTrigHits)} :
                            ((triggerGranularity == 3'd2) ? {14'd0,  |leftTrigHits,|rightTrigHits} :
                            ((triggerGranularity == 3'd3) ? {12'd0,  leftTrigHits[2]|leftTrigHits[3]|leftTrigHits[6]|leftTrigHits[7],
                                                                    leftTrigHits[0]|leftTrigHits[1]|leftTrigHits[4]|leftTrigHits[5],
                                                                    rightTrigHits[2]|rightTrigHits[3]|rightTrigHits[6]|rightTrigHits[7],
                                                                    rightTrigHits[0]|rightTrigHits[1]|rightTrigHits[4]|rightTrigHits[5]} :
                            ((triggerGranularity == 3'd4) ? {8'd0,   leftTrigHits[7]|leftTrigHits[6],
                                                                    leftTrigHits[5]|leftTrigHits[4],
                                                                    leftTrigHits[3]|leftTrigHits[2],
                                                                    leftTrigHits[1]|leftTrigHits[0],
                                                                    rightTrigHits[7]|rightTrigHits[6],
                                                                    rightTrigHits[5]|rightTrigHits[4],
                                                                    rightTrigHits[3]|rightTrigHits[2],
                                                                    rightTrigHits[1]|rightTrigHits[0]} :
                            ((triggerGranularity == 3'd5) ?          {leftTrigHits,rightTrigHits}: 16'd0 ))));
    wire [7:0] splitTrigHitsRight;
    wire [7:0] splitTrigHitsLeft;
    assign splitTrigHitsLeft =  (triggerGranularity == 3'd2) ?   {7'd0, |leftTrigHits} :   
                               ((triggerGranularity == 3'd4) ?   { 6'd0, leftTrigHits[2]|leftTrigHits[3]|leftTrigHits[6]|leftTrigHits[7],
                                                                        leftTrigHits[0]|leftTrigHits[1]|leftTrigHits[4]|leftTrigHits[5]} : 
                               ((triggerGranularity == 3'd5) ?   leftTrigHits : 8'd0));
    assign splitTrigHitsRight = (triggerGranularity == 3'd2) ?   {7'd0, |rightTrigHits} :   
                               ((triggerGranularity == 3'd4) ?   {6'd0,  rightTrigHits[2]|rightTrigHits[3]|rightTrigHits[6]|rightTrigHits[7],
                                                                        rightTrigHits[0]|rightTrigHits[1]|rightTrigHits[4]|rightTrigHits[5]} : 
                               ((triggerGranularity == 3'd5) ? rightTrigHits : 8'd0));

    assign trigHitsToLeftGlobal = singlePort        ? 16'd0 :  //left port is disabled if only one port is enable
                                  (mergeTrigData    ? {8'd0,splitTrigHitsLeft} : //two ports, data and trigger merged
                                                      combineTrigHits);          //two ports, left port dedicated for trigger, right for data

    assign trigHitsToRightGlobal = singlePort       ? combineTrigHits : //left port is disabled if only one port is enable
                                (mergeTrigData      ? {8'd0,splitTrigHitsRight} : //two ports, data and trigger merged
                                                        16'd0);     //two ports, left port dedicated for trigger, right for data

endmodule
