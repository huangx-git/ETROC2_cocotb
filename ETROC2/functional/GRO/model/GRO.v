//Verilog HDL for "ETROC2_GlobalAnalog", "GRO" "functional"


module GRO ( GRO_Out_Down256, GRO_Start, GRO_TOARST_N, GRO_TOA_CK, GRO_TOA_Latch,
GRO_TOTRST_N, GRO_TOT_CK, vdd, vss );

  input GRO_TOT_CK;
  output GRO_Out_Down256;
  input GRO_TOA_Latch;
  input GRO_TOTRST_N;
  input GRO_TOARST_N;
  input GRO_TOA_CK;
  input GRO_Start;
  input vdd, vss;
endmodule
