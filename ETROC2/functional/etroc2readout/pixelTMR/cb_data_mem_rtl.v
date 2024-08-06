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
//       Instance Name:              cb_data_mem_rtl_top
//       Words:                      512
//       User Bits:                  29
//       Mux:                        2
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
//       Creation Date:  Mon Mar 29 23:58:24 2021
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

   E1A : Output present when SER is enabled. It is normally at logic 0. When a single bit or two
               bit error is detected(When 2bd1bc is selected), it is set to logic 1.
   E2A : Output present when SER is selected with two bit error detected, when 2bd1bc is selected.
               It is normally at logic-0. When a two or more bit error is detected, it is set to logic 1.
               Asserted along with E1A if there is a two bit error.
*/

module cb_data_mem_rtl_top (
          QA, 
      //     E1A,  //no E1A  
      //     E2A,  //no E2A  
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
//    output [28:0]            QA;
      output [35:0]            QA;  //do not decode data until frame builder
//    output                   E1A;
//    output                   E2A;
   input                    CLKA;
   input                    CENA;
   input [8:0]              AA;
   input                    CLKB;
   input                    CENB;
   input [8:0]              AB;
   input [28:0]             DB;
   input [2:0]              EMAA;
   input [2:0]              EMAB;
   input                    RET1N;
   input                    COLLDISN;
   wire [35:0]             QOA;
   wire [35:0]             DIB;

   cb_data_mem_fr_top u0 (
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

   cb_data_mem_encoder e0 (
         .EDI(DB),
         .EDO(DIB)
   );

      assign QA = QOA;   
//    cb_data_mem_decoder d0 (
//          .DDI(QOA),
//          .DDO(QA),
//          .E1(E1A),
//          .E2(E2A)
//    );


endmodule

module cb_data_mem_fr_top (
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

   output [35:0]            QOA;
   input                    CLKA;
   input                    CENA;
   input [8:0]              AA;
   input                    CLKB;
   input                    CENB;
   input [8:0]              AB;
   input [35:0]             DIB;
   input [2:0]              EMAA;
   input [2:0]              EMAB;
   input                    RET1N;
   input                    COLLDISN;

   wire [35:0]    DB;
   wire [35:0]    QA;

   assign DB=DIB;
   assign QOA=QA;
   cb_data_mem u0 (
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

endmodule // cb_data_mem_fr_top


module cb_data_mem_encoder (EDI, EDO);
// tmrg default do_not_triplicate

   input     [28:0]  EDI;
   output    [35:0]      EDO;

   assign EDO[0] = EDI[0]^EDI[1]^EDI[2]^EDI[4]^EDI[5]^EDI[7]^EDI[9]^EDI[10]^EDI[12]^EDI[17]^EDI[20]^EDI[24];
   assign EDO[1] = EDI[0]^EDI[1]^EDI[3]^EDI[4]^EDI[6]^EDI[9]^EDI[11]^EDI[13]^EDI[14]^EDI[16]^EDI[18]^EDI[21]^EDI[25];
   assign EDO[2] = EDI[0]^EDI[2]^EDI[3]^EDI[5]^EDI[6]^EDI[8]^EDI[10]^EDI[11]^EDI[15]^EDI[16]^EDI[19]^EDI[22]^EDI[26];
   assign EDO[3] = EDI[0];
   assign EDO[4] = EDI[1]^EDI[2]^EDI[3]^EDI[7]^EDI[8]^EDI[12]^EDI[13]^EDI[17]^EDI[18]^EDI[19]^EDI[23]^EDI[27];
   assign EDO[5] = EDI[1];
   assign EDO[6] = EDI[2];
   assign EDO[7] = EDI[3];
   assign EDO[8] = EDI[4]^EDI[5]^EDI[6]^EDI[7]^EDI[8]^EDI[14]^EDI[15]^EDI[20]^EDI[21]^EDI[22]^EDI[23]^EDI[28];
   assign EDO[9] = EDI[4];
   assign EDO[10] = EDI[5];
   assign EDO[11] = EDI[6];
   assign EDO[12] = EDI[7];
   assign EDO[13] = EDI[8];
   assign EDO[14] = EDI[9]^EDI[10]^EDI[11]^EDI[12]^EDI[13]^EDI[14]^EDI[15]^EDI[24]^EDI[25]^EDI[26]^EDI[27]^EDI[28];
   assign EDO[15] = EDI[9];
   assign EDO[16] = EDI[10];
   assign EDO[17] = EDI[11];
   assign EDO[18] = EDI[12];
   assign EDO[19] = EDI[13];
   assign EDO[20] = EDI[14];
   assign EDO[21] = EDI[15];
   assign EDO[22] = EDI[16]^EDI[17]^EDI[18]^EDI[19]^EDI[20]^EDI[21]^EDI[22]^EDI[23]^EDI[24]^EDI[25]^EDI[26]^EDI[27]^EDI[28];
   assign EDO[23] = EDI[16];
   assign EDO[24] = EDI[17];
   assign EDO[25] = EDI[18];
   assign EDO[26] = EDI[19];
   assign EDO[27] = EDI[20];
   assign EDO[28] = EDI[21];
   assign EDO[29] = EDI[22];
   assign EDO[30] = EDI[23];
   assign EDO[31] = EDI[24];
   assign EDO[32] = EDI[25];
   assign EDO[33] = EDI[26];
   assign EDO[34] = EDI[27];
   assign EDO[35] = EDI[28];

endmodule //cb_data_mem_encoder


