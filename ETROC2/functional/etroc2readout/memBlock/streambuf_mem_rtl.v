/* verilog_rtl_memcomp Version: c0.1.0-EAC */
/* common_memcomp Version: 4.0.5-EAC */
/* lang compiler Version: 4.1.6-EAC2 Oct 30 2012 16:32:37 */
//
//       CONFIDENTIAL AND PROPRIETARY SOFTWARE OF ARM PHYSICAL IP, INC.
//      
//       Copyright (c) 1993 - 2021 ARM Physical IP, Inc.  All Rights Reserved.
//      
//       Use of this Software is subject to the terms and conditions of the
//       applicable license agreement with ARM Physical IP, Inc.
//       In addition, this Software is protected by patents, copyright law 
//       and international treaties.
//      
//       The copyright notice(s) in this Software does not indicate actual or
//       intended publication of this Software.
//
//       Repair Verilog RTL for Synchronous Two-Port Register File
//
//       Instance Name:              streambuf_mem_rtl_top
//       Words:                      16
//       User Bits:                  40
//       Mux:                        1
//       Drive:                      6
//       Write Mask:                 Off
//       Extra Margin Adjustment:    On
//       Redundancy:                 off
//       Redundant Rows:             0
//       Redundant Columns:          0
//       Test Muxes                  Off
//       Ser:                        1bd1bc
//       Retention:                  on
//       Power Gating:               off
//
//       Creation Date:  Thu Apr  8 14:07:44 2021
//       Version:      r0p0
//
//       Verified
//
//       Known Bugs: None.
//
//       Known Work Arounds: N/A
//
`timescale 1ns/1ps
`include "commonDefinition.v"

/*
   Soft Error Repair Special Variable Description :
   ==============================================

   E1A : Output present when SER is enabled. It is normally at logic 0. When a single bit
               bit error is detected, it is set to logic 1.
*/

module streambuf_mem_rtl_top (
          QA, 
          E1A, 
          CLKA, 
          CENA, 
          AA, 
          CLKB, 
          CENB, 
          AB, 
          DB, 
          EMAA, 
          EMAB, 
          RET1N, 
          COLLDISN
   );
// tmrg default triplicate

   output [39:0]            QA;
   output                   E1A;
   input                    CLKA;
   input                    CENA;
   input [1:0]              AA;
   input                    CLKB;
   input                    CENB;
   input [1:0]              AB;
   input [39:0]             DB;
   input [2:0]              EMAA;
   input [2:0]              EMAB;
   input                    RET1N;
   input                    COLLDISN;
   wire [39:0]             QOA;
   wire [39:0]             DIB;

   streambuf_mem_fr_top u0 (
         .QOA(QOA),
         .CLKA(CLKA),
         .CENA(CENA),
         .AA(AA),
         .CLKB(CLKB),
         .CENB(CENB),
         .AB(AB),
         .DIB(DIB),
         .EMAA(EMAA),
         .EMAB(EMAB),
         .RET1N(RET1N),
         .COLLDISN(COLLDISN)
   );

   streambuf_mem_encoder e0 (
         .EDI(DB),
         .EDO(DIB)
   );

   streambuf_mem_decoder d0 (
         .DDI(QOA),
         .DDO(QA),
         .E1CODE(E1A)
   );


endmodule

module streambuf_mem_fr_top (
          QOA, 
          CLKA, 
          CENA, 
          AA, 
          CLKB, 
          CENB, 
          AB, 
          DIB, 
          EMAA, 
          EMAB, 
          RET1N, 
          COLLDISN
   );
// tmrg default triplicate
// tmrg triplicate latchedBasedRAM

   output [39:0]            QOA;
   input                    CLKA;
   input                    CENA;
   input [1:0]              AA;
   input                    CLKB;
   input                    CENB;
   input [1:0]              AB;
   input [39:0]             DIB;
   input [2:0]              EMAA;
   input [2:0]              EMAB;
   input                    RET1N;
   input                    COLLDISN;

   wire [39:0]    DB;
   wire [39:0]    QA;

   assign DB=DIB;
   assign QOA=QA;
