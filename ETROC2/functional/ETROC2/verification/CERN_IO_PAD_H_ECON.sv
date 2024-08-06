/*
 * Module: SF_1V2_THROUGH
 * Author: Cristian Gingu
 * Date: 11/15/2021
 * Description: based on lib_econt_io.v
 * This is a Cell module. Cells are used by certain PLI routines 	(Programming Language Interface)
 * and may be useful for application such as delay calculations.
 */

`timescale 1ps/1ps

//`celldefine
module CERN_IO_PAD_H_ECON (VDDPST, VSSPST, VDD, VSS, A, DS, OUT_EN, PEN, UD, Z_h, Z, IO);
    inout   VDD;             // Core power
    inout   VSS;             // Core ground
    inout   VDDPST;          // IO power
    inout   VSSPST;          // IO ground
    input   A;               // Output data (core side)
    input   DS;              // Drive Strength (1=16mA, 0=5mA)
    input   OUT_EN;          // Output enable
    input   PEN;             // Pull-Up,Pull-Down Enable
    input   UD;              // Pull-Up(=1),Pull-Down(=0)
    inout   IO;              // Bidirectional Data PAD
    output  Z_h;             // Schmitt Trigger input data (core side)
    output  Z;               // Input data (core side)
   // tmrg do_not_touch
   //--------------------   PAD => core pin (Z)   --------------------//
   // gate-level schematic, only for reference
   //
   //nand      (pullup_en_b,  PEN, \UD* ) ;       // control logic
   //nor       (pulldown_en, ~PEN, \UD* ) ;
   //pullup    (Ru) ;                             // 40 kohm pullup-resistor
   //pulldown  (Rd) ;                             // 40 khom pull-down resistor
   //pmos      (Internal, Ru, pullup_en_b) ;      // pmos(D,S,G)
   //nmos      (Internal, Rd, pulldown_en ) ;     // nmos(D,S,G)
   //

   wire  pullup_en_b ;
   wire  pulldown_en ;

   assign pullup_en_b = ~(  PEN & UD ) ;
   assign pulldown_en = ~( ~PEN | UD ) ;

   wire Internal ;

   bufif0 (weak0, weak1) pullup_buf (Internal, 1'b1, pullup_en_b) ;
   bufif1 (weak0, weak1) pulldown_buf (Internal, 1'b0, pulldown_en) ;

   rtran res (Internal, IO) ;    // resistive bidirectional path between IO and Internal (SF_1V2_CDM)

   buf input_buf (Z,   Internal) ;
   buf input_schmitt_buf (Z_h, Internal) ;
   //buf #(1.038, 1.241) (Z, Internal) ;   // 1.038 ns tpLH and 1.241 tpHL delays from SPICE simulation (TT, 30 fF internal load capacitance)


   //--------------------   core pin (A) => PAD   --------------------//
   // delay table (maybe not required)
   //
   //   DS     PEN   UP     tpLH (ps)   tpHL (ps)
   //  1'b0   1'b0  1'b0       -          -
   //  1'b0   1'b1  1'b0
   //  1'b0   1'b1  1'b1
   //  1'b1   1'b0  1'b0
   //  1'b1   1'b1  1'b0
   //  1'b1   1'b1  1'b1
   //

   reg A_reg ;    // to take into account drive-strength

   always @(A or DS) begin
      case ( DS )
         1'b0    : A_reg = A ;        // no delays
         1'b1    : A_reg = A ;
         default : A_reg = A ;
         //1'b0    : A_reg = #(,) A ;
         //1'b1    : A_reg = #(,) A ;
         //default : A_reg = #(,) A ;
      endcase
   end

   bufif1  out_data_buf (IO, A_reg, OUT_EN ) ;

endmodule
//`endcelldefine
