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

module cb_data_mem_decoder (DDI,
         DDO,
         E1,
         E2);
// tmrg default triplicate

   input       [35:0]   DDI;
   output      [28:0]   DDO;
   output      E1;
   output      E2;

   wire        [6:0]   nc;
   wire        [28:0]   errBit;
   wire        [35:0]   XI;

   assign XI = DDI;

   // Create a new syndrome
   assign nc[0] = XI[0]^XI[3]^XI[5]^XI[6]^XI[9]^XI[10]^XI[12]^XI[15]^XI[16]^XI[18]^XI[24]^XI[27]^XI[31];
   assign nc[1] = XI[1]^XI[3]^XI[5]^XI[7]^XI[9]^XI[11]^XI[15]^XI[17]^XI[19]^XI[20]^XI[23]^XI[25]^XI[28]^XI[32];
   assign nc[2] = XI[2]^XI[3]^XI[6]^XI[7]^XI[10]^XI[11]^XI[13]^XI[16]^XI[17]^XI[21]^XI[23]^XI[26]^XI[29]^XI[33];
   assign nc[3] = XI[4]^XI[5]^XI[6]^XI[7]^XI[12]^XI[13]^XI[18]^XI[19]^XI[24]^XI[25]^XI[26]^XI[30]^XI[34];
   assign nc[4] = XI[8]^XI[9]^XI[10]^XI[11]^XI[12]^XI[13]^XI[20]^XI[21]^XI[27]^XI[28]^XI[29]^XI[30]^XI[35];
   assign nc[5] = XI[14]^XI[15]^XI[16]^XI[17]^XI[18]^XI[19]^XI[20]^XI[21]^XI[31]^XI[32]^XI[33]^XI[34]^XI[35];
   assign nc[6] = XI[22]^XI[23]^XI[24]^XI[25]^XI[26]^XI[27]^XI[28]^XI[29]^XI[30]^XI[31]^XI[32]^XI[33]^XI[34]^XI[35];

   // Is there an error ?
   assign E1 = |nc ;
   assign E2 = E1 && !(^nc) ;

   // For x in 0 to 28; errBit[x] is '1' if it is found faulty
   assign errBit[0] =  !nc[6] & !nc[5] & !nc[4] & !nc[3] &   nc[2] &   nc[1] &   nc[0];
   assign errBit[1] =  !nc[6] & !nc[5] & !nc[4] &   nc[3] & !nc[2] &   nc[1] &   nc[0];
   assign errBit[2] =  !nc[6] & !nc[5] & !nc[4] &   nc[3] &   nc[2] & !nc[1] &   nc[0];
   assign errBit[3] =  !nc[6] & !nc[5] & !nc[4] &   nc[3] &   nc[2] &   nc[1] & !nc[0];
   assign errBit[4] =  !nc[6] & !nc[5] &   nc[4] & !nc[3] & !nc[2] &   nc[1] &   nc[0];
   assign errBit[5] =  !nc[6] & !nc[5] &   nc[4] & !nc[3] &   nc[2] & !nc[1] &   nc[0];
   assign errBit[6] =  !nc[6] & !nc[5] &   nc[4] & !nc[3] &   nc[2] &   nc[1] & !nc[0];
   assign errBit[7] =  !nc[6] & !nc[5] &   nc[4] &   nc[3] & !nc[2] & !nc[1] &   nc[0];
   assign errBit[8] =  !nc[6] & !nc[5] &   nc[4] &   nc[3] &   nc[2] & !nc[1] & !nc[0];
   assign errBit[9] =  !nc[6] &   nc[5] & !nc[4] & !nc[3] & !nc[2] &   nc[1] &   nc[0];
   assign errBit[10] =  !nc[6] &   nc[5] & !nc[4] & !nc[3] &   nc[2] & !nc[1] &   nc[0];
   assign errBit[11] =  !nc[6] &   nc[5] & !nc[4] & !nc[3] &   nc[2] &   nc[1] & !nc[0];
   assign errBit[12] =  !nc[6] &   nc[5] & !nc[4] &   nc[3] & !nc[2] & !nc[1] &   nc[0];
   assign errBit[13] =  !nc[6] &   nc[5] & !nc[4] &   nc[3] & !nc[2] &   nc[1] & !nc[0];
   assign errBit[14] =  !nc[6] &   nc[5] &   nc[4] & !nc[3] & !nc[2] &   nc[1] & !nc[0];
   assign errBit[15] =  !nc[6] &   nc[5] &   nc[4] & !nc[3] &   nc[2] & !nc[1] & !nc[0];
   assign errBit[16] =    nc[6] & !nc[5] & !nc[4] & !nc[3] &   nc[2] &   nc[1] & !nc[0];
   assign errBit[17] =    nc[6] & !nc[5] & !nc[4] &   nc[3] & !nc[2] & !nc[1] &   nc[0];
   assign errBit[18] =    nc[6] & !nc[5] & !nc[4] &   nc[3] & !nc[2] &   nc[1] & !nc[0];
   assign errBit[19] =    nc[6] & !nc[5] & !nc[4] &   nc[3] &   nc[2] & !nc[1] & !nc[0];
   assign errBit[20] =    nc[6] & !nc[5] &   nc[4] & !nc[3] & !nc[2] & !nc[1] &   nc[0];
   assign errBit[21] =    nc[6] & !nc[5] &   nc[4] & !nc[3] & !nc[2] &   nc[1] & !nc[0];
   assign errBit[22] =    nc[6] & !nc[5] &   nc[4] & !nc[3] &   nc[2] & !nc[1] & !nc[0];
   assign errBit[23] =    nc[6] & !nc[5] &   nc[4] &   nc[3] & !nc[2] & !nc[1] & !nc[0];
   assign errBit[24] =    nc[6] &   nc[5] & !nc[4] & !nc[3] & !nc[2] & !nc[1] &   nc[0];
   assign errBit[25] =    nc[6] &   nc[5] & !nc[4] & !nc[3] & !nc[2] &   nc[1] & !nc[0];
   assign errBit[26] =    nc[6] &   nc[5] & !nc[4] & !nc[3] &   nc[2] & !nc[1] & !nc[0];
   assign errBit[27] =    nc[6] &   nc[5] & !nc[4] &   nc[3] & !nc[2] & !nc[1] & !nc[0];
   assign errBit[28] =    nc[6] &   nc[5] &   nc[4] & !nc[3] & !nc[2] & !nc[1] & !nc[0];

   // Flip a bit if it is faulty
   assign DDO[0] = XI[3] & !errBit[0] | !XI[3] & errBit[0];
   assign DDO[1] = XI[5] & !errBit[1] | !XI[5] & errBit[1];
   assign DDO[2] = XI[6] & !errBit[2] | !XI[6] & errBit[2];
   assign DDO[3] = XI[7] & !errBit[3] | !XI[7] & errBit[3];
   assign DDO[4] = XI[9] & !errBit[4] | !XI[9] & errBit[4];
   assign DDO[5] = XI[10] & !errBit[5] | !XI[10] & errBit[5];
   assign DDO[6] = XI[11] & !errBit[6] | !XI[11] & errBit[6];
   assign DDO[7] = XI[12] & !errBit[7] | !XI[12] & errBit[7];
   assign DDO[8] = XI[13] & !errBit[8] | !XI[13] & errBit[8];
   assign DDO[9] = XI[15] & !errBit[9] | !XI[15] & errBit[9];
   assign DDO[10] = XI[16] & !errBit[10] | !XI[16] & errBit[10];
   assign DDO[11] = XI[17] & !errBit[11] | !XI[17] & errBit[11];
   assign DDO[12] = XI[18] & !errBit[12] | !XI[18] & errBit[12];
   assign DDO[13] = XI[19] & !errBit[13] | !XI[19] & errBit[13];
   assign DDO[14] = XI[20] & !errBit[14] | !XI[20] & errBit[14];
   assign DDO[15] = XI[21] & !errBit[15] | !XI[21] & errBit[15];
   assign DDO[16] = XI[23] & !errBit[16] | !XI[23] & errBit[16];
   assign DDO[17] = XI[24] & !errBit[17] | !XI[24] & errBit[17];
   assign DDO[18] = XI[25] & !errBit[18] | !XI[25] & errBit[18];
   assign DDO[19] = XI[26] & !errBit[19] | !XI[26] & errBit[19];
   assign DDO[20] = XI[27] & !errBit[20] | !XI[27] & errBit[20];
   assign DDO[21] = XI[28] & !errBit[21] | !XI[28] & errBit[21];
   assign DDO[22] = XI[29] & !errBit[22] | !XI[29] & errBit[22];
   assign DDO[23] = XI[30] & !errBit[23] | !XI[30] & errBit[23];
   assign DDO[24] = XI[31] & !errBit[24] | !XI[31] & errBit[24];
   assign DDO[25] = XI[32] & !errBit[25] | !XI[32] & errBit[25];
   assign DDO[26] = XI[33] & !errBit[26] | !XI[33] & errBit[26];
   assign DDO[27] = XI[34] & !errBit[27] | !XI[34] & errBit[27];
   assign DDO[28] = XI[35] & !errBit[28] | !XI[35] & errBit[28];

endmodule // cb_data_mem_decoder