//ifdef LATCH_RAM
//the stream buffer is tripplicated.
   latchedBasedRAM #(.data_width(40),.depth(4),.log_depth(2),.delay(4)) u0  
// else
//    streambuf_mem u0 
// endif
   (
         .QA(QA),
         .CLKA(CLKA),
         .CENA(CENA),
         .AA(AA),
         .CLKB(CLKB),
         .CENB(CENB),
         .AB(AB),
         .DB(DB),
         .EMAA(EMAA),
         .EMAB(EMAB),
         .RET1N(RET1N),
         .COLLDISN(COLLDISN)
   );

endmodule // streambuf_mem_fr_top


module streambuf_mem_encoder (EDI, EDO);
// tmrg default triplicate

   input     [39:0]  EDI;
   output    [39:0]      EDO;

   assign EDO = EDI;
   // assign EDO[0] = EDI[0]^EDI[1]^EDI[3]^EDI[4]^EDI[6]^EDI[8]^EDI[10]^EDI[11]^EDI[13]^EDI[15]^EDI[17]^EDI[19]^EDI[22]^EDI[24]^EDI[26]^EDI[29]^EDI[33]^EDI[35];
   // assign EDO[1] = EDI[0]^EDI[2]^EDI[3]^EDI[5]^EDI[6]^EDI[9]^EDI[10]^EDI[12]^EDI[13]^EDI[16]^EDI[17]^EDI[20]^EDI[23]^EDI[24]^EDI[27]^EDI[30]^EDI[34]^EDI[35]^EDI[38];
   // assign EDO[2] = EDI[0];
   // assign EDO[3] = EDI[1]^EDI[2]^EDI[3]^EDI[7]^EDI[8]^EDI[9]^EDI[10]^EDI[14]^EDI[15]^EDI[16]^EDI[17]^EDI[21]^EDI[25]^EDI[26]^EDI[27]^EDI[31]^EDI[36]^EDI[39];
   // assign EDO[4] = EDI[1];
   // assign EDO[5] = EDI[2];
   // assign EDO[6] = EDI[3];
   // assign EDO[7] = EDI[4]^EDI[5]^EDI[6]^EDI[7]^EDI[8]^EDI[9]^EDI[10]^EDI[18]^EDI[19]^EDI[20]^EDI[21]^EDI[28]^EDI[29]^EDI[30]^EDI[31]^EDI[37]^EDI[38]^EDI[39];
   // assign EDO[8] = EDI[4];
   // assign EDO[9] = EDI[5];
   // assign EDO[10] = EDI[6];
   // assign EDO[11] = EDI[7];
   // assign EDO[12] = EDI[8];
   // assign EDO[13] = EDI[9];
   // assign EDO[14] = EDI[10];
   // assign EDO[15] = EDI[11]^EDI[12]^EDI[13]^EDI[14]^EDI[15]^EDI[16]^EDI[17]^EDI[18]^EDI[19]^EDI[20]^EDI[21]^EDI[32]^EDI[33]^EDI[34]^EDI[35]^EDI[36]^EDI[37]^EDI[38]^EDI[39];
   // assign EDO[16] = EDI[11];
   // assign EDO[17] = EDI[12];
   // assign EDO[18] = EDI[13];
   // assign EDO[19] = EDI[14];
   // assign EDO[20] = EDI[15];
   // assign EDO[21] = EDI[16];
   // assign EDO[22] = EDI[17];
   // assign EDO[23] = EDI[18];
   // assign EDO[24] = EDI[19];
   // assign EDO[25] = EDI[20];
   // assign EDO[26] = EDI[21];
   // assign EDO[27] = EDI[22]^EDI[23]^EDI[24]^EDI[25]^EDI[26]^EDI[27]^EDI[28]^EDI[29]^EDI[30]^EDI[31]^EDI[32]^EDI[33]^EDI[34]^EDI[35]^EDI[36]^EDI[37]^EDI[38]^EDI[39];
   // assign EDO[28] = EDI[22];
   // assign EDO[29] = EDI[23];
   // assign EDO[30] = EDI[24];
   // assign EDO[31] = EDI[25];
   // assign EDO[32] = EDI[26];
   // assign EDO[33] = EDI[27];
   // assign EDO[34] = EDI[28];
   // assign EDO[35] = EDI[29];
   // assign EDO[36] = EDI[30];
   // assign EDO[37] = EDI[31];
   // assign EDO[38] = EDI[32];
   // assign EDO[39] = EDI[33];
   // assign EDO[40] = EDI[34];
   // assign EDO[41] = EDI[35];
   // assign EDO[42] = EDI[36];
   // assign EDO[43] = EDI[37];
   // assign EDO[44] = EDI[38];
   // assign EDO[45] = EDI[39];

