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
//       Instance Name:              cb_hit_mem8_rtl_top
//       Words:                      64
//       User Bits:                  8
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
//       Creation Date:  Mon Mar 29 15:16:20 2021
//       Version:      r0p0
//
//       Verified
//
//       Known Bugs: None.
//
//       Known Work Arounds: N/A
//
`timescale 1ns/1ps

/*
   Soft Error Repair Special Variable Description :
   ==============================================

   E1A : Output present when SER is enabled. It is normally at logic 0. When a single bit
               bit error is detected, it is set to logic 1.
*/

module cb_hit_mem8_rtl_top (
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
// tmrg default do_not_triplicate

   output [7:0]             QA;
   output                   E1A;
   input                    CLKA;
   input                    CENA;
   input [5:0]              AA;
   input                    CLKB;
   input                    CENB;
   input [5:0]              AB;
   input [7:0]              DB;
   input [2:0]              EMAA;
   input [2:0]              EMAB;
   input                    RET1N;
   input                    COLLDISN;
   wire [11:0]             QOA;
   wire [11:0]             DIB;

   cb_hit_mem8_fr_top u0 (
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

   cb_hit_mem8_encoder e0 (
         .EDI(DB),
         .EDO(DIB)
   );

   cb_hit_mem8_decoder d0 (
         .DDI(QOA),
         .DDO(QA),
         .E1(E1A)
   );


endmodule

module cb_hit_mem8_fr_top (
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
// tmrg default do_not_triplicate

   output [11:0]            QOA;
   input                    CLKA;
   input                    CENA;
   input [5:0]              AA;
   input                    CLKB;
   input                    CENB;
   input [5:0]              AB;
   input [11:0]             DIB;
   input [2:0]              EMAA;
   input [2:0]              EMAB;
   input                    RET1N;
   input                    COLLDISN;

   wire [11:0]    DB;
   wire [11:0]    QA;

   assign DB=DIB;
   assign QOA=QA;
   cb_hit_mem8 u0 (
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

endmodule // cb_hit_mem8_fr_top


module cb_hit_mem8_encoder (EDI, EDO);
// tmrg default do_not_triplicate

   input     [7:0]  EDI;
   output    [11:0]      EDO;

   assign EDO[0] = EDI[0]^EDI[1]^EDI[3]^EDI[4];
   assign EDO[1] = EDI[0]^EDI[2]^EDI[3]^EDI[5]^EDI[7];
   assign EDO[2] = EDI[0];
   assign EDO[3] = EDI[1]^EDI[2]^EDI[3]^EDI[6]^EDI[7];
   assign EDO[4] = EDI[1];
   assign EDO[5] = EDI[2];
   assign EDO[6] = EDI[3];
   assign EDO[7] = EDI[4]^EDI[5]^EDI[6]^EDI[7];
   assign EDO[8] = EDI[4];
   assign EDO[9] = EDI[5];
   assign EDO[10] = EDI[6];
   assign EDO[11] = EDI[7];

endmodule //cb_hit_mem8_encoder

module cb_hit_mem8_decoder (DDI,
         DDO,
         E1);
// tmrg default do_not_triplicate

   input       [11:0]   DDI;
   output      [7:0]   DDO;
   output      E1;

   wire        [3:0]   nc;
   wire        [7:0]   errBit;
   wire        [11:0]   XI;

   assign XI = DDI;

   // Create a new syndrome
   assign nc[0] = XI[0]^XI[2]^XI[4]^XI[6]^XI[8];
   assign nc[1] = XI[1]^XI[2]^XI[5]^XI[6]^XI[9]^XI[11];
   assign nc[2] = XI[3]^XI[4]^XI[5]^XI[6]^XI[10]^XI[11];
   assign nc[3] = XI[7]^XI[8]^XI[9]^XI[10]^XI[11];

   // Is there an error ?
   assign E1 = |nc ;

   // For x in 0 to 7; errBit[x] is '1' if it is found faulty
   assign errBit[0] =  !nc[3] & !nc[2] &   nc[1] &   nc[0];
   assign errBit[1] =  !nc[3] &   nc[2] & !nc[1] &   nc[0];
   assign errBit[2] =  !nc[3] &   nc[2] &   nc[1] & !nc[0];
   assign errBit[3] =  !nc[3] &   nc[2] &   nc[1] &   nc[0];
   assign errBit[4] =    nc[3] & !nc[2] & !nc[1] &   nc[0];
   assign errBit[5] =    nc[3] & !nc[2] &   nc[1] & !nc[0];
   assign errBit[6] =    nc[3] &   nc[2] & !nc[1] & !nc[0];
   assign errBit[7] =    nc[3] &   nc[2] &   nc[1] & !nc[0];

   // Flip a bit if it is faulty
   assign DDO[0] = XI[2] & !errBit[0] | !XI[2] & errBit[0];
   assign DDO[1] = XI[4] & !errBit[1] | !XI[4] & errBit[1];
   assign DDO[2] = XI[5] & !errBit[2] | !XI[5] & errBit[2];
   assign DDO[3] = XI[6] & !errBit[3] | !XI[6] & errBit[3];
   assign DDO[4] = XI[8] & !errBit[4] | !XI[8] & errBit[4];
   assign DDO[5] = XI[9] & !errBit[5] | !XI[9] & errBit[5];
   assign DDO[6] = XI[10] & !errBit[6] | !XI[10] & errBit[6];
   assign DDO[7] = XI[11] & !errBit[7] | !XI[11] & errBit[7];

endmodule // cb_hit_mem8_decoder

