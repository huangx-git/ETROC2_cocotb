//Verilog HDL for "ETROC_PLL_Core_AFC", "thermo2bin6bits" "functional"


module thermo2bin6bits ( in, out, VDD, VSS );

  input  [5:0] in;
  output  [2:0] out;
  inout VDD;
  inout VSS;


	assign out =  (6'b000001&in)+
				 ((6'b000010&in)>>1)+
				 ((6'b000100&in)>>2)+
				 ((6'b001000&in)>>3)+
				 ((6'b010000&in)>>4)+
				 ((6'b100000&in)>>5);


endmodule

