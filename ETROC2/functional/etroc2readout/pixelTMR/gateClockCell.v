`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Tue Apr  6 20:59:28 CDT 2021
// Module Name: gateClockCell
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////

module gateClockCell
(
    input clk,
    input gate,
    input enableGate,
    output gatedClk             //
);
// tmrg default do_not_triplicate
    reg gateReg;
    always @(*)begin
        if(!clk)begin
            gateReg = gate | !enableGate;      
        end
    end
    assign gatedClk = gateReg & clk;

endmodule
