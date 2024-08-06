`timescale 1ns/1ps

module b2g #(
  parameter   N = 4
) (
  output  [N-1:0]   g,
  input   [N-1:0]   b
);
 
  assign g = b ^ (b >> 1);
 
endmodule

module g2b #(
  parameter   N = 4
) (
  output  [N-1:0]   b,
  input   [N-1:0]   g
);
  generate genvar i;
    for (i=0; i<N; i=i+1) begin : gen_bin
      assign b[i] = ^g[N-1:i];
    end
  endgenerate
 
endmodule



module tb;
 
  parameter N = 5;
 
  reg   [N-1:0]   bin;
  wire  [N-1:0]   gray;
  wire  [N-1:0]   binary;
 
 
  initial begin
    bin = 0;
    repeat (2**N) begin
      #10;
      bin = bin + 1;
    end
  end
 
 
  // my preferred versions of both conversions
 
  // binary to gray
  b2g #(.N(N)) uut_b2g (
    .g  (gray),
    .b  (bin)
  );
 
  // gray to binary
  g2b #(.N(N)) uut_g2b (
    .b  (binary),
    .g  (gray)
  );
 
  initial begin
    $monitor ("binary = %b, gray = %b, binary %b", bin, gray, binary);
  end
 
endmodule
