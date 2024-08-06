//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Quan Sun&Xing Huang
// 
// Create Date:    Oct. 4th, 2021
// Design Name:    fast command decoder
// Module Name:    fastCommand_tb
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
module fastCommand_tb;
//																		         hamming code

reg clk1280;
wire clk40;
reg startGen;
reg rstn;
reg clkDelayEn , fcDelayEn, selfAlignEn;

reg fc;
wire [3:0] ed;
wire [3:0] state_bitAlign;
wire bitError;
wire [9:0] fcd;


reg [4:0] cnt; //counter for generating 40 MHz clock
always #390 clk1280 = ~clk1280; //clk1280
always@(posedge clk1280) begin
	cnt <= cnt + 1;
end
assign clk40 = cnt[4]; //clk40
wire clk320_data; //320 MHz clock 
assign #1000 clk320_data = cnt[1];

reg [3:0] n_fc;
reg [7:0] fc_byte_random;
reg [7:0] xorFCD;  //
reg [7:0] fc_byte_random_ref;
always@(posedge clk40) begin
	if(n_fc == 9) 
		n_fc <= 0;
	else
		n_fc <= n_fc + 1;
	case(n_fc)
		0: begin fc_byte_random <=        IDLE^xorFCD; 	fc_byte_random_ref <= IDLE; 		end 
		1: begin fc_byte_random <=   LinkReset^xorFCD; 	fc_byte_random_ref <= LinkReset; 	end
		2: begin fc_byte_random <=         BCR^xorFCD; 	fc_byte_random_ref <= BCR; 			end
		3: begin fc_byte_random <= SyncForTrig^xorFCD; 	fc_byte_random_ref <= SyncForTrig; 	end
		4: begin fc_byte_random <=      L1A_CR^xorFCD; 	fc_byte_random_ref <= L1A_CR; 		end
		5: begin fc_byte_random <=   ChargeInj^xorFCD; 	fc_byte_random_ref <= ChargeInj; 	end
		6: begin fc_byte_random <=         L1A^xorFCD; 	fc_byte_random_ref <= L1A; 			end
		7: begin fc_byte_random <=     L1A_BCR^xorFCD; 	fc_byte_random_ref <= L1A_BCR; 		end
		8: begin fc_byte_random <=    WS_Start^xorFCD; 	fc_byte_random_ref <= WS_Start; 	end
		9: begin fc_byte_random <=     WS_Stop^xorFCD; 	fc_byte_random_ref <= WS_Stop; 		end
		default: begin  fc_byte_random <= IDLE^xorFCD; 	fc_byte_random_ref <= IDLE; 		end
	endcase // this case means the command will roll from 0 to 9 when cmd_sw = 1, and then keep looping
end

wire [7:0] fc_byte_wire;
wire [7:0] fc_byte_wire_ref;
reg cmd_sw;//, cmd_sw_linkReset;
assign fc_byte_wire = cmd_sw ? fc_byte_random : IDLE; //cmd_sw = 0, fc sends idle commands

assign fc_byte_wire_ref = cmd_sw ? fc_byte_random_ref : IDLE;

reg [2:0] cnt_fc;
reg [7:0] fc_byte;
always@(posedge clk320_data) begin
	cnt_fc <= cnt_fc + 1;
	if(cnt_fc==0)
		fc_byte <= fc_byte_wire; //sampling parallel 8 bits fc at 320 MHz clock
	else
		fc_byte[7:0] <= {fc_byte[6:0],fc_byte[7]}; //shift 8-bit parallel fc in 40 MHz period, serializing to 1 bit
end


//Start Line Jittered Clock///////////////////////////////////////////////////////////////////////////////////////////
/*****************************************************************************************************				//
//clkbase is counting at 1 ps period clkbase which decides the non-jittered clk320 and jittered clk320.				//
*****************************************************************************************************/				//
reg clkbase;																										//
reg [63:0] counter;																									//
reg [63:0] nextRise;																								//
reg [63:0] nextFall;																								//
reg clk320_jitter, clk320_nojitter; //320 MHz nonjittered and jittered clock										//
always #0.5 clkbase = ~clkbase; //0.1 ps time resolution															//
																													//
always@(posedge clkbase) begin																						//
/****************************clkbase-based counter****************************/										//
		counter <= counter + 1; 																					//
/******************ideal 320 MHz clock clkbase-based counter******************/										//
    //if(((counter-counter%1560)/1560)%2)																			//
	if((counter/1560)%2) begin clk320_nojitter <= 1'b0; end															//
    else begin clk320_nojitter <= 1'b1; end																			//
/****************non-ideal 320 MHz clock clkbase-based counter****************/										//
    if(counter == nextRise) clk320_jitter <= 1'b1;																	//
    else if(counter == nextFall) clk320_jitter <= 1'b0;																//
end																													//
																													//
