//`define NoDLY
module delayCell_HTree #(parameter delay_cells = 4)(
  input I,
  output Z
);
  // tmrg do_not_touch


wire [delay_cells:0] delayline;
assign delayline[0]  =  I;

`ifdef NoDLY
	assign Z = I;
`else

	genvar k;
	generate
		for(k = 0; k<delay_cells; k = k+1)
			begin : loop_delayline
				DELWRAPPER_HTree delayCell (        
					.I(delayline[k] ),
			        .Z(delayline[k+1])
			    );
			end
	endgenerate
	assign Z = delayline[delay_cells];
`endif

endmodule

