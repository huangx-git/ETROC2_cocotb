/**
 *  File  : majorityVoterTagGates.v
 *  Author: Szymon Kulis (CERN)
 **/

`timescale 1ns/10ps

module majorityVoterTagGates (inA, inB, inC, out, tmrErr);
  // tmrg do_not_touch
  parameter WIDTH = 1;
  input   [(WIDTH-1):0]   inA, inB, inC;
  output  [(WIDTH-1):0]   out;
  output                  tmrErr;
  assign tmrErr=1'b0;
  genvar i;
  wire  [(WIDTH-1):0]   outn;
  for (i=0;i<WIDTH;i=i+1)
  begin
    TAG3GATES voter(.A(inA[i]), .B(inB[i]), .C(inC[i]), .Z(out[i]));
  end

endmodule

