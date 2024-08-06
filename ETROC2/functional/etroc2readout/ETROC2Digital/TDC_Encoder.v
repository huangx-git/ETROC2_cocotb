/**
 *
 *  file: TDC_Encoder.v
 *
 *  TDC_Encoder
 *  Top level module of the TDC encoder, include TOA/TOT encoder.
 *
 *  History:
 *  2019/03/13 Datao Gong    : Created
 *  2019/05/08 Datao Gong    : Add a control signal on the data path to slow control
 *  2019/08/01 Datao Gong    : Output bubble errors for testing 
 **/
//`timescale 1ns/1ps

module TDC_Encoder
(
	input [2:0] TOTCounterA,
	input [2:0] TOTCounterB,
	input [31:0] TOTRawData,

	input [2:0] TOACounterA,
	input [2:0] TOACounterB,
	input [62:0] TOARawData,

	input [2:0] CalCounterA,
	input [2:0] CalCounterB,
	input [62:0] CalRawData,
	
	input RawdataWrtClk,
	input EncdataWrtClk,
	input ResetFlag,
	input enableMon,
	
	input [2:0] level, //user defined error tolerance.
	input [6:0] offset,  //user defined offset, default is 0
	input selRawCode,//output corrected code or raw code, defined by user
    input timeStampMode, //if it is true, output calibration code as timestamp
	
	output reg [8:0] TOT_codeReg,
	output reg [9:0] TOA_codeReg,	
	output reg [9:0] Cal_codeReg,
    output reg hitFlag,	
	output reg TOTerrorFlagReg,
	output reg TOAerrorFlagReg,	
	output reg CalerrorFlagReg,	
	output wire [31:0] TOTRawDataMon, //output raw data for slow control
	output wire [62:0] TOARawDataMon,
	output wire [62:0] CalRawDataMon,
	output wire [2:0] TOTCounterAMon,
	output wire [2:0] TOTCounterBMon,	
	output wire [2:0] TOACounterAMon,
	output wire [2:0] TOACounterBMon,	
	output wire [2:0] CalCounterAMon,
	output wire [2:0] CalCounterBMon	
);

endmodule

