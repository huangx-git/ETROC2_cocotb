//Verilog HDL for "MODELS_qsun", "bin2thermo3bits" "functional"

module bin2thermo3bits (in, out );
	input wire [2:0] in;
	output reg [5:0] out;


	always @ (in) begin

		case (in)
			3'b000:	out=6'b000000;
			3'b001:	out=6'b000001;
			3'b010:	out=6'b000011;
			3'b011:	out=6'b000111;
			3'b100:	out=6'b001111;
			3'b101:	out=6'b011111;
			3'b110:	out=6'b111111;
			3'b111:	out=6'b111111;
			default: out=6'b111111;
		endcase

	end	
	
endmodule
