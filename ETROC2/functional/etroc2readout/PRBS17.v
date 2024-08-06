`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Wed Oct 20 21:05:17 CDT 2021
// Module Name: PRBS17
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module PRBS17
(
	input           clk,            //40MHz
	input           reset,         //
	input           dis,          //
    input           enableBCID,   //enable explicit BCID counter
    output [11:0]    BCID,         //output BCID counter
	output [15:0]    prbs
); //PRBS period is 3564

    wire [16:0] c [16:0]; //chain for iteration
    reg [16:0] r;
    reg [11:0] counter;
    always @(posedge clk) 
    begin
        if(!dis)
        begin
            if(!reset || r == 17'H0A96E)
            begin
                r <= 17'H0AAAA; //fixed seed
                if(enableBCID)counter <= 12'd0;
            end
            else 
            begin
                r <= c[16];
                if(enableBCID)counter <= counter + 1;
            end            
        end
    end
    assign BCID = counter;

    assign c[0] = r;
    generate
        genvar i;
        for (i = 0 ; i < 16; i = i + 1)
        begin : loop_itr
            assign prbs[i] = c[i][3]^c[i][0];
            assign c[i+1] = {prbs[i],c[i][16:1]}; //LSB out, same as serializer
        end
    endgenerate

endmodule
