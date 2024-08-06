`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 23 12:36:50 CST 2021
// Module Name: dataStreamCheck
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module dataStreamCheck  //check frame identifier only, do not touch the data
(
	input           clk,            //40MHz
    input           reset,
    input  [16:0]   chipId,
    input [39:0]    din,
	output          noError         //
);
    localparam filler = {16'h3C5C,2'b10}; //filler
    localparam header = {16'h3C5C,2'b00}; //header
//  previous data status
    localparam unknownPrev = 3'd0;
    localparam fillerPrev = 3'd1;
    localparam headerPrev = 3'd2;
    localparam dataPrev = 3'd3;
    localparam trailerPrev = 3'd4;

    reg noErrorReg;
    wire [39:0] dataFrame = din;
    reg [8:0] dataCount;
    wire [17:0] checkField = dataFrame[39:22];
    wire isData     = (dataFrame[39]     == 1'b1);
    wire isFiller   = (checkField   == filler);
    wire isTrailer  = (checkField   == {1'b0,chipId});
    wire isHeader   = (checkField   == header);
    reg [2:0] preData;
    always @(posedge clk) 
    begin
        if(!reset | noErrorReg == 1'b0) 
        begin
            preData             <= unknownPrev;
            dataCount           <= 9'd0;
            noErrorReg          <= 1'b1;
        end
        else if(dataCount > 9'd256)  //more than 256 hits is impossible
        begin
            noErrorReg          <= 1'b0;
        end
        else if(preData == unknownPrev) //first one, no previous record
        begin
            if(isData)
            begin
                preData     <= dataPrev;
                dataCount   <= dataCount + 1;
            end
            else if(isFiller)
            begin
                preData <= fillerPrev;
            end  
            else if(isHeader)
            begin
                preData <= headerPrev;
                dataCount <= 9'd0;
            end
            else if(isTrailer)
            begin
                preData <= trailerPrev;
            end
            else //if not any of above, it not right syncAddr
            begin
                noErrorReg <= 1'b0;
            end
        end
        else if(preData == dataPrev)
        begin
            if(isData)
            begin
                dataCount <= dataCount + 1;
            end
            else if (isTrailer)
            begin
                preData         <= trailerPrev;
            end
            else  //data must followed by data or trailer
            begin
                noErrorReg <= 1'b0;
            end
        end
        else if(preData == headerPrev)
        begin
            if(isData)
            begin
                dataCount <= dataCount + 1;
            end
            else if (isTrailer)
            begin
                preData <= trailerPrev;
            end
            else    //header must followed by data or a trailer
            begin 
                noErrorReg <= 1'b0;
            end
        end
        else if (preData == trailerPrev || preData == fillerPrev)
        begin
            if(isHeader)
            begin
                preData <= headerPrev;
                dataCount <= 9'd0;
            end
            else if(isFiller)
            begin
                preData <= fillerPrev;
            end  
            else  //trailer/filler must be followed by a header or a filler
            begin
                noErrorReg <= 1'b0;
            end
        end
        else //previous data must be above
        begin
            noErrorReg <= 1'b0;
        end
    end
    assign noError      = noErrorReg;
endmodule