endmodule //streambuf_mem_encoder

module streambuf_mem_decoder (DDI,
         DDO,
         E1CODE);
// tmrg default triplicate

   input       [39:0]   DDI;
   output      [39:0]   DDO;
   output      E1CODE;

   assign E1CODE = 1'b0;
   assign DDO = DDI;
   // wire        [5:0]   nc;
   // wire        [39:0]   errBit;
   // wire        [45:0]   XI;

   // assign XI = DDI;

   // // Create a new syndrome
   // assign nc[0] = XI[0]^XI[2]^XI[4]^XI[6]^XI[8]^XI[10]^XI[12]^XI[14]^XI[16]^XI[18]^XI[20]^XI[22]^XI[24]^XI[28]^XI[30]^XI[32]^XI[35]^XI[39]^XI[41];
   // assign nc[1] = XI[1]^XI[2]^XI[5]^XI[6]^XI[9]^XI[10]^XI[13]^XI[14]^XI[17]^XI[18]^XI[21]^XI[22]^XI[25]^XI[29]^XI[30]^XI[33]^XI[36]^XI[40]^XI[41]^XI[44];
   // assign nc[2] = XI[3]^XI[4]^XI[5]^XI[6]^XI[11]^XI[12]^XI[13]^XI[14]^XI[19]^XI[20]^XI[21]^XI[22]^XI[26]^XI[31]^XI[32]^XI[33]^XI[37]^XI[42]^XI[45];
   // assign nc[3] = XI[7]^XI[8]^XI[9]^XI[10]^XI[11]^XI[12]^XI[13]^XI[14]^XI[23]^XI[24]^XI[25]^XI[26]^XI[34]^XI[35]^XI[36]^XI[37]^XI[43]^XI[44]^XI[45];
   // assign nc[4] = XI[15]^XI[16]^XI[17]^XI[18]^XI[19]^XI[20]^XI[21]^XI[22]^XI[23]^XI[24]^XI[25]^XI[26]^XI[38]^XI[39]^XI[40]^XI[41]^XI[42]^XI[43]^XI[44]^XI[45];
   // assign nc[5] = XI[27]^XI[28]^XI[29]^XI[30]^XI[31]^XI[32]^XI[33]^XI[34]^XI[35]^XI[36]^XI[37]^XI[38]^XI[39]^XI[40]^XI[41]^XI[42]^XI[43]^XI[44]^XI[45];

   // // Is there an error ?
   // assign E1CODE = |nc ;

   // // For x in 0 to 39; errBit[x] is '1' if it is found faulty
   // assign errBit[0] =  !nc[5] & !nc[4] & !nc[3] & !nc[2] &   nc[1] &   nc[0];
   // assign errBit[1] =  !nc[5] & !nc[4] & !nc[3] &   nc[2] & !nc[1] &   nc[0];
   // assign errBit[2] =  !nc[5] & !nc[4] & !nc[3] &   nc[2] &   nc[1] & !nc[0];
   // assign errBit[3] =  !nc[5] & !nc[4] & !nc[3] &   nc[2] &   nc[1] &   nc[0];
   // assign errBit[4] =  !nc[5] & !nc[4] &   nc[3] & !nc[2] & !nc[1] &   nc[0];
   // assign errBit[5] =  !nc[5] & !nc[4] &   nc[3] & !nc[2] &   nc[1] & !nc[0];
   // assign errBit[6] =  !nc[5] & !nc[4] &   nc[3] & !nc[2] &   nc[1] &   nc[0];
   // assign errBit[7] =  !nc[5] & !nc[4] &   nc[3] &   nc[2] & !nc[1] & !nc[0];
   // assign errBit[8] =  !nc[5] & !nc[4] &   nc[3] &   nc[2] & !nc[1] &   nc[0];
   // assign errBit[9] =  !nc[5] & !nc[4] &   nc[3] &   nc[2] &   nc[1] & !nc[0];
   // assign errBit[10] =  !nc[5] & !nc[4] &   nc[3] &   nc[2] &   nc[1] &   nc[0];
   // assign errBit[11] =  !nc[5] &   nc[4] & !nc[3] & !nc[2] & !nc[1] &   nc[0];
   // assign errBit[12] =  !nc[5] &   nc[4] & !nc[3] & !nc[2] &   nc[1] & !nc[0];
   // assign errBit[13] =  !nc[5] &   nc[4] & !nc[3] & !nc[2] &   nc[1] &   nc[0];
   // assign errBit[14] =  !nc[5] &   nc[4] & !nc[3] &   nc[2] & !nc[1] & !nc[0];
   // assign errBit[15] =  !nc[5] &   nc[4] & !nc[3] &   nc[2] & !nc[1] &   nc[0];
   // assign errBit[16] =  !nc[5] &   nc[4] & !nc[3] &   nc[2] &   nc[1] & !nc[0];
   // assign errBit[17] =  !nc[5] &   nc[4] & !nc[3] &   nc[2] &   nc[1] &   nc[0];
   // assign errBit[18] =  !nc[5] &   nc[4] &   nc[3] & !nc[2] & !nc[1] & !nc[0];
   // assign errBit[19] =  !nc[5] &   nc[4] &   nc[3] & !nc[2] & !nc[1] &   nc[0];
   // assign errBit[20] =  !nc[5] &   nc[4] &   nc[3] & !nc[2] &   nc[1] & !nc[0];
   // assign errBit[21] =  !nc[5] &   nc[4] &   nc[3] &   nc[2] & !nc[1] & !nc[0];
   // assign errBit[22] =    nc[5] & !nc[4] & !nc[3] & !nc[2] & !nc[1] &   nc[0];
   // assign errBit[23] =    nc[5] & !nc[4] & !nc[3] & !nc[2] &   nc[1] & !nc[0];
   // assign errBit[24] =    nc[5] & !nc[4] & !nc[3] & !nc[2] &   nc[1] &   nc[0];
   // assign errBit[25] =    nc[5] & !nc[4] & !nc[3] &   nc[2] & !nc[1] & !nc[0];
   // assign errBit[26] =    nc[5] & !nc[4] & !nc[3] &   nc[2] & !nc[1] &   nc[0];
   // assign errBit[27] =    nc[5] & !nc[4] & !nc[3] &   nc[2] &   nc[1] & !nc[0];
   // assign errBit[28] =    nc[5] & !nc[4] &   nc[3] & !nc[2] & !nc[1] & !nc[0];
   // assign errBit[29] =    nc[5] & !nc[4] &   nc[3] & !nc[2] & !nc[1] &   nc[0];
   // assign errBit[30] =    nc[5] & !nc[4] &   nc[3] & !nc[2] &   nc[1] & !nc[0];
   // assign errBit[31] =    nc[5] & !nc[4] &   nc[3] &   nc[2] & !nc[1] & !nc[0];
   // assign errBit[32] =    nc[5] &   nc[4] & !nc[3] & !nc[2] & !nc[1] & !nc[0];
   // assign errBit[33] =    nc[5] &   nc[4] & !nc[3] & !nc[2] & !nc[1] &   nc[0];
   // assign errBit[34] =    nc[5] &   nc[4] & !nc[3] & !nc[2] &   nc[1] & !nc[0];
   // assign errBit[35] =    nc[5] &   nc[4] & !nc[3] & !nc[2] &   nc[1] &   nc[0];
   // assign errBit[36] =    nc[5] &   nc[4] & !nc[3] &   nc[2] & !nc[1] & !nc[0];
   // assign errBit[37] =    nc[5] &   nc[4] &   nc[3] & !nc[2] & !nc[1] & !nc[0];
   // assign errBit[38] =    nc[5] &   nc[4] &   nc[3] & !nc[2] &   nc[1] & !nc[0];
   // assign errBit[39] =    nc[5] &   nc[4] &   nc[3] &   nc[2] & !nc[1] & !nc[0];

   // // Flip a bit if it is faulty
   // assign DDO[0] = XI[2] & !errBit[0] | !XI[2] & errBit[0];
   // assign DDO[1] = XI[4] & !errBit[1] | !XI[4] & errBit[1];
   // assign DDO[2] = XI[5] & !errBit[2] | !XI[5] & errBit[2];
   // assign DDO[3] = XI[6] & !errBit[3] | !XI[6] & errBit[3];
   // assign DDO[4] = XI[8] & !errBit[4] | !XI[8] & errBit[4];
   // assign DDO[5] = XI[9] & !errBit[5] | !XI[9] & errBit[5];
   // assign DDO[6] = XI[10] & !errBit[6] | !XI[10] & errBit[6];
   // assign DDO[7] = XI[11] & !errBit[7] | !XI[11] & errBit[7];
   // assign DDO[8] = XI[12] & !errBit[8] | !XI[12] & errBit[8];
   // assign DDO[9] = XI[13] & !errBit[9] | !XI[13] & errBit[9];
   // assign DDO[10] = XI[14] & !errBit[10] | !XI[14] & errBit[10];
   // assign DDO[11] = XI[16] & !errBit[11] | !XI[16] & errBit[11];
   // assign DDO[12] = XI[17] & !errBit[12] | !XI[17] & errBit[12];
   // assign DDO[13] = XI[18] & !errBit[13] | !XI[18] & errBit[13];
   // assign DDO[14] = XI[19] & !errBit[14] | !XI[19] & errBit[14];
   // assign DDO[15] = XI[20] & !errBit[15] | !XI[20] & errBit[15];
   // assign DDO[16] = XI[21] & !errBit[16] | !XI[21] & errBit[16];
   // assign DDO[17] = XI[22] & !errBit[17] | !XI[22] & errBit[17];
   // assign DDO[18] = XI[23] & !errBit[18] | !XI[23] & errBit[18];
   // assign DDO[19] = XI[24] & !errBit[19] | !XI[24] & errBit[19];
   // assign DDO[20] = XI[25] & !errBit[20] | !XI[25] & errBit[20];
   // assign DDO[21] = XI[26] & !errBit[21] | !XI[26] & errBit[21];
   // assign DDO[22] = XI[28] & !errBit[22] | !XI[28] & errBit[22];
   // assign DDO[23] = XI[29] & !errBit[23] | !XI[29] & errBit[23];
   // assign DDO[24] = XI[30] & !errBit[24] | !XI[30] & errBit[24];
   // assign DDO[25] = XI[31] & !errBit[25] | !XI[31] & errBit[25];
   // assign DDO[26] = XI[32] & !errBit[26] | !XI[32] & errBit[26];
   // assign DDO[27] = XI[33] & !errBit[27] | !XI[33] & errBit[27];
   // assign DDO[28] = XI[34] & !errBit[28] | !XI[34] & errBit[28];
   // assign DDO[29] = XI[35] & !errBit[29] | !XI[35] & errBit[29];
   // assign DDO[30] = XI[36] & !errBit[30] | !XI[36] & errBit[30];
   // assign DDO[31] = XI[37] & !errBit[31] | !XI[37] & errBit[31];
   // assign DDO[32] = XI[38] & !errBit[32] | !XI[38] & errBit[32];
   // assign DDO[33] = XI[39] & !errBit[33] | !XI[39] & errBit[33];
   // assign DDO[34] = XI[40] & !errBit[34] | !XI[40] & errBit[34];
   // assign DDO[35] = XI[41] & !errBit[35] | !XI[41] & errBit[35];
   // assign DDO[36] = XI[42] & !errBit[36] | !XI[42] & errBit[36];
   // assign DDO[37] = XI[43] & !errBit[37] | !XI[43] & errBit[37];
   // assign DDO[38] = XI[44] & !errBit[38] | !XI[44] & errBit[38];
   // assign DDO[39] = XI[45] & !errBit[39] | !XI[45] & errBit[39];

endmodule // streambuf_mem_decoder

