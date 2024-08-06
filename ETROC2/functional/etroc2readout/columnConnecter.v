`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Fri Oct 15 15:25:34 CDT 2021
// Module Name: columnConnecter
// Project Name: ETROC2 readout
// Description: 
// Dependencies: pixelReadout,SWCell
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"

module columnConnecter #(
    parameter BCSTWIDTH = 27
)
(
	input [735:0]   colDataChain,         //46*16
	input [15:0]    colHitChain,
    input [63:0]    trigHitsColumn,       //output to global readout
	output [15:0]   colReadChain,
	output [BCSTWIDTH*16-1:0] colBCSTChain,

    output [15:0]   trigHits,       //0-7 are right, 8-15 are left

//TDC 29 b, E2A,E1A, PixelID 8b
	output [45:0] 	dnDataRight,         
	output          dnUnreadHitRight,
	input 			dnReadRight,
	input [BCSTWIDTH-1:0]     dnBCSTRight,
	output [45:0] 	dnDataLeft,         
	output          dnUnreadHitLeft,
	input 			dnReadLeft,
	input [BCSTWIDTH-1:0]     dnBCSTLeft
);

// tmrg default do_not_triplicate

    wire [BCSTWIDTH-1:0] colBCSTChain2D [15:0];
    wire [45:0] colDataChain2D [15:0];
    generate
        genvar ii;
        for (ii = 0; ii < 16; ii = ii+1) 
        begin 
            assign colDataChain2D[ii] = colDataChain[46*ii+45:46*ii];
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
            .ctData(colDataChain2D[j]),
            .ctHits(colHitChain[j]),
            .ctRead(colReadChain[j]),
            .ctBCST(colBCSTChain2D[j]),
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
    assign  swDataChain[0] = colDataChain2D[0];
    assign  swHitChain[0] = colHitChain[0];
    assign  colReadChain[0] = swReadChain[0];
    assign  colBCSTChain2D[0] = swBCSTChain[0];

    generate
        genvar n;
        for (n = 8; n < 15; n = n+1) //8 to 14
        begin : swLoop2
            SWCell #(.DATAWIDTH(46),.BCSTWIDTH(BCSTWIDTH),.HITSWIDTH(1))SWCellInstLeft(
//ct
            .ctData(colDataChain2D[n]),
            .ctHits(colHitChain[n]),
            .ctRead(colReadChain[n]),
            .ctBCST(colBCSTChain2D[n]),
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
    assign  swDataChain[15] = colDataChain2D[15];
    assign  swHitChain[15] = colHitChain[15];
    assign  colReadChain[15] = swReadChain[15];
    assign  colBCSTChain2D[15] = swBCSTChain[15];

    generate
        genvar jj;
        for (jj = 0; jj < 16; jj = jj+1) 
        begin 
            assign colBCSTChain[jj*BCSTWIDTH+BCSTWIDTH-1:jj*BCSTWIDTH] = colBCSTChain2D[jj];
        end
    endgenerate

    assign dnDataRight      = swDataChain[7];
    assign dnUnreadHitRight = swHitChain[7];
    assign swReadChain[7]   = dnReadRight;
    assign swBCSTChain[7]   = dnBCSTRight;

    assign dnDataLeft      = swDataChain[8];
    assign dnUnreadHitLeft = swHitChain[8];
    assign swReadChain[8]   = dnReadLeft;
    assign swBCSTChain[8]   = dnBCSTLeft;

    generate
        genvar l;
        for(l = 0; l < 16; l = l + 1)
        begin : loopcolumn
            assign trigHits[l] =    trigHitsColumn[(l-(l%4))*4+l%4]|
                                    trigHitsColumn[(l-(l%4))*4+4+l%4]| 
                                    trigHitsColumn[(l-(l%4))*4+8+l%4]|
                                    trigHitsColumn[(l-(l%4))*4+12+l%4];
        end
    endgenerate

endmodule