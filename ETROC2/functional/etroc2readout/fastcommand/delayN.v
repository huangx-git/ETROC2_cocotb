//If you want to delay the signal C by N clock periods, you can use the following approach:

//`timescale 1ns/100ps
module delayN #( parameter N = 7)(
	input rstn,
    input DataIn,
    input clk,
    output delayOut
);

    reg [N-1:0] b;
    reg delayOut;

always @(posedge clk) begin
	if(!rstn) 
		b <= 0;
	else begin
//    b <= {b[N-1:1],C}; // Every time C is placed on the last bit of b, after N clock cycles, C is in the N-1 bit
    	b <= {b[N-2:0], DataIn};
    	delayOut <= b[N-1]; // This equation makes a (reg) will be one clock delay than b[6]
	end
end

//assign a = b[N-1];
//assign delayOut = b[N-1];

endmodule
