`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sun Jan  9 14:25:57 CST 2022
// Module Name: clk320Generator
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module phaseCounter1
(
	input               clk40,            //40MHz
    input               clk1280,
    input               enable,
    output reg [4:0]    phaseCount      //
);
    reg clk40D1;                     //delay clk40
    reg clk40D2;                     //delay clk40
    wire risingClk40;
    assign risingClk40 = ~clk40D2 & clk40D1;
    wire [4:0] nextCount = phaseCount + 1;
    wire [4:0] nextCountVoted = nextCount;
    reg syncClk40;
    always @(negedge clk1280) 
    begin
        if(enable)
            syncClk40 <= clk40;
    end

    always @(posedge clk1280) 
    begin
        if(enable)
        begin
            clk40D1 <= syncClk40;
            clk40D2 <= clk40D1;
            if(risingClk40)
            begin
                phaseCount <= 5'd3;   //align phasECounter == 0 to rising edge of clk40
            end
            else 
            begin
                phaseCount <= nextCountVoted;           
            end
        end
    end
endmodule


module pulseGeneratorClk320
(
    input           clk1280,
    input           enable,
    // input [1:0]     jitterLevel,
    input [4:0]     phaseCount,
    // input [63:0]    prbs,
    // input [7:0]     jitter1,
    // input [7:0]     jitter2,
    output          clkout          //output clock
);
    reg clkoutReg;
    wire [4:0] risingAt [7:0];
    wire [4:0] fallingAt [7:0];

    generate
        genvar i;
        for(i = 0; i < 8; i = i + 1)
        begin : loop_clock_index
            assign risingAt[i]  = ({{3{1'b0}},2'd0}+i*4)%32;
            assign fallingAt[i] = ({{3{1'b0}},2'd0}+i*4+2)%32;
        end
    endgenerate

    always @(posedge clk1280) 
    begin
        if(enable)
        begin
            if( (phaseCount == risingAt[0]) ||
                (phaseCount == risingAt[1]) ||
                (phaseCount == risingAt[2]) ||
                (phaseCount == risingAt[3]) ||
                (phaseCount == risingAt[4]) ||
                (phaseCount == risingAt[5]) ||
                (phaseCount == risingAt[6]) ||
                (phaseCount == risingAt[7])
                )
            begin
                clkoutReg <= 1'b1;
            end
            else if (   (phaseCount == fallingAt[0]) ||
                        (phaseCount == fallingAt[1]) ||
                        (phaseCount == fallingAt[2]) ||
                        (phaseCount == fallingAt[3]) ||
                        (phaseCount == fallingAt[4]) ||
                        (phaseCount == fallingAt[5]) ||
                        (phaseCount == fallingAt[6]) ||
                        (phaseCount == fallingAt[7])
                        )
            begin
                clkoutReg <= 1'b0;                
            end
        end
    end

    // reg clk320d2;
    // always @(posedge clk1280)
    // begin
    //     clk320d2 <= clkoutReg;
    // end

    // reg clk320d1;
    // reg clk320d3;
    // always @(negedge clk1280)
    // begin
    //     clk320d1 <= clkoutReg;
    //     clk320d3 <= clk320d2;
    // end
    // wire clk320d0 = clkoutReg;

    // wire [5:0] index0 = {phaseCount,1'b0};
    // wire [5:0] index1 = {phaseCount,1'b1};
    // wire [1:0] jitterIndex = {prbs[index1],prbs[index0]};
    // wire [1:0] jitter;
    // assign jitter =  jitterLevel == 2'b00 ? 2'b00 : 
    //                 (jitterLevel == 2'b01 ? {1'b0, jitterIndex[0]} :  
    //                 (jitterLevel == 2'b10 ? {jitterIndex[1]&(~jitterIndex[0]), jitterIndex[0]} : jitterIndex)); 

    // assign clkout =  jitter == 2'b00 ? clk320d0 : 
    //                 (jitter == 2'b01 ? clk320d1 : 
    //                 (jitter == 2'b10 ? clk320d2 : clk320d3));
    assign clkout = clkoutReg;
endmodule


module clk320Generator 
(
	input           clk40,            //40MHz
    input           clk1280,
    input           reset,
    input           enable,
    input signed [31:0] high,
    input signed [31:0] low,
    // input [1:0]     jitterLevel,
	output          clk320out           // 320 MHz clock strobes for TDC
);
// tmrg default triplicate

    wire [4:0] phaseCount;
    phaseCounter1 phaseCounterInst
    (
        .clk40(clk40),
        .clk1280(clk1280),
        .enable(enable),
        .phaseCount(phaseCount)
    );

	// wire [15:0] prbs0;
	// wire [15:0] prbs1;
	// wire [15:0] prbs2;
	// wire [15:0] prbs3;

	// wire [30:0] seed0;
	// wire [30:0] seed1;
	// wire [30:0] seed2;
	// wire [30:0] seed3;

	// assign seed0 = {31'h1BCD1234};	
	// assign seed1 = {31'h1BCD1324};	
	// assign seed2 = {31'h1BCD4231};	
	// assign seed3 = {31'h1BCD4321};	

	// PRBS31 #(.WORDWIDTH(16),
    // .FORWARDSTEPS(0)) prbs_inst0(
	// 	.clk(clk40),
	// 	.reset(reset),
	// 	.dis(1'b0),
	// 	.seed(seed0),
	// 	.prbs(prbs0)
	// );

	// PRBS31 #(.WORDWIDTH(16),
    // .FORWARDSTEPS(0)) prbs_inst1(
	// 	.clk(clk40),
	// 	.reset(reset),
	// 	.dis(1'b0),
	// 	.seed(seed1),
	// 	.prbs(prbs1)
	// );

	// PRBS31 #(.WORDWIDTH(16),
    // .FORWARDSTEPS(0)) prbs_inst2(
	// 	.clk(clk40),
	// 	.reset(reset),
	// 	.dis(1'b0),
	// 	.seed(seed2),
	// 	.prbs(prbs2)
	// );
	// PRBS31 #(.WORDWIDTH(16),
    // .FORWARDSTEPS(0)) prbs_inst3(
	// 	.clk(clk40),
	// 	.reset(reset),
	// 	.dis(1'b0),
	// 	.seed(seed3),
	// 	.prbs(prbs3)
	// );

    // wire [63:0] prbs64 = {prbs3,prbs2,prbs1,prbs0};
    wire clk320;
    pulseGeneratorClk320 pulseGeneratorClk320Inst
    (
        .clk1280(clk1280),
        .enable(enable),
        // .jitterLevel(jitterLevel),
        .phaseCount(phaseCount),
        // .prbs(prbs64),
        .clkout(clk320)
    );
    wire ck1;
    wire ck2;
    wire ck3;
    wire ck4;

    assign #600 ck1 = clk320;
    assign #600 ck2 = ck1;
    assign #600 ck3 = ck2;
    assign #720 ck4 = ck3;

	integer seed = 11101;
	integer del;
	always@(posedge clk320) begin
//assume clk period 3120 ps
		del = 600+ $dist_uniform (seed, low, high);
	end

	assign #(del) clk320out = ck4;

endmodule
