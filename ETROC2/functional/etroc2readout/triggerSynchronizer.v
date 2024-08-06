`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Mon Apr  4 00:10:18 CDT 2022
// Module Name: triggerSynchronizer
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
`include "commonDefinition.v"

`define CHECK_COUNT
`define CHECK_TRIGGERBIT

`ifdef CHECK_COUNT
module countOne11B
(
    input [10:0] bits,
    output [3:0] count
);

assign count = {3'b000,bits[0]} + {3'b000,bits[1]} + {3'b000,bits[2]} + 
               {3'b000,bits[3]} + {3'b000,bits[4]} + {3'b000,bits[5]} + 
               {3'b000,bits[6]} + {3'b000,bits[7]} + {3'b000,bits[8]} + 
               {3'b000,bits[9]} + {3'b000,bits[10]}; 

endmodule

module countOne99B
(
    input [98:0] bits,
    output [6:0] count
);

wire [3:0] cnt [8:0];
generate
    genvar i;
    for (i = 0; i < 9; i = i+1)
    begin : loopvar_i
        countOne11B countOne11BInst
        (
            .bits(bits[i*11+10:i*11]),
            .count(cnt[i])
        );
    end
endgenerate 

assign count = {3'b000,cnt[0]} + {3'b000,cnt[1]} + {3'b000,cnt[2]} + 
               {3'b000,cnt[3]} + {3'b000,cnt[4]} + {3'b000,cnt[5]} + 
               {3'b000,cnt[6]} + {3'b000,cnt[7]} + {3'b000,cnt[8]};

endmodule

module countOne891B
(
    input [890:0] bits,
    output [9:0] count
);

wire [6:0] cnt [8:0];
generate
    genvar i;
    for (i = 0; i < 9; i = i+1)
    begin : loopvar_i
        countOne99B countOne99BInst
        (
            .bits(bits[i*99+98:i*99]),
            .count(cnt[i])
        );
    end
endgenerate 

assign count = {3'b000,cnt[0]} + {3'b000,cnt[1]} + {3'b000,cnt[2]} + 
               {3'b000,cnt[3]} + {3'b000,cnt[4]} + {3'b000,cnt[5]} + 
               {3'b000,cnt[6]} + {3'b000,cnt[7]} + {3'b000,cnt[8]};

endmodule

module countOne3564B
(
    input [3563:0] bits,
    output [11:0] count
);

wire [9:0] cnt [3:0];
generate
    genvar i;
    for (i = 0; i < 4; i = i+1)
    begin : loopvar_i
        countOne891B countOne891BInst
        (
            .bits(bits[i*891+890:i*891]),
            .count(cnt[i])
        );
    end
endgenerate 

assign count = {2'b00,cnt[0]} + {2'b00,cnt[1]} + {2'b00,cnt[2]} + {2'b00,cnt[3]};

endmodule

`endif

module triggerSynchronizer
(
    input               reset,                  //active low
	input  			    clk40,
	input [15:0]        trigData,
	input [4:0]         trigDataSize,           //from 0 to 16
    input [11:0]        emptySlotBCID,
    output [11:0]       syncBCID,
    output [11:0]       matchedCount
);

`ifdef CHECK_TRIGGERBIT
reg [15:0] trigDataTestBuf[3563:0];
reg [3:0] testCnt;
reg [11:0] wrAddrTest;
reg foundAnchor;
always @(posedge clk40)
begin
    if(~reset)
    begin
        wrAddrTest  <= 12'd0;   //clear
        testCnt     <= 4'd0;
        foundAnchor   <= 1'b0;
    end
    else if(wrAddrTest == 12'd3563)  
    begin
        wrAddrTest  <= 12'd0;        
        testCnt     <= testCnt + 1;
        if(trigDataTestBuf[wrAddrTest] == 16'HAAAA || trigDataTestBuf[wrAddrTest] == 16'H5555)
            foundAnchor <= 1'b1;
    end
    else 
    begin
        if(trigDataTestBuf[wrAddrTest] == 16'HAAAA || trigDataTestBuf[wrAddrTest] == 16'H5555)
            foundAnchor <= 1'b1;
        wrAddrTest  <= wrAddrTest + 1;           
    end
end

always @(posedge clk40)
begin
    trigDataTestBuf[wrAddrTest][testCnt]     <= trigData[0];
end
`endif


reg trigDataBuf[3563:0];
reg writeBuffer;
reg [11:0] wrAddr;
reg startOver;
reg fulled;

