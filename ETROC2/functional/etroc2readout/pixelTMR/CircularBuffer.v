`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 23 12:36:50 CST 2021
// Module Name: circularBuffer
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"

module circularBuffer
(
	input clk,                  //40MHz
    input reset,                //reset address
    input [8:0] wrAddr,
	//input [29:0] din,           //data from TDC
    input [28:0] din,           //TDC data, not hit
    input inHit,                //validate hitflag 
    input L1A,                  //L1A 
    input L1ADelay,             //delay a clock
    input [8:0] latencyL1A,     //the L1A read address offset to write address
	output [35:0] dout,        // 29 bits data + 7 bits hamming code
    output hit,                //TMR hit information
    output E1A,
    output E2A                  //error detector information
);
// tmrg default do_not_triplicate

    reg rdenData;
    wire outHit;
    always @(posedge clk) 
    begin
        rdenData   <= L1ADelay & outHit;
	end
    
    wire gatedWrClk;
    wire gatedRdClk;

    //assign gatedWrClk = inHit & clk;
    gateClockCell gateWrInst
    (
        .clk(clk),
        .gate(inHit),
        .enableGate(1'b1),
        .gatedClk(gatedWrClk)   
    );
    //assign gatedRdClk = !clk & rdenData;
    gateClockCell gateRdInst
    (
        .clk(!clk),
        .gate(rdenData),
        .enableGate(1'b1),
        .gatedClk(gatedRdClk)   
    );

    wire [8:0] rdAddrData;
    reg [8:0] latchedWrAddrData;
    always @(*)begin
         if(rdenData) begin
            latchedWrAddrData = wrAddr;
         end
    end
    assign rdAddrData = latchedWrAddrData - latencyL1A;

   cb_data_mem_rtl_top dataMem
   (
        .QA(dout), 
        .CLKA(gatedRdClk), 
        .CENA(!rdenData), 
        .AA(rdAddrData), 
        .CLKB(gatedWrClk), 
        .CENB(!inHit), 
        .AB(wrAddr), 
        .DB(din), 
        .EMAA(3'b010), 
        .EMAB(3'b010), 
        .RET1N(1'b1), 
        .COLLDISN(1'b1)
   );
/*
    sram_rf_model #(.wordwidth(32),.addrwidth(9)) dataMem(
            .QA({dummy,dout}),
            .E1A(E1A),   //Output for check
            .E2A(E2A),   //Output for check 
            .CLKA(gatedRdClk),
            .CENA(!rdenData),
            .AA(rdAddrData),
            .CLKB(gatedWrClk),
            .CENB(!inHit),   //do not select chip if no hit
            .AB(wrAddr),     
            .DB({3'b000, wrData}), 
            .EMAA(3'b0),       //not used
            .EMAB(3'b0),       //not used
            .RET1N(1'b1),      
            .COLLDISN(1'b0)   //not used
    );
*/
    wire rdenHit;
    assign rdenHit = L1A;  //synchronized L1A
    reg [8:0] latchedWrAddrHit;
    wire [8:0] rdAddrHit;
    always @(*)begin
         if(rdenHit) begin
            latchedWrAddrHit = wrAddr;
         end
    end
    assign rdAddrHit = latchedWrAddrHit - (latencyL1A - 1);

    wire hitE1A;
    wire hitE2A;
    hitSRAMCircularBuffer hitMem(
        .clk(clk),
        .hit(inHit),
        .rden(rdenHit),
        .E1A(hitE1A),
        .E2A(hitE2A),
        .rdAddr(rdAddrHit),
        .wrAddr(wrAddr),
        .outHit(outHit)
    );

    reg outHitReg;
    reg E1AReg;
    reg E2AReg;
    always @(negedge clk) 
    begin
        outHitReg       <= outHit;
        E1AReg          <= hitE1A;
        //E2AReg          <= hitE2A;
	end
    assign hit = outHitReg;
    assign E1A = E1AReg;
    assign E2A = 1'b0;//E2AReg;
    
endmodule
