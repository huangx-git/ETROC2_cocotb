`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 23 15:25:07 CST 2021
// Module Name: BCIDCounter
// Project Name: ETROC2 readout
// Description: 
// Dependencies: no
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"
// `ifndef BCIDCOUNTER
// `define BCIDCOUNTER
module BCIDCounter
(
	input clkTMR,            //40MHz
	input resetTMR,		  //
	input disTMR,			 // disable
    input rstBCIDTMR,        //BCIDTMR reset signal 
    input [11:0] offsetTMR,  //value when it is reset
    output [11:0] BCIDTMR
);
// tmrg default triplicate

	reg [11:0] BCIDRegTMR;
	assign BCIDTMR = BCIDRegTMR;
	wire [11:0] nextBCID = BCIDRegTMR + 12'd1;
	wire [11:0] nextBCIDVoted = nextBCID;
	always @(posedge clkTMR) begin
		if(!resetTMR)
		begin
			BCIDRegTMR <= offsetTMR;
		end
		else if (!disTMR)
		begin
			if(!rstBCIDTMR) 
			begin
				BCIDRegTMR <= offsetTMR;
			end
			else if( BCIDRegTMR == `MAX_BCID_NUMBER)
			begin
				BCIDRegTMR <= 12'H000; //BCIDTMR from 0 to 3563
			end
			else 
			begin
				BCIDRegTMR <= nextBCIDVoted;
			end
		end
	end
endmodule
// `endif