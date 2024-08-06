`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 23 16:00:43 CST 2021
// Module Name: globalReadoutForPixelTest
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

module globalReadoutForPixelTest #(
    parameter L1ADDRWIDTH = 7,
    parameter BCSTWIDTH = 27
)
(
	input                   clk,            //40MHz
    input                   reset,        //
//    input [L1ADDRWIDTH-1:0] almostFullLevel,
    input                   streamBufAlmostFull,
	input [1:0]             workMode,      //00: normal, 01: self test, periodic trigger fixed TDC data, 10: self test, random TDC data, 11: reserved
    input                   inL1A,        //input L1A signal
    input [11:0]            BCIDoffset,
    input                   BCIDRst,
//SW network    
    input [45:0]            dnData, //TDC data 29 b, E2A, E1A, Pixel ID 8b
    input                   dnUnreadHit,    //if exist unread hit
    output                  dnRead,         //
    output [BCSTWIDTH-1:0]    dnBCST         //load,L1A,Reset
);
    wire emulatorL1A;
    wire dnL1A;
    wire dnReset;
    wire selfTest;
    assign selfTest = (workMode != 2'b00);
    TestL1Generator TestL1GeneratorInst(
        .clkTMR(clk),
        .disTMR(~selfTest),
        .modeTMR(workMode[1]),
        .resetTMR(dnReset),
        .L1ATMR(emulatorL1A) //
    );

    wire actualL1A;
    assign actualL1A        = selfTest ? emulatorL1A        : inL1A;

    wire [11:0] genBCID;
    wire [11:0] actualOffset;
    assign actualOffset = selfTest ? 12'H000 : BCIDoffset;
    BCIDCounter BC(
	    .clkTMR(clk), 
        .disTMR(1'b0),
        .resetTMR(dnReset),                 //40MHz
        .rstBCIDTMR(BCIDRst),    //BCID reset signal 
        .offsetTMR(actualOffset),        //value when it is reset
        .BCIDTMR(genBCID)
    );

    wire dnLoad;
    wire [11:0] gbrcBCID;              //to readout controller
    wire [L1ADDRWIDTH-1:0] wrAddr;
    wire [L1ADDRWIDTH-1:0] rdAddr;
 //   assign L1BufFull     = dnBCST[L1ADDRWIDTH*2+3];
    assign wrAddr           = dnBCST[L1ADDRWIDTH*2+2:L1ADDRWIDTH+3];
    assign rdAddr           = dnBCST[L1ADDRWIDTH+2:3];
    assign dnL1A            = dnBCST[1];
    assign dnLoad           = dnBCST[2];
    assign dnReset          = dnBCST[0];
    wire BCBE1A;
    wire BCBE2A;
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
 //   wire          streamBufAlmostFull;
 //   wire          eventEnd;
  //  wire          idle;
    globalReadoutController #(.L1ADDRWIDTH(L1ADDRWIDTH),.BCSTWIDTH(BCSTWIDTH)) gbrcInst(
	    .clk(clk),              //40MHz
        .reset(reset),          //reset by slow control? 
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
   //     .eventEnd(eventEnd),
  //      .idle(idle),
        .outTDCData(outTDCData),
        .outPixelID(outPixelID),
        .outBCID(outBCID),
        .outEA(EA),
        .outL1BufFull(outL1BufFull), //
        .outL1BufOverflow(outL1BufOverflow),
        .outL1BufHalfFull(outL1BufHalfFull) //BCID overflow error
    );


endmodule
