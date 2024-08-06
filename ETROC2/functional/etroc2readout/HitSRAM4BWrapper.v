`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sun Feb  7 14:12:53 CST 2021
// Module Name: hitSRAM4BWrapper
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created
// 
//////////////////////////////////////////////////////////////////////////////////

module hitSRAM4BWrapper
(
	input clk,                  //40MHz
	input hit,                  //hit
    input rden,                 //read enable, high active
    input [8:0] rdAddr,
    input [8:0] wrAddr,
	output outHit               //
);
`ifdef USE_SIMPLE_SRAM_FOR_HITBUFFER //not an actual SRAM model
    sram_rf_model #(.wordwidth(1),.addrwidth(9)) hitMemA(
            .QA(outHit),
            .E1A(),   
            .E2A(),   
            .CLKA(clk),
            .CENA(!rden),
            .AA(rdAddr),
            .CLKB(clk),
            .CENB(1'b0),
            .AB(wrAddr),
            .DB(hit), 
            .EMAA(3'b0),       //not used
            .EMAB(3'b0),       //not used
            .RET1N(1'b1),      
            .COLLDISN(1'b0)   //not used
    );

`elsif USE_SHORT_L1HITBUFFER
    reg [2:0] wrReg; //temperary regs for wrAddr = 9'bxxxxxx00 to 9'bxxxxxx10
    always @(posedge clk) 
    begin
         if(wrAddr[1:0] != 2'b11)
         begin
                 wrReg[wrAddr[1:0]] <= hit;    
         end
    end

    wire [3:0] hitIn;  
    reg [1:0] rdAddr1D;
    wire wren;
    assign hitIn = {hit,wrReg[2:0]};
    assign wren = wrAddr[0] & wrAddr[1]; 
    wire [3:0] hitOut;
    assign outHit = hitOut[rdAddr1D];
    initial begin
        rdAddr1D <= 2'b0; //for simulation only
    end
    always @(posedge clk) 
    begin
        if(rden == 1'b1)
        begin
                rdAddr1D <= rdAddr[1:0];    
        end
    end
    sram_rf_model #(.wordwidth(4),.addrwidth(7)) hitMemA(
            .QA(hitOut),
            .E1A(),   
            .E2A(),   
            .CLKA(clk),
            .CENA(!rden),
            .AA(rdAddr[8:2]),
            .CLKB(clk),
            .CENB(!wren),
            .AB(wrAddr[8:2]),
            .DB(hitIn), 
            .EMAA(3'b0),       //not used
            .EMAB(3'b0),       //not used
            .RET1N(1'b1),      
            .COLLDISN(1'b0)   //not used
    );
`else 
//
    wire [3:0] hitArray;  //4 bit copy. 0,2 bit are copy and 1,3 are inverse copy
    wire [2:0] hitCount;
    assign hitCount = {2'b00,hitArray[0]} + {2'b00,!hitArray[1]} + {2'b00,hitArray[2]} + {2'b00,!hitArray[3]};
    assign outHit = (hitCount >= 3'b011);
    sram_rf_model #(.wordwidth(4),.addrwidth(9)) hitMemA(
            .QA(hitArray),
            .E1A(),   
            .E2A(),   
            .CLKA(clk),
            .CENA(!rden),
            .AA(rdAddr),
            .CLKB(clk),
            .CENB(1'b0),
            .AB(wrAddr),
            .DB({!hit,hit,!hit,hit}), 
            .EMAA(3'b0),       //not used
            .EMAB(3'b0),       //not used
            .RET1N(1'b1),      
            .COLLDISN(1'b0)   //not used
    );
`endif
endmodule

module hitL1SRAM4BWrapper #(
    parameter ADDRWIDTH = 5
)
(
	input clk,                  //40MHz
	input hit,                  //hit
    input rden,                 //read enable, high active
    input wren,                 //write enable, high active
    input [ADDRWIDTH-1:0] rdAddr,
    input [ADDRWIDTH-1:0] wrAddr,
	output outHit               //
);
//
    wire [3:0] hitArray;  //4 bit copy. 0,2 bit are copy and 1,3 are inverse copy
    wire [2:0] hitCount;
    assign hitCount = {2'b00,hitArray[0]} + {2'b00,!hitArray[1]} + {2'b00,hitArray[2]} + {2'b00,!hitArray[3]};
    assign outHit = (hitCount >= 3'b011);
    sram_rf_model #(.wordwidth(4),.addrwidth(ADDRWIDTH)) hitMemA(
            .QA(hitArray),
            .E1A(),   
            .E2A(),   
            .CLKA(clk),
            .CENA(!rden),
            .AA(rdAddr),
            .CLKB(clk),
            .CENB(!wren),
            .AB(wrAddr),
            .DB({!hit,hit,!hit,hit}), 
            .EMAA(3'b0),       //not used
            .EMAB(3'b0),       //not used
            .RET1N(1'b1),      
            .COLLDISN(1'b0)   //not used
    );
endmodule
