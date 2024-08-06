`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Tue Jan 26 15:19:35 CST 2021
// Module Name: pixelL1TDCDataCheck
// Project Name: ETROC2 readout
// Description: 
// Dependencies: PRBS9
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module pixelL1TDCDataCheck
(
	input  			clk,            //40MHz
	input  			reset,         //
	input [28:0]    TDCData,
    input           unreadHit,
	output reg [19:0]	totalHitEvent,
    output reg [11:0]   errorCount
);

    reg [29:0] TDCDataReg;   //with hit
    wire [8:0] preCountPlusOne;
    wire [8:0] curCount;
    assign curCount = TDCData[8:0];
    assign preCountPlusOne = TDCDataReg[9:1] + 1;

    always @(posedge clk) 
    begin
        if(!reset)
        begin
		//clear counter
            totalHitEvent <= 20'h00000;
            errorCount <= 12'h000;
            TDCDataReg <= 30'h00000000;
        end
        else 
		begin
            if(unreadHit == 1'b1)
            begin
                TDCDataReg <= {TDCData,1'b1};
                totalHitEvent <= totalHitEvent + 1;
                if(curCount != preCountPlusOne && TDCDataReg[0] == 1'b1)
                begin
                    errorCount <= errorCount + 1;
                end
            end
        end	
    end

endmodule
