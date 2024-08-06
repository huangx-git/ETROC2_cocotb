`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Quan Sun&Xing Huang
// 
// Create Date:    Oct. 4th, 2021
// Design Name:    fast command decoder
// Module Name:    fastCommandDecoderTop
// Project Name:   ETROC2
// Description: top of fastCommandDecoder including the self and manual alignment
//
// Dependencies: bitCLKAligner, phaseAdjuster, WADecoder
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////

module fastCommandDecoderTop(
	input fccAlign,				// fast command clock align command. initialize the clock phase alignment process at its rising edge -sefAligner
	input clk1280,				// 1.28 GHz clock -sefAligner
	input clk40,				// 40 MHz clock, PLL clock -sefAligner
	// input rstn40,					// reset, active low	
	// input rstn1280,                 // reset, active low
	input reset,
	input fc,					// fast command input
	input selfAlignEn,			// 
//	input clk320,				// 320 MHz clock  -manual internal divided by clk1280
	input clkDelayEn,			// enable signal of the clock delay -manual
	input fcDelayEn,			// enable signal of the command delay  -manual

	output [3:0] state_bitAlign,// state of the bit alignment state machine -sefAligner
	output bitError,			// error indicator of the bit alignment -sefAligner
	output [3:0] ed,			// detailed error indicator of the bit alignment -sefAligner
	output aligned,
	output invalidCmd,
	output [9:0] fcd 
);
  // tmrg default triplicate

reg rstn40;
reg rstn1280;
always @(posedge clk1280) 
begin
	rstn1280 <= reset;
end

reg iReset;

always @(negedge clk40) 
begin
	iReset <= reset;
	rstn40 <= iReset;
end

wire clk320_aligned;
wire bitAligned;
bitCLKAligner CLKAligner_Inst(
	.fccAlign(fccAlign),
	.clk1280(clk1280),
	.clk40(clk40),
	.enable(selfAlignEn),
	.rstn1280(rstn1280),
	.rstn40(rstn40),
	.fc(fc),
	.clk320_aligned(clk320_aligned),
	.state(state_bitAlign),			//output
	.aligned(bitAligned),
	.error(bitError),				//output
	.ed0(ed[0]),					//output
	.ed1(ed[1]),					//output
	.ed2(ed[2]),					//output
	.ed3(ed[3])						//output
);

wire clk320;
reg [1:0] cnt;
/*
always@(posedge clk1280) begin		//clk 1.28 GHz clock counter for 320 MHz sampling clock - manual.
	if(!rstn) begin
		cnt <= 1'b0;
		clk320 <= 1'b0;
	end
	else if(!selfAlignEn) begin		//if clkAlignerEn = 0, clkdivider enabled; if clkAlignerEn = 1, clkdivider disabled.
		if(cnt == 1'b1) begin
			cnt <= 1'b0;
			clk320 <= ~clk320;
		end
		else cnt <= cnt + 1'b1;
	end
	else clk320 <= 1'b0;
end
*/
wire [1:0] nextCount = cnt + 1'b1;
wire [1:0] nextCountVoted = nextCount;
always@(posedge clk1280) begin		//clk 1.28 GHz clock counter for 320 MHz sampling clock - manual.
	if(!rstn1280) begin
		cnt <= 2'b00;
	end
	else if(!selfAlignEn) begin
		if(cnt == 2'b11) cnt <= 2'b00;
		else cnt <= nextCountVoted;
	end	
end
assign clk320 = cnt[1];

wire clk320In_manual;
wire fcIn_manual;
assign clk320In_manual = selfAlignEn ? 1'b0 : clk320;	//Turn off the inputs of manual Aligner when selfAlignEn = 1'b1;
assign fcIn_manual     = selfAlignEn ? 1'b0 : fc;

wire fc_adj;
wire clk320_adj;
phaseAdjuster phaseAdjuster_inst(
	.fc(fcIn_manual),
	.clk320(clk320In_manual),
	.fcOut(fc_adj), 				//output
	.clk320Out(clk320_adj), 		//output
	.clkDelayEn(clkDelayEn),
	.fcDelayEn(fcDelayEn)
	);

wire clk320_dec;
wire fc_dec;
assign fc_dec = selfAlignEn ? fc : fc_adj;
assign clk320_dec = selfAlignEn ? clk320_aligned : clk320_adj;

reg [1:0] aligned_reg;
reg [1:0] fccAlign_reg;
always@(posedge clk40) begin		
	aligned_reg <= {aligned_reg[0],bitAligned};
	fccAlign_reg <= {fccAlign_reg[0],fccAlign};
end
wire rstDecoder = rstn40&~(aligned_reg[0]&~aligned_reg[1])&~(fccAlign_reg[0]&~fccAlign_reg[1]);

wire wordAligned;
assign aligned = wordAligned & aligned_reg[1];
WADecoder WADecoder_inst(
	.rstn(rstDecoder),
	.clk320_aligned(clk320_dec),		
	.fc(fc_dec),		
	.invalidCmd(invalidCmd),
	.wordAligned(wordAligned),
	.fcd(fcd)						//output
);

endmodule
