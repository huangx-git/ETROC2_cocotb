//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Quan Sun 
// 
// Create Date:    Mon May 4th 2021
// Design Name:    clock aligner
// Module Name:    CLKAligner
// Project Name:   ETROC2
// Description: aligning the clock phase for the fast command decoder
//
// Dependencies: CLKGen, Sampler
//
// Revision: Xing Huang, Nov. 2nd, TMR protection
//
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module bitCLKAligner(
	fccAlign,
	clk1280,
	clk40,
	enable,
	rstn1280,
	rstn40,
	fc,
	clk320_aligned,
	aligned,
	state,
	error,
	ed0,
	ed1,
	ed2,
	ed3
);
  // tmrg default triplicate

input fccAlign;		// fast command clock align command. initialize the clock phase alignment process at its rising edge
input clk1280;		// 1.28 GHz clock
input enable;
input clk40;		// 40 MHz clock, RO clock
input rstn1280;		// reset, active low
input rstn40;       // reset, active low 
input fc;		// fast command bit stream
output clk320_aligned;		// aligned 320 MHz clock, output
output aligned;
reg aligned;
reg clk320;
output [3:0] state;
output error;
output ed0, ed1, ed2, ed3;

reg [3:0] state;
//reg [3:0] stateNext;
wire [3:0] stateVoted = state; //TMR protection

localparam INIT = 0;
localparam RST_ARBITER_P0 = 1;
localparam P0 = 2;
localparam RST_ARBITER_P1 = 3;
localparam P1 = 4;
localparam RST_ARBITER_P2 = 5;
localparam P2 = 6;
localparam RST_ARBITER_P3 = 7;
localparam P3 = 8;
localparam DONE = 9;

reg clken_p0;
reg clken_p1;
reg clken_p2;
reg clken_p3;

wire clk320_p0;
wire clk320_p1;
wire clk320_p2;
wire clk320_p3;
 

wire init_pulse;		// the rising edge of fccalign found
reg [2:0] fcca_stream;	// sampled fccalign

reg clk1, clk2, clk_sampler, rstn_arbiter, error;
reg ed0reg, ed1reg, ed2reg, ed3reg;
wire ed0regVoted, ed1regVoted, ed2regVoted, ed3regVoted;
assign ed0regVoted = ed0reg; //TMR protection
assign ed1regVoted = ed1reg; //TMR protection
assign ed2regVoted = ed2reg; //TMR protection
assign ed3regVoted = ed3reg; //TMR protection
wire ed0, ed1, ed2, ed3;
assign ed0 = ed0reg;
assign ed1 = ed1reg;
assign ed2 = ed2reg;
assign ed3 = ed3reg;
wire ed;
wire [7:0] n_samples;

assign clk320_aligned = clk320;

always@(posedge clk40) begin
	if (!rstn40) begin
		fcca_stream <= 0;
	end
	else if(enable) begin
		fcca_stream[2:0] <= {fcca_stream[1:0],fccAlign};
	end
end