always @(posedge clk40)
begin
    if(~reset | startOver)
    begin
        wrAddr <= 12'd0;   //clear
        fulled <= 1'b0;
    end
    else if(wrAddr == 12'd3563)  
    begin
        wrAddr <= 12'd0;        
        if(~fulled) 
            fulled <= 1'b1;
    end
    else 
    begin
        wrAddr <= wrAddr + 1;           
    end
end

 wire writeTrigg = trigDataSize == 5'd0 ? 1'b0 : trigData[0]; //only use one bit

always @(posedge clk40)
begin
    writeBuffer         <= writeTrigg;
    trigDataBuf[wrAddr] <= writeBuffer;
    trigDataTestBuf[wrAddrTest][testCnt]     <= trigData[0];
end

wire match = writeBuffer ^ trigDataBuf[wrAddr];

reg [11:0] matchCount;
reg [3563:0] matchPoints;    //
reg [11:0] syncBCIDReg;
wire currentPoint = matchPoints[wrAddr];
always @(posedge clk40)
begin
    if(~reset | startOver)
    begin
        matchPoints <= {3564{1'b1}};   //
        matchCount  <= 12'd3564;
        startOver   <= 1'b0;
    end
    else if (fulled == 1'b1) begin
        syncBCIDReg <= currentPoint == 1'b1 ? emptySlotBCID : (syncBCIDReg + 1)%3564;
        if(match == 1'b0 && currentPoint == 1'b1) begin
            matchPoints[wrAddr] <= 1'b0;  //wrAddr is changing
            matchCount <= matchCount - 1;
            if(matchCount == 12'd1) //next clock period
                startOver <= 1'b1;
        end
    end
end

`ifdef CHECK_COUNT
wire [11:0] countOne;

countOne3564B countOne3564BInst
(
    .bits(matchPoints),    
    .count(countOne)
);
`endif
assign syncBCID = syncBCIDReg;
assign matchedCount = matchCount;

endmodule

// module oneHotCode3B
// (
//     input [7:0] bits,
//     output [2:0] oneHot,
//     output orBit  //or of all bits
// );
//     assign oneHot = bits[0] ? 3'd0 :
//                    (bits[1] ? 3'd1 :
//                    (bits[2] ? 3'd2 :
//                    (bits[3] ? 3'd3 :
//                    (bits[4] ? 3'd4 :
//                    (bits[5] ? 3'd5 :
//                    (bits[6] ? 3'd6 :
//                    (bits[7] ? 3'd7 : 3'd0))))))); 
//     assign orBit = |bits;
// endmodule


// module oneHotCode6B
// (
//     input [63:0] bits,
//     output [5:0] oneHot,
//     output orBit
// );

// wire [7:0] or8Bit;
// wire [2:0] oneHotLSB [7:0];
// generate
//     genvar i;
//     for(i = 0; i < 8; i = i + 1)
//     begin : loopvar_i
//         oneHotCode3B oneHotCode3BLSB
//         (
//             .bits(bits[i*8+7:i*8]),
//             .oneHot(oneHotLSB[i]),
//             .orBit(or8Bit[i])
//         );
//     end
// endgenerate 

// assign oneHot[2:0] = or8Bit[0] ? oneHotLSB[0] :
//                     (or8Bit[1] ? oneHotLSB[1] :
//                     (or8Bit[2] ? oneHotLSB[2] :
//                     (or8Bit[3] ? oneHotLSB[3] :
//                     (or8Bit[4] ? oneHotLSB[4] :
//                     (or8Bit[5] ? oneHotLSB[5] :
//                     (or8Bit[6] ? oneHotLSB[6] :
//                     (or8Bit[7] ? oneHotLSB[7] : 3'd0))))))); 

// oneHotCode3B oneHotCode3BMSB
// (
//     .bits(or8Bit),
//     .oneHot(oneHot[5:3]),
//     .orBit(orBit)
// );

// endmodule

// module oneHotCode9B
// (
//     input [511:0] bits,
//     output [8:0] oneHot,
//     output orBit
// );

// wire [7:0] or8Bit;
// wire [5:0] oneHotLSB [7:0];
// generate
//     genvar i;
//     for(i = 0; i < 8; i = i + 1)
//     begin : loopvar_i
//         oneHotCode6B oneHotCode6BLSB
//         (
//             .bits(bits[i*64+63:i*64]),
//             .oneHot(oneHotLSB[i]),
//             .orBit(or8Bit[i])
//         );
//     end
// endgenerate 

// assign oneHot[5:0] = or8Bit[0] ? oneHotLSB[0] :
//                     (or8Bit[1] ? oneHotLSB[1] :
//                     (or8Bit[2] ? oneHotLSB[2] :
//                     (or8Bit[3] ? oneHotLSB[3] :
//                     (or8Bit[4] ? oneHotLSB[4] :
//                     (or8Bit[5] ? oneHotLSB[5] :
//                     (or8Bit[6] ? oneHotLSB[6] :
//                     (or8Bit[7] ? oneHotLSB[7] : 3'd0))))))); 

// oneHotCode3B oneHotCode3BMSB
// (
//     .bits(or8Bit),
//     .oneHot(oneHot[8:6]),
//     .orBit(orBit)
// );

// endmodule

// module oneHotCode12B
// (
//     input [4095:0] bits,
//     output [11:0] oneHot,
//     output orBit   //
// );

// wire [7:0] or8Bit;
// wire [8:0] oneHotLSB [7:0];
// generate
//     genvar i;
//     for(i = 0; i < 8; i = i + 1)
//     begin : loopvar_i
//         oneHotCode9B oneHotCode9BLSB
//         (
//             .bits(bits[i*512+511:i*512]),
//             .oneHot(oneHotLSB[i]),
//             .orBit(or8Bit[i])
//         );
//     end
// endgenerate 

// assign oneHot[8:0] = or8Bit[0] ? oneHotLSB[0] :
//                     (or8Bit[1] ? oneHotLSB[1] :
//                     (or8Bit[2] ? oneHotLSB[2] :
//                     (or8Bit[3] ? oneHotLSB[3] :
//                     (or8Bit[4] ? oneHotLSB[4] :
//                     (or8Bit[5] ? oneHotLSB[5] :
//                     (or8Bit[6] ? oneHotLSB[6] :
//                     (or8Bit[7] ? oneHotLSB[7] : 3'd0))))))); 

// oneHotCode3B oneHotCode3BMSB
// (
//     .bits(or8Bit),
//     .oneHot(oneHot[11:9]),
//     .orBit(orBit)
// );

// endmodule

