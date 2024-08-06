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
//       Instance Name:              BCID_mem_rtl_top
//       Words:                      128
//       User Bits:                  12
//       Mux:                        1
//       Drive:                      6
//       Write Mask:                 Off
//       Extra Margin Adjustment:    On
//       Redundancy:                 off
//       Redundant Rows:             0
//       Redundant Columns:          0
//       Test Muxes                  Off
//       Ser:                        2bd1bc
//       Retention:                  on
//       Power Gating:               off
//
//       Creation Date:  Wed Apr  7 18:45:48 2021
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

   E1A : Output present when SER is enabled. It is normally at logic 0. When a single bit or two
               bit error is detected(When 2bd1bc is selected), it is set to logic 1.
   E2A : Output present when SER is selected with two bit error detected, when 2bd1bc is selected.
               It is normally at logic-0. When a two or more bit error is detected, it is set to logic 1.
               Asserted along with E1A if there is a two bit error.
*/

module BCID_mem_rtl_top (
          QA, 
          E1A, 
          E2A, 
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

   output [11:0]            QA;
   output                   E1A;
   output                   E2A;
   input                    CLKA;
   input                    CENA;
   input [6:0]              AA;
   input                    CLKB;
   input                    CENB;
   input [6:0]              AB;
   input [11:0]             DB;
   input [2:0]              EMAA;
   input [2:0]              EMAB;
   input                    RET1N;
   input                    COLLDISN;
   wire [17:0]             QOA;
   wire [17:0]             DIB;

   BCID_mem_fr_top u0 (
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

   BCID_mem_encoder e0 (
         .EDI(DB),
         .EDO(DIB)
   );

   BCID_mem_decoder d0 (
         .DDI(QOA),
         .DDO(QA),
         .E1CODE(E1A),
         .E2CODE(E2A)
   );


endmodule

module BCID_mem_fr_top (
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
// tmrg do_not_triplicate u0

   output [17:0]            QOA;
   input                    CLKA;
   input                    CENA;
   input [6:0]              AA;
   input                    CLKB;
   input                    CENB;
   input [6:0]              AB;
   input [17:0]             DIB;
   input [2:0]              EMAA;
   input [2:0]              EMAB;
   input                    RET1N;
   input                    COLLDISN;

   wire [17:0]    DB;
   wire [17:0]    QA;

   assign DB=DIB;
   assign QOA=QA;
// `ifdef LATCH_RAM
//latchedBasedRAM is not triplicated.
      latchedBasedRAM #(.data_width(18),.depth(128),.log_depth(7),.delay(4)) u0
//  `else
//    BCID_mem u0 
// `endif
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

endmodule // BCID_mem_fr_top


module BCID_mem_encoder (EDI, EDO);
// tmrg default triplicate
   input     [11:0]  EDI;
   output    [17:0]      EDO;

   assign EDO[0] = EDI[0]^EDI[1]^EDI[2]^EDI[4]^EDI[5]^EDI[8];
   assign EDO[1] = EDI[0]^EDI[1]^EDI[3]^EDI[4]^EDI[6]^EDI[9];
   assign EDO[2] = EDI[0]^EDI[2]^EDI[3]^EDI[5]^EDI[7]^EDI[10];
   assign EDO[3] = EDI[0];
   assign EDO[4] = EDI[1]^EDI[2]^EDI[3]^EDI[6]^EDI[7]^EDI[11];
   assign EDO[5] = EDI[1];
   assign EDO[6] = EDI[2];
   assign EDO[7] = EDI[3];
   assign EDO[8] = EDI[4]^EDI[5]^EDI[8]^EDI[9]^EDI[10]^EDI[11];
   assign EDO[9] = EDI[4];
   assign EDO[10] = EDI[5];
   assign EDO[11] = EDI[6]^EDI[7]^EDI[8]^EDI[9]^EDI[10]^EDI[11];
   assign EDO[12] = EDI[6];
   assign EDO[13] = EDI[7];
   assign EDO[14] = EDI[8];
   assign EDO[15] = EDI[9];
   assign EDO[16] = EDI[10];
   assign EDO[17] = EDI[11];

endmodule //BCID_mem_encoder

module BCID_mem_decoder (DDI,
         DDO,
         E1CODE,
         E2CODE);
// tmrg default triplicate

   input       [17:0]   DDI;
   output      [11:0]   DDO;
   output      E1CODE;
   output      E2CODE;

   wire        [5:0]   nc;
   wire        [11:0]   errBit;
   wire        [17:0]   XI;

   assign XI = DDI;

   // Create a new syndrome
   assign nc[0] = XI[0]^XI[3]^XI[5]^XI[6]^XI[9]^XI[10]^XI[14];
   assign nc[1] = XI[1]^XI[3]^XI[5]^XI[7]^XI[9]^XI[12]^XI[15];
   assign nc[2] = XI[2]^XI[3]^XI[6]^XI[7]^XI[10]^XI[13]^XI[16];
   assign nc[3] = XI[4]^XI[5]^XI[6]^XI[7]^XI[12]^XI[13]^XI[17];
   assign nc[4] = XI[8]^XI[9]^XI[10]^XI[14]^XI[15]^XI[16]^XI[17];
   assign nc[5] = XI[11]^XI[12]^XI[13]^XI[14]^XI[15]^XI[16]^XI[17];

   // Is there an error ?
   assign E1CODE = |nc ;
   assign E2CODE = E1CODE && !(^nc) ;

   // For x in 0 to 11; errBit[x] is '1' if it is found faulty
   assign errBit[0] =  !nc[5] & !nc[4] & !nc[3] &   nc[2] &   nc[1] &   nc[0];
   assign errBit[1] =  !nc[5] & !nc[4] &   nc[3] & !nc[2] &   nc[1] &   nc[0];
   assign errBit[2] =  !nc[5] & !nc[4] &   nc[3] &   nc[2] & !nc[1] &   nc[0];
   assign errBit[3] =  !nc[5] & !nc[4] &   nc[3] &   nc[2] &   nc[1] & !nc[0];
   assign errBit[4] =  !nc[5] &   nc[4] & !nc[3] & !nc[2] &   nc[1] &   nc[0];
   assign errBit[5] =  !nc[5] &   nc[4] & !nc[3] &   nc[2] & !nc[1] &   nc[0];
   assign errBit[6] =    nc[5] & !nc[4] &   nc[3] & !nc[2] &   nc[1] & !nc[0];
   assign errBit[7] =    nc[5] & !nc[4] &   nc[3] &   nc[2] & !nc[1] & !nc[0];
   assign errBit[8] =    nc[5] &   nc[4] & !nc[3] & !nc[2] & !nc[1] &   nc[0];
   assign errBit[9] =    nc[5] &   nc[4] & !nc[3] & !nc[2] &   nc[1] & !nc[0];
   assign errBit[10] =    nc[5] &   nc[4] & !nc[3] &   nc[2] & !nc[1] & !nc[0];
   assign errBit[11] =    nc[5] &   nc[4] &   nc[3] & !nc[2] & !nc[1] & !nc[0];

   // Flip a bit if it is faulty
   assign DDO[0] = XI[3] & !errBit[0] | !XI[3] & errBit[0];
   assign DDO[1] = XI[5] & !errBit[1] | !XI[5] & errBit[1];
   assign DDO[2] = XI[6] & !errBit[2] | !XI[6] & errBit[2];
   assign DDO[3] = XI[7] & !errBit[3] | !XI[7] & errBit[3];
   assign DDO[4] = XI[9] & !errBit[4] | !XI[9] & errBit[4];
   assign DDO[5] = XI[10] & !errBit[5] | !XI[10] & errBit[5];
   assign DDO[6] = XI[12] & !errBit[6] | !XI[12] & errBit[6];
   assign DDO[7] = XI[13] & !errBit[7] | !XI[13] & errBit[7];
   assign DDO[8] = XI[14] & !errBit[8] | !XI[14] & errBit[8];
   assign DDO[9] = XI[15] & !errBit[9] | !XI[15] & errBit[9];
   assign DDO[10] = XI[16] & !errBit[10] | !XI[16] & errBit[10];
   assign DDO[11] = XI[17] & !errBit[11] | !XI[17] & errBit[11];

endmodule // BCID_mem_decoder

