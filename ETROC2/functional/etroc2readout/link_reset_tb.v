`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Mon Feb  1 23:20:20 CST 2021
// Module Name: globalReadout_tb
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

module link_reset_tb;

    localparam BCSTWIDTH = `L1BUFFER_ADDRWIDTH*2+11+2;
	reg clk;
    reg clk1280;
    reg clk640;
    reg clk320;
    reg initReset;
    reg dnReset;
    reg [1:0] rate; //serializer speed
    reg [6:0] ocp;
    reg disSCR;
    wire dnRead;
    wire [35:0] dnTDCData;
    wire [7:0] dnPixelID;
    wire dnUnreadHit;
    wire [45:0] dnData;
    wire [BCSTWIDTH-1:0] dnBCST;
//   `ifdef DEBUG
//      wire [11:0] dbBCID;
//  `endif 

    assign dnTDCData = {46{1'bx}};
    assign dnPixelID = {8{1'bx}};
    wire [15:0] trigHits;
    assign trigHits = {16{1'bx}};

    wire sout;
    wire [4:0] rdClkPhase;
    assign rdClkPhase = 5'b10000;
    wire [4:0] trigDataSize = 5'd3;

    reg link_reset_slowControl;
    reg link_reset_fastCommand;
    reg link_reset_testPatternSel;
    reg [31:0] link_reset_fixedTestPattern;
`ifdef globalTMR
    globalReadoutTMR #(.L1ADDRWIDTH(`L1BUFFER_ADDRWIDTH),.BCSTWIDTH(BCSTWIDTH))globalReadoutInst(
`else
    globalReadout #(.L1ADDRWIDTH(`L1BUFFER_ADDRWIDTH),.BCSTWIDTH(BCSTWIDTH))globalReadoutInst(
`endif

	    .clk(clk),            //40MHz
        .clk1280(clk1280),
        .reset(dnReset),        //reset by slow control? 
        .trigHits(trigHits),
        .trigDataSize(trigDataSize),
        .almostFullLevel(7'h60),
	    .workMode(2'b10),          
        .serRate(rate),
        .link_reset_fastCommand(link_reset_fastCommand),
        .link_reset_slowControl(link_reset_slowControl),
        .link_reset_testPatternSel(link_reset_testPatternSel),
        .link_reset_prbs7Seed(7'h2A),
        .link_reset_fixedTestPattern(link_reset_fixedTestPattern),
        .rdClkPhase(rdClkPhase),
        .BCIDoffset(12'h000),
        .BCIDRst(1'b1),       //periodic BCID reset
        .inL1A(1'b0),        //input L1A signal
        .disSCR(disSCR),
        .streamBufHighLevel(4'd12),
        .streamBufLowLevel(4'd4),
//SW network    //
        .dnData(dnData), //TDC data,
        .dnUnreadHit(dnUnreadHit),    //if exist unread hit
        .dnRead(dnRead),       //
        .dnBCST(dnBCST),
//  `ifdef DEBUG
//          .dbBCID(dbBCID),
//  `endif 
        .sout(sout)   //serializer output
    );

    wire wordCK;
    wire [39:0] word40b;
    wire deserClk;
`ifdef TEST_SERRIALIZER_1280
    assign deserClk = clk1280; 
`elsif TEST_SERRIALIZER_640
    assign deserClk = clk640; 
`elsif TEST_SERRIALIZER_320
    assign deserClk = clk320; 
`endif
    wire dlSout;
    delayLine dlInst(
        .bitClk(deserClk),
        .delay(6'd1),
        .sin(sout),
        .sout(dlSout)
    );

    wire [15:0] triggerDataOut;
    wire [4:0] wordAddr;
    wire wordTrigClk;
    assign wordAddr = 5'h05;
    deserializerWithTriggerData dser40T(
        .bitCK(deserClk),
        .reset(dnReset),
        .rate(rate),
        .delay(wordAddr),
    //    .delay(6'h02),
        .sin(dlSout),
        .trigData(triggerDataOut),
        .trigDataSize(trigDataSize),
        .wordTrigClk(wordTrigClk),
        .word40CK(wordCK),
        .dout(word40b)
    );

    initial begin
        clk = 0;
        clk1280 = 0;
        clk640 = 0;
        clk320 = 0;
        initReset = 1;
        ocp = 7'h02;  //2%
        disSCR = 1'b1;
        link_reset_fixedTestPattern = 32'h3C5C3C5A;
        link_reset_testPatternSel = 1'b1;
        link_reset_slowControl = 1'b0;
        link_reset_fastCommand = 1'b0;
`ifdef TEST_SERRIALIZER_1280
        rate = 2'b11; //high speed readout
`elsif TEST_SERRIALIZER_640
        rate = 2'b01; 
`elsif TEST_SERRIALIZER_320
        rate = 2'b00; 
`endif

        #25 initReset = 1'b0;
        #50 initReset = 1'b1;

        #100 link_reset_slowControl = 1'b1;
        #2000 link_reset_fixedTestPattern = 32'hAAAAAAAA;
        #5000 link_reset_testPatternSel = 1'b0;
        #1000 link_reset_slowControl = 1'b0;
        #100 link_reset_slowControl = 1'b1;
        #1000 link_reset_slowControl = 1'b0;
        #100 link_reset_slowControl = 1'b1;
        #10000
        $stop;
    end

    always 
        #12.48 clk = ~clk; //25 ns clock period
    
    always
        #0.390 clk1280 = ~clk1280;

    always
        #0.780  clk640 = ~clk640;

    always
        #1.56   clk320 = ~clk320;

   always @(posedge clk) 
   begin
        dnReset <= initReset;        
   end
endmodule
