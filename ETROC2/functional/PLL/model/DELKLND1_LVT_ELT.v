//Verilog HDL for "ETROC2_customDigitalLib", "DELKLND1_LVT_ELT" "functional"


// type:  
`timescale 1ns/1ps
`celldefine
module DELKLND1_LVT_ELT (Z, I);
	output Z;
	input I;

	// Function
	buf (Z, I);

	// Timing
	specify
		specparam tpd_I_Z_r = 0.02:0.02:0.02;
		specparam tpd_I_Z_f = 0.02:0.02:0.02;

		(I => Z) = ( tpd_I_Z_r , tpd_I_Z_f );
	endspecify
endmodule
`endcelldefine
