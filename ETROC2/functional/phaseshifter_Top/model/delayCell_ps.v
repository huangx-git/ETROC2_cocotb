//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Xing Huang
// 
// Create Date:    Mar. 30th, 2022
// Design Name:    phase shiter model
// Module Name:    delayCell
// Project Name:   ETROC2
// Description: a 50 ps delay cell, period of 1.28 GHz clock divided by 16
//
// Dependencies: none
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ps/1ps
module delayCell_ps(
    input IN,
    output OUT
);

reg OUT;

always @ (IN)
	OUT <= #49 IN;

endmodule
