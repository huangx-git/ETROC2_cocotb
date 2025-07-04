/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ../output/registerFileTMR.v                                                            *
 *                                                                                                  *
 * user    : qsun                                                                                   *
 * host    : sphy7asic02.smu.edu                                                                    *
 * date    : 24/01/2022 12:04:54                                                                    *
 *                                                                                                  *
 * workdir : /users/qsun/workarea/tsmc65nm/ETROC_PLL/digital_work/i2c_backend_v5/tmr/work           *
 * cmd     : /users/qsun/workarea/tsmc65nm/ETROC_PLL/digital_work/tmrg/bin/tmrg --log tmrg.log      *
 *           --include --inc-dir /users/qsun/workarea/tsmc65nm/ETROC_PLL/digital_work/git1/etroc2/rtl *
 *           --lib ../simplified_std_cell_lib.v --lib                                               *
 *           /users/qsun/workarea/tsmc65nm/ETROC_PLL/digital_work/git1/etroc2/libs/powerOnResetLong.v *
 *           --lib /users/qsun/workarea/tsmc65nm/ETROC_PLL/digital_work/git1/etroc2/libs/IO_1P2V_C4.v *
 *           --lib                                                                                  *
 *           /users/qsun/workarea/tsmc65nm/ETROC_PLL/digital_work/git1/etroc2/libs/customDigitalLib.v *
 *           -c ../config/tmrg.cnf                                                                  *
 * tmrg rev:                                                                                        *
 *                                                                                                  *
 * src file: /users/qsun/workarea/tsmc65nm/ETROC_PLL/digital_work/git2/etroc2/rtl/registerFile.v    *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2022-01-20 11:50:53.569715                                         *
 *           File Size         : 843                                                                *
 *           MD5 hash          : a8f75f03690916b8c5f2ef39044e536f                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale  1ps/1ps
module registerFileTMR #(
  parameter MEMLEN=36
)(
     input [15:0] wbAdrA,
     input [15:0] wbAdrB,
     input [15:0] wbAdrC,
     input [7:0] wbDataInA,
     input [7:0] wbDataInB,
     input [7:0] wbDataInC,
     input  wbWeA,
     input  wbWeB,
     input  wbWeC,
     input  clkA,
     input  clkB,
     input  clkC,
     input  rstA,
     input  rstB,
     input  rstC,
     output [MEMLEN*8-1:0] valuesA,
     output [MEMLEN*8-1:0] valuesB,
     output [MEMLEN*8-1:0] valuesC,
     input [MEMLEN*8-1:0] defaultValue,
     input  errDetectedA,
     input  errDetectedB,
     input  errDetectedC,
     output  tmrErrorA,
     output  tmrErrorB,
     output  tmrErrorC
);
wire [MEMLEN*8-1:0] defaultValueC;
wire [MEMLEN*8-1:0] defaultValueB;
wire [MEMLEN*8-1:0] defaultValueA;
wor MCtmrErrorC;
wor MCtmrErrorB;
wor MCtmrErrorA;
wire [MEMLEN-1:0] wbAdrDecodedA;
wire [MEMLEN-1:0] wbAdrDecodedB;
wire [MEMLEN-1:0] wbAdrDecodedC;

memoryAddrDecTMR #(.MEMLEN(MEMLEN)) AD (
          .addressA(wbAdrA),
          .addressB(wbAdrB),
          .addressC(wbAdrC),
          .enableA(wbAdrDecodedA),
          .enableB(wbAdrDecodedB),
          .enableC(wbAdrDecodedC)
          );
genvar i;

generate
     for(i =  0;i<MEMLEN;i =  i+1)
          begin : memgen 

               memoryCellTMR MC (
                         .rstA(rstA),
                         .rstB(rstB),
                         .rstC(rstC),
                         .clkA(clkA),
                         .clkB(clkB),
                         .clkC(clkC),
                         .dataInA(wbDataInA),
                         .dataInB(wbDataInB),
                         .dataInC(wbDataInC),
                         .loadA(wbAdrDecodedA[i] &wbWeA),
                         .loadB(wbAdrDecodedB[i] &wbWeB),
                         .loadC(wbAdrDecodedC[i] &wbWeC),
                         .dataOutA(valuesA[(8*i)+7:8*i] ),
                         .dataOutB(valuesB[(8*i)+7:8*i] ),
                         .dataOutC(valuesC[(8*i)+7:8*i] ),
                         .defaultValueA(defaultValueA[(8*i)+7:8*i] ),
                         .defaultValueB(defaultValueB[(8*i)+7:8*i] ),
                         .defaultValueC(defaultValueC[(8*i)+7:8*i] ),
                         .tmrErrorA(MCtmrErrorA),
                         .tmrErrorB(MCtmrErrorB),
                         .tmrErrorC(MCtmrErrorC)
                         );
          end

endgenerate
assign tmrErrorA =  MCtmrErrorA;
assign tmrErrorB =  MCtmrErrorB;
assign tmrErrorC =  MCtmrErrorC;

fanout #(.WIDTH(((MEMLEN*8-1)>(0)) ? ((MEMLEN*8-1)-(0)+1) : ((0)-(MEMLEN*8-1)+1))) defaultValueFanout (
          .in(defaultValue),
          .outA(defaultValueA),
          .outB(defaultValueB),
          .outC(defaultValueC)
          );
endmodule

