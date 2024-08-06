`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Fri Jan 29 15:00:09 CST 2021
// Module Name: pixelReadout_tb
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////

module pixelReadoutSW_tb;

	reg clk;
    reg dnReset;

    wire BCIDRst;
    wire dnL1A;


    TestL1Generator TestL1GeneratorInst(
        .clkTMR(clk),
        .resetTMR(dnReset),
        .BCIDRstTMR(BCIDRst),
        .L1ATMR(dnL1A)
    );

    reg [6:0] ocp;

    wire empty;
    wire full;
    wire L1E2A;
    wire L1E1A;

    reg dnRead;
    reg dnLoad;
    wire [8:0] dnL1ADelay;
    wire [8:0] upL1ADelay;
    wire upReset;

    wire [28:0] dnTDCData;
    wire dnE2A;
    wire dnE1A;
    wire dnUnreadHit;

    wire upRead;
    wire upLoad;
    wire upL1A;
    wire [7:0] dnPixelID;
    assign dnL1ADelay = 9'd501;

    pixelReadoutWithSWCell pixelReadoutWithSWCellInst(
        .clk(clk),            //40MHz
	    .selfTest(1'b1),          //selfTest or not
        .pixelID(8'h07),   //
        .TDCData(30'h2AAAAAAB),         //30 bit, not used here
	    .selfTestOccupancy(ocp),  //0.1%, 1%, 2%, 5%, 10% etc
 
 //SW up
        .upData({31'h2AAAAAAC,8'h6}),
        .upUnreadHit(1'b0),  //0 .
        .upRead(upRead),
        .upBCST({upLoad,upL1A,upReset,upL1ADelay}),
//SW dn        
        .dnData({dnTDCData,dnE2A,dnE1A,dnPixelID}),
        .dnUnreadHit(dnUnreadHit), //only use this for read control
        .dnRead(dnRead),
        .dnBCST({dnLoad,dnL1A,dnReset,dnL1ADelay})
    );

    L1OverflowBuffer L1OverflowBufferInst(
        .clk(clk),       //40MHz
        .reset(dnReset),     //reset signal from SW
        .L1A(dnL1A),       //L1A select signal from globalReadout
        .load(dnLoad),      //the data load signal from SW network
        .empty(empty),
        .full(full)     //
    );


   always @(negedge clk) 
    begin
        if(!dnReset)
        begin
            dnLoad <= 1'b0;
            dnRead <= 1'b0;
        end

        dnLoad <= (!empty) & (!dnUnreadHit);
        dnRead <= dnUnreadHit;

    end

    wire [19:0] totalHitEvent;
    wire [11:0] errorCount;
    pixelL1TDCDataCheck L1check(
        .clk(clk),
        .reset(dnReset),
        .TDCData(dnTDCData),
        .unreadHit(dnUnreadHit),
        .totalHitEvent(totalHitEvent),
        .errorCount(errorCount)        
    );

    initial begin
        clk = 0;
        dnReset = 0;
        ocp = 7'h1f;  //2%
    
        #25 dnReset = 1'b1;
        #50 dnReset = 1'b0;
    end
    always 
        #12.5 clk = !clk; //25 ns clock period


endmodule
