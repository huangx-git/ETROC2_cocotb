/**
 *
 *  file: TDC_tb.v
 *
 *  TDC_tb
 *  ideal delayline, ideal controller and actual encoder test.
 *
 *  History:
 *	2019/03/15 Hanhan Sun    : Created
 **/

`timescale 1ps/100fs

//******Module Declaration******
module pulseGenerator 
(
	input clk40,
	input clk1M,    //1M MHz, 1 ps clock period
	input [15:0] width,   //1 ps resolution
	input [15:0] delay,   //1 ps resolution
	output pulse   //output signal
);

	reg [15:0] tickCounter;
	reg clk40D;
	wire  clk40RisingEdge =  ~clk40D & clk40;
	always @(posedge clk1M)
	begin
		clk40D <= clk40;
		if(clk40RisingEdge)
		begin
			tickCounter		<= 16'd0;
		end
		else 
		begin
			tickCounter 	<= tickCounter + 1;
		end
	end 

	wire [15:0] startSession = delay;
	wire [15:0] endSession   = delay + width;
	reg pulseReg;
	always @(posedge clk1M)
	begin
		if(tickCounter > startSession && tickCounter <= endSession)
		begin
			pulseReg	<= 1'b1;
		end
		else 
		begin
			pulseReg 	<= 1'b0;
		end
	end 

	assign pulse = pulseReg;

endmodule

module TDC_tb;

//******Signal Declaration******

wire pulse;
reg pulse2;
reg pulse3;
reg clk40;
reg clk1M;
reg [15:0] pulseWidth;
reg [15:0] pulseDelay;

pulseGenerator pulseGeneratorInst
(
	.clk40(clk40),
	.clk1M(clk1M),
	.delay(pulseDelay),
	.width(pulseWidth),
	.pulse(pulse)
);

reg [1:0] pulseControl;
//00: delay = 0, width = 6ns, prepare for delay scan
//01: width unchange, delay increase to 12.5 ns
//10: delay = 3 ns, width is 0.1 ns
//11: delay un change, increase width to 12.5 ns

always @(posedge clk40)
begin
	if(pulseControl == 2'b00)begin
		pulseWidth <= 16'd6000;   //width 6 ns
		pulseDelay <= 16'd12000;
	end
	else if(pulseControl == 2'b01)
	begin
		if(pulseDelay == 16'd25000)begin
			pulseDelay <= 16'd12000;
		end
		else 
		begin
			pulseDelay <= pulseDelay + 1;
		end
	end
	else if (pulseControl == 2'b10)
	begin
		pulseWidth <= 16'd100;   //width 6 ns
		pulseDelay <= 16'd18500;		
	end
	else  //(pulseControl == 2'b11) 
	begin
		if(pulseWidth == 16'd12500)begin
			pulseWidth <= 16'd100;
		end
		else 
		begin
			pulseWidth <= pulseWidth + 1;
		end		
	end
end

reg clk320;
reg enable;
reg testMode;
reg polaritySel;
reg resetn;
reg autoReset;
reg vdd;
reg vss;
reg enableMon;
reg [2:0] level;
reg [6:0] offset;
reg selRawCode;
reg timeStampMode;

parameter TOA = 3000; //typical : 3000
parameter TOT = 6000; //typical : 6000

wire [2:0] CalCounterAMon;
wire [2:0] CalCounterBMon;
wire [62:0] CalRawDataMon;
wire [9:0] Cal_codeReg;
wire CalerrorFlagReg;

wire [2:0] TOACounterAMon;
wire [2:0] TOACounterBMon;
wire [62:0] TOARawDataMon;
wire [9:0] TOA_codeReg;
wire TOAerrorFlagReg;

wire [2:0] TOTCounterAMon;
wire [2:0] TOTCounterBMon;
wire [31:0] TOTRawDataMon;
wire [8:0] TOT_codeReg;
wire TOTerrorFlagReg;

wire [5:0] DBF_QC;
wire [5:0] RO_DBF_QC;

wire hitFlag;

//******Instantiation of Top-level Design******
ETROC2_TDC TDCInst(
	.CalCounterAMon(CalCounterAMon), 
	.CalCounterBMon(CalCounterBMon), 
	.CalRawDataMon(CalRawDataMon), 
	.Cal_codeReg(Cal_codeReg),
	.CalerrorFlagReg(CalerrorFlagReg), 
	.DBF_QC(DBF_QC), 
	.RO_DBF_QC(RO_DBF_QC), 
	.TOACounterAMon(TOACounterAMon), 
	.TOACounterBMon(TOACounterBMon), 
	.TOARawDataMon(TOARawDataMon),
	.TOA_codeReg(TOA_codeReg), 
	.TOAerrorFlagReg(TOAerrorFlagReg), 
	.TOTCounterAMon(TOTCounterAMon), 
	.TOTCounterBMon(TOTCounterBMon), 
	.TOTRawDataMon(TOTRawDataMon),
	.TOT_codeReg(TOT_codeReg), 
	.TOTerrorFlagReg(TOTerrorFlagReg), 
	.hitFlag(hitFlag), 
	.vdd(vdd), 
	.vss(vss), 
	.autoReset(autoReset), 
	.clk40(clk40), 
	.clk320(clk320), 
	.enable(enable),
	.enableMon(enableMon), 
	.level(level), 
	.offset(offset), 
	.polaritySel(polaritySel), 
	.pulse(pulse), 
	.resetn(resetn), 
	.selRawCode(selRawCode), 
	.testMode(testMode),
	.timeStampMode(timeStampMode) 		
);
//******Provide Stimulus******
	initial begin //this process block specifies the stimulus.
		clk40=0;
		clk320=0;
		clk1M = 1'b0;
		enable=1'b1;
		testMode=0;
		polaritySel=1'b1;
		resetn=0;
		autoReset=0;
		vdd = 1;
		vss = 0;
		enableMon = 0;
		level = 3'b11;
		offset = 7'd0;
		selRawCode = 1'b0;
		timeStampMode = 1'b0;
		pulseControl = 2'b00;
		#5000 resetn=1'b1;
		#50000 pulseControl = 2'b01;
		#350000000 pulseControl = 2'b10;
		#500 pulseControl = 2'b11;
		#350000000 $stop;
	end
	
always
		#12500 clk40 = !clk40;
		
always 
		#0.5 clk1M = !clk1M;
			
always 
		begin
		#12500 clk320=1'b1;
		#1562.5 clk320=0;
		#1562.5 clk320=1'b1;
		#1562.5 clk320=0;
		#7812.5 clk320=0;
		end

endmodule
