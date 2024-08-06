/* verilog_memcomp Version: c0.3.2-EAC */
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
//      Verilog model for Synchronous Two-Port Register File
//
//       Instance Name:              cb_data_mem
//       Words:                      512
//       Bits:                       36
//       Mux:                        2
//       Drive:                      6
//       Write Mask:                 Off
//       Write Thru:                 Off
//       Extra Margin Adjustment:    On
//       Redundant Columns:          0
//       Test Muxes                  Off
//       Power Gating:               Off
//       Retention:                  On
//       Pipeline:                   Off
//       Read Disturb Test:	        Off
//       
//       Creation Date:  Mon Mar 29 23:58:00 2021
//       Version: 	r0p0
//
//      Modeling Assumptions: This model supports full gate level simulation
//          including proper x-handling and timing check behavior.  Unit
//          delay timing is included in the model. Back-annotation of SDF
//          (v3.0 or v2.1) is supported.  SDF can be created utilyzing the delay
//          calculation views provided with this generator and supported
//          delay calculators.  All buses are modeled [MSB:LSB].  All 
//          ports are padded with Verilog primitives.
//
//      Modeling Limitations: None.
//
//      Known Bugs: None.
//
//      Known Work Arounds: N/A
//
`timescale 1 ns/1 ps
module cb_data_mem (QA, CLKA, CENA, AA, CLKB, CENB, AB, DB, EMAA, EMAB, RET1N, COLLDISN);

// tmrg default do_not_triplicate

  parameter ASSERT_PREFIX = "";
  parameter BITS = 36;
  parameter WORDS = 512;
  parameter MUX = 2;
  parameter MEM_WIDTH = 72; // redun block size 2, 36 on left, 36 on right
  parameter MEM_HEIGHT = 256;
  parameter WP_SIZE = 36 ;
  parameter UPM_WIDTH = 3;
  parameter UPMW_WIDTH = 0;
  parameter UPMS_WIDTH = 0;

  output [35:0] QA;
  input  CLKA;
  input  CENA;
  input [8:0] AA;
  input  CLKB;
  input  CENB;
  input [8:0] AB;
  input [35:0] DB;
  input [2:0] EMAA;
  input [2:0] EMAB;
  input  RET1N;
  input  COLLDISN;

endmodule
