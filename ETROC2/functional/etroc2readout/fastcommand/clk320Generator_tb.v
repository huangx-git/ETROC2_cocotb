`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Tue Nov 16 15:49:54 CST 2021
// Module Name: clk320Generator_tb
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module clk320Generator_tb;

    reg enable;
    // reg [1:0] jitterLevel;
    reg reset;
	reg clk40;
    reg clk1280;
    wire clk40out;
    wire clk320out;
    clk320Generator dg
    (
        .clk40(clk40),
        .clk1280(clk1280),
        .reset(reset),
        .enable(enable),
        .high(200),
        .low(-200),
        // .jitterLevel(jitterLevel),
        .clk320out(clk320out)
    );
    reg [2:0] testCount, testCount_ideal;
    reg started;


	reg clk320q = 0;
	always #1560 clk320q = ~clk320q;

	integer del;
	integer seed = 11101;
	integer lower = -100;
	integer higher = 100;
	always@(posedge clk320q) begin
		del = 600+ $dist_uniform (seed, lower, higher);
	end
	//

    wire ck1;
    wire ck2;
    wire ck3;
    wire ck4;

    assign #600 ck1 = clk320q;
    assign #600 ck2 = ck1;
    assign #600 ck3 = ck2;
    assign #720 ck4 = ck3;

    // assign #600 ck1 = clk320q;


	wire clk320q_jitter;
	assign #(del) clk320q_jitter = clk320out;
	


    always@(negedge clk320q_jitter) begin
        if(~reset)
        begin
            testCount  <= 3'd0;
        end
        else if (started)
        begin
            testCount <= testCount + 1;
        end
    end

    always@(negedge clk320q) begin
        if(~reset)
        begin
            testCount_ideal  <= 3'd0;
        end
        else if (started)
        begin
            testCount_ideal <= testCount_ideal + 1;
        end
    end
	wire [2:0] delta = testCount_ideal - testCount;
    initial begin
        enable = 1;
        // jitterLevel = 2'b00;
        clk40 = 0;
        clk1280 = 1;
        reset = 0;
        started = 0;
        #200000  reset = 1;
        started = 1;
        #80000000
        // #20000000   jitterLevel = 2'b00;
        // #20000000   jitterLevel = 2'b01;
        // #20000000   jitterLevel = 2'b10;
        // #20000000   jitterLevel = 2'b11;

        #20000000 $stop;
    end

    always 
        #12480 clk40 = ~clk40; //25 ns clock period
    
    always
        #390 clk1280 = ~clk1280;


endmodule
