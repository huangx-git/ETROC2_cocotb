//////////////////////////////////////////////////////////////////////////////////
// Org:        	SMU & FNAL
// Author:      Quan Sun
// 
// Create Date:    Jan 7 2022
// Design Name:    ETROC2 
// Module Name:    bit_protector
// Project Name: 
// Description: behavioral model of bit_protector
//
// Dependencies: 
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ps/1ps
module bit_protector(
input [8:0] DI,
input AFCBusy,
input AFC_Mode,
output [8:0] DO
);

wire Dsel, Refr_Pulse, C, CP;
wire EC_Pulse = 0;

reg [8:0] DataReg;

assign Dsel = AFCBusy | AFC_Mode;

assign #1000 Refr_Pulse = ~AFCBusy;
assign #1000 C = ~Refr_Pulse;

assign CP = C?Refr_Pulse:EC_Pulse;

always@(posedge CP) begin
	DataReg <= DI;
end 

assign DO = Dsel?DI:DataReg;


endmodule
