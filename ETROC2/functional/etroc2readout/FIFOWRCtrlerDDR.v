`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 23 15:28:14 CST 2021
// Module Name: FIFOWRCtrler
// Project Name: ETROC2 readout
// Description: 
// Dependencies: no
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module FIFOWRCtrlerDDR#(
    parameter WIDTH = 7
)
(
	input clk,            //40MHz
    input reset,          //reset signal 
    input wren,            
    input rden,
    input enWordCount,      
    output empty,
    output full,
    output reg [WIDTH-1:0] wrAddr,
    output reg [WIDTH-1:0] rdAddr,    
    output [WIDTH-1:0] wordCount      //output word count   
);
// tmrg default triplicate

    // wire resetP;
    // reg resetN;
    // always @(negedge clk)
    // begin
    //     resetN <= reset;
    // end
    wire [WIDTH-1:0] wrAddrNext;
    wire [WIDTH-1:0] rdAddrNext;
    assign rdAddrNext = !empty ? (rdAddr + 1) : rdAddr;
    assign wrAddrNext = !full ? (wrAddr + 1) : wrAddr;
    wire [WIDTH-1:0] rdAddrNextVoted = rdAddrNext;
    wire [WIDTH-1:0] wrAddrNextVoted = wrAddrNext;

    reg rdEmpty;
    reg rdFull;
    reg wrEmpty;
    reg wrFull;

    wire rdEmptyNext        = (rdAddrNext == wrAddr) ? ~wrEmpty : wrEmpty;
    wire rdEmptyNextVoted   = rdEmptyNext;
    wire wrFullNext         = (wrAddrNext == rdAddr) ? ~rdFull : rdFull;
    wire wrFullNextVoted    = wrFullNext;

    wire wrFullVoted        = wrFull;
    wire rdEmptyVoted       = rdEmpty;
    assign empty    = wrEmpty ^ rdEmpty;
    assign full     = wrFull ^ rdFull;
    wire rdenVoted = rden;
    wire wrenVoted = wren;
    //read operation
    always @(posedge clk) 
    begin
        if(!reset) 
        begin
            rdAddr <= {WIDTH{1'b0}};
            rdEmpty <= 1'b1;
            rdFull <= 1'b0;
        end
        else 
        begin
            if (rdenVoted == 1'b1) 
            begin
                rdFull  <= wrFullVoted; //set full to be zero
                rdAddr  <= rdAddrNextVoted;
                rdEmpty <= rdEmptyNextVoted;
            end
        end
    end        

    //write operation
    always @(negedge clk) 
    begin
        if(!reset) 
        begin
            wrAddr <= {WIDTH{1'b0}};
            wrEmpty <= 1'b0;   //empty true
            wrFull <= 1'b0;    //full is false
        end
        else 
        begin
            if (wrenVoted == 1'b1) 
            begin
                wrAddr  <= wrAddrNextVoted;
                wrEmpty <= rdEmptyVoted; //set empty to be false
                wrFull  <= wrFullNextVoted;
            end    
        end
    end        

    assign wordCount = ~enWordCount ? {WIDTH{1'b0}} : 
                             ((wrAddr >= rdAddr) ? (wrAddr - rdAddr) : ({1'b1,wrAddr} - {1'b0,rdAddr}));
  
endmodule

