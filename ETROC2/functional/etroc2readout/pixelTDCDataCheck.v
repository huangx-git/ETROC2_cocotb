`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 23 12:36:50 CST 2021
// Module Name: pixelTDCDataCheck
// Project Name: ETROC2 readout
// Description: 
// Dependencies: PRBS9
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module pixelTDCDataCheck
(
	input  			clk,            //40MHz
	input  			reset,         //
    input           hitA,
    input           hitB,
    input           hitC,
	input [28:0]    TDCData,
	output reg [19:0]	totalClockPeriods,
    output reg [19:0]   totalL1AHitEvent,
    output reg [7:0]    hitMismatchErrorCount
);

    wire hitMismatch;
    assign hitMismatch = (hitA != hitB) || (hitA != hitC) || (hitB != hitC);
    wire votedHit;
    wire tmrErr;
    majorityVoterTagGates #(.WIDTH(1))voter1(.inA(hitA),.inB(hitB),.inC(hitC),.out(votedHit),.tmrErr(tmrErr));

    always @(posedge clk) 
    begin
        if(!reset)
        begin
		//clear counter
			totalClockPeriods <= 20'h00000;
            totalL1AHitEvent <= 20'h00000;
            hitMismatchErrorCount <= 8'h00;
        end
        else 
		begin
            totalClockPeriods <= totalClockPeriods + 1;
            if(votedHit == 1'b1)
            begin
                totalL1AHitEvent <= totalL1AHitEvent + 1;
            end
            if (hitMismatch == 1'b1) 
            begin
                hitMismatchErrorCount <= hitMismatchErrorCount + 1;
            end       
        end	
    end

endmodule
