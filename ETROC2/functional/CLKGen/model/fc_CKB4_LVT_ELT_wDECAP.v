
`timescale 1ps/1ps

module fc_CKB4_LVT_ELT_wDECAP(
    input IN,
    output OUT,
    input VDD,
    input VSS
);

assign #25 OUT = IN;

endmodule