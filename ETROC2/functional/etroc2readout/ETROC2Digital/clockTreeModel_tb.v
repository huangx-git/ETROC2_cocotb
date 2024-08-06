//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Xing Huang
// 
// Create Date:    Dec. 16th, 2021
// Design Name:    clock tree model
// Module Name:    clockTreeModel_tb
// Project Name:   ETROC2
// Description: test bench of the fast command decoder top
//
// Dependencies: clockTreeModel
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ps/100fs
module clockTreeModel_tb;

reg TDC_Strobe_IN;
reg CLK40TDC_IN;
reg CLK40RO_IN;
reg ChargeInj_IN;

wire [255:0] TDC_Strobe_OUT;
wire [255:0] CLK40TDC_OUT;
wire [255:0] CLK40RO_OUT;
wire [255:0] ChargeInj_OUT;

//always #390 clk1280 = ~clk1280; //clk1280

always #(390*4) TDC_Strobe_IN = ~TDC_Strobe_IN; //TDC_Strobe_IN

always #(390*4*8) CLK40TDC_IN = ~CLK40TDC_IN; //CLK40TDC_IN

always #(390*4*8) CLK40RO_IN = ~CLK40RO_IN; //CLK40TDC_IN


initial begin
	TDC_Strobe_IN = 0;
	CLK40TDC_IN = 0;
	CLK40RO_IN = 1;
	ChargeInj_IN = 0;

# 1000000
	ChargeInj_IN = 1;
# 1000000
	ChargeInj_IN = 0;

# 20_000_000
$finish();
end

localparam strobeDelay = 4;    	//propagation delay, ns
localparam clk40TDCDelay = 5;	//propagation delay, ns
localparam clk40RODelay = 4;	//propagation delay, ns
localparam QInjDelay = 5;		//propagation delay, ns

clockTreeModel #(.strobeDelay(strobeDelay), .clk40TDCDelay(clk40TDCDelay), .clk40RODelay(clk40RODelay), .QInjDelay(QInjDelay)) clockTreeModel_inst
(
	.TDC_Strobe_IN(TDC_Strobe_IN),		// TDC strobe input signal at 320 MHz from clock generator.
	.CLK40TDC_IN(CLK40TDC_IN),			// TDC 40 MHz input clock from clock generator.
	.CLK40RO_IN(CLK40RO_IN),			// 40 MHz readout input clock from clock generator.
	.ChargeInj_IN(ChargeInj_IN),		// Charge injection input from QInj module.

	.TDC_Strobe_OUT(TDC_Strobe_OUT),	// TDC strobe fan out to pixel.
	.CLK40TDC_OUT(CLK40TDC_OUT),		// TDC 40 MHz fan out to pixel.
	.CLK40RO_OUT(CLK40RO_OUT),			// 40 MHz readout fan out to pixel.
	.ChargeInj_OUT(ChargeInj_OUT)		// Charge injection fan out to pixel.
);

endmodule
