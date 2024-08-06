`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Tue Feb  9 14:13:14 CST 2021
// Module Name: PRBS15_tb
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// LSB firs scrambling

//////////////////////////////////////////////////////////////////////////////////


module PRBS15_tb;
    parameter WORDWIDTH = 15;
	reg clk;
    reg reset;

wire [WORDWIDTH-1:0] prbs1;
PRBS15 #(.WORDWIDTH(WORDWIDTH),
        .FORWARDSTEPS(0)) prbs1Inst
    (
        .clk(clk),
        .reset(reset),
        .dis(1'b0),
        .seed(15'h1E4C),
        .prbs(prbs1)
    ); 

wire [WORDWIDTH-1:0] prbs2;
PRBS15 #(.WORDWIDTH(WORDWIDTH),
        .FORWARDSTEPS(501)) prbs2Inst
    (
        .clk(clk),
        .reset(reset),
        .dis(1'b0),
        .seed(15'h1E4C),
        .prbs(prbs2)
    ); 
    
    reg [14:0] c [501:0];
    wire [14:0] delayPRBS1;
    assign delayPRBS1 = c[500];
    wire matched;
    assign matched = (delayPRBS1 == prbs1); 
    genvar i;
    generate
    for(i = 0; i < 501; i = i+1)
    begin
        always @(posedge clk) 
        begin
        c[i+1] <= c[i];
        end        
    end
    endgenerate

    always @(posedge clk) 
    begin
        c[0] <= prbs2;
    end        

    initial begin
        clk = 0;
        reset = 1;

        #25 reset = 1'b0;
        #50 reset = 1'b1;


        #50000 $stop;
    end
    always 
        #12.5 clk = !clk; //25 ns clock period

endmodule