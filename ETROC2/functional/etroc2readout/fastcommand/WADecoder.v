//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Quan Sun
// 
// Create Date:    Sep 19th 2021
// Design Name:    fast command decoder 
// Module Name:    WADecoder
// Project Name:   ETROC2
// Description: word align and decoder, based on Jinyuan's idea
//
// Dependencies: 
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module WADecoder(
	input rstn,		// reset, active low
	input clk320_aligned,	// 
	input fc,		// serial fc
	output reg invalidCmd,			
	output reg wordAligned,
	output reg [9:0]  fcd		// decoded fast command, fcd[0]: idle, fcd[1]:link rst, fcd[2]: BCR, 
					// fcd[3]: SyncForTrig, fcd[4]: L1A-CR, fcd[5]: charge injection,
					// fcd[6]: L1A, fcd[7]: L1A&BCR, fcd[8]: WS Start, fcd[9]: WS Stop
);
  // tmrg default triplicate

//         NAME    		Decode	           Input_code          		     	
localparam IDLE 		= 4'HE; 			//8'HF0		-->14  		
localparam LinkReset 	= 4'H2; 			//8'H33		-->2   		
localparam BCR 			= 4'H5; 			//8'H5A		-->5   		
localparam SyncForTrig 	= 4'H4; 			//8'H55		-->4   		
localparam L1A_CR 		= 4'H6; 			//8'H66		-->6   		
localparam ChargeInj 	= 4'H7; 			//8'H69		-->7   		
localparam L1A 			= 4'H8; 			//8'H96		-->8   		
localparam L1A_BCR 		= 4'H9; 			//8'H99		-->9   		
localparam WS_Start 	= 4'HA; 			//8'HA5		-->10  		
localparam WS_Stop 		= 4'HB; 			//8'HAA		-->11  		

reg [7:0] fcReg, fcReg1;
reg [2:0] cnt;
always@(posedge clk320_aligned) begin
	fcReg[7:0] <= {fcReg[6:0],fc};
end

//reg init;
reg [3:0] confirmCount;

always@(posedge clk320_aligned) begin
if(~rstn) 
	begin
		fcReg1 			<= 8'd0;
	end
	else if(cnt == 3'b111) begin
		fcReg1 <= fcReg;
	end
end

wire wordAlignedNext = (confirmCount == 4'd15) ? 1'b1 : wordAligned;
wire  wordAlignedVoted = wordAlignedNext;
always@(posedge clk320_aligned) begin
	if(~rstn) 
	begin
		wordAligned		<= 1'b0;
	end
	else begin
		wordAligned <= wordAlignedVoted;
	end
end

wire [3:0] confirmCountNext = (wordAligned == 1'b0 && cnt==3'd7) ? (fcReg == 8'HF0 ? confirmCount + 1 : 4'd0) :confirmCount;
wire [3:0] confirmCountVoted = confirmCountNext;
always@(posedge clk320_aligned) begin
	if(~rstn) 
	begin
 		confirmCount	<= 4'd0;
	end
	else begin
 		confirmCount <= confirmCountVoted;
	end
end

wire [2:0] cntNext = (fcReg == 8'HF0 && wordAlignedVoted == 1'b0) ? 3'd0 : cnt + 1'b1;
wire [2:0] cntNextVoted = cntNext;
always@(posedge clk320_aligned) begin
	if(~rstn) 
	begin
 		cnt	<= 3'd0;
	end
	else begin
 		cnt <= cntNextVoted;
	end
end

wire [3:0] DDO;
wire E1;
wire E2;
decoderHamming8to4 hammingdecoderInst(
	.DDI(fcReg1),
    .DDO(DDO),
    .E1(E1),
    .E2(E2)
);

always@(*) begin
	case (DDO)
				IDLE: begin 
					fcd <= 10'b00_0000_0001;  //3'h001 --> 2'hF0
					invalidCmd <= E2;		 //if E2 is true, it is invalidate command	
				end
				LinkReset: begin  
					fcd <= 10'b00_0000_0010;  //3'h002 --> 2'hF8
					invalidCmd <= E2;
				end
				BCR: begin  
					fcd <= 10'b00_0000_0100;  //3'h004 --> 2'hF1
					invalidCmd <= E2;
				end
				SyncForTrig: begin  
					fcd <= 10'b00_0000_1000;  //3'h008 --> 2'hF2
					invalidCmd <= E2;
				end
				L1A_CR: begin 
					fcd <= 10'b00_0001_0000;  //3'h010 --> 2'hF9
					invalidCmd <= E2;
				end
				ChargeInj: begin  
					fcd <= 10'b00_0010_0000;  //3'h020 --> 2'hF4
					invalidCmd <= E2;
				end
				L1A: begin 
					fcd <= 10'b00_0100_0000;  //3'h040 --> 2'hF6
					invalidCmd <= E2;
				end
				L1A_BCR: begin  
					fcd <= 10'b00_1000_0000;  //3'h080 --> 2'hF3
					invalidCmd <= E2;
				end
				WS_Start: begin  
					fcd <= 10'b01_0000_0000;  //3'h100 --> 2'hFC
					invalidCmd <= E2;
				end
				WS_Stop: begin  
					fcd <= 10'b10_0000_0000;  //3'h200 --> 2'hFA
					invalidCmd <= E2;
				end
				default: begin 
					fcd <= 10'b00_0000_0001;  //3'h001  //IDLE
					invalidCmd <= E2;
				end
		endcase
end

endmodule
