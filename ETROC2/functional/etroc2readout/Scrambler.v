`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Mon Feb  8 19:42:43 CST 2021
// Module Name: Scrambler
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// The scrambling polynomial : x^58 + x^39 + 1
// LSB first scrambling
// DIN (LSB first)
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
module Scrambler
(
    input                       clk,
    input                       reset,
    input [1:0]                 dataWidth,   //00: 8, 01:16, 10/11: 32  
	input [31:0] 	            din,         //input data width not more than 32
    input                       bypass,      //bypass scrambler or not
	output [31:0]               dout        //output data
);
// tmrg default triplicate

    reg[57:0] r;        //internal registers

    wire [57:0] c[32:0];      //chain for iteration
    wire [57:0] rNext = dataWidth == 2'b00 ? c[8] : 
                        (dataWidth == 2'b01 ? c[16] : c[32]);
    wire [57:0] rNextVoted = rNext;
    always @(negedge clk) 
    begin
        if(~reset)
        begin
                r <= {29{2'b00}}; //initial     
        end
        else if (~bypass)  // 
        begin
                r <= rNextVoted;
        end
    end

    wire [31:0] d;
    wire [31:0] outbuf;
    assign d    = bypass ? {32{1'b0}} : din;  //disable data as well
    assign dout = bypass ? din : 
                  (dataWidth == 2'b00 ? {{24{1'b0}},outbuf[7:0]} :
                  (dataWidth == 2'b01 ? {{16{1'b0}},outbuf[15:0]} : outbuf));    //

    // generate
    //     genvar i;
    //     for (i = 0; i < WORDWIDTH; i = i+1 )
    //     begin : scr_itr
    //         assign c[i+1] = {c[i][56:0],d[i]^c[i][38]^c[i][57]}; 
    //         assign outbuf[i] = d[i]^c[i][38]^c[i][57];      
    //     end    
    // endgenerate

    generate
        genvar i;
        for (i = 0; i < 32; i = i+1 )
        begin : scr_itr
            assign c[i+1] = {c[i][56:0],d[i]^c[i][38]^c[i][57]}; 
            assign outbuf[i] = d[i]^c[i][38]^c[i][57];      
        end    
    endgenerate

    assign c[0]    = r;

endmodule