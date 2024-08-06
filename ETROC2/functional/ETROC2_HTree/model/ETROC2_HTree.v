//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Xing Huang
// 
// Create Date:    Dec. 16th, 2021
// Design Name:    clock tree model
// Module Name:    clockTreeModel
// Project Name:   ETROC2
// Description: behaviour model of the 16 x 16 clock tree
//
// Dependencies: DELWRAPPER delayCell
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////
//`timescale 1ps/100fs
module ETROC2_HTree (
	input TDC_Strobe_IN,			// TDC strobe input signal at 320 MHz from clock generator.
	input CLK40TDC_IN,				// TDC 40 MHz input clock from clock generator.
	input CLK40RO_IN,				// 40 MHz readout input clock from clock generator.
	input ChargeInj_IN,				// Charge injection input from QInj module.

	output [255:0] TDC_Strobe_OUT,	// TDC strobe fan out to pixel.
	output [255:0] CLK40TDC_OUT,	// TDC 40 MHz fan out to pixel.
	output [255:0] CLK40RO_OUT,		// 40 MHz readout fan out to pixel.
	output [255:0] ChargeInj_OUT,	// Charge injection fan out to pixel.
	input VDD,
	input VSS,
	input VDD_Dis,
	input VSS_Dis
);

//strobeDelay   //propagation delay, ns
//clk40TDCDelay	//propagation delay, ns
//clk40RODelay 	//propagation delay, ns
//QInjDelay 	//propagation delay, ns
localparam strobeDelay = 6;
localparam clk40TDCDelay = 6;
localparam clk40RODelay = 6;
localparam QInjDelay = 6;


wire [255:0] TDC_Strobe;
genvar i;
generate
	for(i = 0; i<256; i = i+1)
		begin : strobetdc_loop
			delayCell_HTree #(.delay_cells(strobeDelay)) delayCell_TDC_Strobe_Inst (        
				.I(TDC_Strobe_IN ),
		        .Z(TDC_Strobe[i])
		    );
		end
endgenerate
assign TDC_Strobe_OUT = TDC_Strobe;

wire [255:0] CLK40TDC;
genvar j;
generate
	for(j = 0; j<256; j = j+1)
		begin : clk40tdc_loop
			delayCell_HTree #(.delay_cells(clk40TDCDelay)) delayCell_CLK40TDC_Inst (        
				.I(CLK40TDC_IN ),
		        .Z(CLK40TDC[j])
		    );
		end
endgenerate
assign CLK40TDC_OUT = CLK40TDC;

wire [255:0] CLK40RO;
genvar k;
generate
	for(k = 0; k<256; k = k+1)
		begin : clk40ro_loop
			delayCell_HTree #(.delay_cells(clk40RODelay)) delayCell_CLK40TDC_Inst (        
				.I(CLK40RO_IN ),
		        .Z(CLK40RO[k])
		    );
		end
endgenerate
assign CLK40RO_OUT = CLK40RO;

wire [255:0] ChargeInj;
genvar n;
generate
	for(n = 0; n<256; n = n+1)
		begin : chargeinj_loop
			delayCell_HTree #(.delay_cells(QInjDelay)) delayCell_ChargeInj_Inst (        
				.I(ChargeInj_IN ),
		        .Z(ChargeInj[n])
		    );
		end
endgenerate
assign ChargeInj_OUT = ChargeInj;


endmodule

