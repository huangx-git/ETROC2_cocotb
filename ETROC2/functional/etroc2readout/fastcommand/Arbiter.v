//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Quan Sun
// 
// Create Date:    Mon May 4th 2021
// Design Name:    fast command decoder
// Module Name:    Arbiter
// Project Name:   ETROC2
// Description: arbitrating the clock whose rising edge is close to the data edge
//
// Dependencies: 
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module Arbiter(
	clk1,
	clk2,
	enable,
	clk_sampler,
	rstn_arbiter,
	fc,
	ed,
	n_samples
);
  // tmrg default triplicate

input clk1;			// the 1st clock
input clk2;			// the 2nd clock
input enable;
input clk_sampler;		// sampling clock
input rstn_arbiter;		// reset of the arbiter
input fc;			// fast command bit stream
output ed;			// edge detected: ed == 1;
reg ed;
output [7:0] n_samples;		// number of samples
reg [7:0] n_samples;

reg q1, q2;

always@(posedge clk1) begin
	if(enable)
		q1 <= fc;
end

always@(posedge clk2) begin
	if(enable)
		q2 <= fc;
end

wire [7:0] next_n_samples = n_samples + 1;
wire [7:0] next_n_samples_Voted = next_n_samples;
always@(posedge clk_sampler) begin
if(!rstn_arbiter) begin
	n_samples <= 0;
	ed <= 0;
end
else if(enable) begin
	if(n_samples != 8'b11111111) begin
		n_samples <= next_n_samples_Voted;
		if(q1 != q2) begin
			ed <= 1;
		end
	end
end
end

endmodule
