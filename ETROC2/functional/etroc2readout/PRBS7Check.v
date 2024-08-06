`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 23 12:36:50 CST 2021
// Module Name: PRBS7Check
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module PRBS7Check #(parameter WORDWIDTH = 16)
(
	input                   clk,            //40MHz
	input [WORDWIDTH-1:0]   din,
    output                  error           //error flag if it is not prbs7
);
    reg [6:0] r;
    always @(posedge clk) 
    begin
        r <= din[WORDWIDTH-1:WORDWIDTH-7];  //only keep the last 7 bits
    end

    wire [6:0] c [WORDWIDTH:0]; //chain for iteration
    wire [WORDWIDTH - 1 : 0] prbs;
    generate
        genvar i;
        for (i = 0 ; i < WORDWIDTH; i = i + 1)
        begin : loop_itr
            assign prbs[i] = c[i][1]^c[i][0];            
            assign c[i+1] = {prbs[i],c[i][6:1]}; //LSB out, 
        end
    endgenerate
    assign c[0] = r;
    assign error = (prbs != din);

endmodule
