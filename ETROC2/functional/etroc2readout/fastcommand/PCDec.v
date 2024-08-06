//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Quan Sun
// 
// Create Date:    Sep 19th 2021
// Design Name:    fast command decoder 
// Module Name:    PCDec
// Project Name:   ETROC2
// Description: parallel command decoder 
//
// Dependencies: 
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////
//`timescale 1ps/100fs
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
  // tmrg default triplicate

localparam IDEL = 8'b11110000;
localparam LinkReset = 8'b11111000;
localparam BCR = 8'b11110001;
localparam SyncForTrig = 8'b11111001;
localparam L1A_CR = 8'b11111001;
localparam ChargeInj = 8'b11110100;
localparam L1A = 8'b11110110;
localparam L1A_BCR = 8'b11110011;
localparam WS_Start = 8'b11111100;
localparam WS_Stop = 8'b11111010;

always@(negedge clk40_aligned) begin
if(!rstn) begin
	selfAlignIdleDec <= 1'b0;
	fcd <= 10'd10;
end
else begin
	if(selfWordAlignOn) begin
		if(fcReg == IDEL) begin
			selfAlignIdleDec <= 1'b1;
			fcd <= 10'd0;
		end
		else begin
			selfAlignIdleDec <= 1'b0;
			fcd <= 10'd0;
		end	
	end
	else begin
		case (fcReg)
				IDEL: begin 
					selfAlignIdleDec <= 1'b0; 
					fcd <= 10'b0000000001;
				end
				LinkReset: begin 
					selfAlignIdleDec <= 1'b0; 
					fcd <= 10'b0000000010;
				end
				BCR: begin 
					selfAlignIdleDec <= 1'b0; 
					fcd <= 10'b0000000100;
				end
				SyncForTrig: begin 
					selfAlignIdleDec <= 1'b0; 
					fcd <= 10'b0000001000;
				end
				L1A_CR: begin 
					selfAlignIdleDec <= 1'b0; 
					fcd <= 10'b0000010000;
				end
				ChargeInj: begin 
					selfAlignIdleDec <= 1'b0; 
					fcd <= 10'b0000100000;
				end
				L1A: begin 
					selfAlignIdleDec <= 1'b0; 
					fcd <= 10'b0001000000;
				end
				L1A_BCR: begin 
					selfAlignIdleDec <= 1'b0; 
					fcd <= 10'b0010000000;
				end
				WS_Start: begin 
					selfAlignIdleDec <= 1'b0; 
					fcd <= 10'b0100000000;
				end
				WS_Stop: begin 
					selfAlignIdleDec <= 1'b0; 
					fcd <= 10'b1000000000;
				end
				default: begin 
					selfAlignIdleDec <= 1'b0; 
					fcd <= 10'b0000000000;
				end
		endcase
	end
end
end

endmodule
