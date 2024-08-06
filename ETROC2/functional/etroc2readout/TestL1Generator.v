`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 23 12:36:50 CST 2021
// Module Name: TestL1Generator
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"
// `ifndef TESTL1GENERATOR
// `define TESTL1GENERATOR
module TestL1Generator #(parameter WORDWIDTH = 15, FORWARDSTEPS = 0)
(
	input clkTMR,            //40MHz
    input disTMR,
    input resetTMR,      
    input modeTMR,     //0 is periodic trigger, 1 is random trigger
    output L1ATMR    //emulate L1A
);
// tmrg default triplicate

    wire [WORDWIDTH-1:0] prbs;
    wire disPRBS;
    wire disCount;
    assign disPRBS = disTMR | ~modeTMR;
    assign disCount = disTMR | modeTMR;
// `ifdef SIMULATION_RANDOM
//     reg [WORDWIDTH-1:0] prbsReg;
//     always@(posedge clkTMR) begin
//         prbsReg <= $urandom%(16'H8000);
//     end
//     assign prbs = prbsReg;
// `else
  PRBS31 #(.WORDWIDTH(WORDWIDTH),
    .FORWARDSTEPS(FORWARDSTEPS))
     prbs_inst(
		.clkTMR(clkTMR),
		.resetTMR(resetTMR),
		.disTMR(disPRBS),
        //.seed(15'h5AAA),
        .seedTMR(31'h2AAAAAAA),
		.prbsTMR(prbs)
	);
// `endif

    reg startTMR;
    reg [9:0] countTMR;
    wire [9:0] nextCount = countTMR + 10'd1;
    wire [9:0] nextCountVoted = nextCount;
    always @(posedge clkTMR) 
    begin
        if(!resetTMR)
        begin
            countTMR <= 10'h000;
            startTMR <= 1'b0;
        end
        else
        begin
            if(startTMR == 1'b0)
            begin
                countTMR <= nextCountVoted;
                if(countTMR == 10'd512)
                begin
                    startTMR <= 1'b1;
                end     
            end
        end
    end

    //fixed periodic is 41
    reg [5:0] triggerCountTMR;
    wire [5:0] nextTriggerCount = triggerCountTMR + 6'd1;
    wire [5:0] nextTriggerCountVoted = nextTriggerCount;
    always @(posedge clkTMR) 
    if(!resetTMR)
    begin
        triggerCountTMR <= 6'h00;
    end
    else if(!disCount)
    begin
        if(triggerCountTMR == 6'd40)begin
            triggerCountTMR <= 6'h00;
        end
        else begin
            triggerCountTMR <= nextTriggerCountVoted;            
        end
    end
    //do not read garbage in circular buffer in the first 512 clock periods.
    assign L1ATMR = !startTMR ? 1'b0 : (modeTMR ? (prbs < `L1A_THRESHOLD) : triggerCountTMR == 6'd40); //probability about 1/40

endmodule
// `endif 