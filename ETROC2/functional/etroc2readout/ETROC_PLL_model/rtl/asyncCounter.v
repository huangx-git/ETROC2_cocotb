//Verilog HDL for "MODELS_qsun", "asyncCounter" "functional"



module asyncCounter (ck_fsm,ck, enable,reset,doneFlag);
        parameter integer Nbits=12;

	input ck,reset,enable,ck_fsm;
	output doneFlag;

	wire doneFlag_internal;

	reg [Nbits:0] CT;
	reg doneFlag_sync;
	reg doneFlag;

	
	always @(posedge reset or posedge ck) begin
		
		if (reset) 
			CT[0]=0;
		else
			if( (! doneFlag_internal) && enable) 
				CT[0]=~CT[0];
	end


	genvar i;
	generate
		for (i=1; i<=Nbits;i=i+1) begin
			
			always @(posedge reset or negedge CT[i-1]) begin

				if (reset) 
					CT[i]=0;
				else
					if( (! doneFlag_internal) && enable) 
						CT[i]=~CT[i];
			end
		end

	endgenerate

	assign doneFlag_internal=CT[Nbits];

	always @(posedge ck_fsm or posedge reset) begin
		if(reset) begin
			doneFlag_sync <= 0;
			doneFlag <= 0;
			  end
		else begin
			doneFlag_sync <= doneFlag_internal;
			doneFlag <= doneFlag_sync;
		     end
	end

endmodule
