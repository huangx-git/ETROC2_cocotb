`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Quan Sun
// 
// Create Date:    Mon May 4th 2021
// Design Name:    phase adjuster
// Module Name:    phaseAdjuster
// Project Name:   ETROC2
// Description: adjusting phase of the bit clock or the command
//
// Dependencies: 
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////

module phaseAdjuster(fc, clk320, fcOut, clk320Out, clkDelayEn, fcDelayEn);
input fc;
input clk320;
output fcOut;
output clk320Out;
input clkDelayEn;
input fcDelayEn;
wire clk320DelayIn;
wire clk320DelayOut;
assign clk320DelayIn = clkDelayEn ? clk320 : 1'b0;
DELWRAPPER DELWRAPPER_clk320_Inst(
	.I(clk320DelayIn),
	.Z(clk320DelayOut)
);
  // tmrg default triplicate

assign clk320Out = clkDelayEn ? clk320DelayOut : clk320;

wire fcDelay;
wire fcDelayIn;
assign fcDelayIn = fcDelayEn ? fc : 1'b0;
DELWRAPPER DELWRAPPER_fc_Inst(
	.I(fcDelayIn),
	.Z(fcDelay)
);

assign fcOut =  fcDelayEn ? fcDelay : fc;

endmodule
