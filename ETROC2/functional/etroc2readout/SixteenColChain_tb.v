`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Mon Feb  1 10:08:46 CST 2021
// Module Name: SixteenColChain_tb
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
//`define FAST_READOUT
`include "commonDefinition.v"

module SixteenColChain_tb;

	reg clk;
    reg dnReset;

    wire dnL1A;
    wire selfTest;
    assign selfTest = 1'b1;

    TestL1Generator TestL1GeneratorInst(
        .clkTMR(clk),
        .disTMR(!selfTest),
        .resetTMR(dnReset),
        .L1ATMR(dnL1A)
    );

    reg [6:0] ocp;
 //   wire empty;
  //  wire full;
   wire [11:0] genBCID;

    reg dnRead;
    reg dnLoad;
    wire [28:0] dnTDCData;
    wire dnE2A;
    wire dnE1A;
    wire dnUnreadHit;
    wire [7:0] dnPixelID;
    wire [`L1BUFFER_ADDRWIDTH*2+10+2:0]   dnBCST;

    sixteenColChain #(.L1ADDRWIDTH(`L1BUFFER_ADDRWIDTH))sixteenColChainInst(
        .clk(clk),            //40MHz
	    .selfTest(1'b1),          //selfTest or not
        .TDCDataArray({7680{1'b0}}),  
        .L1ADelay(9'd501),  
	    .selfTestOccupancy(ocp),  //0.1%, 1%, 2%, 5%, 10% etc
`ifdef DEBUG
        .dbBCID(genBCID),
`endif 
//SW
	    .dnData({dnTDCData,dnE2A,dnE1A,dnPixelID}),
	    .dnUnreadHit(dnUnreadHit),
	    .dnRead(dnRead),
        .dnBCST(dnBCST)
	    //.dnBCST({dnLoad,dnL1A,dnReset}) //
    );


    wire BCIDRst;
    wire [11:0] BCIDoffset;
    assign BCIDoffset = 12'h000;
    assign BCIDRst = 1'b1;
    BCIDCounter BC(
	    .clkTMR(clk),                  //40MHz
        .rstBCIDTMR(BCIDRst),    //BCID reset signal 
        .offsetTMR(BCIDoffset),        //value when it is reset
        .BCIDTMR(genBCID)
    );

    wire [8:0] CBwrAddr;
    CircularBufferAddr CBAddrInst(
        .clk(clk),
        .reset(dnReset),
  //      .enableGrayCode(1'b1),
        .wrAddr(CBwrAddr)
    );

    wire [`L1BUFFER_ADDRWIDTH-1:0] wordCount;
    wire L1EvtBufEmpty;      // from overflow buffer
    wire [`L1BUFFER_ADDRWIDTH-1:0] L1rdAddr;
    wire [`L1BUFFER_ADDRWIDTH-1:0] L1wrAddr;
    L1BufferAddr #(.ADDRWIDTH(`L1BUFFER_ADDRWIDTH)) L1BAddrInst(
        .clk(clk),
        .reset(dnReset),
        .wrEn(dnL1A),
        .rdEn(dnLoad),
        .wordCount(wordCount),
        .wrAddr(L1wrAddr),
        .rdAddr(L1rdAddr),
        .empty(L1EvtBufEmpty),
        .full(L1EvtBufFull)
    );

    assign dnBCST = {CBwrAddr,L1EvtBufFull,L1wrAddr,L1rdAddr,dnLoad,dnL1A,dnReset};


`ifdef DEBUG
    assign dbBCID = genBCID;
`endif 

    wire [11:0] gbrcBCID;              //to readout controller

    BCIDBuffer BCB (
	    .clk(clk),                      //40MHz
        .reset(dnReset),                  //buffer reset signal 
        .inBCID(genBCID),               //current BCID
        .wrAddr(L1wrAddr),
        .rdAddr(L1rdAddr),
        .L1EvtBufFull(L1EvtBufFull),   //from overflow buffer,
        .rdEn(dnLoad),           //from global readout controller, read BCID from buffer
        .L1A(dnL1A),                //used to read BCID from BCID counter
        .outBCID(gbrcBCID)             //read BCID to global controller.
    );

//core read control
    wire L1BufAlmostFull;
    wire L1Overflow;
    assign L1BufAlmostFull = (wordCount >= 7'd64);
    assign L1Overflow = (wordCount >= 7'd112);
    reg sessionStarted;
    reg L1OverflowReg;
    always @(negedge clk) 
    begin
        if(!dnReset)
        begin
            dnLoad <= 1'b0;
            dnRead <= 1'b0;
            sessionStarted <= 1'b0;
            L1OverflowReg <= 1'b0;
        end
        if(!sessionStarted)
        begin
            if(!L1EvtBufEmpty) 
            begin
                sessionStarted <= 1'b1;   
                dnLoad <= 1'b1;  
                L1OverflowReg <= L1Overflow;  //only check once
            end 
        end
        else 
        begin
            dnLoad <= 1'b0; 
            dnRead          <= L1OverflowReg ? 1'b0 : dnUnreadHit;
            sessionStarted  <= L1OverflowReg ? 1'b0 : dnUnreadHit;             
        end
    end

    reg TsessionReg;
    reg TloadReg;
    reg THit;
    reg [28:0] TdnTDCDataReg;
    always @(posedge clk) 
    begin
        TsessionReg     <= sessionStarted;
        TloadReg        <= dnLoad;
        THit            <= dnUnreadHit;
        TdnTDCDataReg   <= dnTDCData;
    end


    wire [19:0] totalHitEvent;
    wire [19:0] errorCount;
    wire [8:0] hittedPixelCount;
    wire [19:0] missedCount; 
    wire [19:0] mismatchedBCIDCount;

    multiplePixelDataCheck L1check(
        .clk(clk),
        .reset(dnReset),
        .TDCData(dnTDCData),
        .unreadHit(dnUnreadHit),
        .totalHitEvent(totalHitEvent),
        .errorCount(errorCount),
        .missedCount(missedCount),
        .hittedPixelCount(hittedPixelCount),
        .mismatchedBCIDCount(mismatchedBCIDCount)               
    );

    initial begin
        clk = 0;
        dnReset = 0;
        ocp = 7'h03;  //2%
    
        #25 dnReset = 1'b1;
        #50 dnReset = 1'b0;
          #100000   ocp = 7'h06;  //2%
          #200000   ocp = 7'h20;  //2%
          #800000   ocp = 7'h06;  //2%
          #1000000   ocp = 7'h02;  //2%
        #1500000 $stop;
    end
    always 
        #12.5 clk = !clk; //25 ns clock period


endmodule
