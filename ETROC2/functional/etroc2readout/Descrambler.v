`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Tue Feb  9 10:18:39 CST 2021
// Module Name: Descrambler
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// The scrambling polynomial : x^58 + x^39 + 1
// LSB firs scrambling
//
//DIN (LSB first)
//    |
//    V
//   (+)<---------------------------(+)<-----------------------------.
//    |                              ^                               |
//    |  .----.  .----.       .----. |  .----.       .----.  .----.  |
//    +->|  0 |->|  1 |->...->| 38 |-+->| 39 |->...->| 56 |->| 57 |--'
//    |  '----'  '----'       '----'    '----'       '----'  '----'
//    V
//   DOUT


//////////////////////////////////////////////////////////////////////////////////


module Descrambler #(parameter WORDWIDTH = 40) 
(
    input                       clk,
    input                       reset,
	input [WORDWIDTH-1:0] 	    din,         //input data
    input                       bypass,      //bypass scrambler or not
	output [WORDWIDTH-1:0]      dout         //output data
);

    reg[57:0] r;        //internal registers

    wire [57:0] c[WORDWIDTH:0]; //chain for iteration
    always @(posedge clk) 
    begin
        if(!reset)
        begin
                r <= {29{2'b00}}; //initial     
        end
        else if (!bypass)  // 
        begin
                r <= c[WORDWIDTH];
        end
    end

    wire [WORDWIDTH-1:0] d;  //input buffer
    wire [WORDWIDTH-1:0] outbuf; //output buffer
    assign d    = bypass ? {WORDWIDTH{1'b0}} : din;  //disable data as well
    assign dout = bypass ? din : outbuf;    //
    generate
        genvar i;
        for (i = 0; i < WORDWIDTH; i = i+1 )
        begin : dscr_itr
            assign c[i+1] = {c[i][56:0],d[i]};
            assign outbuf[i] = d[i]^c[i][38]^c[i][57];        
        end    
    endgenerate

    assign c[0]  = r;

endmodule