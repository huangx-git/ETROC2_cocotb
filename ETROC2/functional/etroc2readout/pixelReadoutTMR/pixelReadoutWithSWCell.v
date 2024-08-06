`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sun Jan 24 14:09:46 CST 2021
// Module Name: BCIDOverflowCount
// Project Name: ETROC2 readout
// Description: For test only
// Dependencies: pixelReadout,SWCell
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"

module pixelReadoutWithSWCell #(
    parameter L1ADDRWIDTH = 7,
    parameter BCSTWIDTH  = 27
)
(
	input                   clk,            //40MHz
	input [1:0]             workMode,       //00: normal, 01: self test, periodic trigger fixed TDC data, 10: self test, random TDC data, 11: reserved
    input [8:0]             L1ADelay,
    input [7:0]             pixelID,        //from slow control
    input                   disDataReadout,     //disable data readout
    //for trigger path
    input                   disTrigPath,
    input [9:0]             upperTOATrig,
    input [9:0]             lowerTOATrig,
    input [8:0]             upperTOTTrig,
    input [8:0]             lowerTOTTrig,
    input [9:0]             upperCalTrig,
    input [9:0]             lowerCalTrig,
//event selections based on TOT/TOA/Cal
    input [9:0]             upperTOA,
    input [9:0]             lowerTOA,
    input [8:0]             upperTOT,
    input [8:0]             lowerTOT,
    input [9:0]             upperCal,
    input [9:0]             lowerCal,
    input                   addrOffset,
    input [29:0]            TDCData,
	input [6:0]             selfTestOccupancy,  //0.1%, 1%, 2%, 5%, 10% etc
//SWCell part
	input [45:0] 	        upData,  //TDCdata 29 bits (no hit), E2A,E1A, PixelID 8 bits
	output [45:0] 	        dnData,
	input [4:0]		        upHits,
	output [4:0]	        dnHits,
	input 			        dnRead,
	output 			        upRead,
	input [BCSTWIDTH-1:0] 	dnBCST,  //load, L1A, Reset
	output [BCSTWIDTH-1:0] 	upBCST   //
);

wire reset;
wire L1A;
wire read;
wire load;
wire unreadHit;
wire [3:0] trigHit;
wire [35:0] outTDCData;
wire L1E2A;
wire L1E1A;

wire [8:0] CBwrAddr;
wire [L1ADDRWIDTH-1:0] L1rdAddr;
wire [L1ADDRWIDTH-1:0] L1wrAddr;
//wire L1Full;
wire preLoad;
 
//  `ifdef pixelTMR
      pixelReadoutTMR pixelReadoutInst(
//  `else
//    pixelReadout #(.L1ADDRWIDTH(L1ADDRWIDTH)) pixelReadoutInst(
// `endif
	.clk(clk),            //40MHz
	.reset(reset),         //
	.workMode(workMode),          //selfTest or not
    .L1wrAddr(L1wrAddr),
    .L1rdAddr(L1rdAddr),
    .CBwrAddr(CBwrAddr),
    .preLoad(preLoad),
//    .L1Full(L1Full),
    .disDataReadout(disDataReadout),
    .disTrigPath(disTrigPath),
    .upperTOATrig(upperTOATrig),
    .lowerTOATrig(lowerTOATrig),
    .upperTOTTrig(upperTOTTrig),
    .lowerTOTTrig(lowerTOTTrig),
    .upperCalTrig(upperCalTrig),
    .lowerCalTrig(lowerCalTrig),
    .upperTOA(upperTOA),
    .lowerTOA(lowerTOA),
    .upperTOT(upperTOT),
    .lowerTOT(lowerTOT),
    .upperCal(upperCal),
    .lowerCal(lowerCal),
    .addrOffset(addrOffset),
    .L1A(L1A),            //seltest or real L1A signal from global readout
    .pixelID(pixelID),   //
    .TDCData(TDCData),
    .latencyL1A(L1ADelay),
	.selfTestOccupancy(selfTestOccupancy),  //0.1%, 1%, 2%, 5%, 10% etc
    .read(read),  //data read 
    .load(load),  //data load 
    .trigHit(trigHit),
    .unreadHit(unreadHit),
	.dout(outTDCData),  //output data
    .outE1A(L1E1A),
    .outE2A(L1E2A)  //output error detect
);



SWCell #(.DATAWIDTH(46),.BCSTWIDTH(BCSTWIDTH),.HITSWIDTH(5))SWellInst (
        .ctData({outTDCData,L1E2A,L1E1A,pixelID}),
        .ctHits({trigHit,unreadHit}),
        .ctRead(read),
//        .ctBCST({preLoad,CBwrAddr,L1Full,L1wrAddr,L1rdAddr,load,L1A,reset}),   //load, L1A, Reset, L1ADelay 9 bits
        .ctBCST({preLoad,CBwrAddr,L1wrAddr,L1rdAddr,load,L1A,reset}),   //load, L1A, Reset, L1ADelay 9 bits
        .upData(upData),
        .upHits(upHits),
        .upRead(upRead),
        .upBCST(upBCST),
        .dnData(dnData),
        .dnHits(dnHits),
        .dnRead(dnRead),
        .dnBCST(dnBCST)
);
endmodule