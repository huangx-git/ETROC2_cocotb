//Verilog HDL for "ETROC_PLL_Sim0", "PFD" "functional"

`timescale 10ps/1fs
module PFD_INSTLOCK ( CKFB, CKREF, UP, DOWN, INSTLOCK);

  input CKREF;
  input CKFB;
  output DOWN;
  output UP;
  output reg INSTLOCK;




    wire fv_rst, fr_rst;
    reg q0, q1;

	wire CKFB,CKREF;


    assign #15 fr_rst = (q0 & q1);
    assign #15 fv_rst = (q0 & q1);

    always @(posedge CKFB or posedge fv_rst) begin
	    if (fv_rst) q0 <= 0; else q0 <= 1;
    end

    always @(posedge CKREF or posedge fr_rst) begin
	    if (fr_rst) q1 <= 0; else q1 <= 1;
    end

    assign UP = q1;
    assign DOWN = q0;

    always@(posedge CKFB)
		INSTLOCK <= ~(UP|DOWN);

endmodule


