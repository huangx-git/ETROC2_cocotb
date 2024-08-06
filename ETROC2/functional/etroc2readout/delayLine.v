`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat May  1 21:08:38 CDT 2021
// Module Name: DelayLine
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////

module delayLine
(
    input bitClk,
    input [5:0] delay,
    input sin,  //input serial data 
    input sout  //output serial data
);

    reg[63:0] mem;
    
    always @( posedge bitClk) begin
        mem[63:0] <= {mem[62:0],sin};
    end

    assign sout = mem[delay[5:0]];

endmodule
