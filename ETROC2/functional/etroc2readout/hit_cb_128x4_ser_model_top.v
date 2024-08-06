
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

module hit_cb_128x4_ser_model_top (
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

   output [3:0]             QA;
   output                   E1A;
   output                   E2A;
   input                    CLKA;
   input                    CENA;
   input [6:0]              AA;
   input                    CLKB;
   input                    CENB;
   input [6:0]              AB;
   input [3:0]              DB;
   input [2:0]              EMAA;
   input [2:0]              EMAB;
   input                    RET1N;
   input                    COLLDISN;
   wire [7:0]             QOA;
   wire [7:0]             DIB;

   hit_cb_128x4_ser_model_wrapper u0 (
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

   hit_cb_128x4_ser_encoder_model e0 (
         .EDI(DB),
         .EDO(DIB)
   );

   hit_cb_128x4_ser_decoder_model d0 (
         .DDI(QOA),
         .DDO(QA),
         .E1(E1A),
         .E2(E2A)
   );


endmodule

module hit_cb_128x4_ser_model_wrapper (
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

   output [7:0]             QOA;
   input                    CLKA;
   input                    CENA;
   input [6:0]              AA;
   input                    CLKB;
   input                    CENB;
   input [6:0]              AB;
   input [7:0]              DIB;
   input [2:0]              EMAA;
   input [2:0]              EMAB;
   input                    RET1N;
   input                    COLLDISN;

   wire [7:0]    DB;
   wire [7:0]    QA;

   assign DB=DIB;
   assign QOA=QA;
   hit_cb_128x4_ser_model u0 (
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

endmodule // hit_cb_512x4_fr_top


module hit_cb_128x4_ser_encoder_model (EDI, EDO);
   input     [3:0]  EDI;
   output    [7:0]      EDO;

   assign EDO[0] = EDI[0]^EDI[1]^EDI[2];
   assign EDO[1] = EDI[0]^EDI[1]^EDI[3];
   assign EDO[2] = EDI[0]^EDI[2]^EDI[3];
   assign EDO[3] = EDI[0];
   assign EDO[4] = EDI[1]^EDI[2]^EDI[3];
   assign EDO[5] = EDI[1];
   assign EDO[6] = EDI[2];
   assign EDO[7] = EDI[3];

endmodule //hit_cb_512x4_encoder

module hit_cb_128x4_ser_decoder_model (DDI,
         DDO,
         E1,
         E2);

   input       [7:0]   DDI;
   output      [3:0]   DDO;
   output      E1;
   output      E2;

   wire        [3:0]   nc;
   wire        [3:0]   errBit;
   wire        [7:0]   XI;

   assign XI = DDI;

   // Create a new syndrome
   assign nc[0] = XI[0]^XI[3]^XI[5]^XI[6];
   assign nc[1] = XI[1]^XI[3]^XI[5]^XI[7];
   assign nc[2] = XI[2]^XI[3]^XI[6]^XI[7];
   assign nc[3] = XI[4]^XI[5]^XI[6]^XI[7];

   // Is there an error ?
   assign E1 = |nc ;
   assign E2 = E1 && !(^nc) ;

   // For x in 0 to 3; errBit[x] is '1' if it is found faulty
   assign errBit[0] =  !nc[3] &   nc[2] &   nc[1] &   nc[0];
   assign errBit[1] =    nc[3] & !nc[2] &   nc[1] &   nc[0];
   assign errBit[2] =    nc[3] &   nc[2] & !nc[1] &   nc[0];
   assign errBit[3] =    nc[3] &   nc[2] &   nc[1] & !nc[0];

   // Flip a bit if it is faulty
   assign DDO[0] = XI[3] & !errBit[0] | !XI[3] & errBit[0];
   assign DDO[1] = XI[5] & !errBit[1] | !XI[5] & errBit[1];
   assign DDO[2] = XI[6] & !errBit[2] | !XI[6] & errBit[2];
   assign DDO[3] = XI[7] & !errBit[3] | !XI[7] & errBit[3];

endmodule // hit_cb_512x4_decoder

