`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 30 15:16:08 CST 2021
// Module Name: pixelReadouCol
// Project Name: ETROC2 readout
// Description: 
// Dependencies: pixelReadout,SWCell
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"

module pixelReadoutCol #(
    parameter L1ADDRWIDTH = 7,
    parameter BCSTWIDTH = 27
)
(
	input           clk,            //40MHz
	input [1:0]     workMode,      //00: normal, 01: self test, periodic trigger fixed TDC data, 10: self test, random TDC data, 11: reserved
    input [8:0]     L1ADelay,
    input [3:0]     colID,   //
    input [15:0]    disDataReadout,     //disable data readout
    //for trigger path
    input [15:0]    disTrigPath,
    input [9:0]             upperTOATrig,
    input [9:0]             lowerTOATrig,
    input [8:0]             upperTOTTrig,
    input [8:0]             lowerTOTTrig,
    input [9:0]             upperCalTrig,
    input [9:0]             lowerCalTrig,

//event selections based on TOT/TOA/Cal
    input [9:0]     upperTOA,
    input [9:0]     lowerTOA,
    input [8:0]     upperTOT,
    input [8:0]     lowerTOT,
    input [9:0]     upperCal,
    input [9:0]     lowerCal,
    input           addrOffset,       
    input [527:0]   TDCDataArray, //TDC source, 33 bits a TDC data. 
	input [6:0]     selfTestOccupancy,  //0.1%, 1%, 2%, 5%, 10% etc
//SWCell part
	output [45:0] 	dnData,
	output [4:0]	dnHits,
	input 			dnRead,
	input [BCSTWIDTH-1:0]	    dnBCST  //
);

    wire [7:0] pixleIDs[15:0]; //one more for upPixelID setting
    wire [3:0] rowIDs[15:0];

    generate
        genvar k;
        for (k = 0; k < 16; k = k+1 )
        begin
            assign rowIDs[k] = k;
            assign pixleIDs[k] = {colID,rowIDs[k]};
        end
    endgenerate

    wire [45:0] dataChain [16:0];
    wire [4:0] hitChain [16:0];
    wire [16:0] readChain;
    wire [BCSTWIDTH-1:0] BCSTChain [16:0];
    generate
        genvar i;
        for (i = 0; i < 16; i = i+1)
        begin : pixelLoop
            pixelReadoutWithSWCell #(.L1ADDRWIDTH(L1ADDRWIDTH))pixelReadoutInst
            (
            .clk(clk),            //40MHz
	        .workMode(workMode),          //selfTest or not
            .L1ADelay(L1ADelay),
            .pixelID(pixleIDs[i]),
            .disDataReadout(disDataReadout[i]),
            .disTrigPath(disTrigPath[i]),
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
//            .TDCData(TDCDataArray[i*30+29:i*30]),
            .TDC_EncError(TDCDataArray[i*33+32:i*33+30]),
            .TDC_TOA(TDCDataArray[i*33+29:i*33+20]),
            .TDC_TOT(TDCDataArray[i*33+19:i*33+11]),
            .TDC_Cal(TDCDataArray[i*33+10:i*33+1]),
            .TDC_hit(TDCDataArray[i*33]),
            .selfTestOccupancy(selfTestOccupancy),
            .upData({dataChain[i+1]}),
            .dnData(dataChain[i]),
            .upHits(hitChain[i+1]),
            .dnHits(hitChain[i]),
            .upRead(readChain[i+1]),
            .dnRead(readChain[i]),
            .upBCST(BCSTChain[i+1]),
            .dnBCST(BCSTChain[i])
            );
        end
    endgenerate

//for debug purpose
	wire [45:0] 	upData;
	wire [4:0]		upHits;
    wire 	        upRead;
    wire [L1ADDRWIDTH*2+11+2:0]      upBCST;
    assign upHits   = 5'b00000;
    assign upData   = {31'h00000000,colID,4'h0}; //
    assign upUnreadHit = 1'b0;  //has to be zero.

    assign dataChain[16]    = upData;
    assign dnData           = dataChain[0];
    assign hitChain[16]     = upHits;
    assign dnHits           = hitChain[0];
    assign upRead           = readChain[16];
    assign readChain[0]     = dnRead;
    assign upBCST           = BCSTChain[16];
    assign BCSTChain[0]     = dnBCST;

endmodule