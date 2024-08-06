`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sun Feb  7 14:12:53 CST 2021
// Module Name: hitSRAMCircularBuffer
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"

module hitSRAMCircularBuffer
(
	input clk,                  //40MHz
	input hit,                  //hit
    input rden,                 //read enable, high active
    input [8:0] rdAddr,
    input [8:0] wrAddr,
    output E1A,
    output E2A,
	output outHit               //
);
// tmrg default do_not_triplicate

    reg [6:0] wrReg;          //temperary regs 
    wire wren = & wrAddr[2:0]; //reduction and
    always @(posedge clk) 
    begin
        if(wren != 1'b1)
        begin
            wrReg[wrAddr[2:0]] <= hit;    
        end
    end

    wire [7:0] rawHits;
    assign rawHits = wren ? {hit, wrReg} : 8'h00; //simple gate. 
    wire [11:0] hitOut;
    wire gatedWrClk;
    wire gatedRdClk;
    // assign gatedWrClk = wren & clk;
    // assign gatedRdClk = rden & !clk;

    gateClockCell gateWrInst
    (
        .clk(clk),
        .gate(wren),
        .enableGate(1'b1),
        .gatedClk(gatedWrClk)   
    );    
    gateClockCell gateRdInst
    (
        .clk(!clk),
        .gate(rden),
        .enableGate(1'b1),
        .gatedClk(gatedRdClk)   
    );    

    wire [7:0] ser_hits;


    cb_hit_mem8_rtl_top hitMemA
    (
        .QA(ser_hits), 
        .E1A(E1A), 
        .CLKA(gatedRdClk), 
        .CENA(!rden), 
        .AA(rdAddr[8:3]), 
        .CLKB(gatedWrClk), 
        .CENB(!wren), 
        .AB(wrAddr[8:3]), 
        .DB(rawHits), 
        .EMAA(3'b010), 
        .EMAB(3'b010), 
        .RET1N(1'b1), 
        .COLLDISN(1'b1)
    );
    assign E2A = 1'b0;

    reg[2:0] rdAddr1D;
    initial begin
        rdAddr1D = 3'b000;  //for initial only
    end
    always @(negedge clk) 
    begin
        if(rden == 1'b1)
        begin
            rdAddr1D <= rdAddr[2:0];    
        end        
    end
    assign outHit = ser_hits[rdAddr1D[2:0]];


endmodule

