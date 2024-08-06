`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Wed Mar  3 17:05:22 CST 2021
// Module Name: hitSRAML1Buffer
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////

module hitSRAML1Buffer #(
    parameter ADDRWIDTH = 7
)
(
	input clk,                  //40MHz
    input dis,
	input hit,                  //hit
    input rden,                 //read enable, high active
    input wren,                 //write enable, high active
    input [ADDRWIDTH-1:0] rdAddr,
    input [ADDRWIDTH-1:0] wrAddr,
    output  E1A,                //hamming code error detection. error or not
    output  E2A,                //
	output outHit               //
);
// tmrg default do_not_triplicate

    wire gatedWrClk;
    wire gatedRdClk;
    gateClockCell gateWrInst
    (
        .clk(~clk),
        .gate(wren & ~dis),
        .enableGate(1'b1),
        .gatedClk(gatedWrClk)   
    );    
    gateClockCell gateRdInst
    (
        .clk(clk),
        .gate(rden & ~dis),
        .enableGate(1'b1),
        .gatedClk(gatedRdClk)   
    );    

    L1_hit_mem_rtl_top hitMem
    (
        .QA(outHit), 
        .E1A(E1A),
        .E2A(E2A),
        .CLKA(gatedRdClk), 
        .CENA(~rden), 
        .AA(rdAddr), 
        .CLKB(gatedWrClk), 
        .CENB(~wren), 
        .AB(wrAddr), 
        .DB(hit), 
        .EMAA(3'b010), 
        .EMAB(3'b010), 
        .RET1N(1'b1), 
        .COLLDISN(1'b1)
    );

endmodule
