`timescale 1ns/1ps
module DIO(vss_IO, vdd_IO, internal, pad);
inout vss_IO, vdd_IO;
input pad;
output internal;

assign internal = pad; 

endmodule
