//Verilog HDL for "ETROC2_TDCWrap", "ETROC2_TDC" "functional"


module ETROC2_TDC ( CalCounterAMon, CalCounterBMon, CalRawDataMon, Cal_codeReg,
CalerrorFlagReg, DBF_QC, RO_DBF_QC, TOACounterAMon, TOACounterBMon, TOARawDataMon,
TOA_codeReg, TOAerrorFlagReg, TOTCounterAMon, TOTCounterBMon, TOTRawDataMon,
TOT_codeReg, TOTerrorFlagReg, hitFlag, vdd, vss, autoReset, clk40, clk320, enable,
enableMon, level, offset, polaritySel, pulse, resetn, selRawCode, testMode,
timeStampMode );

  input testMode;
  output  [2:0] CalCounterAMon;
  output  [2:0] TOTCounterBMon;
  output hitFlag;
  input selRawCode;
  output  [2:0] CalCounterBMon;
  input  [2:0] level;
  output  [2:0] TOACounterAMon;
  input vdd;
  output  [2:0] TOACounterBMon;
  input clk40;
  input polaritySel;
  output  [62:0] TOARawDataMon;
  output  [9:0] TOA_codeReg;
  output  [5:0] DBF_QC;
  output  [8:0] TOT_codeReg;
  input timeStampMode;
  output CalerrorFlagReg;
  output  [5:0] RO_DBF_QC;
  input pulse;
  input  [6:0] offset;
  output TOAerrorFlagReg;
  output TOTerrorFlagReg;
  output  [9:0] Cal_codeReg;
  input enable;
  input resetn;
  input enableMon;
  output  [31:0] TOTRawDataMon;
  output  [2:0] TOTCounterAMon;
  input autoReset;
  output  [62:0] CalRawDataMon;
  input vss;
  input clk320;

wire start;
wire TOA_clk;
wire TOA_Latch;
wire TOT_clk;
wire TOTReset;
wire TOAReset;
wire RawdataWrtClk;
wire EncdataWrtClk;
wire ResetFlag;

TDC_controller controllerInst
(
	.pulse(pulse),
	.clk40(clk40),
	.clk320(clk320),
	.enable(enable),
	.testMode(testMode),
	.polaritySel(polaritySel),
	.resetn(resetn),
	.autoReset(autoReset),
	.start(start),
	.TOA_clk(TOA_clk),
	.TOA_Latch(TOA_Latch),	
	.TOT_clk(TOT_clk),
	.TOTReset(TOTReset),
	.TOAReset(TOAReset),	
	.RawdataWrtClk(RawdataWrtClk),
	.EncdataWrtClk(EncdataWrtClk),
	.ResetFlag(ResetFlag)
);

	wire [2:0] TOACounterA;
	wire [2:0] TOACounterB;
	wire [62:0] TOARawData;
	
	wire [2:0] CalCounterA;
	wire [2:0] CalCounterB;
	wire [62:0] CalRawData;
	
	wire [2:0] TOTCounterA;
	wire [2:0] TOTCounterB;
	wire [31:0] TOTRawData;
	
TDC_delayLine delayLinInst
(
	.start(start),
	.TOA_clk(TOA_clk),
	.TOT_clk(TOT_clk),	
	.TOTReset(TOTReset),
	.TOAReset(TOAReset),	
	.TOA_Latch(TOA_Latch),
	.TOACounterA(TOACounterA),
	.TOACounterB(TOACounterB),	
	.TOARawData(TOARawData),
	.CalCounterA(CalCounterA),
	.CalCounterB(CalCounterB),
	.CalRawData(CalRawData),
	.TOTCounterA(TOTCounterA),
	.TOTCounterB(TOTCounterB),
	.TOTRawData(TOTRawData)
);

	//wire [8:0] TOT_codeReg;
	//wire [9:0] TOA_codeReg;	
	//wire [9:0] Cal_codeReg;
   // wire hitFlag;	
	//wire TOTerrorFlagReg;
	//wire TOAerrorFlagReg;	
	//wire CalerrorFlagReg;	
	// wire [31:0] TOTRawDataMon; //output raw data for slow control
	// wire [62:0] TOARawDataMon;
	// wire [62:0] CalRawDataMon;
	// wire [2:0] TOTCounterAMon;
	// wire [2:0] TOTCounterBMon;	
	// wire [2:0] TOACounterAMon;
	// wire [2:0] TOACounterBMon;	
	// wire [2:0] CalCounterAMon;
	// wire [2:0] CalCounterBMon;	

TDC_Encoder encoderInst
(
	.TOTCounterA(TOTCounterA),
	.TOTCounterB(TOTCounterB),
	.TOTRawData(TOTRawData),
	.TOACounterA(TOACounterA),
	.TOACounterB(TOACounterB),	
	.TOARawData(TOARawData),
	.CalCounterA(CalCounterA),
	.CalCounterB(CalCounterB),
	.CalRawData(CalRawData),
	.RawdataWrtClk(RawdataWrtClk),
	.EncdataWrtClk(EncdataWrtClk),
	.ResetFlag(ResetFlag),
	.enableMon(enableMon),
	.level(level),
	.offset(offset),
	.selRawCode(selRawCode),
	.timeStampMode(timeStampMode),
	.TOT_codeReg(TOT_codeReg),
	.TOA_codeReg(TOA_codeReg),
	.Cal_codeReg(Cal_codeReg),
	.hitFlag(hitFlag),
	.TOTerrorFlagReg(TOTerrorFlagReg),
	.TOAerrorFlagReg(TOAerrorFlagReg),
	.CalerrorFlagReg(CalerrorFlagReg),
	.TOTRawDataMon(TOTRawDataMon),
	.TOARawDataMon(TOARawDataMon),
	.CalRawDataMon(CalRawDataMon),
	.TOTCounterAMon(TOTCounterAMon),
	.TOTCounterBMon(TOTCounterBMon),
	.TOACounterAMon(TOACounterAMon),
	.TOACounterBMon(TOACounterBMon),
	.CalCounterAMon(CalCounterAMon),
	.CalCounterBMon(CalCounterBMon)
);

assign DBF_QC     = 6'd0;
assign RO_DBF_QC  = 6'd0;

endmodule

