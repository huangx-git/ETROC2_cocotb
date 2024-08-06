`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sun Jan 24 14:09:46 CST 2021
// Module Name: BCIDOverflowCount
// Project Name: ETROC2 readout
// Description: For test only
// Dependencies: pixelReadout,SWCell
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"

module pixelReadoutWithSWCell #(
    parameter L1ADDRWIDTH = 7,
    parameter BCSTWIDTH  = 27
)
(
	input                   clk,            //40MHz
	input [1:0]             workMode,       //00: normal, 01: self test, periodic trigger fixed TDC data, 10: self test, random TDC data, 11: reserved
    input [8:0]             L1ADelay,
    input [7:0]             pixelID,        //from slow control
    input                   disDataReadout,     //disable data readout
    //for trigger path
    input                   disTrigPath,
    input [9:0]             upperTOATrig,
    input [9:0]             lowerTOATrig,
    input [8:0]             upperTOTTrig,
    input [8:0]             lowerTOTTrig,
    input [9:0]             upperCalTrig,
    input [9:0]             lowerCalTrig,
//event selections based on TOT/TOA/Cal
    input [9:0]             upperTOA,
    input [9:0]             lowerTOA,
    input [8:0]             upperTOT,
    input [8:0]             lowerTOT,
    input [9:0]             upperCal,
    input [9:0]             lowerCal,
    input                   addrOffset,
//    input [29:0]    TDCData,
    input [8:0]             TDC_TOT,
    input [9:0]             TDC_TOA,
    input [9:0]             TDC_Cal,
    input                   TDC_hit,
    input [2:0]             TDC_EncError,
	input [6:0]             selfTestOccupancy,  //0.1%, 1%, 2%, 5%, 10% etc
//SWCell part
	input [45:0] 	        upData,  //TDCdata 29 bits (no hit), E2A,E1A, PixelID 8 bits
	output [45:0] 	        dnData,
	input [4:0]		        upHits,
	output [4:0]	        dnHits,
	input 			        dnRead,
	output 			        upRead,
	input [BCSTWIDTH-1:0] 	dnBCST,  //load, L1A, Reset
	output [BCSTWIDTH-1:0] 	upBCST,   //
	input VDD, 
    input VSS
);

endmodule
