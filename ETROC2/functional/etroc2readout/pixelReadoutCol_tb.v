`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 30 20:04:20 CST 2021
// Module Name: pixelReadoutCol_tb
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"

`define TEST_SERRIALIZER_1280
//`define TEST_SERRIALIZER_640
//`define TEST_SERRIALIZER_320
`define TEST_SCRAMBLER
module pixelReadoutCol_tb;

    localparam BCSTWIDTH = `L1BUFFER_ADDRWIDTH*2+11+2;

	reg clk;
    reg reset;
    reg dnReset;
    reg [6:0] ocp;
    wire dnRead;
    wire [35:0] dnTDCData;
    wire [7:0] dnPixelID;
    wire dnUnreadHit;
    wire [45:0] dnData;
    wire [BCSTWIDTH-1:0] dnBCST;

    assign dnTDCData = dnData[45:10];
    assign dnPixelID = dnData[7:0];
    wire [15:0] trigHits;
    wire [3:0] colTrigHits;
    assign trigHits = {12'd0,colTrigHits};

    wire [527:0] TDCDataCol;
    reg [3:0] colId;
    wire [3:0] rowIDs[15:0];    
    generate
        genvar i;
        for (i = 0; i < 16; i = i+1)
        begin : colLoop
            assign rowIDs[i] = i;
            TDCTestPatternGen TDCEM (
                .clk(clk),              //40MHz
                .reset(dnReset),          //
                .dis(1'b0),          //
                .mode(1'b1),
                .latencyL1A(9'd501),
                .pixelID({colId,rowIDs[i]}),   
                .occupancy(ocp),   
                .dout(TDCDataCol[i*33+29:i*33])
            );
            assign TDCDataCol[i*33+32:i*33+30] = 3'b000;
        end
    endgenerate

    wire streamBufAlmostFull;
    assign streamBufAlmostFull = 1'b0;

    pixelReadoutCol #(.L1ADDRWIDTH(`L1BUFFER_ADDRWIDTH)) pixelReadoutColInst(
        .clk(clk),            //40MHz
	    .workMode(2'b00),          //selfTest or not
        .L1ADelay(9'd501),
        .colID(colId),   //
        .TDCDataArray(TDCDataCol),  
	    .selfTestOccupancy(ocp),  //0.1%, 1%, 2%, 5%, 10% etc
        .disDataReadout({16{1'b0}}),
        .disTrigPath({16{1'b0}}),
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
//SW
	    .dnData(dnData),
        .dnHits({colTrigHits,dnUnreadHit}),
	    .dnRead(dnRead),
	    .dnBCST(dnBCST)
    );

    wire externalL1A;  //period 40
    TestL1Generator TestL1GeneratorInst(
        .clkTMR(clk),
        .disTMR(1'b0),
        .modeTMR(1'b0),
        .resetTMR(dnReset),
        .L1ATMR(externalL1A) //
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
    wire dnLoad = dnBCST[2];
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
        colId = 4'd5;
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
        #12.48 clk = ~clk; //25 ns clock period
    
   always @(posedge clk) 
   begin
        dnReset <= reset;        
   end

endmodule
