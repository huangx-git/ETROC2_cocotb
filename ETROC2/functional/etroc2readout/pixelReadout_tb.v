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

	reg clk;
    reg reset;
    reg dnReset;
    wire [6:0] L1wrAddr;
    wire [6:0] L1rdAddr;
    wire [8:0] CBwrAddr;
    wire preLoad;
    wire L1BufEmpty;      // from overflow buffer
    wire L1BufFull;      // from overflow buffer
    wire [29:0] TDCData;
    reg [6:0] ocp;
    reg dnRead;
    reg dnLoad;
    wire [3:0] trigHit;
    wire [35:0] pixelOut;
    wire E1A;
    wire E2A;
    wire dnUnreadHit;
    reg dnL1A;
    wire [28:0] sourceTDC = TDCData[29:1];

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
// `ifdef pixelTMR
//     pixelReadout pixelInst1(
//`else
    pixelReadoutTMR pixelInst2(
//`endif
        .clk(clk),
        .reset(dnReset),
`ifdef NOT_SELFTEST
        .workMode(2'b00), //external data
`else 
        .workMode(2'b10), //self test mode
`endif
        .L1wrAddr(L1wrAddr),
        .L1rdAddr(L1rdAddr),
        .CBwrAddr(CBwrAddr),
        .preLoad(preLoad),
//        .L1Full(L1BufFull),
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
        .L1A(dnL1A),            //seltest or real L1A signal from global readout
        .pixelID(8'h15),   //
        .TDCData(TDCData),
        .latencyL1A(9'd501),
	    .selfTestOccupancy(ocp),  //0.1%, 1%, 2%, 5%, 10% etc
        .trigHit(trigHit),
        .read(dnRead),  //data read 
        .load(dnLoad),  //data load 
        .unreadHit(dnUnreadHit),
        .dout(pixelOut),  //output data
        .outE1A(E1A),
        .outE2A(E2A)  //output error detect
    );

    wire L1A;
    TestL1Generator TestL1GeneratorInst(
        .clkTMR(clk),
        .resetTMR(dnReset),
        .disTMR(1'b0),
        .modeTMR(1'b0), //periodic L1
        .L1ATMR(L1A)
    );

    CircularBufferAddr CBAddrInst(
        .clk(clk),
        .reset(dnReset),
        .wrAddr(CBwrAddr)
    );

	always @(negedge clk) 
    begin
        dnReset <= reset;   //synchize the reset   
    end

    reg syncL1A;


	always @(negedge clk) 
    begin
        dnReset <= reset;   //synchize the reset   
    end
    always @(negedge clk) 
    begin
         dnL1A <= L1A;        
    end

    always @(posedge clk) 
    begin
         syncL1A <= dnL1A;        
    end

    wire L1HalfFull;
    wire firstEvent;
    wire L1BufOverflow;
    wire [6:0] wordCount;
    assign L1HalfFull = wordCount >= 7'd64;  //user define
    assign L1BufOverflow = wordCount >= 7'd96;   //user define

    L1BufferAddr #(.ADDRWIDTH(7)) L1BAddrInst(
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

    reg sessionStart;
    reg load1D;
    reg [35:0] encTDCData;
   	always @(negedge clk) 
    begin
        if(!dnReset)
        begin
            dnLoad              <= 1'b0;
            dnRead              <= 1'b0;
            sessionStart        <= 1'b0;
        end
        else   
        begin
            if(!sessionStart)
            begin
                if(!L1BufEmpty)begin
                    sessionStart        <= 1'b1;
                    dnLoad              <= 1'b1;
                end
            end
            else
            begin
                dnLoad          <= 1'b0;
                dnRead          <= dnUnreadHit;
                if(dnUnreadHit)begin
                   encTDCData <= pixelOut;         
                end
                sessionStart    <= dnUnreadHit;                        
            end
        end
        load1D <= dnLoad;
	end	

    assign preLoad = (load1D & ~L1BufEmpty) | firstEvent;

    wire dataE1A;
    wire dataE2A;
    wire [28:0]  outTDCData;
    cb_data_mem_decoder decoder0
    (
        .DDI(encTDCData),
        .DDO(outTDCData),
        .E1(dataE1A),
        .E2(dataE2A)
    );


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
    
        #25 reset = 1'b0;
        #50 reset = 1'b1;
        #1000000 ocp = 7'h01;
        #2500000 $stop;
    end
    always 
        #12.5 clk = ~clk; //25 ns clock period


endmodule
