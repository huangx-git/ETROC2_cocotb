`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 23 15:28:14 CST 2021
// Module Name: BCIDBuffer
// Project Name: ETROC2 readout
// Description: 
// Dependencies: sram_rf_model, FIFOWRCtrler
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module BCIDBuffer #(
    parameter ADDRWIDTH = 7
)
(
    input                   clk,            //40MHz
    input                   reset,           //reset signal from SW
    input [11:0]            inBCID,     //current BCID
    input [ADDRWIDTH-1:0]   wrAddr,     //from global
    input [ADDRWIDTH-1:0]   rdAddr,     //from global
//    input                   L1BufFull,
    input                   L1A,        //L1A select signal from globalReadout, synched to local clock
    input                   rdEn,       //the data load signal from SW network
    output [11:0]           outBCID,     //29 bit TDC data 
    output                  E1A,
    output                  E2A         //
);
// tmrg default triplicate


    reg wren;
    reg syncL1A;
    reg syncL1A1D; //delay one clock
    reg localL1A;
    always @(posedge clk) 
    begin
        if(~reset)localL1A <= 1'b0;
        else localL1A <= L1A;
    end
    always @(negedge clk) 
    begin
        syncL1A      <= localL1A;
        syncL1A1D    <= syncL1A;
	end

    always @(posedge clk) 
    begin
        if(~reset) wren <= 1'b0;
        else wren <= syncL1A1D ;
    end
    wire rdEnN = ~rdEn;
    wire clkN = ~clk;
    wire wrenN = ~wren;
    BCID_mem_rtl_top BCIDB(
            .QA(outBCID),
            .E1A(E1A),   //Output for test?
            .E2A(E2A),   //Output for test? 
            .CLKA(clk),
            .CENA(rdEnN),
            .AA(rdAddr),
            .CLKB(clkN),
            .CENB(wrenN),
            .AB(wrAddr),
            .DB(inBCID), //hit input
            .EMAA(3'b010),       //not used
            .EMAB(3'b010),       //not used
            .RET1N(1'b1),      //useful
            .COLLDISN(1'b1)   //not used
    );

    // sram_rf_model #(.wordwidth(12),.addrwidth(ADDRWIDTH)) BCIDB (
    //         .QA(outBCID),
    //         .E1A(),   //Output for test?
    //         .E2A(),   //Output for test? 
    //         .CLKA(clk),
    //         .CENA(!rdEn),
    //         .AA(rdAddr),
    //         .CLKB(!clk),
    //         .CENB(!wren),
    //         .AB(wrAddr),
    //         .DB(inBCID), //hit input
    //         .EMAA(3'b0),       //not used
    //         .EMAB(3'b0),       //not used
    //         .RET1N(1'b1),      //useful
    //         .COLLDISN(1'b0)   //not used
    // );


endmodule
