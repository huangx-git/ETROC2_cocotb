`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Wed Nov  3 23:03:57 CDT 2021
// Module Name: chargeInjectionPulseGen
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module chargeInjectionPulseGen 
(
	input           clk40,              //40MHz
    input           clk1280,
    input           reset,
    input           chargeInjectionCmd,
    input [4:0]     delay,              //phase from clk40 rising edge to rising edge
	output          pulse               //
);
// tmrg default triplicate

    reg rstn40;
    reg resetlatch;
    reg rstn1280;
    always @(posedge clk40) 
    begin
        resetlatch <= reset;
        rstn40 <= resetlatch;
    end

    always @(posedge clk1280) 
    begin
        rstn1280 <= resetlatch;
    end

    reg chargeInjectionCmdDelay;
    reg [1:0] sessionCount;
    wire [1:0] nextsessionCount = sessionCount + 1'b1;
    // wire [1:0] nextsessionCountVoted = nextsessionCount;
    reg endSession;
    wire startSession = ~chargeInjectionCmdDelay&chargeInjectionCmd; //only start at rising edge
    reg startReg;
    always @(posedge clk40) 
    begin
        startReg <= startSession;
        chargeInjectionCmdDelay <= chargeInjectionCmd;
        if(~rstn40)
        begin
            endSession <= 1'b1;
            sessionCount <= 2'd0;
        end
        else if(startSession)
        begin
            endSession <= 1'b0;
            sessionCount <= 2'd0;
        end
        else if (~endSession) begin
            sessionCount <= nextsessionCount;
            if(sessionCount == 2'd3)
            begin
                endSession <= 1'b1;
                sessionCount <= 2'd0;
            end
        end
    end

    reg syncClk40;
    always @(posedge clk1280) 
    begin
        if(~rstn1280)
            syncClk40 <= 1'b0;
        else if(~endSession)begin
            syncClk40 <= clk40;
        end
    end

    reg [4:0] phaseCounter;
    reg clk40D1;                     //delay clk40
    reg clk40D2;                     //delay clk40
    wire risingClk40;
    assign risingClk40 = ~clk40D2 & clk40D1;
    // wire [4:0] nextCount = phaseCounter + 1'b1;
    // wire [4:0] nextCountVoted = nextCount;

    reg resetPhaseCount;
    always @(posedge clk1280) 
    begin
        if(~rstn1280) begin
            phaseCounter <= 5'd3;
            clk40D1 <= 1'b0;
            clk40D2 <= 1'b0;
            resetPhaseCount <= 1'b0;
        end
        else if(~endSession)begin
            clk40D1 <= syncClk40;
            clk40D2 <= clk40D1;
            resetPhaseCount <= ~clk40D1&syncClk40&startReg; 
            if(resetPhaseCount)
            begin
                phaseCounter <= 5'd3;   //align phasECounter == 0 to rising edge of clk40
            end
            else 
            begin
                phaseCounter <= phaseCounter + 1'b1;           
            end
        end
    end

    reg pulseReg;
    always @(posedge clk1280) 
    begin
        if(~rstn1280)begin
            pulseReg <= 1'b0;                          
        end
        else if(~endSession)begin
            if(phaseCounter == delay && sessionCount == 2'b01)
            begin
                pulseReg <= 1'b1;              
            end
            else if (phaseCounter == delay && sessionCount == 2'b11)
            begin
                pulseReg <= 1'b0;              
            end
        end
        else
        begin
                pulseReg <= 1'b0;                          
        end
    end

    assign pulse = pulseReg;

endmodule
