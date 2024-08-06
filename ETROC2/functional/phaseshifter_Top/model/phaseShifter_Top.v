//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Xing Huang
// 
// Create Date:    Mar. 30th, 2022
// Design Name:    phase shiter model
// Module Name:    phaseShifterModel
// Project Name:   ETROC2
// Description: the fine phase adjustment is 50 ps delay per tap. clk40, clk1280 are delayed by two delay lines and selected by two multiplexers.
//
// Dependencies: coarsePhase, delayLine
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ps/1ps
// Verilog code for phase shifter model
module phaseShifter_Top(
	input clk1G28,
	input dllCapResetA, 
	input dllCapResetB, 
	input dllCapResetC,
	input [3:0] dllChargePumpCurrent,
	input dllEnableA,
	input dllEnableB,
	input dllEnableC,
	input dllForceDown,
	input [7:0] s,
	input syncCK40,
	//input rstn, 
 
	output clk40MOut,
	output clk320MOut,
	output dllLateA,
	output dllLateB,
	output dllLateC,

	inout vCtrl,
	inout VDD,
	inout VSS
);

wire clk320, clk40;
wire [15:0] clk320Tap, clk40Tap;
reg clk320OutReg, clk40OutReg;

wire syncCK40Delay;
assign #1500 syncCK40Delay = syncCK40;

coarsePhase coarsePhase_inst(
	.syncCK40(syncCK40Delay), 
	.clk1G28(clk1G28), 
	//.rstn(rstn), 
	.setVal(s[7:3]), 
	.clk320Out(clk320),
	.clk40Out(clk40)
);

delayLine_ps delayLine_instClk320(
	.clkIn(clk320), 
	.tapOut(clk320Tap)
);

delayLine_ps delayLine_instClk40(
	.clkIn(clk40), 
	.tapOut(clk40Tap)
);

always @(s[2:0], clk320Tap, clk40Tap) begin
	case(s[2:0])
	3'b000: begin 
		clk320OutReg = clk320Tap[0];
		clk40OutReg = clk40Tap[0]; end
	3'b001: begin
		clk320OutReg = clk320Tap[2];
		clk40OutReg = clk40Tap[2]; end
	3'b010: begin 
		clk320OutReg = clk320Tap[4];
		clk40OutReg = clk40Tap[4]; end
	3'b011: begin
		clk320OutReg = clk320Tap[6];
		clk40OutReg = clk40Tap[6]; end
	3'b100: begin 
		clk320OutReg = clk320Tap[8];
		clk40OutReg = clk40Tap[8]; end
	3'b101: begin
		clk320OutReg = clk320Tap[10];
		clk40OutReg = clk40Tap[10]; end
	3'b110: begin 
		clk320OutReg = clk320Tap[12];
		clk40OutReg = clk40Tap[12]; end
	3'b111: begin
		clk320OutReg = clk320Tap[14];
		clk40OutReg = clk40Tap[14]; end
	default: begin 
		clk320OutReg = clk320Tap[0];
		clk40OutReg = clk40Tap[0]; end
	endcase
end

assign #200 clk320MOut = clk320OutReg;
assign #200 clk40MOut = clk40OutReg;

endmodule
