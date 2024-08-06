`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Wed Feb  3 10:14:24 CST 2021
// Module Name: finalPixelDataCheck
// Project Name: ETROC2 readout
// Description: 
// Dependencies: PRBS9
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"

module finalPixelDataCheck
(
	input  			    clk,            //40MHz
	input  			    reset,         //
	input [28:0]        TDCData,
    input               hit,
    input               eventStart,
    input [7:0]         pixelID,
    input [11:0]        BCID,
	output wire [19:0]  totalHitEvent,
    output reg [19:0]   totalGoodEventCount,
    output reg [19:0]   totalClockCount,
    output wire [19:0]  dataErrorCount,
    output wire [19:0]  missedCount,
    output wire [8:0]   hittedPixelCount,
    output wire [19:0]  mismatchedBCIDCount,
// `ifdef DEBUG
    output reg [19:0]  BCIDErrorCount,
// `endif 
    output reg [19:0]   emptyEventCount
);

// tmrg default do_not_triplicate

    wire goodEvent;
    assign goodEvent = hit;
    reg [11:0] BCIDReg;
    reg preGoodEvt;

    multiplePixelDataCheck L1Check(
        .clk(clk),
        .reset(reset),
        .TDCData(TDCData),
        .unreadHit(goodEvent),
        .totalHitEvent(totalHitEvent),
        .errorCount(dataErrorCount),
        .missedCount(missedCount),
        .hittedPixelCount(hittedPixelCount),
        .mismatchedBCIDCount(mismatchedBCIDCount)        
    );

//`ifdef DEBUG
    wire [11:0] BCIDinData;
    assign BCIDinData = TDCData[20:9];
//`endif 

    always @(posedge clk) 
    begin
        if(!reset)
        begin
		//clear counter
            emptyEventCount <= 20'h00000;
            totalGoodEventCount <= 20'h00000;
            totalClockCount <= 20'h00000;
            preGoodEvt <= 1'b0;
            BCIDReg <= 12'h000;
//`ifdef DEBUG
            BCIDErrorCount <= 20'h00000;
//`endif 
        end
        else 
        begin 
            totalClockCount <= totalClockCount + 1;
            BCIDReg <= BCID;
            preGoodEvt <= goodEvent;
            if(goodEvent == 1'b1)
            begin
//`ifdef DEBUG
                if(BCIDinData != BCID)
                begin
                    BCIDErrorCount <= BCIDErrorCount + 1;                
                end
//`endif 
                if(eventStart == 1'b1)
                begin
                    totalGoodEventCount <= totalGoodEventCount + 1;
                end
            end
            if(eventStart == 1'b1  && hit == 1'b0)
            begin
                emptyEventCount <= emptyEventCount + 1;
            end
        end
    end



endmodule
