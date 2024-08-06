//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Quan Sun
// 
// Create Date:    Mon Sep 27th 2021
// Design Name:    fast command decoder 
// Module Name:    manualAlignTop
// Project Name:   ETROC2
// Description: the top module of the manual alignment
//
// Dependencies: 
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////

module manualAlignTop(
	input clk320,		//320 MHz clock
	input clkDelayEn,	// enable signal of the clock delay
	input fcDelayEn,	// enable signal of the command delay
	input rstn,		// reset, active low	
	input fc,		// fast command input	
	output [9:0] fcd 
);
  // tmrg default triplicate

wire clk320_adj;
wire fc_adj;

phaseAdjuster phaseAdjuster_inst(
	.fc(fc), 
	.clk320(clk320), 
	.fcOut(fc_adj), 
	.clk320Out(clk320_adj), 
	.clkDelayEn(clkDelayEn), 
	.fcDelayEn(fcDelayEn)
	);

WADecoder WADecoder_inst(
	.rstn(rstn),
	.clk320_aligned(clk320_adj),		
	.fc(fc_adj),		
	.fcd(fcd));

endmodule