/*****************************************************************************************************				//
//The jitter of the next edge is added based on the current ideal clock edge. If the rising edge of the ideal clock //
is detected, the coming falling edge of the jittered clock is calculated by adding the random number to the clkbase	//
-based counter, and vice versa. Each jitter generation is fully based on the current period of the ideal clock 		//
independently. No accumulation effect occurs because of no relationship with the previous edges of jitterd clock.//
******************************************************************************************************/				//
integer period320 = 780*4;																							//
integer seed = 11101;																								//
integer jitter = 500;																									//
/****************Jittered rising edge generating****************/													//
always@(negedge clk320_nojitter)																					//
	begin nextRise <= counter + 64'd1560 + $ceil($dist_uniform (seed, -jitter, jitter)); end						//
/****************Jittered falling edge generating****************/													//
always@(posedge clk320_nojitter)																					//
	begin nextFall <= counter + 64'd1560 + $ceil($dist_uniform (seed, -jitter, jitter)); end						//
/////////////////////////////////////////////////////////////////////////////////////////////End Line Jittered Clock//


//wire clk320_jittered;
//assign #750 clk320_jittered = clk320_jitter;
always@(posedge clk320_jitter) fc <= fc_byte[7];
//assign fc = fc_byte[7];

initial begin
	clk1280 = 0;
	clk320_jitter = 0;
	clk320_nojitter = 0;
	clkbase = 0;
	counter = 0;
	cnt_fc = 0;
	n_fc = 0;
	cnt = 0;
	cmd_sw = 0;

	xorFCD = 8'b0000_0000;

	rstn = 1;
	clkDelayEn = 1;
	fcDelayEn = 1;

	selfAlignEn = 0;
	fccAlign = 0;


# 1000000
	rstn = 0;
# 1000000
	rstn = 1;
# 100000
	cmd_sw = 1;
	xorFCD = 8'b0000_0000;


/*
//NO.1--> manual, no delay
# 100000
	clkDelayEn = 0;
	fcDelayEn = 1;
	cmd_sw = 0;
# 100000
	cmd_sw = 1;
*/

/*
//NO.2--> manual, delay fc only
# 10000000
	clkDelayEn = 1;
	fcDelayEn = 0;
//	rstn = 0;
	cmd_sw = 0;
# 1000000
	rstn = 1;
# 100000
	cmd_sw = 1;
*/

/*
//NO.3--> manual, delay clock only
# 80000000
	clkDelayEn = 1;
	fcDelayEn = 0;
//	rstn = 0;
	cmd_sw = 0;
# 1000000
	rstn = 1;
# 100000
	cmd_sw = 1;
*/

/*
//NO.4--> manual, delay fc and clock
# 80000000
	clkDelayEn = 1;
	fcDelayEn = 1;
//	rstn = 0;
	cmd_sw = 0;
# 1000000
	rstn = 1;
# 100000
	cmd_sw = 1;
*/

/*
//NO.5--> selfAlign
//# 80000000
//	rstn = 0;
	cmd_sw = 0;
	fccAlign = 0;
# 1000000
	rstn = 1;
# 1000000
	selfAlignEn = 1;
# 1000000
	fccAlign = 1;
# 1000000
	fccAlign = 0;
# 10000000
	cmd_sw = 1;
	xorFCD = 8'b0000_0111;
*/

# 20_000_000
$finish();
end


fastCommandDecoderTop fastCommandDecoderTop_inst(
	.fccAlign(fccAlign),			// fast command clock align command. initialize the clock phase alignment process at its rising edge -sefAligner
	.clk1280(clk1280),				// 1.28 GHz clock -sefAligner
	.clk40(clk40),					// 40 MHz clock, RO clock -sefAligner
	.rstn(rstn),					// reset, active low	
	.fc(fc),						// fast command input
	.selfAlignEn(selfAlignEn),		// 
//	.clk320(clk320),				// 320 MHz clock  -manual
	.clkDelayEn(clkDelayEn),		// enable signal of the clock delay -manual
	.fcDelayEn(fcDelayEn),			// enable signal of the command delay  -manual

	.state_bitAlign(state_bitAlign),// state of the bit alignment state machine -sefAligner
	.bitError(bitError),			// error indicator of the bit alignment -sefAligner
	.ed(ed),						// detailed error indicator of the bit alignment -sefAligner
	.fcd(fcd) 
);

