`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Thu Feb 25 15:08:00 CST 2021
// Module Name: PRBS31
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// polynomial:  
// X^31 + X^28 + 1
// 
//////////////////////////////////////////////////////////////////////////////////

// `ifndef PRBS31
// `define PRBS31
//pure combinational logic
module forwardPRBS31Seed #(
    parameter WORDWIDTH = 15,
    parameter FORWARDSTEPS = 1
)
(
    input [30:0] seedTMR,
    output [30:0] newSeedTMR
);
// tmrg default triplicate

    wire [30:0] c[WORDWIDTH*FORWARDSTEPS:0]; //chain for iteration
    assign c[0] = seedTMR;
    generate
        genvar i;
        for (i = 0 ; i < WORDWIDTH*FORWARDSTEPS; i = i + 1)
        begin : loop_itr
            assign c[i+1] = {c[i][3]^c[i][0],c[i][30:1]}; //LSB out
        end
    endgenerate
    assign newSeedTMR = c[WORDWIDTH*FORWARDSTEPS];
endmodule

module nextPRBS31Word #(
    parameter WORDWIDTH = 15
)
(
    input  [30:0] seedTMR,
    output [30:0] nextWordTMR
);
// tmrg default triplicate

    wire [30:0] c[WORDWIDTH:0]; //chain for iteration
    assign c[0] = seedTMR;
    generate
        genvar i;
        for (i = 0 ; i < WORDWIDTH; i = i + 1)
        begin : loop_itr
 //           assign nextWordTMR[i] = c[i][3]^c[i][0];    
            assign c[i+1] = {c[i][3]^c[i][0],c[i][30:1]}; //LSB out
        end
    endgenerate
    assign nextWordTMR = c[WORDWIDTH];
endmodule


module PRBS31 #(
    parameter WORDWIDTH = 15,   //WORDWIDTH < 31
    parameter FORWARDSTEPS = 1
)
(
	input           clkTMR,            //40MHz
	input           resetTMR,         //
	input           disTMR,          //
    input [30:0]    seedTMR,
	output [WORDWIDTH-1:0]    prbsTMR
);
// tmrg default triplicate

    reg [30:0] rTMR;
    wire [30:0] newSeedTMR;
    forwardPRBS31Seed #(  .WORDWIDTH(WORDWIDTH),
                    .FORWARDSTEPS(FORWARDSTEPS))forwardPRBS31SeedInst
    (
        .seedTMR(seedTMR),
        .newSeedTMR(newSeedTMR)
    );

    wire [30:0] nextWordTMR;
    wire [30:0] nextWordVoted = nextWordTMR;

    always @(posedge clkTMR) 
    begin
        if(!resetTMR)
        begin
            rTMR <= newSeedTMR;
        end
        else if(!disTMR)
        begin
            rTMR <= nextWordVoted;
        end            
    end

    nextPRBS31Word #(.WORDWIDTH(WORDWIDTH)) nextWordInst
    (
        .seedTMR(rTMR),
        .nextWordTMR(nextWordTMR)
    );

    assign prbsTMR = rTMR[WORDWIDTH-1:0];

 endmodule
// `endif