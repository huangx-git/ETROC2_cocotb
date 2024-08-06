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
//       Instance Name:              L1_hit_mem_rtl_top
//       Words:                      128
//       User Bits:                  1
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
//       Creation Date:  Mon Apr  5 23:31:43 2021
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

module L1_hit_mem_rtl_top (
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
// tmrg default do_not_triplicate

   output                   QA;
   output                   E1A;
   output                   E2A;
   input                    CLKA;
   input                    CENA;
   input [6:0]              AA;
   input                    CLKB;
   input                    CENB;
   input [6:0]              AB;
   input                    DB;
   input [2:0]              EMAA;
   input [2:0]              EMAB;
   input                    RET1N;
   input                    COLLDISN;
   wire [3:0]             QOA;
   wire [3:0]             DIB;

   L1_hit_mem_fr_top u0 (
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

   L1_hit_mem_encoder e0 (
         .EDI(DB),
         .EDO(DIB)
   );

   L1_hit_mem_decoder d0 (
         .DDI(QOA),
         .DDO(QA),
         .E1(E1A),
         .E2(E2A)
   );


endmodule

module L1_hit_mem_fr_top (
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

   output [3:0]             QOA;
   input                    CLKA;
   input                    CENA;
   input [6:0]              AA;
   input                    CLKB;
   input                    CENB;
   input [6:0]              AB;
   input [3:0]              DIB;
   input [2:0]              EMAA;
   input [2:0]              EMAB;
   input                    RET1N;
   input                    COLLDISN;

   wire [3:0]    DB;
   wire [3:0]    QA;

   assign DB ={DIB[3],~DIB[2],DIB[1],~DIB[0]};  //changed
   assign QOA={QA[3], ~QA[2], QA[1], ~QA[0]};   //changed
 `ifdef LATCH_RAM
      latchedBasedRAM #(.data_width(4),.depth(128),.log_depth(7),.delay(4)) u0
 `else
   L1_hit_mem u0 
`endif   
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

endmodule // L1_hit_mem_fr_top


module L1_hit_mem_encoder (EDI, EDO);
// tmrg default do_not_triplicate

   input     [0:0]  EDI;
   output    [3:0]      EDO;

   assign EDO[0] = EDI[0];
   assign EDO[1] = EDI[0];
   assign EDO[2] = EDI[0];
   assign EDO[3] = EDI[0];

endmodule //L1_hit_mem_encoder

module L1_hit_mem_decoder (DDI,
         DDO,
         E1,
         E2);
// tmrg default do_not_triplicate

   input       [3:0]   DDI;
   output      [0:0]   DDO;
   output      E1;
   output      E2;

   wire        [2:0]   nc;
   wire        [0:0]   errBit;
   wire        [3:0]   XI;

   assign XI = DDI;

   // Create a new syndrome
   assign nc[0] = XI[0]^XI[3];
   assign nc[1] = XI[1]^XI[3];
   assign nc[2] = XI[2]^XI[3];

   // Is there an error ?
   assign E1 = |nc ;
   assign E2 = E1 & ~(^nc) ;

   // For x in 0 to 0; errBit[x] is '1' if it is found faulty
   assign errBit[0] =    nc[2] &   nc[1] &   nc[0];

   // Flip a bit if it is faulty
   assign DDO[0] = XI[3] & ~errBit[0] | ~XI[3] & errBit[0];

endmodule // L1_hit_mem_decoder