reg [9:0] fc_para_In;
always@(*) begin
	case (fc_byte_wire_ref)
				IDLE: 			begin fc_para_In <= 10'b00_0000_0001; end
				LinkReset: 		begin fc_para_In <= 10'b00_0000_0010; end
				BCR: 			begin fc_para_In <= 10'b00_0000_0100; end
				SyncForTrig: 	begin fc_para_In <= 10'b00_0000_1000; end
				L1A_CR: 		begin fc_para_In <= 10'b00_0001_0000; end
				ChargeInj: 		begin fc_para_In <= 10'b00_0010_0000; end
				L1A: 			begin fc_para_In <= 10'b00_0100_0000; end
				L1A_BCR: 		begin fc_para_In <= 10'b00_1000_0000; end
				WS_Start: 		begin fc_para_In <= 10'b01_0000_0000; end
				WS_Stop: 		begin fc_para_In <= 10'b10_0000_0000; end
				default: 		begin fc_para_In <= 10'b00_0000_0000; end
		endcase
end

//******Jittered clk1280******
/* 
localparam InputDelay00 = 54;
wire [9:0] fc_para_InDelay00;
delayN_10bit #(.InputDelay(InputDelay00)) delayN_10bit_inst_00(
	.rstn(rstn),
	.clk1280(clk1280),
	.fc_para_In(fc_para_In),
	.fc_para_InDelay(fc_para_InDelay00)
);

localparam InputDelay01 = 24;
wire [9:0] fc_para_InDelay01;
delayN_10bit #(.InputDelay(InputDelay00)) delayN_10bit_inst_01(
	.rstn(rstn),
	.clk1280(clk1280),
	.fc_para_In(fc_para_In),
	.fc_para_InDelay(fc_para_InDelay01)
);

localparam InputDelay10 = 51;
wire [9:0] fc_para_InDelay10;
delayN_10bit #(.InputDelay(InputDelay10)) delayN_10bit_inst_10(
	.rstn(rstn),
	.clk1280(clk1280),
	.fc_para_In(fc_para_In),
	.fc_para_InDelay(fc_para_InDelay10)
);
//assign 

wire [9:0] fc_para_InDelay11;
assign #1000 fc_para_InDelay11 = fc_para_InDelay00;

wire [9:0] fc_para_InDelay1xx;
//assign #41340 fc_para_InDelay1xx = fc_para_In;
localparam InputDelay1xx = 52;
delayN_10bit #(.InputDelay(InputDelay1xx)) delayN_10bit_inst_1xx(
	.rstn(rstn),
	.clk1280(clk1280),
	.fc_para_In(fc_para_In),
	.fc_para_InDelay(fc_para_InDelay1xx)
);
*/

//******Jittered fc****** 
localparam InputDelay00 = 53;
wire [9:0] fc_para_InDelay00;
delayN_10bit #(.InputDelay(InputDelay00)) delayN_10bit_inst_00(
	.rstn(rstn),
	.clk1280(clk1280),
	.fc_para_In(fc_para_In),
	.fc_para_InDelay(fc_para_InDelay00)
);

localparam InputDelay01 = 57;
wire [9:0] fc_para_InDelay01;
delayN_10bit #(.InputDelay(InputDelay01)) delayN_10bit_inst_01(
	.rstn(rstn),
	.clk1280(clk1280),
	.fc_para_In(fc_para_In),
	.fc_para_InDelay(fc_para_InDelay01)
);

localparam InputDelay10 = 54;
wire [9:0] fc_para_InDelay10, fc_para_InDelay10_delay;
delayN_10bit #(.InputDelay(InputDelay10)) delayN_10bit_inst_10(
	.rstn(rstn),
	.clk1280(clk1280),
	.fc_para_In(fc_para_In),
	.fc_para_InDelay(fc_para_InDelay10_delay)
);
assign #220 fc_para_InDelay10 = fc_para_InDelay10_delay;


wire [9:0] fc_para_InDelay11;
assign #1000 fc_para_InDelay11 = fc_para_InDelay00;

wire [9:0] fc_para_InDelay1xx;
//assign #41340 fc_para_InDelay1xx = fc_para_In;
localparam InputDelay1xx = 54;
delayN_10bit #(.InputDelay(InputDelay1xx)) delayN_10bit_inst_1xx(
	.rstn(rstn),
	.clk1280(clk1280),
	.fc_para_In(fc_para_In),
	.fc_para_InDelay(fc_para_InDelay1xx)
);



reg [9:0] fcd_ref;
wire [2:0] enReg;
assign enReg = {selfAlignEn, clkDelayEn, fcDelayEn};
always@(*) begin
	case (enReg)
		3'b000: fcd_ref <= fc_para_InDelay00;
		3'b001: fcd_ref <= fc_para_InDelay01;
		3'b010: fcd_ref <= fc_para_InDelay10;
		3'b011: fcd_ref <= fc_para_InDelay11;
		3'b100: fcd_ref <= fc_para_InDelay1xx;
		3'b101: fcd_ref <= fc_para_InDelay1xx;
		3'b110: fcd_ref <= fc_para_InDelay1xx;
		3'b111: fcd_ref <= fc_para_InDelay1xx;
	endcase
end

wire fcd_flag;
assign fcd_flag = fcd ^ fcd_ref ? 1'b1 : 1'b0;

endmodule
