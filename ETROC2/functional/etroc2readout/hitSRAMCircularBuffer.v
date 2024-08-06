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
    input dis,
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
    // wire [2:0] wrAddrLSB = wrAddr[2:0];
    // always @(posedge clk) 
    // begin
    //     if(~dis)
    //     begin
    //         case (wrAddrLSB)
    //             3'd0: wrReg[0] <= hit;
    //             3'd1: wrReg[1] <= hit;
    //             3'd2: wrReg[2] <= hit;
    //             3'd3: wrReg[3] <= hit;
    //             3'd4: wrReg[4] <= hit;
    //             3'd5: wrReg[5] <= hit;
    //             3'd6: wrReg[6] <= hit;
    //             3'd7: begin end         //do nothing
    //         endcase
    //     end
    // end

    wire [6:0] wrRegEn;
    assign wrRegEn[0] = (wrAddr[2:0] == 3'd0) && !dis;
    assign wrRegEn[1] = (wrAddr[2:0] == 3'd1) && !dis;
    assign wrRegEn[2] = (wrAddr[2:0] == 3'd2) && !dis;
    assign wrRegEn[3] = (wrAddr[2:0] == 3'd3) && !dis;
    assign wrRegEn[4] = (wrAddr[2:0] == 3'd4) && !dis;
    assign wrRegEn[5] = (wrAddr[2:0] == 3'd5) && !dis;
    assign wrRegEn[6] = (wrAddr[2:0] == 3'd6) && !dis;

    always @(posedge clk) 
    begin
        if(wrRegEn[0]) begin
            wrReg[0] <= hit;           
        end
        if(wrRegEn[1]) begin
            wrReg[1] <= hit;           
        end
        if(wrRegEn[2]) begin
            wrReg[2] <= hit;           
        end
        if(wrRegEn[3]) begin
            wrReg[3] <= hit;           
        end
        if(wrRegEn[4]) begin
            wrReg[4] <= hit;           
        end
        if(wrRegEn[5]) begin
            wrReg[5] <= hit;           
        end
        if(wrRegEn[6]) begin
            wrReg[6] <= hit;           
        end
    end

    wire wren = & wrAddr[2:0]; //reduction and
    wire [7:0] rawHits;
    assign rawHits = wren ? {hit, wrReg} : 8'h00; //simple gate. 
    wire gatedWrClk;
    wire gatedRdClk;

    gateClockCell gateWrInst
    (
        .clk(clk),
        .gate(wren&~dis),
        .enableGate(1'b1),
        .gatedClk(gatedWrClk)   
    );    
    gateClockCell gateRdInst
    (
        .clk(~clk),
        .gate(rden&~dis),
        .enableGate(1'b1),
        .gatedClk(gatedRdClk)   
    );    

    wire [7:0] ser_hits;


    cb_hit_mem8_rtl_top hitMemA
    (
        .QA(ser_hits), 
        .E1A(E1A), 
        .CLKA(gatedRdClk), 
        .CENA(~rden), 
        .AA(rdAddr[8:3]), 
        .CLKB(gatedWrClk), 
        .CENB(~wren), 
        .AB(wrAddr[8:3]), 
        .DB(rawHits), 
        .EMAA(3'b010), 
        .EMAB(3'b010), 
        .RET1N(1'b1), 
        .COLLDISN(1'b1)
    );
    assign E2A = 1'b0;

    reg[2:0] rdAddr1D;
    // initial begin
    //     rdAddr1D = 3'b000;  //for initial only
    // end
    always @(negedge clk) 
    begin
        if(rden&~dis)
        begin
            rdAddr1D <= rdAddr[2:0];    
        end        
    end
    assign outHit = ser_hits[rdAddr1D[2:0]];


endmodule

