//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Quan Sun
// 
// Create Date:    Mon May 3rd 2021
// Design Name:    fast command decoder 
// Module Name:    clock generator
// Project Name:   ETROC2
// Description: generating four 320 MHz clocks with different phase from a 1.28 GHz clock
//
// Dependencies: none
//
// Revision:  Xing Huang, Nov. 2nd, TMR protection 
//
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module bitclkgen(
	clk1280,
//	phase_sel,
	rstn,
	enable,
	clken_p0,
	clken_p1,
	clken_p2,
	clken_p3,
	clk320_p0,
	clk320_p1,
	clk320_p2,
	clk320_p3
);
  // tmrg default triplicate

input clk1280;				//1.28 GHz clock
input enable;
//input [1:0] phase_sel;			//phase selection
input rstn;				//synchronous reset, reset the counter at rising edge of clk1280 when rstn==0
input clken_p0, clken_p1, clken_p2, clken_p3;		// clock enable, active high
output reg clk320_p0, clk320_p1, clk320_p2, clk320_p3;		//output clocks, spaced 90 degree

reg [1:0] counter;			// the counter for the phase control
/*
wire clk1280_p0_gated;
wire clk1280_p1_gated;
wire clk1280_p2_gated;
wire clk1280_p3_gated;


gateClockCell gatingclk_p0_inst
(
	.clk(clk1280),
	.gate(clken_p0),
	.enableGate(1'b1),
	.gatedClk(clk1280_p0_gated)   
);

gateClockCell gatingclk_p1_inst
(
	.clk(clk1280),
	.gate(clken_p1),
	.enableGate(1'b1),
	.gatedClk(clk1280_p1_gated)   
);

gateClockCell gatingclk_p2_inst
(
	.clk(clk1280),
	.gate(clken_p2),
	.enableGate(1'b1),
	.gatedClk(clk1280_p2_gated)   
);

gateClockCell gatingclk_p3_inst
(
	.clk(clk1280),
	.gate(clken_p3),
	.enableGate(1'b1),
	.gatedClk(clk1280_p3_gated)   
);
*/

wire [1:0] nextCount = counter + 1;
wire [1:0] nextCountVoted = nextCount;
always@(posedge clk1280) begin
	if(!rstn)
		counter <= 2'b00;
	else if(enable)
		counter <= nextCountVoted;
end


always@(posedge clk1280) begin
	if(enable)
	begin
		if(clken_p0 == 1) begin
			if(counter == 2'd0)
				clk320_p0 <= 1;
			else if( counter == 2'd2)
				clk320_p0 <= 0;	
		end
		else
			clk320_p0 <= 0;	
	end
end

always@(posedge clk1280) begin
	if(enable)
	begin
		if(clken_p1 == 1) begin
			if(counter == 2'd1)
				clk320_p1 <= 1;
			else if( counter == 2'd3)
				clk320_p1 <= 0;	
		end
		else
			clk320_p1 <= 0;	
	end
end

always@(posedge clk1280) begin
	if(enable)
	begin
		if(clken_p2 == 1) begin
			if(counter == 2'd2)
				clk320_p2 <= 1;
			else if( counter == 2'd0)
				clk320_p2 <= 0;
		end	
		else
			clk320_p2 <= 0;	
	end
end

always@(posedge clk1280) begin
	if(enable)
	begin
		if(clken_p3 == 1) begin
			if(counter == 2'd3)
				clk320_p3 <= 1;
			else if( counter == 2'd1)
				clk320_p3 <= 0;	
		end
		else
			clk320_p3 <= 0;	
	end
end


endmodule
