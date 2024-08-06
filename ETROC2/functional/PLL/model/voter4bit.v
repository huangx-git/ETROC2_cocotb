//Verilog HDL for "MODELS_qsun", "voter4bit" "functional"

module voter4bit(
A,
B,
C,
Q
);

input wire [3:0] A, B, C ;
output reg [3:0] Q ;


	always @ (A , B , C ) begin
		case ({A[0],B[0],C[0]})
			3'b000: Q[0]<= 1'b0;
			3'b001: Q[0]<=1'b0;
			3'b010: Q[0]<=1'b0;
			3'b011: Q[0]<=1'b1;
			3'b100: Q[0]<=1'b0;
			3'b101: Q[0]<=1'b1;
			3'b110: Q[0]<=1'b1;
			3'b111: Q[0]<=1'b1;
			default: Q[0]<=	1'b0;
		endcase

		case ({A[1],B[1],C[1]})
			3'b000: Q[1]<= 1'b0;
			3'b001: Q[1]<=1'b0;
			3'b010: Q[1]<=1'b0;
			3'b011: Q[1]<=1'b1;
			3'b100: Q[1]<=1'b0;
			3'b101: Q[1]<=1'b1;
			3'b110: Q[1]<=1'b1;
			3'b111: Q[1]<=1'b1;
			default: Q[1]<=	1'b0;
		endcase
		
		case ({A[2],B[2],C[2]})
			3'b000: Q[2]<= 1'b0;
			3'b001: Q[2]<=1'b0;
			3'b010: Q[2]<=1'b0;
			3'b011: Q[2]<=1'b1;
			3'b100: Q[2]<=1'b0;
			3'b101: Q[2]<=1'b1;
			3'b110: Q[2]<=1'b1;
			3'b111: Q[2]<=1'b1;
			default: Q[2]<=	1'b0;
		endcase

		case ({A[3],B[3],C[3]})
			3'b000: Q[3]<= 1'b0;
			3'b001: Q[3]<=1'b0;
			3'b010: Q[3]<=1'b0;
			3'b011: Q[3]<=1'b1;
			3'b100: Q[3]<=1'b0;
			3'b101: Q[3]<=1'b1;
			3'b110: Q[3]<=1'b1;
			3'b111: Q[3]<=1'b1;
			default: Q[3]<=	1'b0;
		endcase
	end
		
	

endmodule
