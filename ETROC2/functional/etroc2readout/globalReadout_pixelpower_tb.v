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

module globalReadout_tb;

    localparam BCSTWIDTH = `L1BUFFER_ADDRWIDTH*2+11+2;
	reg clk;
    reg clk1280;
    reg clk640;
    reg clk320;
    reg L1A_Rst;
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

    assign dnTDCData = dnData[45:10];
    assign dnPixelID = dnData[7:0];
    wire [15:0] trigHits;
`ifdef DEBUG_TRIGGERPATH
    wire [15:0] dbTrigHits;
`endif

    sixteenColChain #(.L1ADDRWIDTH(`L1BUFFER_ADDRWIDTH),.BCSTWIDTH(BCSTWIDTH))sixteenColChainInst(
        .clk(clk),            //40MHz
	    .workMode(2'b10),          //selfTest or not
        .L1ADelay(9'd501),
        .TDCDataArray({7680{1'b0}}),  
	    .selfTestOccupancy(ocp),  //0.1%, 1%, 2%, 5%, 10% etc
        .disDataReadout({256{1'b0}}),
        .disTrigPath({256{1'b0}}),
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
	    .dnUnreadHit(dnUnreadHit),
        .trigHits(trigHits),
`ifdef DEBUG_TRIGGERPATH
        .dbTrigHits(dbTrigHits),
`endif
	    .dnRead(dnRead),
	    .dnBCST(dnBCST)
    );
`ifdef DEBUG_TRIGGERPATH
reg [15:0] dbTrigHitsReg1D;
reg [15:0] dbTrigHitsReg2D;
reg [15:0] trigHitsReg1D;

always @( negedge clk )
begin
    dbTrigHitsReg1D <= dbTrigHits;
    dbTrigHitsReg2D <= dbTrigHitsReg1D;
    trigHitsReg1D   <= trigHits;
end
    wire checkTrigHit = (trigHitsReg1D == dbTrigHitsReg2D);
`endif

    wire sout;
    wire [4:0] rdClkPhase;
    assign rdClkPhase = 5'b10000;
    wire [4:0] trigDataSize = 5'd3;

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
        .emptySlotBCID(12'd1177),
        .splitTrigger(1'b0),
        .trigScrOn(1'b0),
        .almostFullLevel(7'h60),
	    .workMode(2'b10),          
        .serRate(rate),
        .link_reset_fastCommand(1'b0),
        .link_reset_slowControl(1'b0),
        .link_reset_testPatternSel(1'b1),
        .link_reset_prbs7Seed(7'h2A),
        .link_reset_fixedTestPattern(32'h3C5C3C5A),
	    .L1A_Rst(1'b0),
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

    // deserializer #(.WORDWIDTH(40),.WIDTH(6))dser40
    // (
    //     .bitCK(deserClk),
    //     .reset(dnReset),
    //     .delay(6'h02),
    //     .sin(dlSout),
    //     .wordCK(wordCK),
    //     .dout(word40b)
    // );

    wire aligned;
    reg reset2;
    wire [39:0] receivedDataFrame;
    wire [9:0] RC_goodEventRate;
    dataExtract dataExtractInst
    (
        .clk(wordCK),
        .reset(reset2),
        .wordAddr(wordAddr),
        .disSCR(disSCR),
        .din(word40b),
        .aligned(aligned),
        .goodEventRate(RC_goodEventRate),
        .dout(receivedDataFrame)
    );

//`ifdef CHECK_DATA_AFTER_RECEIVER
    wire [1:0] RC_dataType;
    wire [19:0] RC_BCIDErrorCount;
    wire [19:0] RC_nullEventCount;
    wire [19:0] RC_goodEventCount;
    wire [19:0] RC_notHitEventCount;
    wire [19:0] RC_L1OverlfowEventCount;
    wire [19:0] RC_totalHitsCount;
    wire [19:0] RC_dataErrorCount;
    wire [19:0] RC_missedHitsCount;
    wire [8:0] RC_hittedPixelCount;
    wire [19:0] RC_frameErrorCount;
    wire [19:0] RC_mismatchBCIDCount;
    wire [19:0] RC_L1FullEventCount;
    wire [19:0] RC_L1HalfFullEventCount;
    wire [19:0] RC_SEUEventCount;
    wire [19:0] RC_hitCountMismatchEventCount;

    dataRecordCheck dataRecordCheckReceiver
    (
        .clk(wordCK),
        .reset(reset2),
        .dataRecord(receivedDataFrame),
        .BCIDErrorCount(RC_BCIDErrorCount),
        .dataType(RC_dataType),
        .nullEventCount(RC_nullEventCount),
        .goodEventCount(RC_goodEventCount),
        .notHitEventCount(RC_notHitEventCount),
        .L1OverlfowEventCount(RC_L1OverlfowEventCount),
        .totalHitsCount(RC_totalHitsCount),
        .dataErrorCount(RC_dataErrorCount),
        .missedHitsCount(RC_missedHitsCount),
        .hittedPixelCount(RC_hittedPixelCount),
        .frameErrorCount(RC_frameErrorCount),
        .L1FullEventCount(RC_L1FullEventCount),
        .L1HalfFullEventCount(RC_L1HalfFullEventCount),
        .SEUEventCount(RC_SEUEventCount),
        .goodEventRate(RC_goodEventRate),
        .hitCountMismatchEventCount(RC_hitCountMismatchEventCount),
        .mismatchBCIDCount(RC_mismatchBCIDCount)
    );
//`endif 


    initial begin
        clk = 0;
        clk1280 = 0;
        clk640 = 0;
        clk320 = 0;
        initReset = 1;
        reset2 = 1;
        ocp = 7'h02;  //2%
        disSCR = 1'b1;
`ifdef TEST_SERRIALIZER_1280
        rate = 2'b11; //high speed readout
`elsif TEST_SERRIALIZER_640
        rate = 2'b01; 
`elsif TEST_SERRIALIZER_320
        rate = 2'b00; 
`endif
        L1A_Rst = 1'b0;

        #25 initReset = 1'b0;
        #50 initReset = 1'b1;
        #10000 reset2 = 1'b0;
        #10050 reset2 = 1'b1;

//`ifdef TEST_SCRAMBLER
//        #500000 disSCR = 1'b0;
//`else
//        #500000 disSCR = 1'b1; 
//`endif
         #200   ocp = 7'd1;
        #1000000 ocp = 7'd2;
        #1000000 ocp = 7'd4;
        #1000000 ocp = 7'd6;
        #1000000 ocp = 7'd8;
        #1000000 ocp = 7'd10;
        #1000000
        $stop;
    end
    always 
        #12.48 clk = ~clk; //25 ns clock period
    
    always
//        #0.390625 clk1280 = ~clk1280;
        #0.390 clk1280 = ~clk1280;

    always
//        #0.78125  clk640 = ~clk640;
        #0.780  clk640 = ~clk640;

    always
//        #1.5625   clk320 = ~clk320;
        #1.56   clk320 = ~clk320;

   always @(posedge clk) 
   begin
        dnReset <= initReset;        
   end
endmodule
