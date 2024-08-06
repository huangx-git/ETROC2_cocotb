//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL
// Author:      Quan Sun
// 
// Create Date:    Wed Jan 06 2020
// Design Name:    rf_model 
// Module Name:    rf_model
// Project Name: 
// Description: simpified register file model to emulate ARM register file
//
// Dependencies: 
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////

`define wordwidth 8
`define memdepth 128
module hit_cb_128x4_ser_model(
          QA, 
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
   output [`wordwidth-1:0]            QA;
//   output                   E1A;
//   output                   E2A;
   input                    CLKA;
   input                    CENA;
   input [6:0]              AA;
   input                    CLKB;
   input                    CENB;
   input [6:0]              AB;
   input [`wordwidth-1:0]             DB;
   input [2:0]              EMAA;
   input [2:0]              EMAB;
   input                    RET1N;
   input                    COLLDISN;

   reg [`wordwidth-1:0] memory [`memdepth-1:0];
   reg [`wordwidth-1:0] QA;

 //  assign E1A = RET1N&(~CENA)&(~CENB)?0:1'bx;
 //  assign E2A = RET1N&(~CENA)&(~CENB)?0:1'bx;

   always@(posedge CLKB) begin
       if(!CENB && RET1N)
            memory[AB] = DB;
   end

   always@(posedge CLKA) begin
       if(!CENA && RET1N)   QA = memory[AA];
       else QA = QA;
   end  

   integer i;
   initial begin 
   for (i=0; i<`memdepth; i=i+1)
    begin
//      memory[i] = $urandom%(wordwidth+1);
      QA <= {`wordwidth{1'b0}};
      memory[i] = 0;
    end
   end 

endmodule
