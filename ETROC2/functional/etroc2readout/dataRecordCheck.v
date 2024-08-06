`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Wed Feb  3 10:14:24 CST 2021
// Module Name: dataRecordCheck
// Project Name: ETROC2 readout
// Description: 
// Dependencies: PRBS9
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"

module dataRecordCheck
(
	input  			    clk,            //40MHz
	input  			    reset,         //
    input [39:0]        dataRecord,
// `ifdef DEBUG
    output reg [19:0]  BCIDErrorCount,
// `endif 
    output reg [1:0]    dataType,
    output reg [19:0]   nullEventCount, //idle count
    output reg [19:0]   goodEventCount,
    output reg [19:0]   notHitEventCount,
    output reg [19:0]   L1OverlfowEventCount,
    output reg [19:0]   L1FullEventCount,
    output reg [19:0]   L1HalfFullEventCount,
    output reg [19:0]   SEUEventCount,
    output reg [19:0]   hitCountMismatchEventCount,
    output [19:0]       totalHitsCount,
    output [19:0]       dataErrorCount,
    output [19:0]       missedHitsCount,
    output [8:0]        hittedPixelCount,
    output reg [19:0]   frameErrorCount,
    output reg [9:0]        goodEventRate, //CRCError for every 64 frame
    output [19:0]       mismatchBCIDCount
);
// tmrg default do_not_triplicate

    localparam header   = 2'b00;
    localparam data     = 2'b01;
    localparam trailer  = 2'b10;
    localparam idle     = 2'b11;

    localparam goodFrame        = 3'b000;
    localparam noTrailer        = 3'b001;
    localparam noHeader         = 3'b010;
    localparam countMismatch    = 3'b011;
    localparam CRCMismatch      = 3'b100;
    localparam headerError      = 3'b101;
    localparam idleError        = 3'b110;
    localparam overlfowData     = 3'b111; //overflow but not empty event.

    reg [39:0] record;
    always @(posedge clk) 
    begin
        record <= dataRecord;
        if(dataRecord[39] == 1'b1)
        begin
            dataType <= data;
        end
        else if(dataRecord[39:22] == {16'h3C5C,2'b00})
        begin
            dataType <= header;            
        end
        else if(dataRecord[39:22] == {16'h3C5C,2'b10})
        begin
            dataType <= idle;                        
        end
        else 
        begin
            dataType <= trailer;                                    
        end
    end

	wire [28:0]        TDCData;
    wire isData;
    assign isData = dataType == data;
    assign TDCData = record[28:0];
//`ifdef DEBUG
    wire [11:0] BCIDinData;
    assign BCIDinData = TDCData[20:9];
//`endif 

    multiplePixelDataCheck L1Check(
        .clk(clk),
        .reset(reset),
        .TDCData(TDCData),
        .unreadHit(isData),
        .totalHitEvent(totalHitsCount),
        .errorCount(dataErrorCount),
        .missedCount(missedHitsCount),
        .hittedPixelCount(hittedPixelCount),
        .mismatchedBCIDCount(mismatchBCIDCount)        
    );


//`ifdef DEBUG
    reg [11:0] BCID;
    always @(posedge clk) 
    begin
        if(!reset)
        begin
		//clear counter
            BCIDErrorCount <= 20'h00000;
        end
        else if (isData == 1'b0)
        begin
            BCID <= record[11:0]; 
        end
        else if(isData == 1'b1 && BCID != BCIDinData)
        begin
            BCIDErrorCount <= BCIDErrorCount + 1; 
        end
    end
//`endif 

    reg [7:0] hitsCount;
    reg sessionStart;
    reg [2:0] frameError;
    reg [7:0] CRC;
    wire [7:0] nextCRC;
    wire enableCRC;
    wire [39:0] crcData; 
//    assign crcData = dataType == idle ? {40{1'b0}} : ((dataType == trailer) ? {record[39:8],8'h00} : record);
    assign crcData = dataType == idle ? {40{1'b0}} : record;

    assign enableCRC = dataType != idle;
    reg [9:0] counter;
    reg [9:0] counterNewGoodEvt;
    always @(posedge clk) 
    begin
        if(!reset)
        begin
            sessionStart <= 1'b0;
            nullEventCount <= {20{1'b0}};
            goodEventCount <= {20{1'b0}};
            notHitEventCount <= {20{1'b0}};
            L1OverlfowEventCount <= {20{1'b0}};
            frameErrorCount <= {20{1'b0}};
            L1FullEventCount <= {20{1'b0}};
            L1HalfFullEventCount <= {20{1'b0}};
            SEUEventCount <= {20{1'b0}};
            hitCountMismatchEventCount <= {20{1'b0}};
            counter <= 10'd0;
            counterNewGoodEvt <= 10'd0;
            goodEventRate <= 10'd0;
        end
        else
        begin
            counter <= counter + 1;
            if(counter[6:0] == 7'D64)
            begin
                if(frameError != goodFrame)
                begin
                    goodEventRate <= counterNewGoodEvt;
                end
                else
                begin
                    goodEventRate <= counterNewGoodEvt+10'd1;
                end
                counterNewGoodEvt <= 10'd0;
            end
            else
            begin
                if(frameError == goodFrame)
                    counterNewGoodEvt <= counterNewGoodEvt + 10'd1;
            end    

            if(frameError != goodFrame)frameErrorCount <= frameErrorCount + 1;
            if(dataType == header)
            begin
                if(sessionStart != 1'b0)
                begin
                    frameError <= noTrailer; //not terminated by a trailer       
                end
                else
                begin
                    frameError <= goodFrame;                
                end
                sessionStart <= 1'b1; 
                hitsCount <= 8'h00;
                CRC <= nextCRC;
            end
            else if (dataType == data)
            begin
                if(sessionStart != 1'b1)
                begin
                    frameError <= noHeader;
                end
                else 
                begin
                    frameError <= goodFrame;                                
                end
                hitsCount <= hitsCount + 1;
                CRC <= nextCRC;
            end 
            else if(dataType == trailer)
            begin
                CRC <= 8'h00;
                sessionStart <= 1'b0;
                //if(hitsCount >= 1)goodEventCount <= goodEventCount + 1;      
                if(hitsCount == 8'h00)notHitEventCount <= notHitEventCount + 1;  
                if(record[21:20] == 2'b10)L1OverlfowEventCount <= L1OverlfowEventCount + 1;
                if(record[21:20] == 2'b01)L1HalfFullEventCount <= L1HalfFullEventCount + 1;
                if(record[21:20] == 2'b11)L1FullEventCount <= L1FullEventCount + 1;
                if(record[19] == 1'b1)SEUEventCount <= SEUEventCount + 1;
                if(record[15:8] != hitsCount)hitCountMismatchEventCount <= hitCountMismatchEventCount + 1;
                if(sessionStart != 1'b1)
                begin
                    frameError <= noHeader;                
                end
                else if(hitsCount != record[15:8])
                begin
                    frameError <= countMismatch;                   
                end 
 //               else if(record[7:0] != nextCRC)      
                else if (nextCRC != 8'h00)
                begin
                    frameError <= CRCMismatch;          
                end
                else if(record[21] == 1'b1 && hitsCount != 8'h00) 
                begin
                    if(hitsCount != 8'h00) frameError <= overlfowData;
                end  
                else 
                begin
                    frameError <= goodFrame;
                    if(hitsCount >= 1)
                    begin
                        goodEventCount <= goodEventCount + 1; 
                    end
                end  
            end
            else //idle
            begin
                if(sessionStart != 1'b0)
                begin
                    frameError <= noTrailer;
                end
//                else if(record != {16'h3C5C,2'b10,22'h2AAAAA})
                else if(record[39:22] != {16'h3C5C,2'b10})
                begin
                    frameError <= idleError;
                end
                else
                begin
                    frameError <= goodFrame;               
                end
                nullEventCount <= nullEventCount + 1;
            end
        end
    end

    CRC8 #(.WORDWIDTH(40))CRCInst(
            .cin(CRC),
            .dis(!enableCRC),
            .din(crcData),
            .dout(nextCRC));

endmodule
