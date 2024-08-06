`timescale 1ps/1ps

module TAG3GATES(
  input A,
  input B,
  input C,
  output Z
);
  //tmrg do_not_touch
  wire az;
  wire bz;
  wire cz;
  wire abc;

/*
  and aand(az,A,Z);
  and band(bz,B,Z);
  and cand(cz,C,Z);
  and abcand(abc,A,B,C);
  or zor(Z,az,bz,cz,abc);
  wire Z;
*/
  assign az = A&Z;
  assign bz = B&Z;
  assign cz = C&Z;
  assign abc = A&B&C;
  assign Z = az|bz|cz|abc;

//  always @(Z)
//    ZN=#(100+$urandom%200) Z;
//  assign ZN=!Z;
endmodule

