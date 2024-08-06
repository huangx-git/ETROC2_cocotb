module voter(
A,
B,
C,
Q
);

input A, B, C ;
output Q ;


reg Q;

	always @ (A , B , C ) 
		case ({A,B,C})
			3'b000: Q<= 1'b0;
			3'b001: Q<=1'b0;
			3'b010: Q<=1'b0;
			3'b011: Q<=1'b1;
			3'b100: Q<=1'b0;
			3'b101: Q<=1'b1;
			3'b110: Q<=1'b1;
			3'b111: Q<=1'b1;
			
		endcase
		
	

endmodule
