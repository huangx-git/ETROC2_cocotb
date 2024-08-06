`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Tue Nov 16 15:49:54 CST 2021
// Module Name: digitalPhaseshifter_tb
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module digitalPhaseshifter_tb;

    reg enable;
	reg clk40;
    reg clk1280;
    reg [5:0] clockDelay;
    reg [7:0] clock320Mask;
    wire clk40out;
    wire clk320out;
    digitalPhaseshifterTDCClk dg
    (
        .clk40(clk40),
        .clk1280(clk1280),
        .enable(enable),
        .clockDelay(clockDelay),
        .clock320Mask(clock320Mask),
        .clk40out(clk40out),
        .clk320out(clk320out)
    );

    initial begin
        enable = 1;
        clk40 = 0;
        clk1280 = 1;
        clockDelay = 5'd0;
        clock320Mask = 8'b11000000;
        #200 clockDelay = 6'd0;
        #200 clockDelay = 6'd1;
        #200 clockDelay = 6'd2;
        #200 clockDelay = 6'd3;
//        enable = 1'b1;
        #200 clockDelay = 6'd59;
        #200 clockDelay = 6'd60;
        #200 clockDelay = 6'd61;
        #200 clockDelay = 6'd62;
        #200 clockDelay = 6'd63;

        #200 clockDelay = 6'd0;
        #200 clock320Mask = 8'b11000000;
        #200 clock320Mask = 8'b10100000;
        #200 clock320Mask = 8'b10010000;
        #200 clock320Mask = 8'b10001000;
        #200 clock320Mask = 8'b10000100;
        #200 clock320Mask = 8'b10000010;
        #200 clock320Mask = 8'b10000001;
        #200 clock320Mask = 8'b00000011;
        #200 $stop;
    end

    always 
        #12.48 clk40 = ~clk40; //25 ns clock period
    
    always
        #0.390 clk1280 = ~clk1280;


endmodule
