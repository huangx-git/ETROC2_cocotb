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

    // reg enable;
	reg clk40;
    reg clk1280;
    reg [4:0] clockDelay1;
    reg [4:0] pulseWidth1;

    reg [4:0] clockDelay2;
    reg [4:0] pulseWidth2;

    wire clkout1;
    wire clkout2;
    digitalPhaseshifter dg
    (
        .clk40(clk40),
        .clk1280(clk1280),
        // .enable(enable),
        .clockDelay1(clockDelay1),
        .clockDelay2(clockDelay2),
        .pulseWidth1(pulseWidth1),
        .pulseWidth2(pulseWidth2),
        .clkout1(clkout1),
        .clkout2(clkout2)
    );

    initial begin
        // enable = 1;
        pulseWidth1 = 16;
        pulseWidth2 = 16;
        clk40 = 0;
        clk1280 = 1;
        clockDelay2 = 5'd0;
        clockDelay1 = 5'd0;
        #200 clockDelay1 = 5'd0;
        #200 clockDelay1 = 5'd1;
        #200 clockDelay1 = 5'd2;
        #200 clockDelay1 = 5'd3;
//        enable = 1'b1;
        #200 clockDelay1 = 5'd29;
        #200 clockDelay1 = 5'd30;
        #200 clockDelay1 = 5'd31;

        #200 clockDelay1 = 5'd0;
        #200 pulseWidth1 = 5'd0;
        #200 pulseWidth1 = 5'd1;
        #200 pulseWidth1 = 5'd2;
        #200 pulseWidth1 = 5'd3;
        // enable = 1'b0;

        #200 pulseWidth1 = 5'd15;
        #200 pulseWidth1 = 5'd16;

        #200 pulseWidth1 = 5'd29;
        #200 pulseWidth1 = 5'd30;
        #200 pulseWidth1 = 5'd31;
        // enable = 1'b1;

        #200 clockDelay2 = 5'd0;
        #200 clockDelay2 = 5'd1;
        #200 clockDelay2 = 5'd2;
        #200 clockDelay2 = 5'd3;

        #200 clockDelay2 = 5'd29;
        #200 clockDelay2 = 5'd30;
        #200 clockDelay2 = 5'd31;

        // enable = 1'b0;

        #200 clockDelay2 = 5'd0;
        #200 pulseWidth2 = 5'd0;
        #200 pulseWidth2 = 5'd1;
        #200 pulseWidth2 = 5'd2;
        #200 pulseWidth2 = 5'd3;

        #200 pulseWidth2 = 5'd15;
        #200 pulseWidth2 = 5'd16;
        // enable = 1'b1;

        #200 pulseWidth2 = 5'd29;
        #200 pulseWidth2 = 5'd30;
        #200 pulseWidth2 = 5'd31;

        #200 $stop;
    end

    always 
        #12.48 clk40 = ~clk40; //25 ns clock period
    
    always
        #0.390 clk1280 = ~clk1280;


endmodule
