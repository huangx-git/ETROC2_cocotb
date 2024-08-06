`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Mon Oct 25 09:54:46 CDT 2021
// Module Name: PRBS17_tb
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
//

//////////////////////////////////////////////////////////////////////////////////


module PRBS17_tb;
    parameter WORDWIDTH = 16;
	reg clk;
    reg reset;

wire [15:0] prbs1;
wire [11:0] BCID;
PRBS17 prbs1Inst
    (
        .clk(clk),
        .reset(reset),
        .dis(1'b0),
        .enableBCID(1'b1),
        .BCID(BCID),
        .prbs(prbs1)
    ); 

reg [63:0] prbsword;

wire match;

always @(posedge clk) 
begin
    prbsword[63:48] <= prbs1;
    prbsword[47:0] <= prbsword[63:16];
end

assign match = ~((prbsword[0]^prbsword[3+0]!=prbsword[17+0]) || 
               (prbsword[1]^prbsword[3+1]!=prbsword[17+1]) ||
               (prbsword[2]^prbsword[3+2]!=prbsword[17+2]) ||
               (prbsword[3]^prbsword[3+3]!=prbsword[17+3]) ||
               (prbsword[4]^prbsword[3+4]!=prbsword[17+4]) ||
               (prbsword[5]^prbsword[3+5]!=prbsword[17+5]) ||
               (prbsword[6]^prbsword[3+6]!=prbsword[17+6]) ||
               (prbsword[7]^prbsword[3+7]!=prbsword[17+7]) ||
               (prbsword[8]^prbsword[3+8]!=prbsword[17+8]) ||
               (prbsword[9]^prbsword[3+9]!=prbsword[17+9]) ||
               (prbsword[10]^prbsword[3+10]!=prbsword[17+10]) ||
               (prbsword[11]^prbsword[3+11]!=prbsword[17+11]) ||
               (prbsword[12]^prbsword[3+12]!=prbsword[17+12]) ||
               (prbsword[13]^prbsword[3+13]!=prbsword[17+13]) ||
               (prbsword[14]^prbsword[3+14]!=prbsword[17+14]) ||
               (prbsword[15]^prbsword[3+15]!=prbsword[17+15]));

    initial begin
        clk = 0;
        reset = 1;

        #25 reset = 1'b0;
        #50 reset = 1'b1;


        #400000 $stop;
    end
    always 
        #12.5 clk = !clk; //25 ns clock period

endmodule