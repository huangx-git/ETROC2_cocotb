`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Tue Feb  9 14:13:14 CST 2021
// Module Name: CRC8_tb
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 

//////////////////////////////////////////////////////////////////////////////////


module CRC8_tb;
    parameter WORDWIDTH = 40;
	reg clk;
    reg reset;
    reg syn_reset;
    reg [WORDWIDTH-1:0] counter;
	wire [7:0] prbs;
	PRBS31 #(.WORDWIDTH(8),
    .FORWARDSTEPS(0)) prbs_inst(
		.clk(clk),
		.reset(syn_reset),
		.dis(1'b0),
		.seed(31'h7AAAAAA),
		.prbs(prbs)
	);

    always @(posedge clk) 
    begin
        if(syn_reset)
        begin
                counter <= {WORDWIDTH{1'b0}}; //initial     
        end
        else 
        begin
                counter <= counter + 99;
        end
    end
    always @(posedge clk) 
    begin
        begin
                syn_reset <= reset;      
        end
    end

    wire [31:0] record;
    assign record = { counter[39:8]};
    wire [7:0] CRC1;
    CRC8 #(.WORDWIDTH(32)) C1Inst(
        .cin(prbs),
        .dis(1'b0),
        .din(record),
        .dout(CRC1)
    );

    wire [7:0] CRC2;
    wire [39:0] record2;
    assign record2 = { counter[39:8], CRC1};
    CRC8 #(.WORDWIDTH(40)) C2Inst(
        .cin(prbs),
        .dis(1'b0),
        .din(record2),
        .dout(CRC2)
    );
 
    initial begin
        clk = 0;
        reset = 0;

        #25 reset = 1'b1;
        #50 reset = 1'b0;


        #100000 $stop;
    end
    always 
        #12.5 clk = ~clk; //25 ns clock period

endmodule