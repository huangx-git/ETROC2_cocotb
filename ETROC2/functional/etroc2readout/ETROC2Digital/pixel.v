//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Quan Sun
// 
// Create Date:    Sun Dec 19th 2021 
// Module Name:    pixel
// Project Name:   ETROC2
// Description: pixel including pixelAnalog and pixelReadoutWithSWCell
//
// Dependencies: 
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////

module pixel #(
    parameter L1ADDRWIDTH = 7,
    parameter BCSTWIDTH  = 27
)
(
	input [3:0] rowAddrIn,
	input [3:0] colAddrIn,
	input clkRO,
	input clkTDC,
	input strobeTDC,
	input QInj,
	input [45:0] 	        upData,  //TDCdata 29 bits (no hit), E2A,E1A, PixelID 8 bits
	output [45:0] 	        dnData,
	input [4:0]		        upHits,
	output [4:0]	        dnHits,
	input 			        dnRead,
	output 			        upRead,
	input [BCSTWIDTH-1:0] 	dnBCST,  //load, L1A, Reset
	output [BCSTWIDTH-1:0] 	upBCST   //
);

wire [1:0]     workMode;       //00: normal, 01: self test, periodic trigger fixed TDC data, 10: self test, random TDC data, 11: reserved
wire [8:0]     L1ADelay;
wire [7:0]     pixelID;        //from slow control
wire                   disDataReadout;     //disable data readout
    //for trigger path
wire                   disTrigPath;
wire [9:0]             upperTOATrig;
wire [9:0]             lowerTOATrig;
wire [8:0]             upperTOTTrig;
wire [8:0]             lowerTOTTrig;
wire [9:0]             upperCalTrig;
wire [9:0]             lowerCalTrig;
//event selections based on TOT/TOA/Cal
wire [9:0]     upperTOA;
wire [9:0]     lowerTOA;
wire [8:0]     upperTOT;
wire [8:0]     lowerTOT;
wire [9:0]     upperCal;
wire [9:0]     lowerCal;
wire           addrOffset;
//    input [29:0]    TDCData;
wire [8:0]             TDC_TOT;
wire [9:0]             TDC_TOA;
wire [9:0]             TDC_Cal;
wire                   TDC_hit;
wire [2:0]             TDC_EncError;
wire [6:0]     selfTestOccupancy;  //0.1%, 1%, 2%, 5%, 10% etc

pixelAnalog pixelAnalog_Inst(
	.rowAddrIn(rowAddrIn),
	.colAddrIn(colAddrIn),
	.clkTDC(clkTDC),
	.strobeTDC(strobeTDC),
	.QInj(QInj),
	.workMode(workMode),       //00: normal, 01: self test, periodic trigger fixed TDC data, 10: self test, random TDC data, 11: reserved
	.L1ADelay(L1ADelay),
	.pixelID(pixelID),        //from slow control
	.disDataReadout(disDataReadout),     //disable data readout
    //for trigger path
	.disTrigPath(disTrigPath),
	.upperTOATrig(upperTOATrig),
	.lowerTOATrig(lowerTOATrig),
	.upperTOTTrig(upperTOTTrig),
	.lowerTOTTrig(lowerTOTTrig),
	.upperCalTrig(upperCalTrig),
	.lowerCalTrig(lowerCalTrig),
//event selections based on TOT/TOA/Cal
	.upperTOA(upperTOA),
	.lowerTOA(lowerTOA),
	.upperTOT(upperTOT),
	.lowerTOT(lowerTOT),
	.upperCal(upperCal),
	.lowerCal(lowerCal),
	.addrOffset(addrOffset),
//    input [29:0]    TDCData,
	.TDC_TOT(TDC_TOT),
	.TDC_TOA(TDC_TOA),
	.TDC_Cal(TDC_Cal),
	.TDC_hit(TDC_hit),
	.TDC_EncError(TDC_EncError),
	.selfTestOccupancy(selfTestOccupancy)  //0.1%, 1%, 2%, 5%, 10% etc
);

pixelReadoutWithSWCell #(.L1ADDRWIDTH(L1ADDRWIDTH))pixelReadoutInst(
	.clk(clkRO),            //40MHz
	.workMode(workMode),       //00: normal, 01: self test, periodic trigger fixed TDC data, 10: self test, random TDC data, 11: reserved
	.L1ADelay(L1ADelay),
	.pixelID(pixelID),        //from slow control
	.disDataReadout(disDataReadout),     //disable data readout
    //for trigger path
	.disTrigPath(disTrigPath),
	.upperTOATrig(upperTOATrig),
	.lowerTOATrig(lowerTOATrig),
	.upperTOTTrig(upperTOTTrig),
	.lowerTOTTrig(lowerTOTTrig),
	.upperCalTrig(upperCalTrig),
	.lowerCalTrig(lowerCalTrig),
//event selections based on TOT/TOA/Cal
	.upperTOA(upperTOA),
	.lowerTOA(lowerTOA),
	.upperTOT(upperTOT),
	.lowerTOT(lowerTOT),
	.upperCal(upperCal),
	.lowerCal(lowerCal),
	.addrOffset(addrOffset),
//    input [29:0]    TDCData,
	.TDC_TOT(TDC_TOT),
	.TDC_TOA(TDC_TOA),
	.TDC_Cal(TDC_Cal),
	.TDC_hit(TDC_hit),
	.TDC_EncError(TDC_EncError),
	.selfTestOccupancy(selfTestOccupancy),  //0.1%, 1%, 2%, 5%, 10% etc
//SWCell part
	.upData(upData),  //TDCdata 29 bits (no hit), E2A,E1A, PixelID 8 bits
	.dnData(dnData),
	.upHits(upHits),
	.dnHits(dnHits),
	.dnRead(dnRead),
	.upRead(upRead),
	.dnBCST(dnBCST),  //load, L1A, Reset
	.upBCST(upBCST)   //
);

endmodule
