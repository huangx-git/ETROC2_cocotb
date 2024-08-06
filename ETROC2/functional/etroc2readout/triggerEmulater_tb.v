`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Fri Feb 19 00:59:07 CST 2021
// Module Name: TestL1Generator_tb
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////

module TestL1Generator_tb;

	reg clk;
    reg reset;

    wire L1A;

    TestL1Generator TestL1GeneratorInst(
        .clk(clk),
        .reset(reset),
        .dis(1'b0),
        .L1A(L1A)
    );

	wire predictL1A;
	TestL1Generator #(.WORDWIDTH(15),
    .FORWARDSTEPS(9'd501)) predict_trigger
	(
		.clk(clk),
		.reset(reset),
		.dis(1'b0),
		.L1A(predictL1A)
	);

    wire [29:0] TDCData;
    TDCTestPatternGen TDC
    (
        .clk(clk),
        .reset(reset),
        .dis(1'b0),
        .pixelID(8'h05),
        .occupancy(7'h06),
        .dout(TDCData)
    );
    wire hit;
    assign hit = TDCData[0];

    reg [19:0] clkCount;
    reg [19:0] L1ACount;
    reg [19:0] TDCHitCount;
    reg [19:0] L1AHitCount;
    always @(posedge clk) 
    begin
        if(!reset)
        begin
            clkCount <= 20'h00000;
            L1ACount <= 20'h00000;
            TDCHitCount <= 20'h00000;
            L1AHitCount <= 20'h00000;
        end
        else
        begin
            clkCount <= clkCount + 1;
            if(L1A)L1ACount <= L1ACount + 1;
            if(hit)TDCHitCount <= TDCHitCount + 1;
            if(hit&L1A)L1AHitCount <= L1AHitCount + 1;
        end
    end

    initial begin
        clk = 0;
        reset = 0;
    
        #25 reset = 1'b0;
        #50 reset = 1'b1;
 
        #20000000 $stop;
    end
    always 
        #12.5 clk = !clk; //25 ns clock period


endmodule
