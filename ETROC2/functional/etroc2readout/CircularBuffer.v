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
//    input reset,                //reset address
    input dis,
    input [8:0] wrAddr,
	//input [29:0] din,           //data from TDC
    input [28:0] din,           //TDC data, not hit
    input inHit,                //validate hitflag 
    input L1APre,               //L1A from globalReadout, aligned to falling edge
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
        if(!dis)
            rdenData   <= L1ADelay & outHit;
	end
    
    wire gatedWrClk;
    wire gatedRdClk;

    gateClockCell gateWrInst
    (
        .clk(clk),
        .gate(inHit&~dis),
        .enableGate(1'b1),
        .gatedClk(gatedWrClk)   
    );
    
    gateClockCell gateRdInst
    (
        .clk(~clk),
        .gate(rdenData&~dis),
        .enableGate(1'b1),
        .gatedClk(gatedRdClk)   
    );

    // wire rdenDataN = L1ADelay & outHit;         //aligned to clock falling edge.
    // wire gatedRdDataAddrClk;
    // gateClockCell gateDataAddrClkInst
    // (
    //     .clk(clk),
    //     .gate(rdenDataN),
    //     .enableGate(1'b1),
    //     .gatedClk(gatedRdDataAddrClk)   
    // );

    reg [8:0] latchedwrAddr1;
    always @(posedge clk)
    begin
        if(~dis & L1ADelay & outHit)
            latchedwrAddr1 <= wrAddr;
    end

    // wire rdAddrDataGate = L1ADelay & outHit;
    // always @(*)
    // begin
    //     if(rdAddrDataGate)
    //         latchedwrAddr1 <= wrAddr;
    // end

    wire [8:0] rdAddrData = latchedwrAddr1 - latencyL1A;
 
 //`ifdef LATCH_RAM
//     reg [8:0] gatedWrAddr;
//     always @(*)
//     begin
//         if (inHit)
//         begin
//             gatedWrAddr <= wrAddr;
//         end
//     end
//  //`endif
    
   wire [8:0] gatedWrAddr;
//    assign gatedWrAddr = {9{inHit}} & wrAddr;

    wire delayInHit;
    assign #0.05  delayInHit = inHit;
    assign gatedWrAddr = {9{delayInHit}} & wrAddr;

   cb_data_mem_rtl_top dataMem
   (
        .QA(dout), 
        .CLKA(gatedRdClk), 
        .CENA(~rdenData), 
        .AA(rdAddrData), 
        .CLKB(gatedWrClk), 
        .CENB(~inHit), 
 //`ifdef LATCH_RAM
         .AB(gatedWrAddr),
 //`else
 //       .AB(wrAddr),  
 //`endif 
        .DB(din), 
        .EMAA(3'b010), 
        .EMAB(3'b010), 
        .RET1N(1'b1), 
        .COLLDISN(1'b1)
   );

//    wire gatedRdHitAddrClk;
//     gateClockCell gateHitAddrClkInst
//     (
//         .clk(clk),
//         .gate(L1APre),
//         .enableGate(1'b1),
//         .gatedClk(gatedRdHitAddrClk)   
//     );

    reg [8:0] latchedwrAddr2;
    always @(posedge clk)
    begin
        if(~dis&L1APre)
            latchedwrAddr2 <= wrAddr;
    end
    wire [8:0] rdAddrHit = latchedwrAddr2 - (latencyL1A - 9'd1);

    wire rdenHit = L1A;  //synchronized L1A
    wire hitE1A;
//    wire hitE2A;
    hitSRAMCircularBuffer hitMem(
        .clk(clk),
        .dis(dis),
        .hit(inHit),
        .rden(rdenHit),
        .E1A(hitE1A),
//        .E2A(hitE2A),
        .E2A(),
        .rdAddr(rdAddrHit),
        .wrAddr(wrAddr),
        .outHit(outHit)
    );

    reg outHitReg;
    reg E1AReg;
    //reg E2AReg;
    always @(negedge clk) 
    begin
        if(~dis)
        begin
            outHitReg       <= outHit;
            E1AReg          <= hitE1A;
            //E2AReg          <= hitE2A;
        end
	end
    assign hit = outHitReg;
    assign E1A = E1AReg;
    assign E2A = 1'b0;//E2AReg;
    
endmodule
