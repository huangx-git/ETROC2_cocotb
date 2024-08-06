`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 30 12:41:44 CST 2021
// Module Name: CircularBufferAddr
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module CircularBufferAddr 
(
    input clk,       //40MHz
    input reset,     //reset signal from SW
//    input enableGrayCode,
    output [8:0] wrAddr
);
// tmrg default triplicate

    reg [8:0] CBwrAddr;
    wire [8:0] CBwrAddrNext = CBwrAddr + 9'd1; 
    wire [8:0] CBwrAddrNextVoted = CBwrAddrNext;
    always @(negedge clk) 
    begin
		if(!reset) 
        begin
            CBwrAddr          <= 9'h000;
		end
		else
        begin 
            CBwrAddr          <= CBwrAddrNextVoted;
		end
	end 
//    assign wrAddr = enableGrayCode ? CBwrAddr ^ (CBwrAddr >>1) : CBwrAddr;
    assign wrAddr = CBwrAddr;
endmodule
