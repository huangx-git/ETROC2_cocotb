`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sun Jan 31 20:00:59 CST 2021
// Module Name: sixteenColChain
// Project Name: ETROC2 readout
// Description: 
// Dependencies: pixelReadout,SWCell
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"

module sixteenColChain #(
    parameter L1ADDRWIDTH = 7,
    parameter BCSTWIDTH = 27
)
(
	input           clk,            //40MHz
	input [1:0]     workMode,      //00: normal, 01: self test, periodic trigger fixed TDC data, 10: self test, random TDC data, 11: reserved
    input [8:0]     L1ADelay,
    input [8447:0]  TDCDataArray, //TDC source, 30 bits a TDC data, 256 TDCs
	input [6:0]     selfTestOccupancy,  //0.1%, 1%, 2%, 5%, 10% etc
    input [255:0]           disDataReadout,     //disable data readout
    //for trigger path
    input [255:0]           disTrigPath,
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
//SWCell part
	output [45:0] 	dnData,         //TDC 29 b, E2A,E1A, PixelID 8b
	output          dnUnreadHit,
    output [15:0]   trigHits,       //output to global readout
	input 			dnRead,
	input [BCSTWIDTH-1:0]     dnBCST
);

    wire [3:0] colIDs[15:0];
    generate
        genvar k;
        for (k = 0; k < 16; k = k+1 )
        begin
            assign colIDs[k] = k;
        end
    endgenerate

    wire [63:0] trigHitsColumn;
    wire [45:0] colDataChain [15:0];
    wire [15:0] colHitChain;
    wire [15:0] colReadChain;
    wire [BCSTWIDTH-1:0] colBCSTChain [15:0];
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
	        .dnData(colDataChain[i]),
	        .dnHits({trigHitsColumn[i*4+3:i*4],colHitChain[i]}),
	        .dnRead(colReadChain[i]),
	        .dnBCST(colBCSTChain[i]) //
            );
        end
    endgenerate

    wire [45:0] swDataChain [15:0];
    wire [15:0] swHitChain;
    wire [15:0] swReadChain;
    wire [BCSTWIDTH-1:0] swBCSTChain [15:0];

    generate
        genvar j;
        for (j = 1; j < 8; j = j+1) //col 1 to 7
        begin : swLoop1
            SWCell #(.DATAWIDTH(46),.BCSTWIDTH(BCSTWIDTH),.HITSWIDTH(1))SWCellInstRght(
//ct
            .ctData(colDataChain[j]),
            .ctHits(colHitChain[j]),
            .ctRead(colReadChain[j]),
            .ctBCST(colBCSTChain[j]),
//up  0-6
            .upData(swDataChain[j-1]),  
            .upHits(swHitChain[j-1]),
            .upRead(swReadChain[j-1]),
            .upBCST(swBCSTChain[j-1]),
//dn  1-7
            .dnData(swDataChain[j]),
            .dnHits(swHitChain[j]),
            .dnRead(swReadChain[j]),
            .dnBCST(swBCSTChain[j])
            );
        end
    endgenerate

    //The DN of Column 0 is connected to SW 1 Up
    assign  swDataChain[0] = colDataChain[0];
    assign  swHitChain[0] = colHitChain[0];
    assign  colReadChain[0] = swReadChain[0];
    assign  colBCSTChain[0] = swBCSTChain[0];

    generate
        genvar n;
        for (n = 8; n < 15; n = n+1) //8 to 14
        begin : swLoop2
            SWCell #(.DATAWIDTH(46),.BCSTWIDTH(BCSTWIDTH),.HITSWIDTH(1))SWCellInstLeft(
//ct
            .ctData(colDataChain[n]),
            .ctHits(colHitChain[n]),
            .ctRead(colReadChain[n]),
            .ctBCST(colBCSTChain[n]),
//up  9-15
            .upData(swDataChain[n+1]),
            .upHits(swHitChain[n+1]),
            .upRead(swReadChain[n+1]),
            .upBCST(swBCSTChain[n+1]),
//dn  8-14
            .dnData(swDataChain[n]),
            .dnHits(swHitChain[n]),
            .dnRead(swReadChain[n]),
            .dnBCST(swBCSTChain[n])
            );
        end
    endgenerate

    //The DN of Column 15 is connected to SW 14 Up
    assign  swDataChain[15] = colDataChain[15];
    assign  swHitChain[15] = colHitChain[15];
    assign  colReadChain[15] = swReadChain[15];
    assign  colBCSTChain[15] = swBCSTChain[15];

    SWCell #(.DATAWIDTH(46),.BCSTWIDTH(BCSTWIDTH),.HITSWIDTH(1))SWCellInstCenter(
//ct  node 8, higher prioty than node 7
        .ctData(swDataChain[8]),
        .ctHits(swHitChain[8]),
        .ctRead(swReadChain[8]),
        .ctBCST(swBCSTChain[8]),
//up  node 7
        .upData(swDataChain[7]),
        .upHits(swHitChain[7]),
        .upRead(swReadChain[7]),
        .upBCST(swBCSTChain[7]),
//dn
        .dnData(dnData),
        .dnHits(dnUnreadHit),
        .dnRead(dnRead),
        .dnBCST(dnBCST)
    );

//    wire [63:0] columnIds;
    // columnAdapterChain columnAdapterChainInst(
    //     .trigHitsColumn(trigHitsColumn),
    //     .columnIds(columnIds),
    //     .trigHits(trigHits)
    // );
    
    // assign trigerHits[0] = trigHitsColumn[0+0]|trigHitsColumn[4+0]|trigHitsColumn[8+0]| trigHitsColumn[12+0];
    // assign trigerHits[1] = trigHitsColumn[0+1]|trigHitsColumn[4+1]|trigHitsColumn[8+1]| trigHitsColumn[12+1];
    // assign trigerHits[2] = trigHitsColumn[0+2]|trigHitsColumn[4+2]|trigHitsColumn[8+2]| trigHitsColumn[12+2];
    // assign trigerHits[3] = trigHitsColumn[0+3]|trigHitsColumn[4+3]|trigHitsColumn[8+3]| trigHitsColumn[12+3];
    // assign trigerHits[4] = trigHitsColumn[16+0]|trigHitsColumn[20+0]|trigHitsColumn[24+0]| trigHitsColumn[28+0];
    // assign trigerHits[5] = trigHitsColumn[16+1]|trigHitsColumn[20+1]|trigHitsColumn[24+1]| trigHitsColumn[28+1];
    // assign trigerHits[6] = trigHitsColumn[16+2]|trigHitsColumn[20+2]|trigHitsColumn[24+2]| trigHitsColumn[28+2];
    // assign trigerHits[7] = trigHitsColumn[16+3]|trigHitsColumn[20+3]|trigHitsColumn[24+3]| trigHitsColumn[28+3];
    // assign trigerHits[8] = trigHitsColumn[32+0]|trigHitsColumn[36+0]|trigHitsColumn[40+0]| trigHitsColumn[44+0];
    // assign trigerHits[9] = trigHitsColumn[32+1]|trigHitsColumn[36+1]|trigHitsColumn[40+1]| trigHitsColumn[44+1];
    // assign trigerHits[10] = trigHitsColumn[32+2]|trigHitsColumn[36+2]|trigHitsColumn[40+2]| trigHitsColumn[44+2];
    // assign trigerHits[11] = trigHitsColumn[32+3]|trigHitsColumn[36+3]|trigHitsColumn[40+3]| trigHitsColumn[44+3];
    // assign trigerHits[12] = trigHitsColumn[48+0]|trigHitsColumn[52+0]|trigHitsColumn[56+0]| trigHitsColumn[60+0];
    // assign trigerHits[13] = trigHitsColumn[48+1]|trigHitsColumn[52+1]|trigHitsColumn[56+1]| trigHitsColumn[60+1];
    // assign trigerHits[14] = trigHitsColumn[48+2]|trigHitsColumn[52+2]|trigHitsColumn[56+2]| trigHitsColumn[60+2];
    // assign trigerHits[15] = trigHitsColumn[48+3]|trigHitsColumn[52+3]|trigHitsColumn[56+3]| trigHitsColumn[60+3];

    generate
        genvar l;
        for(l = 0; l < 16; l = l + 1)
        begin : loopcolumn
            assign trigHits[l] = trigHitsColumn[(l-(l%4))*4+l%4]|
                                     trigHitsColumn[(l-(l%4))*4+4+l%4]| 
                                     trigHitsColumn[(l-(l%4))*4+8+l%4]|
                                     trigHitsColumn[(l-(l%4))*4+12+l%4];
        end
    endgenerate

endmodule