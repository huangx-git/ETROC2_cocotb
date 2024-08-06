`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sun Oct 17 22:09:15 CDT 2021
// Module Name: sixteenColPixels
// Project Name: ETROC2 readout
// Description: 
// Dependencies: pixelReadout,SWCell
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"

module sixteenColPixels #(
    parameter L1ADDRWIDTH = 7,
    parameter BCSTWIDTH = 27
)
(
	input           clk,            //40MHz
	input [1:0]     workMode,      //00: normal, 01: self test, periodic trigger fixed TDC data, 10: self test, random TDC data, 11: reserved
    input [8:0]     L1ADelay,
    input [8447:0]  TDCDataArray, //TDC source, 30 bits a TDC data, 256 TDCs
	input [6:0]     selfTestOccupancy,  //0.1%, 1%, 2%, 5%, 10% etc
    input [255:0]   disDataReadout,     //disable data readout

//for trigger path
    input [255:0]   disTrigPath,
    input [9:0]     upperTOATrig,
    input [9:0]     lowerTOATrig,
    input [8:0]     upperTOTTrig,
    input [8:0]     lowerTOTTrig,
    input [9:0]     upperCalTrig,
    input [9:0]     lowerCalTrig,

//event selections based on TOT/TOA/Cal
    input [9:0]     upperTOA,
    input [9:0]     lowerTOA,
    input [8:0]     upperTOT,
    input [8:0]     lowerTOT,
    input [9:0]     upperCal,
    input [9:0]     lowerCal,
    input           addrOffset,
//SWCell part
//TDC 29 b, E2A,E1A, PixelID 8b
	output [735:0] 	colDataChain,         //46*16
	output [15:0]   colHitChain,
    output [63:0]   trigHitsColumn,       //output to global readout
	input  [15:0]	colReadChain,
	input [BCSTWIDTH*16-1:0]     colBCSTChain
);

    wire [3:0] colIDs[15:0];
    generate
        genvar k;
        for (k = 0; k < 16; k = k+1 )
        begin
            assign colIDs[k] = k;
        end
    endgenerate

//    wire [45:0] colDataChain [15:0];
//wire [BCSTWIDTH-1:0] colBCSTChain [15:0];
    wire [45:0] colDataChain2D [15:0];
    wire [BCSTWIDTH-1:0] colBCSTChain2D [15:0];
    generate
        genvar jj;
        for (jj = 0; jj < 16; jj = jj+1) 
        begin 
            assign colBCSTChain2D[jj] = colBCSTChain[jj*BCSTWIDTH+BCSTWIDTH-1:jj*BCSTWIDTH];
        end
    endgenerate

`ifdef DEBUG_TRIGGERPATH
    wire [3:0] dbTrigHitCol[15:0];
`endif
    generate
        genvar i;
        for (i = 0; i < 16; i = i+1)  
        begin : colLoop
            pixelReadoutCol #(.L1ADDRWIDTH(L1ADDRWIDTH)) pixelReadoutColInst(
            .clk(clk),                      //40MHz
	        .workMode(workMode),            //selfTest or not
            .L1ADelay(L1ADelay),
            .disDataReadout(disDataReadout[i*16+15:i*16]),
            .disTrigPath(disTrigPath[i*16+15:i*16]),
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
            .colID(colIDs[i]),
            .TDCDataArray(TDCDataArray[i*528+527:i*528]),
            .selfTestOccupancy(selfTestOccupancy),
	        .dnData(colDataChain2D[i]),
`ifdef DEBUG_TRIGGERPATH
            .dbTrigHits(dbTrigHitCol[i]),
`endif
	        .dnHits({trigHitsColumn[i*4+3:i*4],colHitChain[i]}),
	        .dnRead(colReadChain[i]),
	        .dnBCST(colBCSTChain2D[i]) //
            );
        end
    endgenerate

    generate
        genvar ii;
        for (ii = 0; ii < 16; ii = ii+1) 
        begin 
            assign  colDataChain[46*ii+45:46*ii] = colDataChain2D[ii];
        end
    endgenerate

`ifdef DEBUG_TRIGGERPATH
    generate
        genvar m; 
        for (m = 0; m < 16; m = m+1)  
        begin : colLoopTrig
            assign dbTrigHits[m] =  dbTrigHitCol[m-(m%4)+0][m%4]|
                                    dbTrigHitCol[m-(m%4)+1][m%4]|
                                    dbTrigHitCol[m-(m%4)+2][m%4]|
                                    dbTrigHitCol[m-(m%4)+3][m%4];
        end
    endgenerate
`endif

endmodule