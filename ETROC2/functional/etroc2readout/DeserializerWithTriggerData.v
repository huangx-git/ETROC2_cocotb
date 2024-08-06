`timescale 10ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Fri Feb 12 12:40:40 CST 2021
// Module Name: deserializer with trigger data
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// LSB first deserializer
//  for logic check only


//////////////////////////////////////////////////////////////////////////////////


module deserializerWithTriggerData (
    input                   bitCK,
    input                   reset,
    input                   disSCR,
    input [1:0]             rate,      //serializer rate
    input [4:0]             delay,   //delay from 0 to 31
	input                   sin,         //serial data
    input [4:0]             trigDataSize,   //from 0 to 16
    output [15:0]           trigData,
    output                  wordTrigClk,
    output                  word40CK,
	output [39:0]       dout         //input data
);

    wire word32CK;
    wire [31:0] word32;
    deserializer #(.WORDWIDTH(32),.WIDTH(5)) des32(
        .bitCK(bitCK),
        .reset(reset),
        .disSCR(disSCR),
        .delay(delay),
        .sin(sin),
        .wordCK(word32CK),
        .dout(word32)
    );

    wire word16CK;
    wire [15:0] word16;
    deserializer #(.WORDWIDTH(16),.WIDTH(4)) des16(
        .bitCK(bitCK),
        .reset(reset),
        .disSCR(disSCR),
        .delay(delay[3:0]),
        .sin(sin),
        .wordCK(word16CK),
        .dout(word16)
    );

    wire word8CK;
    wire [7:0] word8;
    deserializer #(.WORDWIDTH(8),.WIDTH(3)) des8(
        .bitCK(bitCK),
        .reset(reset),
        .disSCR(disSCR),
        .delay(delay[2:0]),
        .sin(sin),
        .wordCK(word8CK),
        .dout(word8)
    );

    assign wordTrigClk = rate == 2'b00 ? word8CK :(rate == 2'b01 ? word16CK : word32CK);

    reg [10 : 0] counter;  
    wire [10:0] stepsize8 = {4'd0,(5'd8 - trigDataSize),2'b00};
    wire [10:0] stepsize16 = {5'd0,(5'd16 - trigDataSize),1'b0};
    wire [10:0] stepsize32 = {5'd0,(6'd32 - {1'b0,trigDataSize})};

    wire [10:0] stepsize = rate == 2'b00 ? stepsize8 : (rate == 2'b01 ? stepsize16 : stepsize32);

    reg [127:0] delayCell;
    wire delayedRST;
    always @(posedge bitCK) 
    begin
            delayCell <= {delayCell[126:0],reset};
    end
    assign delayedRST = delayCell[127];

    always @(posedge bitCK) 
    begin
        if(!reset)
        begin
            counter <= {11*{1'b0}};
        end
        else if(counter < (11'd1280-stepsize))
        begin
            counter <= counter + stepsize;
        end
        else 
        begin
            counter <= counter + stepsize - 11'd1280;
        end
    end

    assign word40CK = (counter >= 11'd640);

    reg[1023:0] cb;             //a circular buffer
    reg [9:0] wrAddr;
    reg [9:0] rdAddr;

    wire [9:0] wordsize8 = {5'd0,(5'd8 - trigDataSize)};
    wire [9:0] wordsize16 = {5'd0,(5'd16 - trigDataSize)};
    wire [9:0] wordsize32 = {4'd0,(6'd32 - {1'b0,trigDataSize})};
    wire [9:0] wordsize = rate == 2'b00 ? wordsize8 : (rate == 2'b01 ? wordsize16 : wordsize32);
    wire [31:0] word = rate == 2'b00 ? {24'd0,word8} : (rate == 2'b01 ? {16'd0,word16} : word32);

    reg wordReset;
    reg [15:0] triggerDataReg;
    always @(posedge wordTrigClk) //40 MHz clock
    begin
        if(!delayedRST)
        begin
            wrAddr <= 10'H000;
            wordReset <= 1'b0;
        end
        else
        begin
            if(word40CK)
            begin
                wordReset <= 1'b1; //just reset once                
            end         
            wrAddr <=  wrAddr + wordsize;
//write data in cb            
            //cb[wrAddr +: 32] <= word[31:0];
            cb[wrAddr+10'd0] <= word[0];
            cb[wrAddr+10'd1] <= word[1];
            cb[wrAddr+10'd2] <= word[2];
            cb[wrAddr+10'd3] <= word[3];
            cb[wrAddr+10'd4] <= word[4];
            cb[wrAddr+10'd5] <= word[5];
            cb[wrAddr+10'd6] <= word[6];
            cb[wrAddr+10'd7] <= word[7];
            if(rate != 2'b00)
            begin
                cb[wrAddr+10'd8] <= word[8];
                cb[wrAddr+10'd9] <= word[9];
                cb[wrAddr+10'd10] <= word[10];
                cb[wrAddr+10'd11] <= word[11];
                cb[wrAddr+10'd12] <= word[12];
                cb[wrAddr+10'd13] <= word[13];
                cb[wrAddr+10'd14] <= word[14];
                cb[wrAddr+10'd15] <= word[15];
                cb[wrAddr+10'd16] <= word[16];
                if(rate == 2'b10 || rate == 2'b11)
                begin
                    cb[wrAddr+10'd17] <= word[17];
                    cb[wrAddr+10'd18] <= word[18];
                    cb[wrAddr+10'd19] <= word[19];
                    cb[wrAddr+10'd20] <= word[20];
                    cb[wrAddr+10'd21] <= word[21];
                    cb[wrAddr+10'd22] <= word[22];
                    cb[wrAddr+10'd23] <= word[23];
                    cb[wrAddr+10'd24] <= word[24];
                    cb[wrAddr+10'd25] <= word[25];
                    cb[wrAddr+10'd26] <= word[26];
                    cb[wrAddr+10'd27] <= word[27];
                    cb[wrAddr+10'd28] <= word[28];
                    cb[wrAddr+10'd29] <= word[29];  
                    cb[wrAddr+10'd30] <= word[30];                   
                    cb[wrAddr+10'd31] <= word[31];                   
                end
            end
            triggerDataReg[0] <= cb[wrAddr];
            triggerDataReg[1] <= cb[wrAddr+10'd1];
            triggerDataReg[2] <= cb[wrAddr+10'd2];
            triggerDataReg[3] <= cb[wrAddr+10'd3];
            triggerDataReg[4] <= cb[wrAddr+10'd4];
            triggerDataReg[5] <= cb[wrAddr+10'd5];
            triggerDataReg[6] <= cb[wrAddr+10'd6];
            triggerDataReg[7] <= cb[wrAddr+10'd7];
            triggerDataReg[8] <= cb[wrAddr+10'd8];
            triggerDataReg[9] <= cb[wrAddr+10'd9];
            triggerDataReg[10] <= cb[wrAddr+10'd10];
            triggerDataReg[11] <= cb[wrAddr+10'd11];
            triggerDataReg[12] <= cb[wrAddr+10'd12];
            triggerDataReg[13] <= cb[wrAddr+10'd13];
            triggerDataReg[14] <= cb[wrAddr+10'd14];
            triggerDataReg[15] <= cb[wrAddr+10'd15];
        end
    end
    assign trigData = triggerDataReg;

    reg [39:0] word40;
    always @(posedge word40CK) //data frame clock
    begin
        if(!wordReset)
        begin
            rdAddr <= 10'd512;  //far enough from write address
        end
        else
        begin
            rdAddr <=  rdAddr + 10'd40;
            word40[0]  <= cb[rdAddr];
            word40[1]  <= cb[rdAddr + 10'd1];
            word40[2]  <= cb[rdAddr + 10'd2];
            word40[3]  <= cb[rdAddr + 10'd3];
            word40[4]  <= cb[rdAddr + 10'd4];
            word40[5]  <= cb[rdAddr + 10'd5];
            word40[6]  <= cb[rdAddr + 10'd6];
            word40[7]  <= cb[rdAddr + 10'd7];
            word40[8]  <= cb[rdAddr + 10'd8];
            word40[9]  <= cb[rdAddr + 10'd9];
            word40[10] <= cb[rdAddr + 10'd10];
            word40[11] <= cb[rdAddr + 10'd11];
            word40[12] <= cb[rdAddr + 10'd12];
            word40[13] <= cb[rdAddr + 10'd13];
            word40[14] <= cb[rdAddr + 10'd14];
            word40[15] <= cb[rdAddr + 10'd15];
            word40[16] <= cb[rdAddr + 10'd16];
            word40[17] <= cb[rdAddr + 10'd17];
            word40[18] <= cb[rdAddr + 10'd18];
            word40[19] <= cb[rdAddr + 10'd19];
            word40[20] <= cb[rdAddr + 10'd20];
            word40[21] <= cb[rdAddr + 10'd21];
            word40[22] <= cb[rdAddr + 10'd22];
            word40[23] <= cb[rdAddr + 10'd23];
            word40[24] <= cb[rdAddr + 10'd24];
            word40[25] <= cb[rdAddr + 10'd25];
            word40[26] <= cb[rdAddr + 10'd26];
            word40[27] <= cb[rdAddr + 10'd27];
            word40[28] <= cb[rdAddr + 10'd28];
            word40[29] <= cb[rdAddr + 10'd29];
            word40[30] <= cb[rdAddr + 10'd30];
            word40[31] <= cb[rdAddr + 10'd31];
            word40[32] <= cb[rdAddr + 10'd32];
            word40[33] <= cb[rdAddr + 10'd33];
            word40[34] <= cb[rdAddr + 10'd34];
            word40[35] <= cb[rdAddr + 10'd35];
            word40[36] <= cb[rdAddr + 10'd36];
            word40[37] <= cb[rdAddr + 10'd37];
            word40[38] <= cb[rdAddr + 10'd38];
            word40[39] <= cb[rdAddr + 10'd39];            
        end
    end    

    assign dout = word40;

endmodule