//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Quan Sun
// 
// Create Date:    Sep. 19th, 2021
// Design Name:    fast command decoder
// Module Name:    selfAlignTop_tb
// Project Name:   ETROC2
// Description: test bench of the self alignment
//
// Dependencies: 
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////
//`timescale 1ps/100fs
module selfAlignTop_tb;


localparam IDLE = 8'b11110000;
localparam LinkReset = 8'b11111000;
localparam BCR = 8'b11110001;
localparam SyncForTrig = 8'b11110010;
localparam L1A_CR = 8'b11111001;
localparam ChargeInj = 8'b11110100;
localparam L1A = 8'b11110110;
localparam L1A_BCR = 8'b11110011;
localparam WS_Start = 8'b11111100;
localparam WS_Stop = 8'b11111010;

reg clk1280;
wire clk40;
reg [4:0] cnt;
reg fccAlign;
reg rstn;

reg [7:0] fc_byte;
wire [7:0] fc_byte_wire;
wire fc;
wire [3:0] ed;
reg cmd_sw;
reg [2:0] cnt_fc;
reg [3:0] n_fc;
initial begin
	clk1280 = 0;
	cnt_fc = 0;
	n_fc = 0;
	fccAlign = 0;
	rstn = 1;
	cnt = 0;
	cmd_sw = 0;
# 10000000
	rstn = 0;
# 10000000
	rstn = 1;
# 20000000
	fccAlign = 1;
# 10000000
	fccAlign = 0;
# 100000
	cmd_sw = 1;

# 100000000
$finish();
end
reg [7:0] fc_byte_random;

assign fc_byte_wire = cmd_sw?fc_byte_random:IDLE;

always@(posedge clk40) begin
if(n_fc == 9) 
	n_fc <= 0;
else
	n_fc <= n_fc + 1;
case(n_fc)
	0: fc_byte_random <= IDLE;
	1: fc_byte_random <= LinkReset;
	2: fc_byte_random <= BCR;
	3: fc_byte_random <= SyncForTrig;
	4: fc_byte_random <= L1A_CR;
	5: fc_byte_random <= ChargeInj;
	6: fc_byte_random <= L1A;
	7: fc_byte_random <= L1A_BCR;
	8: fc_byte_random <= WS_Start;
	9: fc_byte_random <= WS_Stop;
	default: fc_byte_random <= IDLE;
endcase

end



always #390 clk1280 = ~clk1280;


always@(posedge clk1280) begin
cnt <= cnt + 1;
end

assign clk40 = cnt[4];

wire clk320_data;
assign #1000 clk320_data = cnt[1];


always@(posedge clk320_data) begin
cnt_fc <= cnt_fc + 1;
if(cnt_fc==0)
fc_byte <= fc_byte_wire;
else
fc_byte[7:0] <= {fc_byte[6:0],fc_byte[7]};
end

integer seed = 11101;
integer lower = -600;
integer higher = 600;
integer delay;
always @(posedge clk320_data) begin
	delay = 3200+$dist_uniform (seed, lower, higher);
end
assign #delay fc = fc_byte[7];
//assign fc = fc_byte[7];

wire [3:0] state_bitAlign;
wire bitError;
wire [9:0] fcd;

selfAlignTop selfAlignTop_inst(
	.fccAlign(fccAlign),
	.clk1280(clk1280),
	.clk40(clk40),
	.rstn(rstn),		// reset, active low	
	.fc(fc),		// fast command input
	.state_bitAlign(state_bitAlign),	// state of the bit alignment state machine
	.bitError(bitError),		// error indicator of the bit alignment
	.ed(ed),			// detailed error indicator of the bit alignment
	.fcd(fcd)
);

endmodule
