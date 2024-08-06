`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 23 12:36:50 CST 2021
// Module Name: dataExtractUnit
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module dataExtractUnit 
(
	input           clk,            //40MHz
    input           reset,
    input  [16:0]   chipId,
    input [39:0]    din,
    input [5:0]     alignAddr,
    output          decided,
    output          aligned,   
	output [39:0]   dout
);

    reg [79:0] dataBuf;
    always @(posedge clk) 
    begin
        dataBuf[79:40]  <=  din;
        dataBuf[39:0] <= dataBuf[79:40];
    end

    generate
        genvar i;
        for (i = 0 ; i < 40; i= i+1 )
        begin
            assign  dout[i] = dataBuf[alignAddr+i];
        end    
    endgenerate

    wire noError;
    dataStreamCheck dataCheck 
    (
        .clk(clk),
        .reset(reset),
        .chipId(chipId),
        .din(dout),
        .noError(noError)
    );

    reg synched;            //synched status or not
    reg decidedReg;  //if it is decided that the current data is 
    reg [8:0] clockCount;
    always @(posedge clk) 
    begin
        if(!reset)
        begin
            synched         <= 1'b0;
            decidedReg      <= 1'b0;  //not decided yet
            clockCount      <= 9'd0;
        end
        else if (~decidedReg)
        begin
            if(~noError)
            begin
                synched         <= 1'b0;
                decidedReg      <= 1'b1;
            end
            else 
            begin
                clockCount <= clockCount + 1;
                if(clockCount >= 9'd300) //no error of 300 clock periods
                begin
                    synched         <= 1'b1;
                    decidedReg      <= 1'b1;                    
                end
            end
        end    
    end
    assign aligned = synched;
    assign decided = decidedReg; 
endmodule
