
module TH_CtrlTMR(
     CLK,
     RSTn,
     DiscriPul,
     Bypass,
     CLKEn,
     ScanStart,
     ScanDone,
     DAC,
     TH_offset,
     TH,
     BL,
     NW,
     Acc,
     StateOut,
	VDD, VSS
);

input CLK;
input RSTn;
input DiscriPul;
input Bypass;
input CLKEn;
input ScanStart;
output wire    ScanDone;
input [9:0] DAC;
input [5:0] TH_offset;
output wire   [9:0] TH;
output wire   [9:0] BL;
output wire   [3:0] NW;
output wire   [15:0] Acc;
output wire   [2:0] StateOut;
inout VDD, VSS;

endmodule
