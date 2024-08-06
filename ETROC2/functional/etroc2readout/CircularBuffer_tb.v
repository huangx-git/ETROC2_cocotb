`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 23 12:36:50 CST 2021
// Module Name: circularBuffer_tb
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////

module circularBuffer_tb;

	reg clk;
    reg reset;


    reg [11:0] counter;
    wire [29:0] TDCData;
    wire hitIn;
    wire L1A;
    assign hitIn = counter[3:0] == 4'H00; //for every 16 data
    assign TDCData = {counter[4:0], counter, counter, hitIn};
  //  assign TDCData = {counter, 1'b0};
    assign L1A = counter%2'd3 == 2'H0;
    always @(posedge clk) 
    begin
        if(!reset)
        begin
            counter <= 29'h00000000;
        end
        else
        begin
            counter <= counter + 1;
        end
    end

    wire [8:0] latency;
    assign latency = 9'd501;
 //   assign latency = 9'd511;
 //   assign latency = 9'd1;
 //   assign latency = 9'd1;
//`undef USE_SHORT_L1HITBUFFER
//`define USE_SIMPLE_SRAM_FOR_HITBUFFER
    wire [28:0] TDCDataOut1;
    wire [11:0] outputCounter1;
    wire [11:0] deltaCounter1;
    assign outputCounter1 = TDCDataOut1[11:0];
    assign deltaCounter1 = counter - outputCounter1;

    wire hitA1;
    wire hitB1;
    wire hitC1;
    circularBuffer CBInstsimple(
        .clk(clk),
        .reset(reset), 
        .din(TDCData),
        .L1A(L1A),
        .latencyL1A(9'd501),
        .dout(TDCDataOut1),
        .hitA(hitA1),
        .hitB(hitB1),
        .hitC(hitC1),
        .E1A(),
        .E2A()
    );
/*
`define USE_SHORT_L1HITBUFFER
`undef USE_SIMPLE_SRAM_FOR_HITBUFFER
   wire [28:0] TDCDataOut2;
    wire [11:0] outputCounter2;
    wire [11:0] deltaCounter2;
    assign deltaCounter2 = counter - outputCounter2;
    assign outputCounter2 = TDCDataOut2[11:0];
    wire hitA2;
    wire hitB2;
    wire hitC2;
    circularBuffer CBInstShort(
        .clk(clk),
        .reset(reset), 
        .din(TDCData),
        .L1A(L1A),
        .latencyL1A(9'd501),
        .dout(TDCDataOut2),
        .hitA(hitA2),
        .hitB(hitB2),
        .hitC(hitC2),
        .E1A(),
        .E2A()
    );

`undef USE_SHORT_L1HITBUFFER
`undef USE_SIMPLE_SRAM_FOR_HITBUFFER
   wire [28:0] TDCDataOut3;
    wire [11:0] outputCounter3;
    wire [11:0] deltaCounter3;
    assign deltaCounter3 = counter - outputCounter3;
    assign outputCounter3 = TDCDataOut3[11:0];
    wire hitA3;
    wire hitB3;
    wire hitC3;
    circularBuffer CBInst4bit(
        .clk(clk),
        .reset(reset), 
        .din(TDCData),
        .L1A(L1A),
        .latencyL1A(9'd501),
        .dout(TDCDataOut3),
        .hitA(hitA3),
        .hitB(hitB3),
        .hitC(hitC3),
        .E1A(),
        .E2A()
    );
*/

    initial begin
        clk = 0;
        reset = 1;
    
        #25 reset = 1'b0;
        #50 reset = 1'b1;
        #2500000 $stop;
    end
    always 
        #12.5 clk = ~clk; //25 ns clock period



endmodule
