`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Thu Feb 11 12:58:07 CST 2021
// Module Name: triggerProcessor
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// LSB first serializer


//////////////////////////////////////////////////////////////////////////////////

module triggerProcessor(
    input           clk,            //
    input           reset,
    input [15:0]    trigHits,       //16 bits trigger bits
    input [11:0]    BCID,
    input [11:0]    emptySlotBCID,   // specify one empty slot of BCID for synchronization.
    output [15:0]   encTrigHits       //encoded trigHits  
);
// tmrg default triplicate

    wire emptySlot = BCID == emptySlotBCID;

    reg odd;
    wire nextOdd = ~odd;
    wire nextOddVoted = nextOdd;
    always @(negedge clk) 
    begin
        if(~reset)
        begin
            odd <= 1'b0;
        end
        else if (emptySlot)
        begin
            odd <= nextOddVoted;
        end
    end
    
    assign encTrigHits = ~emptySlot ? trigHits : 
                         ( odd ? 16'H0000 : 16'HFFFF);
endmodule