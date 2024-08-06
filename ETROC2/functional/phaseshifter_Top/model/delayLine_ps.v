//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Xing Huang
// 
// Create Date:    Mar. 30th, 2022
// Design Name:    phase shiter model
// Module Name:    delayLine
// Project Name:   ETROC2
// Description: a 50 ps delay per tap. The total 16 delay is the period of 1.28 GHz clock.
//
// Dependencies: delayCell
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ps/1ps
module delayLine_ps(
    input clkIn,
    output [15:0] tapOut
);

wire [16:0] delayline;
assign delayline[0] = clkIn;

genvar i;
generate
    for(i = 0; i < 16; i = i + 1)
        begin:loop_delayline
            delayCell_ps delayCell_inst(
                .IN(delayline[i]),
                .OUT(delayline[i+1])
            );
		end
endgenerate

assign tapOut = delayline;

endmodule
