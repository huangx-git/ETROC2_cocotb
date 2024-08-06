`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Tue Nov 16 15:49:54 CST 2021
// Module Name: simplePLL_tb
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module simplePLL_tb;

	reg clk40Ref;
    reg clk1280In;
    reg [11:0] calibrationTime;
    reg [11:0] lockTime;
    reg reset;
    wire clk40;
    wire clk1280;
    reg startCalibration;
    wire pllCalibrationDone;
    wire instantLock;
    simplePLL dg
    (
        .clk40Ref(clk40Ref),
        .asynReset(reset),
        .clk1280In(clk1280In),
        .calibrationTime(calibrationTime),
        .lockTime(lockTime),
        .pllCalibrationDone(pllCalibrationDone),
        .startCalibration(startCalibration),
        .clk1280(clk1280),
        .clk40(clk40),
        .instantLock(instantLock)
    );

    initial begin
        reset         = 0;
        clk40Ref    = 0;
        clk1280In   = 1;
        calibrationTime     = 12'd123;
        lockTime            = 12'd235;
        startCalibration    = 1'b0;

        #200 reset = 1'b1;
        #200 reset = 1'b0;
        #200 startCalibration = 1'b1;
        #200 startCalibration = 1'b0;
    
        #200000 $stop;
    end

    always 
        #12.48 clk40Ref = ~clk40Ref; //25 ns clock period
    
    always
        #0.390 clk1280In = ~clk1280In;


endmodule
