`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Fri Apr 23 22:49:35 CDT 2021
// Module Name: columnAdapterChain
// Project Name: ETROC2 readout
// Description: Create Column ID and process trigger hit
// Dependencies: pixelReadout,SWCell
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"

module columnAdapterChain 
(
    input [63:0] trigHitsColumn,
    output [63:0] columnIds,    //output column IDs for data readout
    output [15:0] trigHits      //final trigger Hits
);
// tmrg default do_not_triplicate

    wire [3:0] columnAddrChain [16:0];
    wire [7:0] rightHits;
    wire [7:0] leftHits;
    assign columnAddrChain[0] = 4'H0;
    wire [7:0] rightTrigHitsChain [8:0];
    assign rightTrigHitsChain[0] = 8'H00;
    wire [7:0] leftTrigHitsChain [8:0];
    assign leftTrigHitsChain[8] = 8'H00;

    wire [7:0] columnTrigHits [15:0];

    generate
        genvar i;
        for(i = 0 ; i < 8; i = i + 1) //right half
        begin : colLoop0
            columnAdapter columnAdapterInst(
                .trigHits(trigHitsColumn[i*4+3:i*4]),
                .columnAddrIn(columnAddrChain[i]),
                .columnAddrNextOut(columnAddrChain[i+1]),
                .columnAddr(columnIds[4*i+3:4*i]),
                .columTrigHits(columnTrigHits[i])
            ); 
            SWCell #(.DATAWIDTH(1),.BCSTWIDTH(1),.HITSWIDTH(8))SWCellInstRght(
            .ctData(1'b0),
            .ctHits(columnTrigHits[i]),
            .ctRead(),
            .ctBCST(),
//up  0-6
            .upData(1'b0),  
            .upHits(rightTrigHitsChain[i]),
            .upRead(),
            .upBCST(),
//dn  1-7
            .dnData(),
            .dnHits(rightTrigHitsChain[i+1]),
            .dnRead(1'b0),
            .dnBCST(1'b0)
            );
        end

        for(i = 8 ; i < 16; i = i + 1) //right half
        begin : colLoop1
            columnAdapter columnAdapterInst(
                .trigHits(trigHitsColumn[i*4+3:i*4]),
                .columnAddrIn(columnAddrChain[i]),
                .columnAddrNextOut(columnAddrChain[i+1]),
                .columnAddr(columnIds[4*i+3:4*i]),
                .columTrigHits(columnTrigHits[i])
            ); 
            SWCell #(.DATAWIDTH(1),.BCSTWIDTH(1),.HITSWIDTH(8))SWCellInstLeft(
            .ctData(1'b0),
            .ctHits(columnTrigHits[i]),
            .ctRead(),
            .ctBCST(),
//up  
            .upData(1'b0),  
            .upHits(leftTrigHitsChain[i-8+1]),
            .upRead(),
            .upBCST(),
//dn  
            .dnData(),
            .dnHits(leftTrigHitsChain[i-8]),
            .dnRead(1'b0),
            .dnBCST(1'b0)
            );

        end
    endgenerate

    assign trigHits = {leftTrigHitsChain[0],rightTrigHitsChain[8]};

endmodule