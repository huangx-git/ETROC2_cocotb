`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 23 12:36:50 CST 2021
// Module Name: PRBS15
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// polynomial:  n 
// x^15 + x^14 + 1
// 
//////////////////////////////////////////////////////////////////////////////////

//pure combinational logic
module forwardSeed #(
    parameter WORDWIDTH = 15,
    parameter FORWARDSTEPS = 1
)
(
    input [14:0] seed,
    output [14:0] newSeed
);

    wire [14:0] c[WORDWIDTH*FORWARDSTEPS:0]; //chain for iteration
    assign c[0] = seed;
    generate
        genvar i;
        for (i = 0 ; i < WORDWIDTH*FORWARDSTEPS; i = i + 1)
        begin : loop_itr
            assign c[i+1] = {c[i][1]^c[i][0],c[i][14:1]}; //LSB out
        end
    endgenerate
    assign newSeed = c[WORDWIDTH*FORWARDSTEPS];
endmodule

module nextPRBSWord #(
    parameter WORDWIDTH = 15
)
(
    input  [14:0] seed,
    output [14:0] nextWord
);
    wire [14:0] c[WORDWIDTH:0]; //chain for iteration
    assign c[0] = seed;
    generate
        genvar i;
        for (i = 0 ; i < WORDWIDTH; i = i + 1)
        begin : loop_itr
//            assign nextWord[i] = c[i][1]^c[i][0];    
            assign c[i+1] = {c[i][1]^c[i][0],c[i][14:1]}; //LSB out
        end
    endgenerate
    assign nextWord = c[WORDWIDTH];
endmodule


module PRBS15 #(
    parameter WORDWIDTH = 15,
    parameter FORWARDSTEPS = 1
)
(
	input           clk,            //40MHz
	input           reset,         //
	input           dis,          //
    input [14:0]    seed,
	output [WORDWIDTH-1:0]    prbs
);

    reg [14:0] r;
    wire [14:0] newSeed;
    forwardSeed #(  .WORDWIDTH(WORDWIDTH),
                    .FORWARDSTEPS(FORWARDSTEPS))forwardSeedInst
    (
        .seed(seed),
        .newSeed(newSeed)
    );

    wire [14:0] nextWord;
    always @(posedge clk) 
    begin
        if(!dis)
        begin
            if(!reset)
            begin
                r <= newSeed;
            end
            else 
            begin
                r <= nextWord;
            end            
        end
    end

    nextPRBSWord #(.WORDWIDTH(WORDWIDTH)) nextWordInst
    (
        .seed(r),
        .nextWord(nextWord)
    );

    assign prbs = r;
/*   always @(posedge clk) 
    begin
        if(!dis)
        begin
            if(!reset)
            begin
                nextWord <= seed;
            end
            else 
            begin
                nextWord <= {nextWord[12]^nextWord[13],
                         nextWord[11]^nextWord[12],
                         nextWord[10]^nextWord[11],
                         nextWord[9]^nextWord[10],
                         nextWord[8]^nextWord[9],
                         nextWord[7]^nextWord[8],
                         nextWord[6]^nextWord[7],
                         nextWord[5]^nextWord[6],
                         nextWord[4]^nextWord[5],
                         nextWord[3]^nextWord[4],
                         nextWord[2]^nextWord[3],
                         nextWord[1]^nextWord[2],
                         nextWord[0]^nextWord[1],
                         nextWord[0]^nextWord[13]^nextWord[14],
                         nextWord[12]^nextWord[14]};
            end            
        end
    end
 
 */ 
 endmodule
