//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Quan Sun&Xing Huang
// 
// Create Date:    Oct. 4th, 2021
// Design Name:    fast command decoder
// Module Name:    fastCommandDecoderTop_tb
// Project Name:   ETROC2
// Description: test bench of the fast command decoder top
//
// Dependencies: fastCommandDecoderTop
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ps/100fs
module fastCommandDecoderTop_tb;
//																		         hamming code

reg clk1280;
wire clk40;
reg fccAlign;
reg rstn;
reg clkDelayEn , fcDelayEn, selfAlignEn;

//reg fc;
wire [3:0] ed;
wire [3:0] state_bitAlign;
wire [9:0] fcd;


reg [4:0] cnt; //counter for generating 40 MHz clock
always #390 clk1280 = ~clk1280; //clk1280
always@(posedge clk1280) begin
	cnt <= cnt + 1;
end
assign clk40 = cnt[4]; //clk40


// wire clk320_data; //320 MHz clock 
// assign #1000 clk320_data = cnt[1]; 

//Start Line Jittered Clock///////////////////////////////////////////////////////////////////////////////////////////
/*****************************************************************************************************				//
//clkbase is counting at 1 ps period clkbase which decides the non-jittered clk320 and jittered clk320.				//
*****************************************************************************************************/				//
// reg clkbase;																										//
// reg [63:0] counter;																									//
// reg [63:0] nextRise;																								//
// reg [63:0] nextFall;																								//
// reg clk320_jitter, clk320_nojitter; //320 MHz nonjittered and jittered clock										//
// always #0.5 clkbase = ~clkbase; //0.1 ps time resolution															//
// 																													//
// always@(posedge clkbase) begin																						//
// /****************************clkbase-based counter****************************/										//
// 		counter <= counter + 1; 																					//
// /******************ideal 320 MHz clock clkbase-based counter******************/										//
//     //if(((counter-counter%1560)/1560)%2)																			//
// 	if((counter/1560)%2) begin clk320_nojitter <= 1'b0; end															//
//     else begin clk320_nojitter <= 1'b1; end																			//
// /****************non-ideal 320 MHz clock clkbase-based counter****************/										//
//     if(counter == nextRise) clk320_jitter <= 1'b1;																	//
//     else if(counter == nextFall) clk320_jitter <= 1'b0;																//
// end																													//
																													//
/*****************************************************************************************************				//
//The jitter of the next edge is added based on the current ideal clock edge. If the rising edge of the ideal clock //
is detected, the coming falling edge of the jittered clock is calculated by adding the random number to the clkbase	//
-based counter, and vice versa. Each jitter generation is fully based on the current period of the ideal clock 		//
independently. No accumulation effect occurs because of no relationship with the previous edges of jitterd clock.//
******************************************************************************************************/				//
// integer period320 = 780*4;																							//
// integer seed = 11101;																								//
// integer jitter = 500;																									//
// /****************Jittered rising edge generating****************/													//
// always@(negedge clk320_nojitter)																					//
// 	begin nextRise <= counter + 64'd1560 + $ceil($dist_uniform (seed, -jitter, jitter)); end						//
// /****************Jittered falling edge generating****************/													//
// always@(posedge clk320_nojitter)																					//
// 	begin nextFall <= counter + 64'd1560 + $ceil($dist_uniform (seed, -jitter, jitter)); end						//
// /////////////////////////////////////////////////////////////////////////////////////////////End Line Jittered Clock//

reg start;
reg randomMode;
// reg [1:0] jitterLevel;
reg [2:0] flipError; //how many error bits (0-3 only now)
wire [9:0] fcd_ref;
wire fcData;
fastCommandGenerator fcGenInst
(
	.clk40(clk40),
	.clk1280(clk1280),
	// .jitterLevel(jitterLevel),
//	.clk320(clk320_nojitter),
	.jitterHigh(200),
	.jitterLow(-200),
	.reset(rstn),
	.start(start),
	.randomMode(randomMode),
	// .errorRate(8'd128),
	.flipError(flipError),
	.fcd_ref(fcd_ref),
	.fcData(fcData)
);

wire [9:0] fcd_ref2;
wire fcData2;
fastCommandGenerator fcGenInstRef
(
	.clk40(clk40),
	.clk1280(clk1280),
	// .jitterLevel(2'b00),
	.jitterHigh(0),
	.jitterLow(0),
	.reset(rstn),
	.start(start),
	.randomMode(randomMode),
	// .errorRate(8'd128),
	.flipError(flipError),
	.fcd_ref(fcd_ref2),
	.fcData(fcData2)
);
//wire clk320_jittered;
//assign #750 clk320_jittered = clk320_jitter;
//always@(posedge clk320_jitter) fc <= fc_byte[7];
//assign fc = fc_byte[7];

