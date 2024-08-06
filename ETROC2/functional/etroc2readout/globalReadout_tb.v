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
    reg reset2;
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

    sixteenColChain #(.L1ADDRWIDTH(`L1BUFFER_ADDRWIDTH),.BCSTWIDTH(BCSTWIDTH))sixteenColChainInst(
        .clk(clk),            //40MHz
	    .workMode(2'b10),          //selfTest or not
        .L1ADelay(9'd501),
        .TDCDataArray({8448{1'b0}}),  
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
	    .dnRead(dnRead),
	    .dnBCST(dnBCST)
    );

    wire sout;
    // wire [4:0] rdClkPhase;
    // assign rdClkPhase = 5'b10000;
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
	    .onChipL1AConf(2'b11),          
        .serRate(rate),
        .link_reset_fastCommand(1'b0),
        .link_reset_slowControl(1'b0),
        .link_reset_testPatternSel(1'b1),
        .link_reset_fixedTestPattern(32'h3C5C3C5A),
        .L1A_Rst(L1A_Rst),
        .BCIDoffset(12'h000),
        .BCIDRst(1'b1),       //periodic BCID reset
        .inL1A(1'b0),        //input L1A signal
        .disSCR(disSCR),
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

    wire aligned;
    wire [9:0] RC_goodEventRate;
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
    wire [15:0] RC_triggerDataOut;

    fullChainDataCheck fullChainDataCheckInst
    (
        .clk320(clk320),
        .clk640(clk640),
        .clk1280(clk1280),
        .dataRate(rate),
        .triggerDataSize(trigDataSize),
        .reset(dnReset),
        .reset2(reset2),
        .aligned(aligned),
        .disSCR(disSCR),
        .serialIn(sout),
        .RC_BCIDErrorCount(RC_BCIDErrorCount),
        .RC_dataType(RC_dataType),
        .RC_nullEventCount(RC_nullEventCount),
        .RC_goodEventCount(RC_goodEventCount),
        .RC_notHitEventCount(RC_notHitEventCount),
        .RC_L1OverlfowEventCount(RC_L1OverlfowEventCount),
        .RC_totalHitsCount(RC_totalHitsCount),
        .RC_dataErrorCount(RC_dataErrorCount),
        .RC_missedHitsCount(RC_missedHitsCount),
        .RC_hittedPixelCount(RC_hittedPixelCount),
        .RC_frameErrorCount(RC_frameErrorCount),
        .RC_L1FullEventCount(RC_L1FullEventCount),
        .RC_L1HalfFullEventCount(RC_L1HalfFullEventCount),
        .RC_SEUEventCount(RC_SEUEventCount),
        .RC_goodEventRate(RC_goodEventRate),
        .RC_hitCountMismatchEventCount(RC_hitCountMismatchEventCount),
        .RC_mismatchBCIDCount(RC_mismatchBCIDCount),
        .RC_triggerDataOut(RC_triggerDataOut)
    );
//`endif 


    initial begin
        clk = 0;
        clk1280 = 1;
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
`ifdef TEST_SCRAMBLER
        #500000 disSCR = 1'b0;
`else
        #500000 disSCR = 1'b1; 
`endif
         #900000 ocp = 7'h04;
        #150000 ocp = 7'h30;
        #180000 ocp = 7'h06;
        #220000 ocp = 7'h02; 


/*    
        #300000 ocp = 7'h0A;
        #400000 ocp = 7'h0E;
        #500000 ocp = 7'h15;
        #600000 ocp = 7'h1A;
        #700000 ocp = 7'h20;
        #800000 ocp = 7'h25;
        #900000 ocp = 7'h2A;
        #1000000 ocp = 7'h30;    
        #1100000 ocp = 7'h3A;    
        #1200000 ocp = 7'h3F;    
        #1300000 ocp = 7'h30;    
        #1400000 ocp = 7'h2A;    
        #1500000 ocp = 7'h25;    
        #1600000 ocp = 7'h20;    
        #1700000 ocp = 7'h1A;    
        #1800000 ocp = 7'h15;    
        #1900000 ocp = 7'h10;    
        #2000000 ocp = 7'h05;    
        #2100000 ocp = 7'h02;    
*/
        #2500000
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
