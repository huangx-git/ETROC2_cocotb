`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Wed Feb  3 21:31:30 CST 2021
// Module Name: frameBuilder
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////

module frameBuilder
(
	input  			    clk,            //40MHz
	input  			    reset,         //
    input [1:0]         type,
	input [28:0]        TDCData,
    input [16:0]        chipID,
    input               hit,
    input               eventStart,
    input [7:0]         pixelID,
    input [11:0]        BCID,
    input [7:0]         L1Counter,
    input [1:0]         EA,
    input               L1BufFull,
    input               L1BufHalfFull,
    input               L1BufOverflow,
    input               streamBufAlmostFull,
	output reg [39:0]   dataFrame
);
// tmrg default triplicate

    localparam header   = 2'b00;
    localparam data     = 2'b01;
    localparam trailer  = 2'b10;
    localparam idle     = 2'b11;

    reg [11:0] BCIDReg;
    reg [7:0] L1CounterReg;
    reg [39:0] dataRecord; //
    reg SEUError;
    reg [1:0] L1Status;
    reg [1:0] dataType; //00:header, 01, data, 10, trailer, 11: idle 
    reg [7:0] hitCount;
    wire [7:0] hitCountNext         = hitCount + 1; 
    wire [7:0] hitCountNextVoted    = hitCountNext;
    wire [1:0] dataTypeVoted = dataType;
    wire eventStartVoted = eventStart;
    wire hitVoted = hit;
    wire streamBufAlmostFullVoted = streamBufAlmostFull;
    always @(posedge clk) 
    begin
        if(~reset)
        begin
            dataType        <= idle;
            dataRecord      <= {40{1'b0}};
            BCIDReg         <= 12'd0;
            L1CounterReg    <= 8'd0;
            L1Status        <= 2'd0;
            SEUError        <= 1'b0;
            hitCount        <= 8'h00;
        end
        else if(!streamBufAlmostFullVoted)
        begin
            BCIDReg         <= BCID;
            L1CounterReg    <= L1Counter;
            dataRecord      <= {1'b1,EA,pixelID,TDCData};
            L1Status        <= L1BufFull ? 2'b11 : (L1BufOverflow ? 2'b10 : (L1BufHalfFull ? 2'b01: 2'b00));
            if(eventStartVoted)
            begin
                dataType <= header;
                SEUError <= 1'b0;
                hitCount <= 8'h00;
            end
            else if (hitVoted )
            begin
                dataType <= data;           
                SEUError <= SEUError | EA[0] | EA[1];   
                hitCount <= hitCountNextVoted;         
            end
            else if(hitVoted == 1'b0 && (dataTypeVoted == data || dataTypeVoted == header))
            begin
                dataType <= trailer;                       
            end
            else
            begin
                dataType <= idle;                                   
            end
        end
    end

    wire [39:0] frameHeader;
    wire [39:0] frameTrailer;
    reg [7:0] CRC;
    wire [7:0] nextCRC;
    wire [7:0] nextCRCVoted = nextCRC;
    wire [7:0] finalCRC;
  //  assign frameHeader = {16'h3C5C,2'b00,8'hAA,type,BCIDReg};
    assign frameHeader = {16'h3C5C,2'b00,L1CounterReg,type,BCID}; //real BCID aligned with data 
    assign frameTrailer = {1'b0,chipID,L1Status,SEUError,3'b000,hitCount,finalCRC};
    wire [39:0]  frameTrailerVoted = frameTrailer;
    wire [39:0] dataRecordVoted = dataRecord;
    always @(posedge clk) 
    begin
        if(~reset)
        begin
            dataFrame <= {16'h3C5C,2'b10,22'h2AAAAA};
            CRC <= 8'h00;
        end
        else if(!streamBufAlmostFullVoted)
        begin
            if(dataTypeVoted == header)
            begin
                dataFrame <= frameHeader;
                CRC <= nextCRCVoted;
            end
            else if(dataTypeVoted == data)
            begin
                dataFrame <= dataRecordVoted;   
                CRC <= nextCRCVoted;         
            end
            else if(dataTypeVoted == trailer)
            begin
                CRC <= 8'h00;
                dataFrame <= frameTrailerVoted;                        
            end
            else //(dataType == idle)
            begin
                dataFrame <= {16'h3C5C,2'b10,22'h2AAAAA};  
            end
        end
    end

    wire enableCRC32;
    wire enableCRC40;
    assign enableCRC40 = (dataTypeVoted != idle) && (dataTypeVoted != trailer); //header | data | trailer;
    assign enableCRC32 = (dataTypeVoted == trailer);
    wire [39:0] crcData; 
    assign crcData = (dataType == header) ? frameHeader : (dataType == trailer ? frameTrailer : dataRecord);
    wire disCRC32 = ~enableCRC32;
    wire disCRC40 = ~enableCRC40;
    CRC8 #(.WORDWIDTH(40))CRCInst40(
            .cin(CRC),
            .dis(disCRC40),
            .din(crcData),
            .dout(nextCRC));

   CRC8 #(.WORDWIDTH(32))CRCInst32(
            .cin(CRC),
            .dis(disCRC32),
            .din(crcData[39:8]),
            .dout(finalCRC));

endmodule
