`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 30 22:24:24 CST 2021
// Module Name: multiplePixelDataCheck
// Project Name: ETROC2 readout
// Description: 
// Dependencies: PRBS9
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module multiplePixelDataCheck
(
	input  			    clk,            //40MHz
	input  			    reset,         //
	input [28:0]        TDCData,
    input               unreadHit,
	output reg [19:0]   totalHitEvent,
    output reg [19:0]   errorCount,
    output reg [19:0]   missedCount,
    output reg [8:0]    hittedPixelCount,
    output reg [19:0]   mismatchedBCIDCount
);

    reg [8:0] TDCDataReg [255:0];   
    reg [11:0] BCIDReg;
    reg [255:0] Hitted;
    reg preUnreadHit;
    wire [11:0] BCID;
    wire [8:0] preCountPlusOne;
    wire [8:0] curCount;
    wire [7:0] pixelID;
    wire [8:0] missedCnt; // missed events 
    assign pixelID = TDCData[28:21];
    assign curCount = TDCData[8:0];
    assign preCountPlusOne = TDCDataReg[pixelID][8:0] + 1;
    assign missedCnt = (curCount >= preCountPlusOne) ? curCount - preCountPlusOne : 
                                        ((9'h1FF-(preCountPlusOne-curCount)) + 9'h001);
    assign BCID = TDCData[20:9]; //
    always @(posedge clk) 
    begin
        if(!reset)
        begin
		//clear counter
            Hitted <= {256{1'b0}}; //clear
            totalHitEvent <= 20'h00000;
            errorCount <= 20'h00000;
            missedCount <= 20'h00000;
            mismatchedBCIDCount <= 20'h00000;
            hittedPixelCount <= 9'h000;
            preUnreadHit <= 1'b0;
        end
        else
        begin
            preUnreadHit <= unreadHit;    
            BCIDReg <= BCID; 
            if(unreadHit == 1'b1)
            begin
                if(preUnreadHit == 1'b1) //
                begin
                    if (BCID != BCIDReg)
                    begin
                        mismatchedBCIDCount <= mismatchedBCIDCount + 1;
                    end
                end
                TDCDataReg[pixelID] <= TDCData[8:0];
                totalHitEvent <= totalHitEvent + 1;
                Hitted[pixelID] <= 1'b1;
                if(Hitted[pixelID] == 1'b0) 
                begin
                    hittedPixelCount <= hittedPixelCount + 1;
                end
                if(curCount != preCountPlusOne && Hitted[pixelID] == 1'b1)
                begin
                    errorCount <= errorCount + 1;
                    missedCount <= missedCount + missedCnt;
                end
            end	
        end
    end

endmodule
