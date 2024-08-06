/**
 *  File  : majorityVoterTag.v
 *  Author: Szymon Kulis (CERN)
 **/

`timescale 1ps/1ps

module majorityVoterTag (inA, inB, inC, out, tmrErr);
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
    TAG3 voter(.A(inA[i]), .B(inB[i]), .C(inC[i]), .ZN(outn[i]));
    INVD2 inv(.I(outn[i]),.ZN(out[i]));
  end

endmodule

