//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Quan Sun
// 
// Create Date:    Fri Nov 12th 2021 
// Module Name:    pixelAnalog
// Project Name:   ETROC2
// Description: a block box for pixel analog
//
// Dependencies: 
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////

`define SIM
module pixelAnalog (
input [3:0] rowAddrIn,
input [3:0] colAddrIn,
input clkTDC,
input strobeTDC,
input QInj,
output [1:0]     workMode,       //00: normal, 01: self test, periodic trigger fixed TDC data, 10: self test, random TDC data, 11: reserved
output [8:0]     L1ADelay,
output [7:0]     pixelID,        //from slow control
output                   disDataReadout,     //disable data readout
    //for trigger path
output                   disTrigPath,
output [9:0]             upperTOATrig,
output [9:0]             lowerTOATrig,
output [8:0]             upperTOTTrig,
output [8:0]             lowerTOTTrig,
output [9:0]             upperCalTrig,
output [9:0]             lowerCalTrig,
//event selections based on TOT/TOA/Cal
output [9:0]     upperTOA,
output [9:0]     lowerTOA,
output [8:0]     upperTOT,
output [8:0]     lowerTOT,
output [9:0]     upperCal,
output [9:0]     lowerCal,
output           addrOffset,
//    input [29:0]    TDCData,
output [8:0]             TDC_TOT,
output [9:0]             TDC_TOA,
output [9:0]             TDC_Cal,
output                   TDC_hit,
output [2:0]             TDC_EncError,
output [6:0]     selfTestOccupancy  //0.1%, 1%, 2%, 5%, 10% etc
);
// TDC pinout declaration
wire [2:0] TOTCounterA;
wire [2:0] TOTCounterB;
wire [31:0] TOTRawData;

wire [2:0] TOACounterA;
wire [2:0] TOACounterB;
wire [62:0] TOARawData;

wire [2:0] CalCounterA;
wire [2:0] CalCounterB;
wire [62:0] CalRawData;

wire RawdataWrtClk;
wire EncdataWrtClk;
wire ResetFlag;
wire enableMon;

wire [2:0] level;
wire [6:0] offset;

wire selRawCode;
wire timeStampMode;

/*
wire [8:0] TOT_codeReg;
wire [9:0] TOA_codeReg;
wire [9:0] Cal_codeReg;
wire hitFlag;
wire TOTerrorFlagReg;
wire TOAerrorFlagReg;
wire CalerrorFlagReg;
*/

wire [31:0] TOTRawDataMon;
wire [62:0] TOARawDataMon;
wire [62:0] CalRawDataMon;
wire [2:0] TOTCounterAMon;
wire [2:0] TOTCounterBMon;
wire [2:0] TOACounterAMon;
wire [2:0] TOACounterBMon;
wire [2:0] CalCounterAMon;
wire [2:0] CalCounterBMon;


// slow control for pixel readout declaration
wire [1:0]     workMode_int;       //00: normal, 01: self test, periodic trigger fixed TDC data, 10: self test, random TDC data, 11: reserved
wire [8:0]     L1ADelay_int;
wire [7:0]     pixelID_int;        //from slow control
wire                   disDataReadout_int;     //disable data readout
    //for trigger path
wire                   disTrigPath_int;
wire [9:0]             upperTOATrig_int;
wire [9:0]             lowerTOATrig_int;
wire [8:0]             upperTOTTrig_int;
wire [8:0]             lowerTOTTrig_int;
wire [9:0]             upperCalTrig_int;
wire [9:0]             lowerCalTrig_int;
//event selections based on TOT/TOA/Cal
wire [9:0]     upperTOA_int;
wire [9:0]     lowerTOA_int;
wire [8:0]     upperTOT_int;
wire [8:0]     lowerTOT_int;
wire [9:0]     upperCal_int;
wire [9:0]     lowerCal_int;
wire           addrOffset_int;
//    input [29:0]    TDCData,

wire [6:0]     selfTestOccupancy_int;  //0.1%, 1%, 2%, 5%, 10% etc

//Slow control for pixel Readout assignment
assign workMode_int = 2'b10;
assign L1ADelay_int = 9'd501;
assign pixelID_int = {colAddrIn,rowAddrIn};
assign disDataReadout_int = 1'b0;
assign disTrigPath_int = 1'b0;
assign upperTOATrig_int = 10'h3FF;
assign lowerTOATrig_int = 10'h000;
assign upperTOTTrig_int = 9'h1FF;
assign lowerTOTTrig_int = 9'h000;
assign upperCalTrig_int = 10'h3FF;
assign lowerCalTrig_int = 10'h000;
assign upperTOA_int = 10'h3FF;
assign lowerTOA_int = 10'h000;
assign upperTOT_int = 9'h1FF;
assign lowerTOT_int = 9'h000;
assign upperCal_int = 10'h3FF;
assign lowerCal_int = 10'h000;
assign addrOffset_int = 1'b1;
assign selfTestOccupancy_int= 7'h02;  //0.1%, 1%, 2%, 5%, 10% etc

wire strobeTDC_int, clkTDC_int, QInj_int;

pixelAnalogInBuf #(.WIDTH(1)) IB_QInj (.I(QInj), .Z(QInj_int));
pixelAnalogInBuf #(.WIDTH(1)) IB_clkTDC (.I(clkTDC), .Z(clkTDC_int));
pixelAnalogInBuf #(.WIDTH(1)) IB_strobeTDC (.I(strobeTDC), .Z(strobeTDC_int));


pixelAnalogOutBuf #(.WIDTH(2)) OB_workMode (.I(workMode_int), .Z(workMode));
pixelAnalogOutBuf #(.WIDTH(9)) OB_L1ADelay (.I(L1ADelay_int), .Z(L1ADelay));
pixelAnalogOutBuf #(.WIDTH(8)) OB_pixelID (.I(pixelID_int), .Z(pixelID));
pixelAnalogOutBuf #(.WIDTH(1)) OB_disDataReadout (.I(disDataReadout_int), .Z(disDataReadout));
pixelAnalogOutBuf #(.WIDTH(1)) OB_disTrigPath (.I(disTrigPath_int), .Z(disTrigPath));
pixelAnalogOutBuf #(.WIDTH(10)) OB_upperTOATrig (.I(upperTOATrig_int), .Z(upperTOATrig));
pixelAnalogOutBuf #(.WIDTH(10)) OB_lowerTOATrig (.I(lowerTOATrig_int), .Z(lowerTOATrig));
pixelAnalogOutBuf #(.WIDTH(9)) OB_upperTOTTrig (.I(upperTOTTrig_int), .Z(upperTOTTrig));
pixelAnalogOutBuf #(.WIDTH(9)) OB_lowerTOTTrig (.I(lowerTOTTrig_int), .Z(lowerTOTTrig));
pixelAnalogOutBuf #(.WIDTH(10)) OB_upperCalTrig (.I(upperCalTrig_int), .Z(upperCalTrig));
pixelAnalogOutBuf #(.WIDTH(10)) OB_lowerCalTrig (.I(lowerCalTrig_int), .Z(lowerCalTrig));
pixelAnalogOutBuf #(.WIDTH(10)) OB_upperTOA (.I(upperTOA_int), .Z(upperTOA));
pixelAnalogOutBuf #(.WIDTH(10)) OB_lowerTOA (.I(lowerTOA_int), .Z(lowerTOA));
pixelAnalogOutBuf #(.WIDTH(9)) OB_upperTOT (.I(upperTOT_int), .Z(upperTOT));
pixelAnalogOutBuf #(.WIDTH(9)) OB_lowerTOT (.I(lowerTOT_int), .Z(lowerTOT));
pixelAnalogOutBuf #(.WIDTH(10)) OB_upperCal (.I(upperCal_int), .Z(upperCal));
pixelAnalogOutBuf #(.WIDTH(10)) OB_lowerCal (.I(lowerCal_int), .Z(lowerCal));
pixelAnalogOutBuf #(.WIDTH(1)) OB_addrOffset (.I(addrOffset_int), .Z(addrOffset));
pixelAnalogOutBuf #(.WIDTH(7)) OB_selfTestOccupancy (.I(selfTestOccupancy_int), .Z(selfTestOccupancy));





// TDC input section
assign TOTCounterA = 0;
assign TOTCounterB = 0;
assign TOTRawData = 0;
assign TOACounterA = 0;
assign TOACounterB = 0;
assign CalRawData = 0;
assign RawdataWrtClk = ~clkTDC;
assign EncdataWrtClk = ~clkTDC;
assign ResetFlag = 0;
assign enableMon = 0;
assign level = 0;
assign offset = 0;
assign selRawCode = 0;
assign timeStampMode = 0;



TDC_Encoder TDC_Encoder_Inst(
	.TOTCounterA(TOTCounterA),
	.TOTCounterB(TOTCounterB),
	.TOTRawData(TOTRawData) ,

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
	
	.level(level), //user defined error tolerance.
	.offset(offset),  //user defined offset, default is 0
	.selRawCode(selRawCode),//output corrected code or raw code, defined by user
	.timeStampMode(timeStampMode), //if it is true, output calibration code as timestamp
	
	.TOT_codeReg(TDC_TOT),
	.TOA_codeReg(TDC_TOA),	
	.Cal_codeReg(TDC_Cal),
    	.hitFlag(TDC_hit),	
	.TOTerrorFlagReg(TDC_EncError[0]),
	.TOAerrorFlagReg(TDC_EncError[1]),	
	.CalerrorFlagReg(TDC_EncError[2]),	
	.TOTRawDataMon(TOTRawDataMon), //output raw data for slow control
	.TOARawDataMon(TOARawDataMon),
	.CalRawDataMon(CalRawDataMon),
	.TOTCounterAMon(TOTCounterAMon),
	.TOTCounterBMon(TOTCounterBMon),	
	.TOACounterAMon(TOACounterAMon),
	.TOACounterBMon(TOACounterBMon),	
	.CalCounterAMon(CalCounterAMon),
	.CalCounterBMon(CalCounterBMon)	
);




endmodule

module pixelAnalogInBuf #(
  parameter WIDTH = 16
)(
  input [WIDTH-1:0] I,
  output [WIDTH-1:0] Z
);

  genvar i;
  generate
  for(i=0; i<WIDTH; i=i+1) begin
    `ifdef SIM
	assign Z[i] = I[i];
    `else
	CKBD1 B_preserve(.I(I[i]), .Z(Z[i]));
    `endif
  end
  endgenerate
endmodule

module pixelAnalogOutBuf #(
  parameter WIDTH = 16
)(
  input [WIDTH-1:0] I,
  output [WIDTH-1:0] Z
);
  genvar i;
  generate
  for(i=0; i<WIDTH; i=i+1) begin
    `ifdef SIM
	assign Z[i] = I[i];
    `else
	CKBD1 B_preserve(.I(I[i]), .Z(Z[i]));
    `endif
  end
  endgenerate
endmodule
