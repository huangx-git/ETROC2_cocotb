`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Tue Feb  9 14:13:14 CST 2021
// Module Name: Scrambler_tb
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// The scrambling polynomial : x^58 + x^39 + 1
// LSB firs scrambling

//////////////////////////////////////////////////////////////////////////////////
//`define TEST8BITS
//`define TEST16BITS
`define TEST32BITS

module Scrambler_tb;
`ifdef TEST8BITS
    parameter WORDWIDTH = 8;
`elsif TEST16BITS
    parameter WORDWIDTH = 16;
`elsif TEST32BITS 
    parameter WORDWIDTH = 32;
`endif
	reg clk;
    reg reset;
    reg syn_reset;
    reg [31:0] counter;

    always @(posedge clk) 
    begin
        if(~syn_reset)
        begin
                counter <= {32{1'b0}}; //initial     
        end
        else 
        begin
                counter <= counter + 1;
        end
    end
    always @(posedge clk) 
    begin
        begin
                syn_reset <= reset;      
        end
    end

    reg bypass;
    wire [31:0] scr;
    Scrambler scrInst(
        .clk(clk),
        .reset(syn_reset),
`ifdef TEST8BITS
        .dataWidth(2'b00),
`elsif TEST16BITS
        .dataWidth(2'b01),
`elsif TEST32BITS
        .dataWidth(2'b10),
`endif
        .din(counter),
        .bypass(bypass),
        .dout(scr)
    );

    wire [31:0] dscr;
    Descrambler #(.WORDWIDTH(WORDWIDTH)) dscrInst(
        .clk(clk),
        .reset(syn_reset),
        .din(scr[WORDWIDTH-1:0]),
        .bypass(bypass),
        .dout(dscr[WORDWIDTH-1:0])
    );

    wire [7:0] dscr8;
    wire [15:0] dscr16;
    assign dscr8 = dscr[7:0];
    assign dscr16 = dscr[15:0];
    initial begin
        clk = 0;
        reset = 1;
        bypass = 0;

        #25 reset = 1'b0;
        #50 reset = 1'b1;


        #50000 bypass = 1'b1;
        #100000 $stop;
    end
    always 
        #12.5 clk = !clk; //25 ns clock period

endmodule