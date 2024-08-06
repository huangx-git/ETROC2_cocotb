`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sun Jan  9 14:25:57 CST 2022
// Module Name: digitalPhaseshifterTDCClk
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module phaseCounterTDCClk
(
	input               clk40,            //40MHz
    input               clk1280,
    input               enable,
    output reg [4:0]    phaseCount      //
);
    reg clk40D1;                     //delay clk40
    reg clk40D2;                     //delay clk40
    wire risingClk40;
    assign risingClk40 = ~clk40D2 & clk40D1;
    wire [4:0] nextCount = phaseCount + 1;
    wire [4:0] nextCountVoted = nextCount;
    reg syncClk40;
    always @(negedge clk1280) 
    begin
        if(enable)
            syncClk40 <= clk40;
    end

    always @(posedge clk1280) 
    begin
        if(enable)
        begin
            clk40D1 <= syncClk40;
            clk40D2 <= clk40D1;
            if(risingClk40)
            begin
                phaseCount <= 5'd3;   //align phasECounter == 0 to rising edge of clk40
            end
            else 
            begin
                phaseCount <= nextCountVoted;           
            end
        end
    end
endmodule

module pulseGeneratorClk40
(
    input           clk1280,
    input           enable,
    input [4:0]     phaseCount,
    input [5:0]     clockDelay,     //phase from clk40 rising edge to rising edge
    output          clkout          //output clock
);
    reg clkoutReg;
    wire [4:0] risingAt;
    assign risingAt     =  clockDelay[5:1];

    wire [4:0] fallingAt;
    assign fallingAt    = (risingAt + 5'd16)%32;

    always @(posedge clk1280) 
    begin
        if(enable)
        begin
            if(phaseCount == risingAt)
            begin
                clkoutReg <= 1'b1;
            end
            else if (phaseCount == fallingAt)
            begin
                clkoutReg <= 1'b0;                
            end
        end
    end
    reg clk40NReg;
    always @(negedge clk1280)
    begin
        if(clockDelay[0])
            clk40NReg <= clkoutReg;
    end
    assign clkout = clockDelay[0] ? clk40NReg : clkoutReg;

endmodule

module pulseGeneratorClk320
(
    input           clk1280,
    input           enable,
    input [4:0]     phaseCount,
    input [7:0]     mask,
    input [2:0]     clockDelay,     //phase from clk320 rising edge to rising edge
    output          clkout          //output clock
);
    reg clkoutReg;
    wire [4:0] risingAt [7:0];
    wire [4:0] fallingAt [7:0];

    generate
        genvar i;
        for(i = 0; i < 8; i = i + 1)
        begin : loop_clock_index
            assign risingAt[i]  = ({{3{1'b0}},clockDelay[2:1]}+i*4)%32;
            assign fallingAt[i] = ({{3{1'b0}},clockDelay[2:1]}+i*4+2)%32;
        end
    endgenerate

    always @(posedge clk1280) 
    begin
        if(enable)
        begin
            if( (phaseCount == risingAt[0]&&mask[0] == 1'b1) ||
                (phaseCount == risingAt[1]&&mask[1] == 1'b1) ||
                (phaseCount == risingAt[2]&&mask[2] == 1'b1) ||
                (phaseCount == risingAt[3]&&mask[3] == 1'b1) ||
                (phaseCount == risingAt[4]&&mask[4] == 1'b1) ||
                (phaseCount == risingAt[5]&&mask[5] == 1'b1) ||
                (phaseCount == risingAt[6]&&mask[6] == 1'b1) ||
                (phaseCount == risingAt[7]&&mask[7] == 1'b1))
            begin
                clkoutReg <= 1'b1;
            end
            else if (   (phaseCount == fallingAt[0]&&mask[0] == 1'b1) ||
                        (phaseCount == fallingAt[1]&&mask[1] == 1'b1) ||
                        (phaseCount == fallingAt[2]&&mask[2] == 1'b1) ||
                        (phaseCount == fallingAt[3]&&mask[3] == 1'b1) ||
                        (phaseCount == fallingAt[4]&&mask[4] == 1'b1) ||
                        (phaseCount == fallingAt[5]&&mask[5] == 1'b1) ||
                        (phaseCount == fallingAt[6]&&mask[6] == 1'b1) ||
                        (phaseCount == fallingAt[7]&&mask[7] == 1'b1))
            begin
                clkoutReg <= 1'b0;                
            end
        end
    end
    reg clk320NReg;
    always @(negedge clk1280)
    begin
        if(clockDelay[0])
            clk320NReg <= clkoutReg;
    end
    assign clkout = clockDelay[0] ? clk320NReg : clkoutReg;

endmodule


module digitalPhaseshifterTDCClk 
(
	input           clk40,            //40MHz
    input           clk1280,
    input           enable,
    input [5:0]     clockDelay,         //phase from clk40 rising edge to rising edge
    input [7:0]     clock320Mask,       //mask the clock strobes
	output          clk40out,           // 40 MHz clock for TDC
	output          clk320out           // 320 MHz clock strobes for TDC
);
// tmrg default triplicate

    wire [4:0] phaseCount;
    phaseCounterTDCClk phaseCounterInst
    (
        .clk40(clk40),
        .clk1280(clk1280),
        .enable(enable),
        .phaseCount(phaseCount)
    );

    pulseGeneratorClk40 pulseGeneratorClk40Inst
    (
        .clk1280(clk1280),
        .enable(enable),
        .phaseCount(phaseCount),
        .clockDelay(clockDelay),
        .clkout(clk40out)
    );

    pulseGeneratorClk320 pulseGeneratorClk320Inst
    (
        .clk1280(clk1280),
        .enable(enable),
        .phaseCount(phaseCount),
        .mask(clock320Mask),
        .clockDelay(clockDelay[2:0]),
        .clkout(clk320out)
    );


endmodule
