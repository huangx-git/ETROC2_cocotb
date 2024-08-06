//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Quan Sun
// 
// Create Date:    Sep 18th 2021
// Design Name:    fast command decoder
// Module Name:    arbiterWordAlign
// Project Name:   ETROC2
// Description: arbitrating the clock aligned up the frame. if 255 consecutive selfAlignIdleDec
//              found, allIdle become 1 and done become 1.
//
// Dependencies: 
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module arbiterWordAlign(
	input selfAlignIdleDec,
	input clk,
	input rstn_arbiter,
	output reg allIdle,		//
	output reg done,
	output reg [7:0] cnt_arbiter
);
  // tmrg default triplicate

always@(posedge clk) begin
if(!rstn_arbiter) begin
	cnt_arbiter <= 8'b00000000;
	allIdle <= 1'b0;
	done <= 1'b0;
end
else begin
	if(!selfAlignIdleDec) begin
		done <= 1'b1;
		allIdle <= 1'b0;
		cnt_arbiter <= cnt_arbiter;
	end
	else begin
		if (cnt_arbiter == 8'b11111111) begin
			allIdle <= 1'b1;
			done <= 1'b1;
			cnt_arbiter <= cnt_arbiter;
		end
		else begin
			allIdle <= 1'b0;
			done <= 1'b0;
			cnt_arbiter <= cnt_arbiter + 1;			
		end	
	end
end
end

endmodule 
