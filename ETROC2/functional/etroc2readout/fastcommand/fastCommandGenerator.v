`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Thu Dec 16 12:23:48 CST 2021
// Module Name: fastCommandGenerator
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////

module fastCommandGenerator
(
    input clk40,                //40 MHz clock
    input clk1280,              //1280 MHz clock, generate 320 MHz clock
    input signed [31:0] jitterHigh,
    input signed [31:0] jitterLow,
    // input [1:0] jitterLevel,         //Jitter increase from 0 to 3*390 ps
    // input clk320,               //320MHz clock, assuming its rising edge aligned with 40 MHz clock
    input reset,                //reset, active low
    input start,                //start the generator, can be asynchronization signal
    input randomMode,           //random mode or working mode. In random mode, the commands are randomlized.
                                //in working mode, only L1A/BCR and IDLE are sending out.
    // input [7:0] errorRate,
    input [2:0] flipError,      //how many bited flips in the command
    output [9:0] fcd_ref,       //send out reference for checking
    output fcData               //output data
);

localparam IDLE 		= 8'HF0; //8'b1111_0000; //2'hF0 -->n_fc = 0--3'h001 --- 8'HF0-->14 
localparam LinkReset	= 8'H33; //8'b1111_1000; //2'hF8 -->n_fc = 1--3'h002 --- 8'H33-->2
localparam BCR 			= 8'H5A; //8'b1111_0001; //2'hF1 -->n_fc = 2--3'h004 --- 8'H5A-->5
localparam SyncForTrig 	= 8'H55; //8'b1111_0010; //2'hF2 -->n_fc = 3--3'h008 --- 8'H55-->4
localparam L1A_CR 		= 8'H66; //8'b1111_1001; //2'hF9 -->n_fc = 4--3'h010 --- 8'H66-->6
localparam ChargeInj 	= 8'H69; //8'b1111_0100; //2'hF4 -->n_fc = 5--3'h020 --- 8'H69-->7 
localparam L1A 			= 8'H96; //8'b1111_0110; //2'hF6 -->n_fc = 6--3'h040 --- 8'H96-->8
localparam L1A_BCR 		= 8'H99; //8'b1111_0011; //2'hF3 -->n_fc = 7--3'h080 --- 8'H99-->9 
localparam WS_Start 	= 8'HA5; //8'b1111_1100; //2'hFC -->n_fc = 8--3'h100 --- 8'HA5-->10
localparam WS_Stop 		= 8'HAA; //8'b1111_1010; //2'hFA -->n_fc = 9--3'h200 --- 8'HAA-->11

reg [2:0] startDelay;
wire syncStart = ~startDelay[2]&startDelay[1];          //last one clock
always@(posedge clk40) begin
    if(~reset)
    begin
        startDelay      <= 3'd0;
    end
    else
    begin
        startDelay[2:0] <= {startDelay[1:0],start};
    end
end


reg [11:0] startCount;
reg init;  //initialization status 
reg started;
reg [7:0] fc_set[15:0];

always@(negedge clk40) begin
    if(~reset)
    begin
        startCount  <= 12'd0;
        init        <= 1'b0; 
        started     <= 1'b0;
        fc_set[0]    <= IDLE;
        fc_set[1]    <= LinkReset;
        fc_set[2]    <= BCR;
        fc_set[3]    <= SyncForTrig;
        fc_set[4]    <= L1A_CR;
        fc_set[5]    <= ChargeInj;
        fc_set[6]    <= L1A;
        fc_set[7]    <= L1A_BCR;
        fc_set[8]    <= WS_Start;
        fc_set[9]    <= WS_Stop;
        // fc_set[10]   <= IDLE;
        // fc_set[11]   <= IDLE;
        // fc_set[12]   <= IDLE;
        // fc_set[13]   <= IDLE;
        // fc_set[14]   <= IDLE;
        // fc_set[15]   <= IDLE;
    end
    else if(syncStart)begin
        init <= 1'b1;
        started <= 1'b1;
    end
    else if(init)
    begin
//        init <= 1'b0;
        startCount  <= startCount + 1;
        if(startCount > 12'd600)
            init  <= 1'b0;
    end
end



reg [3:0] n_fc;
reg [7:0] fc_byte_random;
reg [7:0] flipBitsReg;  //
wire [3:0] fc_cmd_index = n_fc%10; //index for checking
reg [7:0] fc_cmd_random_ref; 
// wire errorOccur;
always@(posedge clk40) begin
    if(init)
    begin
        fc_byte_random      <= IDLE;
        fc_cmd_random_ref   <= IDLE;
    end
    else
    begin
        fc_cmd_random_ref   <= fc_set[fc_cmd_index];
//        fc_byte_random      <= errorOccur ? fc_set[fc_cmd_index]^flipBitsReg : fc_set[fc_cmd_index];
        fc_byte_random      <= fc_set[fc_cmd_index]^flipBitsReg;

    end
end


	wire [14:0] prbs;
	wire [30:0] seed;
	assign seed = {31'h1BCD1234};	
	PRBS31 #(.WORDWIDTH(15),
    .FORWARDSTEPS(0)) prbs_inst(
		.clkTMR(clk40),
		.resetTMR(reset),
		.disTMR(1'b0),
		.seedTMR(seed),
		.prbsTMR(prbs)
	);

// assign errorOccur = (prbs%256) < errorRate;
always@(posedge clk40) begin
    n_fc <= prbs%10;
end
	wire [14:0] prbs2;
	wire [30:0] seed2;
	assign seed2 = {31'h1BCD4567};	
	PRBS31 #(.WORDWIDTH(15),
    .FORWARDSTEPS(0)) prbs_inst2(
		.clkTMR(clk40),
		.resetTMR(reset),
		.disTMR(1'b0),
		.seedTMR(seed2),
		.prbsTMR(prbs2)
	);

wire [2:0] eb1Pos;
wire [2:0] eb2Pos;
wire [2:0] eb3Pos;
wire [2:0] minPos12;
wire [2:0] maxPos12;
assign eb1Pos = prbs2%8;
assign eb2Pos = prbs2%7 < eb1Pos ? prbs2%7 : prbs2%7 + 1;
assign minPos12 = eb2Pos > eb1Pos ? eb1Pos : eb2Pos;
assign maxPos12 = eb2Pos < eb1Pos ? eb1Pos : eb2Pos;
assign eb3Pos = prbs2%6 < minPos12 ? prbs2%6 : 
                (prbs2%6+1) < maxPos12 ? prbs2%6 + 1 : prbs2%6 + 2;


always@(posedge clk40) begin
    if(flipError == 3'd0)
    begin
        flipBitsReg <= 8'd0;
    end
    else if (flipError == 3'd1) begin
        flipBitsReg <= 8'd1<<eb1Pos;
    end
    else if(flipError == 3'd2) begin
        flipBitsReg <= (8'd1<<eb1Pos)|(8'd1<<eb2Pos);
    end
    else if(flipError == 3'd3)
    begin
        flipBitsReg <= (8'd1<<eb1Pos)|(8'd1<<eb2Pos)|(8'd1<<eb3Pos);        
    end
end

reg [11:0] BCIDCount;
reg L1AReg;
reg BCReset;
always@(posedge clk40) begin
    if(~reset)
    begin
        L1AReg <= 1'b0;
        BCIDCount <= 12'd0;
    end
    else
    begin
        L1AReg      <= (prbs2%40 == 1);
        BCIDCount   <= BCIDCount == 12'd3563 ? 12'd0 : BCIDCount + 1;
        BCReset     <= (BCIDCount == 12'd1);
    end  
end

wire clk320;
clk320Generator dg
(
    .clk40(clk40),
    .clk1280(clk1280),
    .reset(reset),
    .enable(1'b1),
    .high(jitterHigh),
    .low(jitterLow),
//    .jitterLevel(jitterLevel),
    .clk320out(clk320)
);


reg [7:0] fc_byte;
reg [2:0] cnt_fc;
reg [7:0] fc_cmd_ref;
reg fc_data_reg;
reg [2:0] testCount;
always@(posedge clk320) begin
    if(~reset)
    begin
        testCount  <= 3'd0;
    end
	else if (started)
    begin
        testCount <= testCount + 1;
    end
end

reg [1:0] resetnReg;
always@(posedge clk40) begin
    resetnReg <= {resetnReg[0],reset};
end

always@(posedge clk320) begin
    if(~resetnReg[1])
    begin
        fc_byte <= 8'd0;
        cnt_fc  <= 3'd2;
        fc_data_reg <= 1'b0;
    end
	else if (started)
    begin
	    cnt_fc <= cnt_fc + 1;
        if(cnt_fc==3'd0)
        begin
            if(randomMode)
            begin
                fc_byte     <= fc_byte_random;
                fc_cmd_ref  <= fc_cmd_random_ref;
            end
            else
            begin
                if(L1AReg&BCReset)begin 
                    fc_byte     <= L1A_BCR;
                    fc_cmd_ref  <= L1A_BCR;
                end
                else if(L1AReg)begin 
                    fc_byte     <= L1A;
                    fc_cmd_ref  <= L1A;
                end
                else if(BCReset)begin 
                    fc_byte     <= BCR;
                    fc_cmd_ref  <= BCR;
                end
                else begin 
                    fc_byte     <= IDLE;
                    fc_cmd_ref  <= IDLE;
                end
            end
        end
        else
        begin
		    fc_byte[7:0] <= {fc_byte[6:0],fc_byte[7]}; //shift 8-bit parallel fc in 40 MHz period, serializing to 1 bit
        end
        fc_data_reg <= fc_byte[7];
    end
end

assign fcData = fc_data_reg;

reg [9:0] fcd_ref_reg;
always@(*) begin
	case (fc_cmd_ref)
				IDLE: 			begin fcd_ref_reg <= 10'b00_0000_0001; end
				LinkReset: 		begin fcd_ref_reg <= 10'b00_0000_0010; end
				BCR: 			begin fcd_ref_reg <= 10'b00_0000_0100; end
				SyncForTrig: 	begin fcd_ref_reg <= 10'b00_0000_1000; end
				L1A_CR: 		begin fcd_ref_reg <= 10'b00_0001_0000; end
				ChargeInj: 		begin fcd_ref_reg <= 10'b00_0010_0000; end
				L1A: 			begin fcd_ref_reg <= 10'b00_0100_0000; end
				L1A_BCR: 		begin fcd_ref_reg <= 10'b00_1000_0000; end
				WS_Start: 		begin fcd_ref_reg <= 10'b01_0000_0000; end
				WS_Stop: 		begin fcd_ref_reg <= 10'b10_0000_0000; end
				default: 		begin fcd_ref_reg <= 10'b00_0000_0000; end
		endcase
end
assign fcd_ref = fcd_ref_reg;

endmodule