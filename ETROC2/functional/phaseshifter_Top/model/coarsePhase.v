//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Xing Huang
// 
// Create Date:    Mar. 30th, 2022
// Design Name:    phase shiter model
// Module Name:    coarsePhase
// Project Name:   ETROC2
// Description: a 5-bit settable down counter for coarse to generator phase adjustable clk40 and clk320 outputs.
//
// Dependencies: delayLine
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ps/1ps
// Verilog code for coarse phse shifter
module coarsePhase(
	input syncCK40, 
	input clk1G28, 
//	input rstn, 
	input [4:0] setVal, 
	
	output clk320Out,
	output clk40Out
);


wire [15:0] tapOut;
reg [4:0] counter_down;

wire syncCK40Delay, set;

delayLine_ps delayLine_inst(
	.clkIn(syncCK40), 
	.tapOut(tapOut)
);

assign syncCK40Delay = tapOut[15];

assign set = (~syncCK40) & syncCK40Delay;

// down counter
always @(posedge clk1G28)
begin
	//if(!rstn || set)
	if(set)
 		counter_down <= setVal;
	else
 		counter_down <= counter_down - 5'd1;
end 


assign clk320Out = counter_down[1];
assign clk40Out = counter_down[4];
endmodule
