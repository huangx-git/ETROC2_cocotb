/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ./globalDigitalTMR/streambuf_mem_rtlTMR.v                                              *
 *                                                                                                  *
 * user    : dtgong                                                                                 *
 * host    : sphy7asic01.smu.edu                                                                    *
 * date    : 03/04/2022 15:30:09                                                                    *
 *                                                                                                  *
 * workdir : /users/dtgong/workarea/tsmc65/ETLROC/digital/ETROC2Readout/gitlab/etroc2readout        *
 * cmd     : ../../tmrg/tmrg/bin/tmrg -c tmrgGlobal.cnf                                             *
 * tmrg rev:                                                                                        *
 *                                                                                                  *
 * src file: memBlock/streambuf_mem_rtl.v                                                           *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2022-03-15 14:02:02.378901                                         *
 *           File Size         : 14299                                                              *
 *           MD5 hash          : 36da1b2ffbb7a8cc5c9215b0bbec0484                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale  1ns/1ps
`include  "commonDefinition.v"
module streambuf_mem_rtl_topTMR(
     QAA,
     QAB,
     QAC,
     E1AA,
     E1AB,
     E1AC,
     CLKAA,
     CLKAB,
     CLKAC,
     CENAA,
     CENAB,
     CENAC,
     AAA,
     AAB,
     AAC,
     CLKBA,
     CLKBB,
     CLKBC,
     CENBA,
     CENBB,
     CENBC,
     ABA,
     ABB,
     ABC,
     DBA,
     DBB,
     DBC,
     EMAAA,
     EMAAB,
     EMAAC,
     EMABA,
     EMABB,
     EMABC,
     RET1NA,
     RET1NB,
     RET1NC,
     COLLDISNA,
     COLLDISNB,
     COLLDISNC
);
output [39:0] QAA;
output [39:0] QAB;
output [39:0] QAC;
output E1AA;
output E1AB;
output E1AC;
input CLKAA;
input CLKAB;
input CLKAC;
input CENAA;
input CENAB;
input CENAC;
input [1:0] AAA;
input [1:0] AAB;
input [1:0] AAC;
input CLKBA;
input CLKBB;
input CLKBC;
input CENBA;
input CENBB;
input CENBC;
input [1:0] ABA;
input [1:0] ABB;
input [1:0] ABC;
input [39:0] DBA;
input [39:0] DBB;
input [39:0] DBC;
input [2:0] EMAAA;
input [2:0] EMAAB;
input [2:0] EMAAC;
input [2:0] EMABA;
input [2:0] EMABB;
input [2:0] EMABC;
input RET1NA;
input RET1NB;
input RET1NC;
input COLLDISNA;
input COLLDISNB;
input COLLDISNC;
wire [39:0] QOAA;
wire [39:0] QOAB;
wire [39:0] QOAC;
wire [39:0] DIBA;
wire [39:0] DIBB;
wire [39:0] DIBC;

streambuf_mem_fr_topTMR u0 (
          .QOAA(QOAA),
          .QOAB(QOAB),
          .QOAC(QOAC),
          .CLKAA(CLKAA),
          .CLKAB(CLKAB),
          .CLKAC(CLKAC),
          .CENAA(CENAA),
          .CENAB(CENAB),
          .CENAC(CENAC),
          .AAA(AAA),
          .AAB(AAB),
          .AAC(AAC),
          .CLKBA(CLKBA),
          .CLKBB(CLKBB),
          .CLKBC(CLKBC),
          .CENBA(CENBA),
          .CENBB(CENBB),
          .CENBC(CENBC),
          .ABA(ABA),
          .ABB(ABB),
          .ABC(ABC),
          .DIBA(DIBA),
          .DIBB(DIBB),
          .DIBC(DIBC),
          .EMAAA(EMAAA),
          .EMAAB(EMAAB),
          .EMAAC(EMAAC),
          .EMABA(EMABA),
          .EMABB(EMABB),
          .EMABC(EMABC),
          .RET1NA(RET1NA),
          .RET1NB(RET1NB),
          .RET1NC(RET1NC),
          .COLLDISNA(COLLDISNA),
          .COLLDISNB(COLLDISNB),
          .COLLDISNC(COLLDISNC)
          );

streambuf_mem_encoderTMR e0 (
          .EDIA(DBA),
          .EDIB(DBB),
          .EDIC(DBC),
          .EDOA(DIBA),
          .EDOB(DIBB),
          .EDOC(DIBC)
          );

streambuf_mem_decoderTMR d0 (
          .DDIA(QOAA),
          .DDIB(QOAB),
          .DDIC(QOAC),
          .DDOA(QAA),
          .DDOB(QAB),
          .DDOC(QAC),
          .E1CODEA(E1AA),
          .E1CODEB(E1AB),
          .E1CODEC(E1AC)
          );
endmodule

module streambuf_mem_fr_topTMR(
     QOAA,
     QOAB,
     QOAC,
     CLKAA,
     CLKAB,
     CLKAC,
     CENAA,
     CENAB,
     CENAC,
     AAA,
     AAB,
     AAC,
     CLKBA,
     CLKBB,
     CLKBC,
     CENBA,
     CENBB,
     CENBC,
     ABA,
     ABB,
     ABC,
     DIBA,
     DIBB,
     DIBC,
     EMAAA,
     EMAAB,
     EMAAC,
     EMABA,
     EMABB,
     EMABC,
     RET1NA,
     RET1NB,
     RET1NC,
     COLLDISNA,
     COLLDISNB,
     COLLDISNC
);
output [39:0] QOAA;
output [39:0] QOAB;
output [39:0] QOAC;
input CLKAA;
input CLKAB;
input CLKAC;
input CENAA;
input CENAB;
input CENAC;
input [1:0] AAA;
input [1:0] AAB;
input [1:0] AAC;
input CLKBA;
input CLKBB;
input CLKBC;
input CENBA;
input CENBB;
input CENBC;
input [1:0] ABA;
input [1:0] ABB;
input [1:0] ABC;
input [39:0] DIBA;
input [39:0] DIBB;
input [39:0] DIBC;
input [2:0] EMAAA;
input [2:0] EMAAB;
input [2:0] EMAAC;
input [2:0] EMABA;
input [2:0] EMABB;
input [2:0] EMABC;
input RET1NA;
input RET1NB;
input RET1NC;
input COLLDISNA;
input COLLDISNB;
input COLLDISNC;
wire [39:0] DBA;
wire [39:0] DBB;
wire [39:0] DBC;
wire [39:0] QAA;
wire [39:0] QAB;
wire [39:0] QAC;
assign DBA =  DIBA;
assign DBB =  DIBB;
assign DBC =  DIBC;
assign QOAA =  QAA;
assign QOAB =  QAB;
assign QOAC =  QAC;

latchedBasedRAM #(.data_width(40), .depth(4), .log_depth(2), .delay(4)) u0A (
          .QA(QAA),
          .CLKA(CLKAA),
          .CENA(CENAA),
          .AA(AAA),
          .CLKB(CLKBA),
          .CENB(CENBA),
          .AB(ABA),
          .DB(DBA),
          .EMAA(EMAAA),
          .EMAB(EMABA),
          .RET1N(RET1NA),
          .COLLDISN(COLLDISNA)
          );

latchedBasedRAM #(.data_width(40), .depth(4), .log_depth(2), .delay(4)) u0B (
          .QA(QAB),
          .CLKA(CLKAB),
          .CENA(CENAB),
          .AA(AAB),
          .CLKB(CLKBB),
          .CENB(CENBB),
          .AB(ABB),
          .DB(DBB),
          .EMAA(EMAAB),
          .EMAB(EMABB),
          .RET1N(RET1NB),
          .COLLDISN(COLLDISNB)
          );

latchedBasedRAM #(.data_width(40), .depth(4), .log_depth(2), .delay(4)) u0C (
          .QA(QAC),
          .CLKA(CLKAC),
          .CENA(CENAC),
          .AA(AAC),
          .CLKB(CLKBC),
          .CENB(CENBC),
          .AB(ABC),
          .DB(DBC),
          .EMAA(EMAAC),
          .EMAB(EMABC),
          .RET1N(RET1NC),
          .COLLDISN(COLLDISNC)
          );
endmodule

module streambuf_mem_encoderTMR(
     EDIA,
     EDIB,
     EDIC,
     EDOA,
     EDOB,
     EDOC
);
input [39:0] EDIA;
input [39:0] EDIB;
input [39:0] EDIC;
output [39:0] EDOA;
output [39:0] EDOB;
output [39:0] EDOC;
assign EDOA =  EDIA;
assign EDOB =  EDIB;
assign EDOC =  EDIC;
endmodule

module streambuf_mem_decoderTMR(
     DDIA,
     DDIB,
     DDIC,
     DDOA,
     DDOB,
     DDOC,
     E1CODEA,
     E1CODEB,
     E1CODEC
);
input [39:0] DDIA;
input [39:0] DDIB;
input [39:0] DDIC;
output [39:0] DDOA;
output [39:0] DDOB;
output [39:0] DDOC;
output E1CODEA;
output E1CODEB;
output E1CODEC;
assign E1CODEA =  1'b0;
assign E1CODEB =  1'b0;
assign E1CODEC =  1'b0;
assign DDOA =  DDIA;
assign DDOB =  DDIB;
assign DDOC =  DDIC;
endmodule

