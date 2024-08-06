`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Fri Apr 23 22:49:35 CDT 2021
// Module Name: columnAdapter
// Project Name: ETROC2 readout
// Description: Create Column ID and process trigger hit
// Dependencies: pixelReadout,SWCell
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////

module columnAdapter (
    input [3:0] trigHits,
    input [3:0] columnAddrIn,
    output [3:0] columnAddrNextOut,
    output [3:0] columnAddr,
    output [7:0] columTrigHits      //corresponding to 8 lines
);
// tmrg default triplicate
// tmrg do_not_triplicate trigHits
// tmrg do_not_triplicate columnAddr
// tmrg do_not_triplicate columTrigHits
    wire [3:0] columnAddrInInc = columnAddrIn + 1;
    wire [3:0] columnAddrInIncVoted = columnAddrInInc;
    assign columnAddrNextOut = columnAddrInIncVoted;
    assign columnAddr = columnAddrIn;

    assign columTrigHits[0] = (columnAddr[2] == 1'b0) ? trigHits[0] : 1'b0;
    assign columTrigHits[1] = (columnAddr[2] == 1'b0) ? trigHits[1] : 1'b0;
    assign columTrigHits[2] = (columnAddr[2] == 1'b0) ? trigHits[2] : 1'b0;
    assign columTrigHits[3] = (columnAddr[2] == 1'b0) ? trigHits[3] : 1'b0;
    assign columTrigHits[4] = (columnAddr[2] == 1'b1) ? trigHits[0] : 1'b0;
    assign columTrigHits[5] = (columnAddr[2] == 1'b1) ? trigHits[1] : 1'b0;
    assign columTrigHits[6] = (columnAddr[2] == 1'b1) ? trigHits[2] : 1'b0;
    assign columTrigHits[7] = (columnAddr[2] == 1'b1) ? trigHits[3] : 1'b0;

endmodule