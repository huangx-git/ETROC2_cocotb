`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 23 12:36:50 CST 2021
// Module Name: TDCTestPatternGen
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"

module TDCTestPatternGen (
	input  clk,            //40MHz
	input  reset,         //
	input  dis,          //
	input  mode, 		//0 output counter, 1, output random TDC data
    input [7:0] pixelID,   //use it as a seed
	input [8:0] latencyL1A,
	input  [6:0] occupancy,  //from 0 to 100%, step size is 1/128.
	output wire [29:0] dout   //8 bit pixelID, 12 bit counter, 9bit constance, 1 bit hit
);
// tmrg default triplicate
// tmrg do_not_triplicate clk
// tmrg do_not_triplicate reset
// tmrg do_not_triplicate dis
// tmrg do_not_triplicate mode
// tmrg do_not_triplicate pixelID
// tmrg do_not_triplicate latencyL1A
// tmrg do_not_triplicate occupancy
// tmrg do_not_triplicate dout

	wire [14:0] prbs;
	wire [30:0] seed;
	assign seed = {23'h2AAAAA,8'haa^pixelID};	
	PRBS31 #(.WORDWIDTH(15),
    .FORWARDSTEPS(0)) prbs_inst(
		.clkTMR(clk),
		.resetTMR(reset),
		.disTMR(dis),
		.seedTMR(seed),
		.prbsTMR(prbs)
	);

	wire predictL1A;
	TestL1Generator #(.WORDWIDTH(15),
    .FORWARDSTEPS(`DEFAULT_L1A_LATENCY-1)) predict_trigger
	(
		.clkTMR(clk),
		.resetTMR(reset),
		.disTMR(dis),
		.modeTMR(mode),
		.L1ATMR(predictL1A)
	);

	wire hit;
	wire [15:0] threshold;
	assign threshold = ({9'd0, occupancy} << 8);
	assign hit = ({1'b0,prbs} < threshold);

	reg [8:0] counterL1ATMR;
	wire [8:0] nextCounterL1A = counterL1ATMR + 9'd1;
	wire [8:0] nextCounterL1AVoted = nextCounterL1A;
//	assign nextCounterL1A = counterL1ATMR + 1;
//	assign nextCounterL1AVoted = nextCounterL1A;
    always @(posedge clk) 
    begin
		if(!reset)
		begin
			counterL1ATMR <= 9'h000;
		end
		else if(!dis)
		begin
			if(predictL1A == 1'b1 && hit == 1'b1)
			begin
				counterL1ATMR <= nextCounterL1AVoted;
			end
		end            
    end	

    wire [11:0] genBCID;
   	wire [11:0] offset = latencyL1A+2;
   	BCIDCounter BC(
	    .clkTMR(clk),                  //40MHz
		.resetTMR(reset),
		.disTMR(dis),
        .rstBCIDTMR(1'b1),    			//BCID reset signal 
        .offsetTMR(offset),        //value when it is reset
		//.offset(12'H000),
        .BCIDTMR(genBCID)
    );
	wire [8:0] usedCounter;
	assign usedCounter = (mode == 1'b1)&&(predictL1A == 1'b1 && hit == 1'b1) ? counterL1ATMR : 9'h1aa;
	assign dout = dis ? {30{1'b0}} : {pixelID,genBCID,usedCounter,hit};


endmodule
