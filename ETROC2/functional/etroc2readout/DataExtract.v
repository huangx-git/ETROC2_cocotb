`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 23 12:36:50 CST 2021
// Module Name: dataExtract
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module dataExtract 
(
	input           clk,            //40MHz
    input           reset,
    input [16:0]    chipId,
    input [9:0]     goodEventRate,
    input [39:0]    din,
    output          aligned,   
    output [4:0]    wordAddr,
	output [39:0]   dout
);

    wire [39:0] alignedData [39:0];
    wire [39:0] maskedData [39:0];
    wire [39:0] alignedArray;
    wire [39:0] alignedMask [39:0];
    wire [39:0] decidedArray;
    wire resyncUnit;
    reg resync;
    assign resyncUnit = reset &~ resync;
    generate
        genvar i;
        for (i = 0 ; i < 40; i= i+1 )
        begin : alignAddrLoop
            wire [5:0] alignAddr = i;
            dataExtractUnit dataExtractUnitInst
            (
                .clk(clk),
                .reset(resyncUnit),
                .chipId(chipId),
                .din(din),
                .alignAddr(alignAddr),
                .decided(decidedArray[i]),
                .aligned(alignedArray[i]),
                .dout(alignedData[i])
            );
            assign alignedMask[i] = (40'd1<<(i+1))-40'd1;
            assign maskedData[i] =  ((alignedMask[i]&alignedArray) == (40'd1<<i)) ? alignedData[i] : 40'd0; 
        end    
    endgenerate

    wire [5:0] alignCount;
    assign alignCount = {4'd0,alignedArray[0]} + 
                        {4'd0,alignedArray[1]} +    
                        {4'd0,alignedArray[2]} +    
                        {4'd0,alignedArray[3]} +    
                        {4'd0,alignedArray[4]} +    
                        {4'd0,alignedArray[5]} +    
                        {4'd0,alignedArray[6]} +    
                        {4'd0,alignedArray[7]} +    
                        {4'd0,alignedArray[8]} +    
                        {4'd0,alignedArray[9]} +    
                        {4'd0,alignedArray[10]} +    
                        {4'd0,alignedArray[11]} +    
                        {4'd0,alignedArray[12]} +    
                        {4'd0,alignedArray[13]} +    
                        {4'd0,alignedArray[14]} +    
                        {4'd0,alignedArray[15]} +    
                        {4'd0,alignedArray[16]} +    
                        {4'd0,alignedArray[17]} +    
                        {4'd0,alignedArray[18]} +    
                        {4'd0,alignedArray[19]} +    
                        {4'd0,alignedArray[20]} +    
                        {4'd0,alignedArray[21]} +    
                        {4'd0,alignedArray[22]} +    
                        {4'd0,alignedArray[23]} +    
                        {4'd0,alignedArray[24]} +    
                        {4'd0,alignedArray[25]} +    
                        {4'd0,alignedArray[26]} +    
                        {4'd0,alignedArray[27]} +    
                        {4'd0,alignedArray[28]} +    
                        {4'd0,alignedArray[29]} +    
                        {4'd0,alignedArray[30]} +    
                        {4'd0,alignedArray[31]} +    
                        {4'd0,alignedArray[32]} +    
                        {4'd0,alignedArray[33]} +    
                        {4'd0,alignedArray[34]} +    
                        {4'd0,alignedArray[35]} +    
                        {4'd0,alignedArray[36]} +    
                        {4'd0,alignedArray[37]} +    
                        {4'd0,alignedArray[38]} +    
                        {4'd0,alignedArray[39]};

    //assign wordAddr = 5'd0;
    assign aligned = | alignedArray[39:0];
    assign dout = maskedData[0]|
                  maskedData[1]|  
                  maskedData[2]|  
                  maskedData[3]|  
                  maskedData[4]|  
                  maskedData[5]|  
                  maskedData[6]|  
                  maskedData[7]|  
                  maskedData[8]|  
                  maskedData[9]|  
                  maskedData[10]|
                  maskedData[11]|  
                  maskedData[12]|  
                  maskedData[13]|  
                  maskedData[14]|  
                  maskedData[15]|  
                  maskedData[16]|  
                  maskedData[17]|  
                  maskedData[18]|  
                  maskedData[19]|  
                  maskedData[20]|
                  maskedData[21]|  
                  maskedData[22]|  
                  maskedData[23]|  
                  maskedData[24]|  
                  maskedData[25]|  
                  maskedData[26]|  
                  maskedData[27]|  
                  maskedData[28]|  
                  maskedData[29]|  
                  maskedData[30]|
                  maskedData[31]|  
                  maskedData[32]|  
                  maskedData[33]|  
                  maskedData[34]|  
                  maskedData[35]|  
                  maskedData[36]|  
                  maskedData[37]|  
                  maskedData[38]|  
                  maskedData[39];

    wire decided = &decidedArray[39:0];
    // reg [9:0] counter;
    // reg [9:0] lowGoodEvtRateTimer;
    reg [4:0] wordAddrReg;
    reg [5:0] resyncCount; //reset signal last 32 clock periods
    always @(posedge clk) 
    begin
        if(!reset)
        begin
        //    counter <= 10'h00; 
        //    lowGoodEvtRateTimer <= 10'h00;
           wordAddrReg <= 5'd0;
           resync <= 1'b0;
           resyncCount <= 6'd0;
        end
        if(resync == 1'b1)
        begin
            if(resyncCount >= 6'd32) //
            begin
                resync <= 1'b0;
            end
            else
            begin
                resyncCount <= resyncCount + 1;
            end
        end
        else if(decided == 1'b1)
        begin
            if(aligned == 1'b0)
            begin
                wordAddrReg <= wordAddrReg + 5'd1;  
                resync <= 1'b1;                      //resync
                resyncCount <= 6'd0; 
            end
        end
        // else
        // begin   //aligned
        //     if(goodEventRate < 10'd50)
        //     begin
        //         lowGoodEvtRateTimer <= lowGoodEvtRateTimer + 10'd1;                                   
        //     end
        //     if(lowGoodEvtRateTimer > 10'd128) 
        //     begin
        //         wordAddrReg <= wordAddrReg + 5'd1;   
        //         lowGoodEvtRateTimer <= 10'd0;       
        //         if(resync == 1'b0)resync <= 1'b1;                                    
        //     end
        //     counter <= 10'h000;             
        // end
    end
    assign wordAddr = wordAddrReg;
endmodule
