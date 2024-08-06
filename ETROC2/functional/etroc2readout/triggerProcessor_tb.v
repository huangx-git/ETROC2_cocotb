`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Mon Oct 25 15:27:25 CDT 2021
// Module Name: triggerProcessor_tb
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 



//////////////////////////////////////////////////////////////////////////////////


module triggerProcessor_tb;
	reg clk;
    reg reset;

wire [15:0] prbs1;
PRBS31 #(.WORDWIDTH(16),
        .FORWARDSTEPS(0)) prbs1Inst
    (
        .clk(clk),
        .reset(reset),
        .dis(1'b0),
        .seed(31'h2AAAAAAA),
        .prbs(prbs1)
    );

reg [5:0] trigDataSize;
reg [11:0] BCIDCounter;
//wire BCR;
//assign BCR = (BCIDCounter == 12'd0);
always @(posedge clk) 
begin
    if(~reset)
    begin
        BCIDCounter <= 12'd123;
    end
    else
    begin
        if(BCIDCounter == 12'd3563)begin
            BCIDCounter <= 12'd0;
        end
        else
        begin
            BCIDCounter <= BCIDCounter + 1;
        end
    end
end

reg [11:0] BC_gap;
wire [15:0] encTrigHits;
wire [15:0] trigHits;
assign trigHits = prbs1;
//assign trigHits = (BCIDCounter == BC_gap) ? 16'd0 : prbs1;
triggerProcessor TPInst
(
    .clk(clk),
    .trigHits(trigHits),
    .trigDataSize(trigDataSize),
    .BCID(BCIDCounter),
    .emptySlotBCID(BC_gap),
    .splitTrigger(1'b0),
    .trigScrOn(1'b1),
    .encTrigHits(encTrigHits)
);

wire [11:0] syncBCID;
wire synched;
wire [15:0] recTrigHits;
triggerSynchronizer triggerSynchronizerInst
(
    .clk(clk),
    .reset(reset),
    .encTrigHits(encTrigHits),
    .trigDataSize(trigDataSize),
    .gapPosition(BC_gap),
    .syncBCID(syncBCID),
    .recSynched(synched),
    .trigHits(recTrigHits)
);


reg [63:0] prbsword;

wire match;

always @(posedge clk) 
begin
    prbsword[63:48] <= recTrigHits;
    prbsword[47:0] <= prbsword[63:16];
end

assign match = ~((prbsword[0]^prbsword[3+0]!=prbsword[31+0]) || 
               (prbsword[1]^prbsword[3+1]!=prbsword[31+1]) ||
               (prbsword[2]^prbsword[3+2]!=prbsword[31+2]) ||
               (prbsword[3]^prbsword[3+3]!=prbsword[31+3]) ||
               (prbsword[4]^prbsword[3+4]!=prbsword[31+4]) ||
               (prbsword[5]^prbsword[3+5]!=prbsword[31+5]) ||
               (prbsword[6]^prbsword[3+6]!=prbsword[31+6]) ||
               (prbsword[7]^prbsword[3+7]!=prbsword[31+7]) ||
               (prbsword[8]^prbsword[3+8]!=prbsword[31+8]) ||
               (prbsword[9]^prbsword[3+9]!=prbsword[31+9]) ||
               (prbsword[10]^prbsword[3+10]!=prbsword[31+10]) ||
               (prbsword[11]^prbsword[3+11]!=prbsword[31+11]) ||
               (prbsword[12]^prbsword[3+12]!=prbsword[31+12]) ||
               (prbsword[13]^prbsword[3+13]!=prbsword[31+13]) ||
               (prbsword[14]^prbsword[3+14]!=prbsword[31+14]) ||
               (prbsword[15]^prbsword[3+15]!=prbsword[31+15]));

    initial begin
        clk = 0;
        reset = 1;
        BC_gap = 12'd1177;
        trigDataSize = 5'd16;
        #25 reset = 1'b0;
        #50 reset = 1'b1;


        #30000000 $stop;
    end
    always 
        #0.5 clk = !clk; //1 ns clock period

endmodule
