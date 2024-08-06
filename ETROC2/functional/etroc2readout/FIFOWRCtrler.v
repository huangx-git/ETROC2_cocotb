`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Jan 23 15:28:14 CST 2021
// Module Name: FIFOWRCtrler
// Project Name: ETROC2 readout
// Description: 
// Dependencies: no
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module FIFOWRCtrler#(
    parameter WIDTH = 4,
    parameter clockEdge = 1   //1 means positive edge, 0 means negative
)
(
	input clk,            //40MHz
    input reset,          //reset signal from SW
    input wren,            
    input rden,
    input enWordCount,      
    output reg empty,
    output reg full,
    output reg [WIDTH-1:0] wrAddr,
    output reg [WIDTH-1:0] rdAddr,    
    output [WIDTH-1:0] wordCount      //output word count   
);
// tmrg default triplicate

    wire [WIDTH-1:0] wrAddrNext;
    wire [WIDTH-1:0] rdAddrNext;
    assign rdAddrNext = !empty ? (rdAddr + 1) : rdAddr;
    assign wrAddrNext = !full ? (wrAddr + 1) : wrAddr;
    wire [WIDTH-1:0] wrAddrNextVoted = wrAddrNext;
    wire [WIDTH-1:0] rdAddrNextVoted = rdAddrNext;
    wire rdenVoted = rden;
    wire wrenVoted = wren;
    wire fullNextVoted  = (wrAddrNextVoted == rdAddr);
    wire emptyNextVoted = (rdAddrNextVoted == wrAddr);
    generate
    if(clockEdge == 1)begin
        always @(posedge clk) 
        begin
		    if(!reset) 
            begin
			    rdAddr <= {WIDTH{1'b0}};
			    wrAddr <= {WIDTH{1'b0}};
                empty <= 1'b1;
                full <= 1'b0;
		    end
		    else 
            begin
                if (rdenVoted == 1'b1) 
                begin
			        rdAddr <= rdAddrNextVoted;
                    empty <= emptyNextVoted;
                    full <= 1'b0;
		        end
                if (wrenVoted == 1'b1) 
                begin
			        wrAddr <= wrAddrNextVoted;
                    full <= fullNextVoted;
                    empty <= 1'b0;
		        end    
	        end
        end        
    end
    else begin
        //read operation
        always @(negedge clk) 
        begin
		    if(!reset) 
            begin
			    rdAddr <= {WIDTH{1'b0}};
			    wrAddr <= {WIDTH{1'b0}};
                empty <= 1'b1;
                full <= 1'b0;
		    end
		    else 
            begin
                if (rdenVoted == 1'b1) 
                begin
			        rdAddr <= rdAddrNextVoted;
                    empty <= emptyNextVoted;
                    full <= 1'b0;
		        end
                if (wrenVoted == 1'b1) 
                begin
			        wrAddr <= wrAddrNextVoted;
                    full <= fullNextVoted;
                    empty <= 1'b0;
		        end    
	        end
        end
        
    end    
    endgenerate

    assign wordCount = !enWordCount ? {WIDTH{1'b0}} : 
                             ((wrAddr >= rdAddr) ? (wrAddr - rdAddr) : ({1'b1,wrAddr} - {1'b0,rdAddr}));
  
endmodule
