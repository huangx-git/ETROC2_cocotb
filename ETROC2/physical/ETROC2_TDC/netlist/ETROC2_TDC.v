//Verilog HDL for "ETROC2_TDCWrap", "ETROC2_TDC" "functional"


module ETROC2_TDC ( CalCounterAMon, CalCounterBMon, CalRawDataMon, Cal_codeReg,
CalerrorFlagReg, DBF_QC, RO_DBF_QC, TOACounterAMon, TOACounterBMon, TOARawDataMon,
TOA_codeReg, TOAerrorFlagReg, TOTCounterAMon, TOTCounterBMon, TOTRawDataMon,
TOT_codeReg, TOTerrorFlagReg, hitFlag, vdd, vss, autoReset, clk40, clk320, enable,
enableMon, level, offset, polaritySel, pulse, resetn, selRawCode, testMode,
timeStampMode );

  input testMode;
  output  [2:0] CalCounterAMon;
  output  [2:0] TOTCounterBMon;
  output hitFlag;
  input selRawCode;
  output  [2:0] CalCounterBMon;
  input  [2:0] level;
  output  [2:0] TOACounterAMon;
  input vdd;
  output  [2:0] TOACounterBMon;
  input clk40;
  input polaritySel;
  output  [62:0] TOARawDataMon;
  output  [9:0] TOA_codeReg;
  output  [5:0] DBF_QC;
  output  [8:0] TOT_codeReg;
  input timeStampMode;
  output CalerrorFlagReg;
  output  [5:0] RO_DBF_QC;
  input pulse;
  input  [6:0] offset;
  output TOAerrorFlagReg;
  output TOTerrorFlagReg;
  output  [9:0] Cal_codeReg;
  input enable;
  input resetn;
  input enableMon;
  output  [31:0] TOTRawDataMon;
  output  [2:0] TOTCounterAMon;
  input autoReset;
  output  [62:0] CalRawDataMon;
  input vss;
  input clk320;
endmodule

