`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 23 12:36:50 CST 2021
// Module Name: L1EventBuffer
// Project Name: ETROC2 readout
// Description: 
// Dependencies: FIFOWRCtrler, sram_rf_model, majorityVoterTagGates
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"

module L1EventBuffer #(
    parameter ADDRWIDTH = 7
)
(
    input clk,            //40MHz
    input reset,           //reset signal from SW
    input [35:0] din,      //data from circular buffer
    input inHit,
    input [ADDRWIDTH-1:0] wrAddr,   //from global
    input [ADDRWIDTH-1:0] rdAddr,   //from global
    input preLoad,                  //preLoad hit 
    input full,                     //from global
    input E1A,
    input E2A,
    input wren,
    input read,     //the data read signal from SW network
    input load,      //the data load signal from SW network
    output unreadHit, //unread hit signal for SW network, positive edge clock
    output outE1A,
    output outE2A,
    output [35:0] dout  //29 bit TDC data + 7 bits hamming code
);
// tmrg default do_not_triplicate

    wire gatedRdClk;
    wire gatedWrClk;
    wire outHit;
    wire hitE1A;
    wire hitE2A;
    wire loadHit;
    assign loadHit = preLoad;
    reg wrenHit;
    wire wrenData;
    reg inHit1D;
    always @(posedge clk) 
    begin
        wrenHit <= wren;
        inHit1D <= inHit;
    end
    assign wrenData = inHit1D & wrenHit;

    hitSRAML1Buffer #(.ADDRWIDTH(ADDRWIDTH)) hitBuffer(
        .clk(clk),
        .hit(inHit1D),
        .rden(loadHit),
        .E1A(hitE1A),
        .E2A(hitE2A),
        .wren(wrenHit),
        .rdAddr(rdAddr),
        .wrAddr(wrAddr),
        .outHit(outHit)
    );
    reg outHitReg;
    reg hitE1AReg;
    reg hitE2AReg;
    always @(posedge clk) 
    begin
        if(!reset)
        begin
            outHitReg <= 1'b0;
        end
        else if(load)   //we ensure that there is no load signal occur at same time
        begin
            outHitReg <= outHit;
        end
        hitE1AReg <= hitE1A;
        hitE2AReg <= hitE2A;       
    end

    reg hitMask;
    always @(posedge clk) 
    begin
        if(!reset)
        begin
            hitMask <= 1'b1;    
        end
        else if(load == 1'b1)
        begin
                hitMask <= 1'b1;
        end
        else
        begin
	        hitMask <= ((read == 1'b1) ? 1'b0 : hitMask);  
        end
    end
    assign unreadHit = hitMask & outHitReg;

    wire loadData;        
    assign loadData = outHit & load;


    gateClockCell gateWrInst
    (
        .clk(!clk),
        .gate(wrenData),
        .enableGate(1'b1),
        .gatedClk(gatedWrClk)   
    );

    gateClockCell gateRdInst
    (
        .clk(clk),
        .gate(loadData),
        .enableGate(1'b1),
        .gatedClk(gatedRdClk)   
    );

    reg [ADDRWIDTH-1:0] wrAddrData;
    reg [ADDRWIDTH-1:0] rdAddrData;

    always @(*) begin
        if(loadData)begin
            rdAddrData  =  rdAddr;  
        end
    end
    always @(*) begin
        if(wrenData)begin
            wrAddrData  =  wrAddr;  
        end
    end


    wire dataE1A;
    wire dataE2A;
    wire [37:0] wrData;
    assign #0.4 wrData = {din,E2A,E1A};
    L1_data_mem dataBuffer
    (
        .QA({dout,dataE2A,dataE1A}), 
        .CLKA(gatedRdClk), 
        .CENA(!loadData), 
        .AA(rdAddrData), 
        .CLKB(gatedWrClk), 
        .CENB(!wrenData), 
        .AB(wrAddrData), 
        .DB(wrData), 
        .EMAA(3'b010), 
        .EMAB(3'b010), 
        .RET1N(1'b1), 
        .COLLDISN(1'b1)
    );

    assign outE1A = dataE1A | hitE1AReg;
    assign outE2A = hitE2AReg; //dataE2A | hitE2AReg; 

endmodule
