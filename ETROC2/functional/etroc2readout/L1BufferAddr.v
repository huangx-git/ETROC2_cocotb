`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 30 12:41:44 CST 2021
// Module Name: L1BufferAddr
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module L1BufferAddr #(
    parameter ADDRWIDTH = 7
)
(
    input clk,              //40MHz
    input reset,            //reset signal from SW
    input wrEn,              //L1A select signal from globalReadout
    input rdEn,             
    output [ADDRWIDTH-1:0] wordCount,
    output reg [ADDRWIDTH-1:0] wrAddr,
    output reg [ADDRWIDTH-1:0] rdAddr,
    output firstEvent,
    output empty,
    output full     //

);
// tmrg default triplicate

    reg wrenFIFO;
    reg wrEnDelay;
    wire fifoEmpty;
    wire fifoFull;
    reg fifoEmpty1D;
    reg fifoFull1D;
    reg firstEventReg;
    always @(negedge clk) 
    begin
        wrEnDelay   <= wrEn;
        wrenFIFO    <= wrEnDelay;  //read one clock later to match the circular buffer readout
        fifoEmpty1D <= fifoEmpty;
        fifoFull1D  <= fifoFull;
        firstEventReg <= fifoEmpty1D & !fifoEmpty;
    end

    assign full = fifoFull1D | fifoFull;
    assign empty = fifoEmpty1D; //| fifoEmpty;  //tell readout not empty one clock later 
    assign firstEvent = firstEventReg;//fifoEmpty1D & !fifoEmpty;

    wire [ADDRWIDTH-1:0] wrAddr1;
    wire [ADDRWIDTH-1:0] rdAddr1;

    FIFOWRCtrlerDDR #(.WIDTH(ADDRWIDTH)) L1Ctrl(

        .clk(clk),
        .reset(reset),
        .wren(wrenFIFO),
        .rden(rdEn),
        .enWordCount(1'b1),
        .empty(fifoEmpty),     //not used
        .full(fifoFull),      //not used
        .wrAddr(wrAddr1),
        .rdAddr(rdAddr1),
        .wordCount(wordCount)   //not used
    );

   always @(posedge clk) 
    begin
        wrAddr <= wrAddr1;
    end    

   always @(negedge clk) 
    begin
        rdAddr <= rdAddr1;
    end    
endmodule