assign init_pulse = (fcca_stream == 3'b011) ;

always@(*) begin
	case (state)
		INIT:		//initialization
			begin
				clk320 = 1'b0;
				clken_p0 = 1'b0;
				clken_p1 = 1'b0;
				clken_p2 = 1'b0;
				clken_p3 = 1'b0;
				clk1 = 1'b0;
				clk2 = 1'b0;
				clk_sampler = 1'b0;
				rstn_arbiter = 1'b1;
				ed0reg = 0;
				ed1reg = 0;
				ed2reg = 0;
				ed3reg = 0;
				error = 1'b0;
			end
		RST_ARBITER_P0:		//reset
			begin
				clk320 = 1'b0;
				clken_p0 = 1'b1;
				clken_p1 = 1'b0;
				clken_p2 = 1'b1;
				clken_p3 = 1'b1;
				clk1 = clk320_p2;
				clk2 = clk320_p3;
				clk_sampler = clk320_p0;
				rstn_arbiter = 1'b0;
				ed0reg = 0;
				ed1reg = 0;
				ed2reg = 0;
				ed3reg = 0;
				error = 1'b0;
			end
		P0:		// phase 0 clock sampling
			begin
				clk320 = 1'b0;
				clken_p0 = 1'b1;
				clken_p1 = 1'b0;
				clken_p2 = 1'b1;
				clken_p3 = 1'b1;
				clk1 = clk320_p2;
				clk2 = clk320_p3;
				clk_sampler = clk320_p0;
				rstn_arbiter = 1'b1;
				ed0reg = ed;
				ed1reg = 0;
				ed2reg = 0;
				ed3reg = 0;	
				error = 1'b0;			
			end
		RST_ARBITER_P1:
			begin
				clk320 = 1'b0;
				clken_p0 = 1'b1;
				clken_p1 = 1'b1;
				clken_p2 = 1'b0;
				clken_p3 = 1'b1;
				clk1 = clk320_p3;
				clk2 = clk320_p0;
				clk_sampler = clk320_p1;
				rstn_arbiter = 1'b0;
				ed0reg = ed0regVoted;
				ed1reg = 0;
				ed2reg = 0;
				ed3reg = 0;
				error = 1'b0;
			end
		P1:
			begin
				clk320 = 1'b0;
				clken_p0 = 1'b1;
				clken_p1 = 1'b1;
				clken_p2 = 1'b0;
				clken_p3 = 1'b1;
				clk1 = clk320_p3;
				clk2 = clk320_p0;
				clk_sampler = clk320_p1;
				rstn_arbiter = 1'b1;
				ed0reg = ed0regVoted;
				ed1reg = ed;
				ed2reg = 0;
				ed3reg = 0;
				error = 1'b0;
			end
		RST_ARBITER_P2:
			begin
				clk320 = 1'b0;
				clken_p0 = 1'b1;
				clken_p1 = 1'b1;
				clken_p2 = 1'b1;
				clken_p3 = 1'b0;
				clk1 = clk320_p0;
				clk2 = clk320_p1;
				clk_sampler = clk320_p2;
				rstn_arbiter = 1'b0;
				ed0reg = ed0regVoted;
				ed1reg = ed1regVoted;
				ed2reg = 0;
				ed3reg = 0;
				error = 1'b0;
			end
		P2:
			begin
				clk320 = 1'b0;
				clken_p0 = 1'b1;
				clken_p1 = 1'b1;
				clken_p2 = 1'b1;
				clken_p3 = 1'b0;
				clk1 = clk320_p0;
				clk2 = clk320_p1;
				clk_sampler = clk320_p2;
				rstn_arbiter = 1'b1;
				ed0reg = ed0regVoted;
				ed1reg = ed1regVoted;
				ed2reg = ed;
				ed3reg = 0;
				error = 1'b0;
			end
		RST_ARBITER_P3:
			begin
				clk320 = 1'b0;
				clken_p0 = 1'b0;
				clken_p1 = 1'b1;
				clken_p2 = 1'b1;
				clken_p3 = 1'b1;
				clk1 = clk320_p1;
				clk2 = clk320_p2;
				clk_sampler = clk320_p3;
				rstn_arbiter = 1'b0;
				ed0reg = ed0regVoted;
				ed1reg = ed1regVoted;
				ed2reg = ed2regVoted;
				ed3reg = 0;
				error = 1'b0;
			end
		P3:
			begin
				clk320 = 1'b0;
				clken_p0 = 1'b0;
				clken_p1 = 1'b1;
				clken_p2 = 1'b1;
				clken_p3 = 1'b1;
				clk1 = clk320_p1;
				clk2 = clk320_p2;
				clk_sampler = clk320_p3;
				rstn_arbiter = 1'b1;
				ed0reg = ed0regVoted;
				ed1reg = ed1regVoted;
				ed2reg = ed2regVoted;
				ed3reg = ed;
				error = 1'b0;
			end
		DONE:
			begin
				if (({ed0regVoted,ed1regVoted,ed2regVoted,ed3regVoted} == 4'b0000)||({ed0regVoted,ed1regVoted,ed2regVoted,ed3regVoted} == 4'b1111)||({ed0regVoted,ed1regVoted,ed2regVoted,ed3regVoted} == 4'b1010)||({ed0regVoted,ed1regVoted,ed2regVoted,ed3regVoted} == 4'b0101)) begin
					clk320 = 0;
					clken_p0 = 1'b0;
					clken_p1 = 1'b0;
					clken_p2 = 1'b0;
					clken_p3 = 1'b0;
					clk1 = 0;
					clk2 = 0;
					clk_sampler = 0;
					rstn_arbiter = 1'b1;
					ed0reg = ed0regVoted;
					ed1reg = ed1regVoted;
					ed2reg = ed2regVoted;
					ed3reg = ed3regVoted;
					error = 1'b1;
				end
				else if({ed0regVoted,ed1regVoted} == 2'b10) begin
					clk320 = clk320_p0;
					clken_p0 = 1'b1;
					clken_p1 = 1'b0;
					clken_p2 = 1'b0;
					clken_p3 = 1'b0;
					clk1 = 0;
					clk2 = 0;
					clk_sampler = 0;
					rstn_arbiter = 1'b1;
					ed0reg = ed0regVoted;
					ed1reg = ed1regVoted;
					ed2reg = ed2regVoted;
					ed3reg = ed3regVoted;
					error = 1'b0;					
				end
				else if({ed1regVoted,ed2regVoted} == 2'b10) begin
					clk320 = clk320_p1;
					clken_p0 = 1'b0;
					clken_p1 = 1'b1;
					clken_p2 = 1'b0;
					clken_p3 = 1'b0;
					clk1 = 0;
					clk2 = 0;
					clk_sampler = 0;
					rstn_arbiter = 1'b1;
					ed0reg = ed0regVoted;
					ed1reg = ed1regVoted;
					ed2reg = ed2regVoted;
					ed3reg = ed3regVoted;
					error = 1'b0;
				end
				else if({ed2regVoted,ed3regVoted} == 2'b10) begin
					clk320 = clk320_p2;
					clken_p0 = 1'b0;
					clken_p1 = 1'b0;
					clken_p2 = 1'b1;
					clken_p3 = 1'b0;
					clk1 = 0;
					clk2 = 0;
					clk_sampler = 0;
					rstn_arbiter = 1'b1;
					ed0reg = ed0regVoted;
					ed1reg = ed1regVoted;
					ed2reg = ed2regVoted;
					ed3reg = ed3regVoted;
					error = 1'b0;
				end
				else if({ed3regVoted,ed0regVoted} == 2'b10) begin
					clk320 = clk320_p3;
					clken_p0 = 1'b0;
					clken_p1 = 1'b0;
					clken_p2 = 1'b0;
					clken_p3 = 1'b1;
					clk1 = 0;
					clk2 = 0;
					clk_sampler = 0;
					rstn_arbiter = 1'b1;
					ed0reg = ed0regVoted;
					ed1reg = ed1regVoted;
					ed2reg = ed2regVoted;
					ed3reg = ed3regVoted;
					error = 1'b0;
				end
				else begin
					clk320 = 0;
					clken_p0 = 1'b0;
					clken_p1 = 1'b0;
					clken_p2 = 1'b0;
					clken_p3 = 1'b0;
					clk1 = 0;
					clk2 = 0;
					clk_sampler = 0;
					rstn_arbiter = 1'b1;
					ed0reg = ed0regVoted;
					ed1reg = ed1regVoted;
					ed2reg = ed2regVoted;
					ed3reg = ed3regVoted;
					error = 1'b1;
				end				
			end
		default:
			begin
				clk320 = 1'b0;
				clken_p0 = 1'b0;
				clken_p1 = 1'b0;
				clken_p2 = 1'b0;
				clken_p3 = 1'b0;
				clk1 = 1'b0;
				clk2 = 1'b0;
				clk_sampler = 1'b0;
				rstn_arbiter = 1'b1;
				ed0reg = 0;
				ed1reg = 0;
				ed2reg = 0;
				ed3reg = 0;
				error = 1'b1;
			end
	endcase
end

always@(posedge clk40) begin
if(!rstn40)
begin 
	state <= INIT;
	aligned <= 1'b0;
end
else if(enable)
	case (stateVoted) //TMR protection
		INIT:
			begin
				if(init_pulse) 
					state <= RST_ARBITER_P0;
				else
					state <= INIT;
			end
		RST_ARBITER_P0:
			begin
				if(n_samples == 8'b00000000 && ed == 1'b0)				
					state <= P0;
				else
					state <= RST_ARBITER_P0;
			end
		P0:
			begin
				if(n_samples == 8'b11111111) 
					state <= RST_ARBITER_P1;
				else
					state <= P0;
			end
		RST_ARBITER_P1:
			begin
				if(n_samples == 8'b00000000 && ed == 1'b0)				
					state <= P1;
				else
					state <= RST_ARBITER_P1;
			end
		P1:
			begin
				if(n_samples == 8'b11111111) state <= RST_ARBITER_P2;
			end
		RST_ARBITER_P2:
			begin
				if(n_samples == 8'b00000000 && ed == 1'b0)				
					state <= P2;
				else
					state <= RST_ARBITER_P2;
			end
		P2:
			begin
				if(n_samples == 8'b11111111) 
					state <= RST_ARBITER_P3;
				else 
					state <= P2;
			end
		RST_ARBITER_P3:
			begin
				if(n_samples == 8'b00000000 && ed == 1'b0)				
					state <= P3;
				else
					state <= RST_ARBITER_P3;
			end
		P3:
			begin
				if(n_samples == 8'b11111111) 
					state <= DONE;
				else 
					state <= P3;
			end
		DONE:			
			begin
				if(init_pulse) 
					state <= RST_ARBITER_P0;
				else
				begin
					state <= DONE;
					aligned <= 1'b1;
				end
			end
		default:
			begin
				if(init_pulse) 
					state <= RST_ARBITER_P0;
				else
					state <= INIT;
			end
	endcase
end

bitclkgen bitclkgen_inst(
	.clk1280(clk1280),
	.rstn(rstn1280),
	.enable(enable),
	.clken_p0(clken_p0),
	.clken_p1(clken_p1),
	.clken_p2(clken_p2),
	.clken_p3(clken_p3),
	.clk320_p0(clk320_p0),
	.clk320_p1(clk320_p1),
	.clk320_p2(clk320_p2),
	.clk320_p3(clk320_p3)
);

Arbiter Arbiter_ints(
	.clk1(clk1),
	.clk2(clk2),
	.enable(enable),
	.clk_sampler(clk_sampler),
	.rstn_arbiter(rstn_arbiter),
	.fc(fc),
	.ed(ed),
	.n_samples(n_samples)
);

endmodule
