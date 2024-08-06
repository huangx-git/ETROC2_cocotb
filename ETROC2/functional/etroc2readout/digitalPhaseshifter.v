`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Wed Nov  3 23:03:57 CDT 2021
// Module Name: digitalPhaseshifter
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module digitalPhaseshifter 
(
	input           clk40,            //40MHz
    input           clk1280,
    input [4:0]     clockDelay1,     //phase from clk40 rising edge to rising edge
    input [4:0]     pulseWidth1,     //phase from rising edge to falling
    input [4:0]     clockDelay2,     //phase from clk40 rising edge to rising edge
    input [4:0]     pulseWidth2,     //phase from rising edge to falling
	output          clkout1,          //
	output          clkout2           //
);
// tmrg default triplicate

    reg [4:0] phaseCounter;
    reg clk40D1;                     //delay clk40
    reg clk40D2;                     //delay clk40
    wire risingClk40;
    assign risingClk40 = ~clk40D2 & clk40D1;
    wire [4:0] nextCount = phaseCounter + 1'b1;
    // wire [4:0] nextCountVoted = nextCount;
    reg syncClk40;
    always @(posedge clk1280) 
    begin
        syncClk40 <= clk40;
    end

    always @(posedge clk1280) 
    begin
        clk40D1 <= syncClk40;
        clk40D2 <= clk40D1;
        if(risingClk40)
        begin
            phaseCounter <= 5'd3;   //align phasECounter == 0 to rising edge of clk40
        end
        else 
        begin
            phaseCounter <= nextCount;           
        end
    end

    reg [1:0] clkoutReg;
    wire [4:0] risingAt[1:0];
    assign risingAt[0]     = clockDelay1;
    assign risingAt[1]     = clockDelay2;

    wire [4:0] fallingAt[1:0];
    assign fallingAt[0]    = risingAt[0] + pulseWidth1;
    assign fallingAt[1]    = risingAt[1] + pulseWidth2;

    // genvar i;
    // generate
    //     for(i = 0; i<2; i = i+1)
    always @(posedge clk1280) 
    begin
        begin
            if(fallingAt[0] > risingAt[0])
            begin
                if(phaseCounter >= risingAt[0] && phaseCounter < fallingAt[0])
                begin
                    clkoutReg[0] <= 1'b1;              
                end
                else
                begin
                    clkoutReg[0] <= 1'b0;              
                end
            end
            else if(fallingAt[0] == risingAt[0]) //falling/rising equal
            begin
                if(phaseCounter == risingAt[0]) //at least one pulse
                begin
                    clkoutReg[0] <= 1'b1;              
                end
                else
                begin
                    clkoutReg[0] <= 1'b0;              
                end                
            end
            else  //faling edge lead
            begin
                if(phaseCounter >= fallingAt[0] && phaseCounter < risingAt[0])    
                begin
                    clkoutReg[0] <= 1'b0;              
                end        
                else 
                begin
                    clkoutReg[0] <= 1'b1;              
                end
            end        
        end
    end
//    endgenerate


    always @(posedge clk1280) 
    begin
        begin
            if(fallingAt[1] > risingAt[1])
            begin
                if(phaseCounter >= risingAt[1] && phaseCounter < fallingAt[1])
                begin
                    clkoutReg[1] <= 1'b1;              
                end
                else
                begin
                    clkoutReg[1] <= 1'b0;              
                end
            end
            else if(fallingAt[1] == risingAt[1]) //falling/rising equal
            begin
                if(phaseCounter == risingAt[1]) //at least one pulse
                begin
                    clkoutReg[1] <= 1'b1;              
                end
                else
                begin
                    clkoutReg[1] <= 1'b0;              
                end                
            end
            else  //faling edge lead
            begin
                if(phaseCounter >= fallingAt[1] && phaseCounter < risingAt[1])    
                begin
                    clkoutReg[1] <= 1'b0;              
                end        
                else 
                begin
                    clkoutReg[1] <= 1'b1;              
                end
            end        
        end
    end

    assign clkout1 = clkoutReg[0];
`ifdef HTreeDLY_ON
    assign #((`HTREE_MIN_DELAY + `PIXEL_CTS_MIN_DELAY):(`HTREE_TYP_DELAY + `PIXEL_CTS_TYP_DELAY):(`HTREE_MAX_DELAY + `PIXEL_CTS_MAX_DELAY)) clkout2 = clkoutReg[1];
`else
    assign clkout2 = clkoutReg[1];
`endif
endmodule
