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
`include "commonDefinition.v"
`define NOT_SELFTEST
module pixelReadout_tb;

    localparam BCSTWIDTH = `L1BUFFER_ADDRWIDTH*2+11+2;
	reg clk;
    reg reset;
    reg dnReset;
    wire [29:0] TDCData;
    reg [6:0] ocp;
    wire dnRead;
    wire dnLoad;
    wire [3:0] trigHit;
    wire dnUnreadHit;
    // reg dnL1A;
    wire [28:0] sourceTDC = TDCData[29:1];


    wire streamBufAlmostFull;
    assign streamBufAlmostFull = 1'b0;

`ifdef NOT_SELFTEST
    TDCTestPatternGen TDCDATAGEN (
    	.clk(clk),              //40MHz
	    .reset(dnReset),          //
	    .dis(1'b0),          //
        .mode(1'b1),
        .latencyL1A(9'd501),
        .pixelID(8'h15),   
	    .occupancy(ocp),   
	    .dout(TDCData)
    );

`endif

    wire [45:0] dnData;
    wire upRead;
    wire [BCSTWIDTH-1:0] dnBCST;
    wire [BCSTWIDTH-1:0] upBCST;

    pixelReadoutWithSWCell pixelInst2(
        .clk(clk),
`ifdef NOT_SELFTEST
        .workMode(2'b00), //external data
`else 
        .workMode(2'b10), //self test mode
`endif
        .disDataReadout(1'b0),
        .disTrigPath(1'b0),
        .upperTOATrig(10'h3FF),
        .lowerTOATrig(10'h000),
        .upperTOTTrig(9'h1FF),
        .lowerTOTTrig(9'h000),
        .upperCalTrig(10'h3FF),
        .lowerCalTrig(10'h000),
        .upperTOA(10'h3FF),
        .lowerTOA(10'h000),
        .upperTOT(9'h1FF),
        .lowerTOT(9'h000),
        .upperCal(10'h3FF),
        .lowerCal(10'h000),
        .addrOffset(1'b1),
        .pixelID(8'h15),   //
        .TDCData(TDCData),
        .L1ADelay(9'd501),
	    .selfTestOccupancy(ocp),  //0.1%, 1%, 2%, 5%, 10% etc

        .upData({46{1'b0}}),
        .dnData(dnData),
        .upHits(5'd0),
        .dnHits({trigHit,dnUnreadHit}),
        .dnRead(dnRead),
        .upRead(upRead),
        .dnBCST(dnBCST),
        .upBCST(upBCST)
    );

    wire externalL1A;
    TestL1Generator TestL1GeneratorInst(
        .clk(clk),
        .reset(dnReset),
        .dis(1'b0),
        .mode(1'b0), //periodic L1
        .L1A(externalL1A)
    );
    globalReadoutForPixelTest #(.L1ADDRWIDTH(`L1BUFFER_ADDRWIDTH),.BCSTWIDTH(BCSTWIDTH))globalReadoutInst(
	    .clk(clk),            //40MHz
        .reset(dnReset),        //reset by slow control? 
        .streamBufAlmostFull(streamBufAlmostFull),
	    .workMode(2'b00),          
        .BCIDoffset(12'h000),
        .BCIDRst(1'b1),       //periodic BCID reset
        .inL1A(externalL1A),        //input L1A signal
//SW network    //
        .dnData(dnData), //TDC data,
        .dnUnreadHit(dnUnreadHit),    //if exist unread hit
        .dnRead(dnRead),       //
        .dnBCST(dnBCST)
    );

    reg [31:0] L1ACount;
    reg [31:0] HitsCount;
    reg [31:0] ReadCount;
    reg [31:0] LoadCount;
    assign dnLoad = dnBCST[2];
    always @(posedge clk) 
    if(!dnReset)
    begin
        L1ACount    <= 32'd0;
        HitsCount   <= 32'd0;
        ReadCount   <= 32'd0;
        LoadCount   <= 32'd0;
    end
    else 
    begin
        if(externalL1A == 1'b1)L1ACount <= L1ACount + 1;
        if(dnRead == 1'b1)ReadCount <= ReadCount + 1;
        if(dnUnreadHit == 1'b1)HitsCount <= HitsCount + 1;
        if(dnLoad == 1'b1)LoadCount <= LoadCount + 1;
    end


    initial begin
        clk = 0;
        reset = 1'b1;
        ocp = 7'h3F;  
        // ocp = 7'h02;  
        // ocp = 7'h03;  
        // ocp = 7'h04;  
        // ocp = 7'h05;  
        // ocp = 7'h06;  
        // ocp = 7'h07;  
        // ocp = 7'h08;  
        // ocp = 7'h09;  
	// ocp = 7'h0A;
    
        #25 reset = 1'b0;
        #50 reset = 1'b1;
        #10000 ocp = 7'H01;
        #2500000 $stop;
    end
    always 
        #12.5 clk = ~clk; //25 ns clock period

   always @(posedge clk) 
   begin
        dnReset <= reset;        
   end


endmodule
