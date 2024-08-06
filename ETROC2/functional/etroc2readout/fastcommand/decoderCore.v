//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Quan Sun
// 
// Create Date:    Sep 19th 2021
// Design Name:    fast command decoder 
// Module Name:    WADecoder.v
// Project Name:   ETROC2
// Description: word align and decoder, based on Jinyuan's idea
//
// Dependencies: 
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////

module PCDec(
	input rstn,		// reset, active low
	input clk40_aligned,	// 
	input selfWordAlignOn,		// 0: self word Alignment off, normal decoding, 1: self word alignment on
	input [7:0] fcReg,		// parallel fc from the shift register
	output reg selfAlignIdleDec, 	// idle detected, 0: no idle found, 1: idle found					
	output reg [9:0] fcd		// decoded fast command, fcd[0]: idle, fcd[1]:link rst, fcd[2]: BCR, 
					// fcd[3]: SyncForTrig, fcd[4]: L1A-CR, fcd[5]: charge injection,
					// fcd[6]: L1A, fcd[7]: L1A&BCR, fcd[8]: WS Start, fcd[9]: WS Stop
);

endmodule
