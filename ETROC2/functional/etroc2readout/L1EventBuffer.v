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
    input dis,
    input [35:0] din,      //data from circular buffer
    input inHit,
    input [ADDRWIDTH-1:0] wrAddr,   //from global
    input [ADDRWIDTH-1:0] rdAddr,   //from global
    input preLoad,                  //preLoad hit 
 //   input full,                     //from global
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
        if(~dis)
        begin
            wrenHit <= wren;
            inHit1D <= inHit;
        end
    end
    assign wrenData = inHit1D & wrenHit;

    hitSRAML1Buffer #(.ADDRWIDTH(ADDRWIDTH)) hitBuffer(
        .clk(clk),
        .dis(dis),
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
            hitE1AReg <= 1'b0;
            hitE2AReg <= 1'b0;
        end
        else if(~dis)
        begin
            hitE1AReg <= hitE1A;
            hitE2AReg <= hitE2A;    
        end   
    end

    always @(posedge clk) 
    begin
        if(!reset)
        begin
            outHitReg <= 1'b0; 
        end
        else if(~dis)
        begin
            if(load == 1'b1)
            begin
                outHitReg <= outHit;
            end
            else if(read == 1'b1)
            begin
                outHitReg <= 1'b0;
            end
        end
    end
    assign unreadHit = outHitReg & ~dis;

    wire loadData;        
    assign loadData = outHit & load;


    gateClockCell gateWrInst
    (
        .clk(~clk),
        .gate(wrenData & ~dis),
        .enableGate(1'b1),
        .gatedClk(gatedWrClk)   
    );

    gateClockCell gateRdInst
    (
        .clk(clk),
        .gate(loadData & ~dis),
        .enableGate(1'b1),
        .gatedClk(gatedRdClk)   
    );

    wire [ADDRWIDTH-1:0] wrAddrData;
    wire [ADDRWIDTH-1:0] rdAddrData;
    assign rdAddrData = {ADDRWIDTH{loadData}} & rdAddr;
    assign wrAddrData = {ADDRWIDTH{wrenData}} & wrAddr;

    wire dataE1A;
    wire dataE2A;
    reg [37:0] wrData;
    wire [37:0] rdData;
    //assign #0.4 wrData = {din,E2A,E1A};
    //assign wrData = {din,E2A,E1A};
    always @(posedge clk)
    begin
        if(wren & inHit & ~dis)
            wrData  <= {din,E2A,E1A};     
    end

`ifdef LATCH_RAM
    latchedBasedRAM #(.data_width(38),.depth(128),.log_depth(7),.delay(4)) u0
`else
    L1_data_mem dataBuffer
`endif
    (
//        .QA({dout,dataE2A,dataE1A}), 
        .QA(rdData),
        .CLKA(gatedRdClk), 
        .CENA(~loadData), 
        .AA(rdAddrData), 
        .CLKB(gatedWrClk), 
        .CENB(~wrenData), 
        .AB(wrAddrData), 
        .DB(wrData), 
        .EMAA(3'b010), 
        .EMAB(3'b010), 
        .RET1N(1'b1), 
        .COLLDISN(1'b1)
    );

    assign dout     = rdData[37:2];
    assign dataE1A  = rdData[0];
    assign outE1A   = dataE1A | hitE1AReg;
    assign outE2A   = hitE2AReg; //dataE2A | hitE2AReg; 
    
endmodule
