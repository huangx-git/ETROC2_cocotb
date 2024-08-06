`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL
// Author:      Quan Sun
// 
// Create Date:    Wed Jan 06 2020
// Design Name:    sram_rf_model 
// Module Name:    sram_rf_model
// Project Name: 
// Description: simpified register file model to emulate ARM register file
//
// Dependencies: 
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////


module sram_rf_model #(
parameter wordwidth = 32,
parameter addrwidth = 9,
parameter memdepth = (1 << addrwidth)
)
(
   output reg [wordwidth-1:0]   QA,
   output                   E1A,   //Output for test?
   output                   E2A,   //Output for test? 
   input                    CLKA,
   input                    CENA,
   input [addrwidth-1:0]    AA,
   input                    CLKB,
   input                    CENB,
   input [addrwidth-1:0]    AB,
   input [wordwidth-1:0]    DB,
   input [2:0]              EMAA,       //not used
   input [2:0]              EMAB,       //not used
   input                    RET1N,      //useful
   input                    COLLDISN   //not used
);



   reg [wordwidth-1:0] memory [memdepth-1:0];
//   reg [wordwidth-1:0] QA;

   assign E1A = RET1N&(~CENA)&(~CENB)? 1'b0: 1'b1; //?
   assign E2A = RET1N&(~CENA)&(~CENB)? 1'b0: 1'b1; 

   always@(posedge CLKB) begin
       if(!CENB && RET1N)
            memory[AB] <= DB;
   end

   always@(posedge CLKA) begin
       if(!CENA && RET1N)   QA <= memory[AA];
//       else QA = 32'hxxxxxxxx;
 //        else QA <= 32'h00000000; //for data check
//         else QA <= QA;
   end  


   integer i;
   initial begin 
   for (i=0; i<memdepth; i=i+1)
    begin
//      memory[i] = $urandom%(wordwidth+1);
      QA <= {wordwidth{1'b0}};
      memory[i] = 0;
    end
   end 

endmodule