initial begin
	clk1280 = 0;
	// clk320_jitter = 0;
	// jitterLevel = 2'b01;
	// clk320_nojitter = 0;
	// clkbase = 0;
	// counter = 0;
	randomMode = 1'b1;
	flipError = 3'd1;
	start = 1'b0;
	cnt = 0;
	rstn = 1;
	clkDelayEn = 1;
	fcDelayEn = 1;

	selfAlignEn = 1;
	fccAlign = 0;


# 1000000
	rstn = 0;
# 1000000
	rstn = 1;
# 100000
   start = 1'b1;
#50000
   start = 1'b0;
   fccAlign = 1;
#50000
   fccAlign = 0;

# 300_000_000
$finish();
end

wire wordAligned;
wire invalidCmd;
fastCommandDecoderTop fastCommandDecoderTop_inst(
	.fccAlign(fccAlign),			// fast command clock align command. initialize the clock phase alignment process at its rising edge -sefAligner
	.clk1280(clk1280),				// 1.28 GHz clock -sefAligner
	.clk40(clk40),					// 40 MHz clock, RO clock -sefAligner
	.reset(rstn),					// reset, active low	
	.fc(fcData),						// fast command input
	.selfAlignEn(selfAlignEn),		// 
//	.clk320(clk320),				// 320 MHz clock  -manual
	.clkDelayEn(clkDelayEn),		// enable signal of the clock delay -manual
	.fcDelayEn(fcDelayEn),			// enable signal of the command delay  -manual
	.aligned(wordAligned),
	.invalidCmd(invalidCmd),
	.state_bitAlign(state_bitAlign),// state of the bit alignment state machine -sefAligner
	.bitError(bitError),			// error indicator of the bit alignment -sefAligner
	.ed(ed),						// detailed error indicator of the bit alignment -sefAligner
	.fcd(fcd) 
);

// wire [9:0] fc_para_In = fcd_ref;


// //******Jittered fc****** 
// localparam InputDelay00 = 53;
// wire [9:0] fc_para_InDelay00;
// delayN_10bit #(.InputDelay(InputDelay00)) delayN_10bit_inst_00(
// 	.rstn(rstn),
// 	.clk1280(clk1280),
// 	.fc_para_In(fc_para_In),
// 	.fc_para_InDelay(fc_para_InDelay00)
// );

// localparam InputDelay01 = 57;
// wire [9:0] fc_para_InDelay01;
// delayN_10bit #(.InputDelay(InputDelay01)) delayN_10bit_inst_01(
// 	.rstn(rstn),
// 	.clk1280(clk1280),
// 	.fc_para_In(fc_para_In),
// 	.fc_para_InDelay(fc_para_InDelay01)
// );

// localparam InputDelay10 = 54;
// wire [9:0] fc_para_InDelay10, fc_para_InDelay10_delay;
// delayN_10bit #(.InputDelay(InputDelay10)) delayN_10bit_inst_10(
// 	.rstn(rstn),
// 	.clk1280(clk1280),
// 	.fc_para_In(fc_para_In),
// 	.fc_para_InDelay(fc_para_InDelay10_delay)
// );
// assign #220 fc_para_InDelay10 = fc_para_InDelay10_delay;


// wire [9:0] fc_para_InDelay11;
// assign #1000 fc_para_InDelay11 = fc_para_InDelay00;

// wire [9:0] fc_para_InDelay1xx;
// //assign #41340 fc_para_InDelay1xx = fc_para_In;
// localparam InputDelay1xx = 54;
// delayN_10bit #(.InputDelay(InputDelay1xx)) delayN_10bit_inst_1xx(
// 	.rstn(rstn),
// 	.clk1280(clk1280),
// 	.fc_para_In(fc_para_In),
// 	.fc_para_InDelay(fc_para_InDelay1xx)
// );



reg [9:0] fcd_ref_reg;
reg [9:0] fcd_ref_reg1;

reg [9:0] fcd_reg;

always@(posedge clk40) begin																						//
	fcd_ref_reg1 <= fcd_ref;
	fcd_ref_reg <= fcd_ref_reg1;
	fcd_reg		<= fcd;
end	
// wire [2:0] enReg;
// assign enReg = {selfAlignEn, clkDelayEn, fcDelayEn};
// always@(*) begin
// 	case (enReg)
// 		3'b000: fcd_ref_reg <= fc_para_InDelay00;
// 		3'b001: fcd_ref_reg <= fc_para_InDelay01;
// 		3'b010: fcd_ref_reg <= fc_para_InDelay10;
// 		3'b011: fcd_ref_reg <= fc_para_InDelay11;
// 		3'b100: fcd_ref_reg <= fc_para_InDelay1xx;
// 		3'b101: fcd_ref_reg <= fc_para_InDelay1xx;
// 		3'b110: fcd_ref_reg <= fc_para_InDelay1xx;
// 		3'b111: fcd_ref_reg <= fc_para_InDelay1xx;
// 	endcase
// end

wire fcd_flag;
assign fcd_flag = |(fcd_reg^fcd_ref_reg);//fcd ^ fcd_ref_reg ? 1'b1 : 1'b0;

endmodule
