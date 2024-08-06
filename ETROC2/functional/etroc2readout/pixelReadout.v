`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 23 13:34:56 CST 2021
// Module Name: pixelReadout
// Project Name: ETROC2 readout
// Description: 
// Dependencies: FIFOWRCtrler, sram_rf_model, majorityVoterTagGates, TDCTestPatternGen
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"

module pixelReadout #(  parameter L1ADDRWIDTH = 7)
(
	input                   clk,            //40MHz
	input                   reset,         //low active
	input [1:0]             workMode,      //00: normal, 01: self test, periodic trigger fixed TDC data, 10: self test, random TDC data, 11: reserved
    input [L1ADDRWIDTH-1:0] L1wrAddr,
    input [L1ADDRWIDTH-1:0] L1rdAddr,
    input [8:0]             CBwrAddr,
    input                   preLoad,
//    input                   L1Full,
    input                   disDataReadout,     //disable data readout
    //for trigger path
    input                   disTrigPath,
    input [9:0]             upperTOATrig,
    input [9:0]             lowerTOATrig,
    input [8:0]             upperTOTTrig,
    input [8:0]             lowerTOTTrig,
    input [9:0]             upperCalTrig,
    input [9:0]             lowerCalTrig,
//event selections based on TOT/TOA/Cal
    input [9:0]             upperTOA,
    input [9:0]             lowerTOA,
    input [8:0]             upperTOT,
    input [8:0]             lowerTOT,
    input [9:0]             upperCal,
    input [9:0]             lowerCal,
    input                   addrOffset,
    input                   L1A,            //seltest or real L1A signal from global readout
    input [7:0]             pixelID,   //
//    input [29:0]            TDCData,
    input [8:0]             TDC_TOT,
    input [9:0]             TDC_TOA,
    input [9:0]             TDC_Cal,
    input                   TDC_hit,
    input [2:0]             TDC_EncError,
    input [8:0]             latencyL1A,
	input [6:0]             selfTestOccupancy,  //0.1%, 1%, 2%, 5%, 10% etc
    input                   read,  //data read 
    input                   load,  //data load 
    output  [3:0]           trigHit,
    output                  unreadHit,
	output [35:0]           dout,  //output data
    output                  outE1A,
    output                  outE2A  //output error detect
);
// tmrg default do_not_triplicate

    wire [29:0] TDCData;
    assign TDCData = {  TDC_TOA,
                        TDC_TOT,
                        TDC_Cal[9]|TDC_EncError[2]|TDC_EncError[1]|TDC_EncError[0],
                        TDC_Cal[8:0],
                        TDC_hit};
    wire [29:0] fakeTDCData;
    wire [29:0] TDCDataInUse;
    wire selfTest;
    wire disTestPattern;
    assign selfTest = workMode != 2'b00;
    assign disTestPattern = ~selfTest | (disDataReadout & disTrigPath);
    assign TDCDataInUse = workMode != 2'b00 ? fakeTDCData : TDCData;
`ifdef pixelTMR
    TDCTestPatternGenTMR TDCEM (
`else
    TDCTestPatternGen TDCEM (
`endif
    	.clk(clk),              //40MHz
	    .reset(reset),          //
	    .dis(disTestPattern),          //
        .mode(workMode[1]),
        .latencyL1A(latencyL1A),
        .pixelID(pixelID),   
	    .occupancy(selfTestOccupancy),   
	    .dout(fakeTDCData)
    );

    wire E1A;
    wire E2A;
    wire hit;

    reg syncL1A;
    reg syncL1A1D; //delay one clock
    reg localL1A;

    always @(posedge clk) 
    begin
        if(disDataReadout == 1'b0)
            localL1A <= L1A;
    end
    always @(negedge clk) 
    begin
        if(disDataReadout == 1'b0)
        begin
            syncL1A      <= localL1A;
            syncL1A1D    <= syncL1A;
        end            
	end

    wire [9:0] TOA;
    wire [8:0] TOT;
    wire [9:0] Cal;
    assign TOA = TDCDataInUse[29:20];
    assign TOT = TDCDataInUse[19:11];
    assign Cal = TDCDataInUse[10:1];

    wire select;
    assign select =  (TOA >= lowerTOA) & (TOA <= upperTOA) & 
                     (TOT >= lowerTOT) & (TOT <= upperTOT) & 
                     (Cal >= lowerCal) & (Cal <= upperCal) & ~disDataReadout;

    wire selectTrig;
    assign selectTrig =  (TOA >= lowerTOATrig) & (TOA <= upperTOATrig) & 
                         (TOT >= lowerTOTTrig) & (TOT <= upperTOTTrig) & 
                         (Cal >= lowerCalTrig) & (Cal <= upperCalTrig) & ~disTrigPath;

    reg [28:0] dataIn;
    reg inHit;
    wire goodHit;
    assign goodHit = TDCDataInUse[0] & select; 
    always @(negedge clk) 
    begin
        if(disDataReadout == 1'b0)
            inHit   <= goodHit;   
	end   

    always @(negedge clk)
    begin
        if(goodHit)
            dataIn <= TDCDataInUse[29:1];
    end

    wire goodHitTrig;
    assign goodHitTrig = TDCDataInUse[0] & selectTrig; 
    // reg trigHitReg;
    // always @(negedge clk) 
    // begin
    //     if(disTrigPath == 1'b0)
    //         trigHitReg  <= goodHitTrig;   
	// end   

    //assign #1.0 dataIn = TDCDataInUse[29:1];

    wire [8:0] phyWrAddr;
    wire [9:0] offsetAddr = CBwrAddr + {6'h00,pixelID[4],pixelID[1:0]};
    assign phyWrAddr = addrOffset ? offsetAddr[8:0] : CBwrAddr;
    wire [35:0] encodedTDCData;

    circularBuffer MB(
	    .clk(clk),                  //40MHz
//	    .reset(reset),              //
        .dis(disDataReadout),
        .wrAddr(phyWrAddr),
	    .din(dataIn),         //data from TDC
        .inHit(inHit),
        .L1APre(L1A),
        .L1A(localL1A),                  //synced L1A signal
        .L1ADelay(syncL1A),
        .latencyL1A(latencyL1A),    //the L1A read address offset to write address
	    .dout(encodedTDCData),
        .hit(hit),
        .E1A(E1A),
        .E2A(E2A)
    );

    wire unreadHitL1;
    L1EventBuffer #(.ADDRWIDTH(L1ADDRWIDTH)) L1EvtB(
    	.clk(clk),            //40MHz
	    .reset(reset),         //
        .dis(disDataReadout),
        .wrAddr(L1wrAddr),
        .rdAddr(L1rdAddr),
        .preLoad(preLoad),
//        .full(L1Full),
	    .din(encodedTDCData),      //data from TDC
        .inHit(hit),
        .E1A(E1A),
        .E2A(E2A),
        .wren(syncL1A1D),
        .read(read),                //the data read signal from SW network
        .load(load),                //the data load signal from SW network
        .unreadHit(unreadHitL1),      //unread hit signal for SW network
        .outE1A(outE1A),
        .outE2A(outE2A),
	    .dout(dout)                 //TDC data, without hit
    );

    assign unreadHit = ~disDataReadout & unreadHitL1;

    reg trigHitOut;
    always @(negedge clk) 
    begin
        if(disTrigPath == 1'b0)
            trigHitOut  <= goodHitTrig;   
	end 

    wire [1:0] rowIDMSB = pixelID[3:2];
    assign trigHit[0]  = (rowIDMSB[1:0] == 2'b00) ? trigHitOut&~disTrigPath : 1'b0;
    assign trigHit[1]  = (rowIDMSB[1:0] == 2'b01) ? trigHitOut&~disTrigPath : 1'b0;
    assign trigHit[2]  = (rowIDMSB[1:0] == 2'b10) ? trigHitOut&~disTrigPath : 1'b0;
    assign trigHit[3]  = (rowIDMSB[1:0] == 2'b11) ? trigHitOut&~disTrigPath : 1'b0;
    
endmodule