//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Xing Huang
// 
// Create Date:    May 3rd, 2022
// Design Name:    pulseGenerator model
// Module Name:    pulseGenerator
// Project Name:   ETROC2
// Description: verilog model of pulseGenerator
//
// Dependencies: DFF_pulseGen, pulseGenerator_DELWRAPPER
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ps/100fs
// Verilog code for rising edge D flip flop 
module DFF_pulseGen(D,clk,Q,Qbar);
input D; // Data input 
input clk; // clock input 
output Q; // output Q 
output Qbar;

reg Q, Qbar;

always @(posedge clk) 
begin
 	Q <= D;
	Qbar <= ~D; 
end 
endmodule 

module pulseGenerator(
	input CLK40M,
	input CLK320M,
	input [7:0] s,
	
  	output clk40_pulse,
	output clk320_pulse,

	inout VDD,
	inout VSS
);
  // tmrg do_not_touch

	wire CLK320Minverted, CLK320MinvertedDelay;

	assign CLK320Minverted = ~CLK320M;

 	pulseGenerator_DELWRAPPER pulseGenerator_DELWRAPPER_inst(
		.I(CLK320Minverted), 
		.Z(CLK320MinvertedDelay));

	wire CLK40MD, CLK40MDbar;
	DFF_pulseGen DFF_inst(
		.D(CLK40M),
		.clk(CLK320MinvertedDelay),
		.Q(CLK40MD),
		.Qbar(CLK40MDbar));

	wire CLK40MD0, CLK40MDbar0;
	DFF_pulseGen DFF_inst0(
		.D(CLK40MD),
		.clk(CLK320MinvertedDelay),
		.Q(CLK40MD0),
		.Qbar(CLK40MDbar0));

	wire CLK40MD1, CLK40MDbar1;
	DFF_pulseGen DFF_inst1(
		.D(CLK40MD0),
		.clk(CLK320MinvertedDelay),
		.Q(CLK40MD1),
		.Qbar(CLK40MDbar1));

	wire CLK40MD2, CLK40MDbar2;
	DFF_pulseGen DFF_inst2(
		.D(CLK40MD1),
		.clk(CLK320MinvertedDelay),
		.Q(CLK40MD2),
		.Qbar(CLK40MDbar2));

	wire CLK40MD3, CLK40MDbar3;
	DFF_pulseGen DFF_inst3(
		.D(CLK40MD2),
		.clk(CLK320MinvertedDelay),
		.Q(CLK40MD3),
		.Qbar(CLK40MDbar3));

	wire CLK40MD4, CLK40MDbar4;
	DFF_pulseGen DFF_inst4(
		.D(CLK40MD3),
		.clk(CLK320MinvertedDelay),
		.Q(CLK40MD4),
		.Qbar(CLK40MDbar4));

	wire CLK40MD5, CLK40MDbar5;
	DFF_pulseGen DFF_inst5(
		.D(CLK40MD4),
		.clk(CLK320MinvertedDelay),
		.Q(CLK40MD5),
		.Qbar(CLK40MDbar5));

	wire CLK40MD6, CLK40MDbar6;
	DFF_pulseGen DFF_inst6(
		.D(CLK40MD5),
		.clk(CLK320MinvertedDelay),
		.Q(CLK40MD6),
		.Qbar(CLK40MDbar6));

	wire CLK40MD7, CLK40MDbar7;
	DFF_pulseGen DFF_inst7(
		.D(CLK40MD6),
		.clk(CLK320MinvertedDelay),
		.Q(CLK40MD7),
		.Qbar(CLK40MDbar7));

	wire pulse0, pulse1, pulse2, pulse3, pulse4, pulse5, pulse6, pulse7;
	assign pulse0 = CLK40MD & CLK40MDbar0;
	assign pulse1 = CLK40MD0 & CLK40MDbar1;
	assign pulse2 = CLK40MD1 & CLK40MDbar2;
	assign pulse3 = CLK40MD2 & CLK40MDbar3;
	assign pulse4 = CLK40MD3 & CLK40MDbar4;
	assign pulse5 = CLK40MD4 & CLK40MDbar5;
	assign pulse6 = CLK40MD5 & CLK40MDbar6;
	assign pulse7 = CLK40MD6 & CLK40MDbar7;

	wire pulseBuf0, pulseBuf1, pulseBuf2, pulseBuf3, pulseBuf4, pulseBuf5, pulseBuf6, pulseBuf7;
	assign pulseBuf1 = s[1] & pulse0;
	assign pulseBuf2 = s[2] & pulse1;	
	assign pulseBuf3 = s[3] & pulse2;
	assign pulseBuf4 = s[4] & pulse3;
	assign pulseBuf5 = s[5] & pulse4;
	assign pulseBuf6 = s[6] & pulse5;
	assign pulseBuf7 = s[7] & pulse6;
	assign pulseBuf0 = s[0] & pulse7;

	assign clk320_pulse = CLK320M & (pulseBuf0 | pulseBuf1 | pulseBuf2 | pulseBuf3 | pulseBuf4 | pulseBuf5 | pulseBuf6 | pulseBuf7);

	assign clk40_pulse = CLK40M;

endmodule
