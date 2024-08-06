`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sun Jan 24 14:09:46 CST 2021
// Module Name: pulseGenerator
// Project Name: ETROC2 readout
// Description: import from Hanhan's code
// Dependencies: DELWRAPPER
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module pulseGenerator #(parameter delay_cells = 4) (
  input enable,       
  input pulseStart,     //generate a negative pulse at the rising edge of this signal
  output pulseN          //
);
wire start = enable&pulseStart;
wire [delay_cells:0] delayline;
assign delayline[0]  =  start;
wire delayedStart = delayline[delay_cells];

genvar k;
generate
	for(k = 0; k<delay_cells; k = k+1)
		begin : loop_delayline
			DELWRAPPER delayCell (        
				.I(delayline[k] ),
		        .Z(delayline[k+1])
		    );
		end
endgenerate

assign pulseN = ~(start & ~delayedStart);

endmodule