`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 23 12:28:04 CST 2021
// Module Name: globalReadoutController
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////

module globalReadoutController #(
    parameter L1ADDRWIDTH = 7,
    parameter BCSTWIDTH = 27
)
(
	input                           clk,                //40MHz
    input                           reset,              //reset input port
    input                           L1A,                //input signal of L1A
//    input [L1ADDRWIDTH-1:0]         almostFullLevel,
//SW network
    input [45:0]                    dnData,          //TDC data 29 b, E2A,E1A, PixelID 8b
    input                           dnUnreadHit,          //if exist unread hit
    output reg                      dnRead,               //
    output [BCSTWIDTH-1:0]          dnBCST,
//BCID buffer
    input [11:0]                    inBCID,             //read BCID to global controller.
    input                           BCBE1A,
    input                           BCBE2A,
// from stream buffer
    input                           streamBufAlmostFull,
//output for check
    output [L1ADDRWIDTH-1:0]        wordCount,   
//output to frame builder
    output wire                     eventStart,         //start a new event
    output reg                      hit,               //hit or not
    output [28:0]                   outTDCData,
    output reg [7:0]                outPixelID,
    output reg [11:0]               outBCID,
    output reg [1:0]                outEA,
    output reg                      outL1BufFull,    //
    output wire                     outL1BufOverflow,
    output reg                      outL1BufHalfFull     //BCID overflow error
);
// tmrg default triplicate
    localparam almostFullLevel = 7'd96;
    wire dnReset;
    reg dnLoad;
    reg syncL1A;
    reg dnL1A;

    wire L1BufEmpty;      // from overflow buffer
    wire L1BufFull;      // from overflow buffer
    assign dnReset = reset; //reset signal has been synchronized in globalDigital module.
    // reg reset1D;
	// always @(negedge clk) 
    // begin
    //     reset1D <= reset;
    //     dnReset <= reset1D;   //synchize the reset   
    // end
    always @(negedge clk) 
    begin
         dnL1A <= L1A;        
    end

    always @(posedge clk) 
    begin
         syncL1A <= dnL1A;        
    end


    wire [8:0] CBwrAddr;
    CircularBufferAddr CBAddrInst(
        .clk(clk),
        .reset(dnReset),
        .wrAddr(CBwrAddr)
    );

    wire [L1ADDRWIDTH-1:0] L1rdAddr;
    wire [L1ADDRWIDTH-1:0] L1wrAddr;
    wire L1HalfFull;
    wire firstEvent;
    wire L1BufOverflow;
    assign L1HalfFull = wordCount >= 7'd64;  //user define
    assign L1BufOverflow = wordCount >= almostFullLevel;   //user define

    L1BufferAddr #(.ADDRWIDTH(L1ADDRWIDTH)) L1BAddrInst(
        .clk(clk),
        .reset(dnReset),
        .wrEn(syncL1A),
        .rdEn(dnLoad),
        .wordCount(wordCount),
        .wrAddr(L1wrAddr),
        .rdAddr(L1rdAddr),
        .empty(L1BufEmpty),
        .firstEvent(firstEvent),
        .full(L1BufFull)
    );

    wire [7:0] dnPixelID;
    wire [35:0] dnTDCData;
    wire [1:0] dnEA;
    wire preLoad;

    assign dnBCST = {preLoad,CBwrAddr,L1wrAddr,L1rdAddr,dnLoad,dnL1A,dnReset};
    assign dnPixelID = dnData[7:0];
    assign dnTDCData = dnData[45:10]; //encoded TDC data
    assign dnEA = dnData[9:8];

    reg L1BufOverflowReg;
    reg [35:0] encTDCData;
    wire [1:0] overallEA;
    reg BCBE1AReg;
    reg BCBE2AReg;
    wire streamBufAlmostFullVoted = streamBufAlmostFull;
	always @(negedge clk) 
    begin
        if(!streamBufAlmostFullVoted)
        begin
            hit             <= L1BufOverflowReg ? 1'b0 : dnUnreadHit;
            outBCID         <= inBCID;
            encTDCData      <= dnTDCData;
            outPixelID      <= dnPixelID;
            outL1BufFull    <= L1BufFull;
            outL1BufHalfFull <= L1HalfFull;
            outEA            <= overallEA;
            BCBE1AReg        <= BCBE1A;
            BCBE2AReg        <= BCBE2A;
        end
	end

    wire dataE1A;
    wire dataE2A;
    cb_data_mem_decoder decoder0
    (
        .DDI(encTDCData),
        .DDO(outTDCData),
        .E1(dataE1A),
        .E2(dataE2A)
    );

    assign overallEA[0] = dataE1A | dnEA[0] | BCBE1AReg;
    assign overallEA[1] = dataE2A | dnEA[1] | BCBE2AReg;
    
    assign eventStart       = dnLoad;
    assign outL1BufOverflow = L1BufOverflowReg;
    reg sessionStart;
    reg load1D;
    wire sessionStartNext = L1BufOverflowReg ? 1'b0 : dnUnreadHit;
    wire sessionStartNextVoted = sessionStartNext;
    wire L1BufEmptyVoted = L1BufEmpty;

	always @(negedge clk) 
    begin
        if(!dnReset)
        begin
            dnLoad              <= 1'b0;
            dnRead              <= 1'b0;
            sessionStart        <= 1'b0;
            L1BufOverflowReg    <= 2'b0;
        end
        else   
        begin
            if(!sessionStart)
            begin
                if(~L1BufEmptyVoted & ~streamBufAlmostFullVoted) //if it is overflow, start the read
                begin
                    sessionStart        <= 1'b1;
                    dnLoad              <= 1'b1;
                    L1BufOverflowReg    <= L1BufOverflow;
                end
            end
            else
            begin
                dnLoad          <= 1'b0;
                dnRead          <= L1BufOverflowReg | streamBufAlmostFull ? 1'b0 : dnUnreadHit;
                if(!streamBufAlmostFullVoted)
                begin
                    sessionStart    <= sessionStartNextVoted;                        
                end
            end
        end
        load1D <= dnLoad;
	end	

    assign preLoad = (load1D & ~L1BufEmpty) | firstEvent;

endmodule
