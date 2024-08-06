`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sun Feb  7 14:12:53 CST 2021
// Module Name: hitSRAM4BWrapper_tb
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`define USE_SHORT_L1HITBUFFER

`define L1_DELAY 9'd501
module hitSRAM4BWrapper_tb;
	reg clk;
    reg reset;

    wire L1A;

    wire hit;
    wire outHit;

    reg [8:0] wrAddr;
    wire [8:0] rdAddr;
    hitSRAM4BWrapper hitMem(
        .clk(clk),
        .hit(hit),
        .rden(L1A),
        .rdAddr(rdAddr),
        .wrAddr(wrAddr),
        .outHit(outHit)
    );

    reg [31:0] counter;
    always @(posedge clk) 
    begin
        if(!reset)
        begin
            counter <= 32'h00000000;
            wrAddr <= 9'h000;
        end
        else
        begin
            wrAddr <= wrAddr +1;
            counter <= counter + 1;
        end 
    end

    assign rdAddr = wrAddr - `L1_DELAY ;
    assign L1A = (counter%7'd40) == 7'd0;
    assign hit = (counter%7'd51) == 7'd0; //about 2%

    initial begin
        clk = 0;
        reset = 0;
    
        #25 reset = 1'b0;
        #50 reset = 1'b1;
        #2000000 $stop;
    end
    always 
        #12.5 clk = !clk; //25 ns clock period


endmodule
