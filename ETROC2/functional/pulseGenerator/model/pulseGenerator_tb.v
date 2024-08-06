//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Xing Huang
// 
// Create Date:    May 3rd, 2022
// Design Name:    pulseGenerator model
// Module Name:    pulseGenerator_tb
// Project Name:   ETROC2
// Description: testbench of verilog model of pulseGenerator
//
// Dependencies: pulseGenerator
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ps/100fs
module pulseGenerator_tb;

	reg CLK40M;
	reg CLK320M;
	reg [7:0] s;
	
  	wire clk40_pulse;
	wire clk320_pulse;

//always #390 clk1280 = ~clk1280; //clk1280

always #(390*4) CLK320M = ~CLK320M; //clk 320 MHz

always #(390*4*8) CLK40M = ~CLK40M; //clk 40 MHz



initial begin
	CLK320M = 0;
	CLK40M = 0;
	s = 8'b0000_0000;

# 1000000
	s = 8'b0010_0001;
# 1000000
	s = 8'b0000_0011;
# 1000000
	s = 8'b0000_0111;
# 1000000
	s = 8'b0000_1111;
# 1000000
	s = 8'b0001_1111;
# 1000000
	s = 8'b0011_1111;
# 1000000
	s = 8'b0111_1111;

# 1000000
$finish();
end


pulseGenerator pulseGenerator_inst
(
	.CLK40M(CLK40M), 
	.CLK320M(CLK320M),
	.s(s),

	.clk40_pulse(clk40_pulse),
	.clk320_pulse(clk320_pulse),

	.VDD(),
	.VSS()
);

endmodule
