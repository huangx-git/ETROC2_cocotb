`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Mon Feb  8 19:42:43 CST 2021
// Module Name: streamBuffer
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created


//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"


module streamBuffer 
#(  parameter FIFODEPTH = 4)
(
	input  			        clk,            //40MHz
	input  			        reset,         //
    input [1:0]             rate,           //00: 320 Mbps, 01: 640Mbps, 10/11: 1280 Mbps
    input [4:0]             triggerDataSize,  //How many trigger signals, from 0 to 16
    input [31:0]            triggerData,    //trigger data, up to 16 bits, 
	input [39:0]            dataFrame,
//    input                   disSCR,        //disable scrambler
    input [11:0]            RT_BCID,
    input [1:0]             DBS,
    input [7:0]             RT_L1Counter,
    output                  almostFull,
    output reg [31:0]       dout            //output data to serializer 
 );
// tmrg default triplicate

    localparam filler = {16'h3C5C,2'b10};
    localparam lowLevel = 2'd2;
    localparam highLevel = 2'd2;

    wire almostEmpty;
    wire isAFiller;
    assign isAFiller = dataFrame[39:22] == filler;
    reg wren;
    wire [39:0] rt_dataFrame;
    assign rt_dataFrame = isAFiller ? {dataFrame[39:22],RT_L1Counter,DBS,RT_BCID} : dataFrame;
    // wire [39:0] scrData;
    // Scrambler scrInst(
    //     .clk(clk),
    //     .reset(reset),
    //     .bypass(disSCR),
    //     .hold(~wren),
    //     .din(dataFrame),
    //     .dout(scrData)
    // );

    reg rden;
    wire [39:0] QA; //read port of SRAM  
    wire [FIFODEPTH-1:0] wrAddr;
    wire [FIFODEPTH-1:0] rdAddr;
    reg [FIFODEPTH-1:0] wrAddrReg;
    reg [39:0] scrDataReg;
    always @(negedge clk)
    begin
        wrAddrReg <= wrAddr;
        wren <= almostFull ? 1'b0: (almostEmpty ? 1'b1 : ~isAFiller); 
        scrDataReg <= rt_dataFrame;       
    end

    streambuf_mem_rtl_top dataBuffer
    (
            .QA(QA),
            .E1A(),   
            .CLKA(~clk),
            .CENA(~rden),  //negtive
            .AA(rdAddr),
            .CLKB(clk),
            .CENB(~wren),
            .AB(wrAddrReg),
            .DB(scrDataReg), 
            .EMAA(3'b010),       //not used
            .EMAB(3'b010),       //not used
            .RET1N(1'b1),      //useful
            .COLLDISN(1'b1)   //not used
    );
    // sram_rf_model #(.wordwidth(40),.addrwidth(FIFODEPTH)) dataBuffer (
    //         .QA(QA),
    //         .E1A(),   //Output for test?
    //         .E2A(),   //Output for test? 
    //         .CLKA(rdClk),
    //         .CENA(~rden),  //negtive
    //         .AA(rdAddr),
    //         .CLKB(clk),
    //         .CENB(~wren),
    //         .AB(wrAddrReg),
    //         .DB(scrData), //hit input
    //         .EMAA(3'b0),       //not used
    //         .EMAB(3'b0),       //not used
    //         .RET1N(1'b1),      //useful
    //         .COLLDISN(1'b0)   //not used
    // );


    // from 0 to 4. the rdState repeat for every 5 clock periods.
    //the output data width can be 8 bits,16 bits or 32 bits.
    //reg [2:0] rdState; 
    reg [127:0] rdBuffer; //read buffer
    reg start;
    reg [31:0] outData;
    //wire [2:0] rdStateNext = rdState + 1;
    //wire [2:0] rdStateNextVoted = rdStateNext;
    wire almostEmptyVoted = almostEmpty;
    wire startVoted = start;
    wire [6:0] serializerBits = (rate == 2'b00) ? 7'd8 : (rate == 2'b01 ? 7'd16 : 7'd32);
    wire [6:0] readOutSize = serializerBits - {2'H0,triggerDataSize};
    //reg [6:0] dataCount;        //how many bits in rdBuffer, from 0 to 127, actual not more than 70.
    reg [6:0] cb_wrAddr;
    reg [6:0] cb_rdAddr;
    wire [6:0] cb_wordCount = cb_wrAddr - cb_rdAddr;//cb_wrAddr >= cb_rdAddr ? cb_wrAddr - cb_rdAddr : cb_wrAddr + (7'H3F-cb_rdAddr) + 7'H01;
    wire loadData = cb_wordCount < readOutSize*2; 
    wire loadDataVoted = loadData;
    wire [6:0] nextWrAddr = loadData ? cb_wrAddr + 7'd40 : cb_wrAddr;
    wire [6:0] nextWrAddrVoted = nextWrAddr;
    wire [6:0] nextRdAddr = cb_rdAddr + readOutSize; 
    wire [6:0] nextRdAddrVoted = nextRdAddr;

    always @(posedge clk) 
    begin 
        if(!reset)
        begin
            start <= 1'b0;
        end
        else
        begin 
            if (!almostEmptyVoted) //do not start untill the FIFO is not almost empty
            begin
                start <= 1'b1;   
                cb_wrAddr <= 7'd40;     
                cb_rdAddr <= 7'd0;
            end
            if(startVoted == 1'b1)
            begin
                cb_wrAddr <= nextWrAddrVoted;
                cb_rdAddr <= nextRdAddrVoted;
            end
        end
    end

    always @(posedge clk) 
    begin 
        if(~reset)
        begin
            rden <= 1'b0;
        end
        else if(startVoted == 1'b1)
        begin
            if(loadDataVoted == 1'b1)
            begin
                rden    <= 1'b1;       //update QA 
//                rdBuffer[ cb_wrAddr +: 40] <= QA; //append QA
                rdBuffer[cb_wrAddr + 7'd0] <= QA[0];
                rdBuffer[cb_wrAddr + 7'd1] <= QA[1];
                rdBuffer[cb_wrAddr + 7'd2] <= QA[2];
                rdBuffer[cb_wrAddr + 7'd3] <= QA[3];
                rdBuffer[cb_wrAddr + 7'd4] <= QA[4];
                rdBuffer[cb_wrAddr + 7'd5] <= QA[5];
                rdBuffer[cb_wrAddr + 7'd6] <= QA[6];
                rdBuffer[cb_wrAddr + 7'd7] <= QA[7];
                rdBuffer[cb_wrAddr + 7'd8] <= QA[8];
                rdBuffer[cb_wrAddr + 7'd9] <= QA[9];
                rdBuffer[cb_wrAddr + 7'd10] <= QA[10];
                rdBuffer[cb_wrAddr + 7'd11] <= QA[11];
                rdBuffer[cb_wrAddr + 7'd12] <= QA[12];
                rdBuffer[cb_wrAddr + 7'd13] <= QA[13];
                rdBuffer[cb_wrAddr + 7'd14] <= QA[14];
                rdBuffer[cb_wrAddr + 7'd15] <= QA[15];
                rdBuffer[cb_wrAddr + 7'd16] <= QA[16];
                rdBuffer[cb_wrAddr + 7'd17] <= QA[17];
                rdBuffer[cb_wrAddr + 7'd18] <= QA[18];
                rdBuffer[cb_wrAddr + 7'd19] <= QA[19];
                rdBuffer[cb_wrAddr + 7'd20] <= QA[20];
                rdBuffer[cb_wrAddr + 7'd21] <= QA[21];
                rdBuffer[cb_wrAddr + 7'd22] <= QA[22];
                rdBuffer[cb_wrAddr + 7'd23] <= QA[23];
                rdBuffer[cb_wrAddr + 7'd24] <= QA[24];
                rdBuffer[cb_wrAddr + 7'd25] <= QA[25];
                rdBuffer[cb_wrAddr + 7'd26] <= QA[26];
                rdBuffer[cb_wrAddr + 7'd27] <= QA[27];
                rdBuffer[cb_wrAddr + 7'd28] <= QA[28];
                rdBuffer[cb_wrAddr + 7'd29] <= QA[29];
                rdBuffer[cb_wrAddr + 7'd30] <= QA[30];
                rdBuffer[cb_wrAddr + 7'd31] <= QA[31];
                rdBuffer[cb_wrAddr + 7'd32] <= QA[32];
                rdBuffer[cb_wrAddr + 7'd33] <= QA[33];
                rdBuffer[cb_wrAddr + 7'd34] <= QA[34];
                rdBuffer[cb_wrAddr + 7'd35] <= QA[35];
                rdBuffer[cb_wrAddr + 7'd36] <= QA[36];
                rdBuffer[cb_wrAddr + 7'd37] <= QA[37];
                rdBuffer[cb_wrAddr + 7'd38] <= QA[38];
                rdBuffer[cb_wrAddr + 7'd39] <= QA[39];
            end
            else 
            begin
                rden <= 1'b0;
            end
            outData[0] <= rdBuffer[cb_rdAddr];
            outData[1] <= rdBuffer[cb_rdAddr+7'd1];
            outData[2] <= rdBuffer[cb_rdAddr+7'd2];
            outData[3] <= rdBuffer[cb_rdAddr+7'd3];
            outData[4] <= rdBuffer[cb_rdAddr+7'd4];
            outData[5] <= rdBuffer[cb_rdAddr+7'd5];
            outData[6] <= rdBuffer[cb_rdAddr+7'd6];
            outData[7] <= rdBuffer[cb_rdAddr+7'd7];
            outData[8] <= rdBuffer[cb_rdAddr+7'd8];
            outData[9] <= rdBuffer[cb_rdAddr+7'd9];
            outData[10] <= rdBuffer[cb_rdAddr+7'd10];
            outData[11] <= rdBuffer[cb_rdAddr+7'd11];
            outData[12] <= rdBuffer[cb_rdAddr+7'd12];
            outData[13] <= rdBuffer[cb_rdAddr+7'd13];
            outData[14] <= rdBuffer[cb_rdAddr+7'd14];
            outData[15] <= rdBuffer[cb_rdAddr+7'd15];
            outData[16] <= rdBuffer[cb_rdAddr+7'd16];
            outData[17] <= rdBuffer[cb_rdAddr+7'd17];
            outData[18] <= rdBuffer[cb_rdAddr+7'd18];
            outData[19] <= rdBuffer[cb_rdAddr+7'd19];
            outData[20] <= rdBuffer[cb_rdAddr+7'd20];
            outData[21] <= rdBuffer[cb_rdAddr+7'd21];
            outData[22] <= rdBuffer[cb_rdAddr+7'd22];
            outData[23] <= rdBuffer[cb_rdAddr+7'd23];
            outData[24] <= rdBuffer[cb_rdAddr+7'd24];
            outData[25] <= rdBuffer[cb_rdAddr+7'd25];
            outData[26] <= rdBuffer[cb_rdAddr+7'd26];
            outData[27] <= rdBuffer[cb_rdAddr+7'd27];
            outData[28] <= rdBuffer[cb_rdAddr+7'd28];
            outData[29] <= rdBuffer[cb_rdAddr+7'd29];
            outData[30] <= rdBuffer[cb_rdAddr+7'd30];
            outData[31] <= rdBuffer[cb_rdAddr+7'd31];
        end
    end    
    
//    always @(posedge rdClk) 
    always @(negedge clk) 
    begin
        //dout <= outData;
        if(reset)
            begin
            if(rate == 2'b00) //8 bits 
            begin 
                dout[0] <= triggerDataSize > 5'd7 ? triggerData[triggerDataSize-5'd8] : outData[0];
                dout[1] <= triggerDataSize > 5'd6 ? triggerData[triggerDataSize-5'd7] : outData[1];
                dout[2] <= triggerDataSize > 5'd5 ? triggerData[triggerDataSize-5'd6] : outData[2];
                dout[3] <= triggerDataSize > 5'd4 ? triggerData[triggerDataSize-5'd5] : outData[3];
                dout[4] <= triggerDataSize > 5'd3 ? triggerData[triggerDataSize-5'd4] : outData[4];
                dout[5] <= triggerDataSize > 5'd2 ? triggerData[triggerDataSize-5'd3] : outData[5];
                dout[6] <= triggerDataSize > 5'd1 ? triggerData[triggerDataSize-5'd2] : outData[6];
                dout[7] <= triggerDataSize > 5'd0 ? triggerData[triggerDataSize-5'd1] : outData[7];            
            end
            else if(rate == 2'b01) //16 bits
            begin
                dout[0]  <= triggerDataSize > 5'd15 ? triggerData[triggerDataSize-5'd16] : outData[0];
                dout[1]  <= triggerDataSize > 5'd14 ? triggerData[triggerDataSize-5'd15] : outData[1];
                dout[2]  <= triggerDataSize > 5'd13 ? triggerData[triggerDataSize-5'd14] : outData[2];
                dout[3]  <= triggerDataSize > 5'd12 ? triggerData[triggerDataSize-5'd13] : outData[3];
                dout[4]  <= triggerDataSize > 5'd11 ? triggerData[triggerDataSize-5'd12] : outData[4];
                dout[5]  <= triggerDataSize > 5'd10 ? triggerData[triggerDataSize-5'd11] : outData[5];
                dout[6]  <= triggerDataSize > 5'd9  ? triggerData[triggerDataSize-5'd10] : outData[6];
                dout[7]  <= triggerDataSize > 5'd8  ? triggerData[triggerDataSize-5'd9] : outData[7];            
                dout[8]  <= triggerDataSize > 5'd7  ? triggerData[triggerDataSize-5'd8] : outData[8];
                dout[9]  <= triggerDataSize > 5'd6  ? triggerData[triggerDataSize-5'd7] : outData[9];
                dout[10] <= triggerDataSize > 5'd5  ? triggerData[triggerDataSize-5'd6] : outData[10];
                dout[11] <= triggerDataSize > 5'd4  ? triggerData[triggerDataSize-5'd5] : outData[11];
                dout[12] <= triggerDataSize > 5'd3  ? triggerData[triggerDataSize-5'd4] : outData[12];
                dout[13] <= triggerDataSize > 5'd2  ? triggerData[triggerDataSize-5'd3] : outData[13];
                dout[14] <= triggerDataSize > 5'd1  ? triggerData[triggerDataSize-5'd2] : outData[14];
                dout[15] <= triggerDataSize > 5'd0  ? triggerData[triggerDataSize-5'd1] : outData[15];            
            end
            else
            begin //32 bits
                dout[15:0] <= outData[15:0];
                dout[16] <= triggerDataSize > 5'd15 ? triggerData[triggerDataSize-5'd16] : outData[16];
                dout[17] <= triggerDataSize > 5'd14 ? triggerData[triggerDataSize-5'd15] : outData[17];
                dout[18] <= triggerDataSize > 5'd13 ? triggerData[triggerDataSize-5'd14] : outData[18];
                dout[19] <= triggerDataSize > 5'd12 ? triggerData[triggerDataSize-5'd13] : outData[19];
                dout[20] <= triggerDataSize > 5'd11 ? triggerData[triggerDataSize-5'd12] : outData[20];
                dout[21] <= triggerDataSize > 5'd10 ? triggerData[triggerDataSize-5'd11] : outData[21];
                dout[22] <= triggerDataSize > 5'd9  ? triggerData[triggerDataSize-5'd10] : outData[22];
                dout[23] <= triggerDataSize > 5'd8  ? triggerData[triggerDataSize-5'd9]  : outData[23];            
                dout[24] <= triggerDataSize > 5'd7  ? triggerData[triggerDataSize-5'd8]  : outData[24];
                dout[25] <= triggerDataSize > 5'd6  ? triggerData[triggerDataSize-5'd7]  : outData[25];
                dout[26] <= triggerDataSize > 5'd5  ? triggerData[triggerDataSize-5'd6]  : outData[26];
                dout[27] <= triggerDataSize > 5'd4  ? triggerData[triggerDataSize-5'd5]  : outData[27];
                dout[28] <= triggerDataSize > 5'd3  ? triggerData[triggerDataSize-5'd4]  : outData[28];
                dout[29] <= triggerDataSize > 5'd2  ? triggerData[triggerDataSize-5'd3]  : outData[29];
                dout[30] <= triggerDataSize > 5'd1  ? triggerData[triggerDataSize-5'd2]  : outData[30];
                dout[31] <= triggerDataSize > 5'd0  ? triggerData[triggerDataSize-5'd1]  : outData[31];            
            end
        end
    end

    wire [FIFODEPTH-1:0] wordCount;
    wire full;
    wire empty;
    assign almostFull   = wordCount >  highLevel;
    assign almostEmpty  = wordCount <  lowLevel;
    FIFOWRCtrler #(.WIDTH(FIFODEPTH),.clockEdge(1)) dataBufCtrl(
        .clk(clk),
        .reset(reset),
        .wren(wren),
        .rden(rden),
        .enWordCount(1'b1),
        .empty(empty),     //not used
        .full(full),      //not used
        .wrAddr(wrAddr),
        .rdAddr(rdAddr),
        .wordCount(wordCount[FIFODEPTH-1:0])   //not used
    );

endmodule
