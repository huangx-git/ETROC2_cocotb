/**
 * TAG3
 *
 * History:
 * 01/Jan/2016 Created by Szymon Kulis for LDQ10
 **/

`timescale 1ps/1ps

/*
module TAG3( A, B, C, ZN );
  //tmrg do_not_touch
  input A;
  input C;
  output ZN;
  input B;
// synopsys translate_off
  reg ZN;
  reg [7:0] del;
  always @(A or B or C)
  begin
    del = 0;//$random() % 30;
    if (A==B && B==C && A==C)
      ZN=#(50+del) ~A;
  end

  initial
     ZN=$random();

  always @(ZN)
    begin
      #11_000;
      if (A==B && B==C && A==C && A==ZN)
      begin
        $display("TAG3 problem. Recovering ...");
        ZN=#(50)~A;
      end
    end
// synopsys translate_on
endmodule
*/

`celldefine
module TAG3(
  input A,
  input B,
  input C,
  output ZN
);
//tmrg do_not_touch

// synopsys translate_off
  wire az;
  wire bz;
  wire cz;
  wire abc;

  wire Z;

  and aand(az,A,Z);
  and band(bz,B,Z);
  and cand(cz,C,Z);
  and abcand(abc,A,B,C);

  or zor(Z,az,bz,cz,abc);

  not nnot(ZN,Z);
/*
  always @(Z)
    ZN<=#(100+$urandom%200) !Z;

  always @(ZN)
    begin
      #51_000;
      if (A==B && B==C && A==C && A==ZN)
      begin
//        $display("TAG3 problem. Recovering ...");
        ZN=#(50)~A;
      end
    end
*/
//  not #(100+$urandom%200) znot(ZN,Z);
// synopsys translate_on
endmodule
`endcelldefine

`celldefine
module AO222D4GF(
  input A1, A2,
  input B1, B2,
  input C1, C2,
  output Z
);
  wire a1a2;
  wire b2b2;
  wire c1c2;
  wire abc;

//  wire Z;

  and a1a2and(a1a2,A1,A2);
  and b1b2and(b1b2,B1,B2);
  and c1c2and(c1c2,C1,C2);

  or zor(Z,a1a2,b1b2,c1c2);

endmodule
`endcelldefine

