//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Quan Sun
// 
// Create Date:    Mon Sep 17th 2021
// Design Name:    fast command decoder 
// Module Name:    selfAlignTop
// Project Name:   ETROC2
// Description: the top module of the self alignment
//
// Dependencies: 
//
// Revision:  Xing Huang, Nov. 2nd, TMR protection
//
//
//////////////////////////////////////////////////////////////////////////////////

module selfAlignTop(
	input fccAlign,		// fast command clock align command. initialize the clock phase alignment process at its rising edge
	input clk1280,		// 1.28 GHz clock
	input clk40,		// 40 MHz clock, RO clock
	input rstn,		// reset, active low	
	input fc,		// fast command input
	output [3:0] state_bitAlign,	// state of the bit alignment state machine
	output bitError,		// error indicator of the bit alignment
	output [3:0] ed,			// detailed error indicator of the bit alignment
	output [9:0] fcd 
);
  // tmrg default triplicate

wire clk320_aligned;


bitCLKAligner CLKAligner_Inst(
	.fccAlign(fccAlign),
	.clk1280(clk1280),
	.clk40(clk40),
	.rstn(rstn),
	.fc(fc),
	.clk320_aligned(clk320_aligned),
	.state(state_bitAlign),
	.error(bitError),
	.ed0(ed[0]),
	.ed1(ed[1]),
	.ed2(ed[2]),
	.ed3(ed[3])
);

WADecoder WADecoder_inst(
	.rstn(rstn),
	.clk320_aligned(clk320_aligned),		
	.fc(fc),		
	.fcd(fcd)
);

endmodule
