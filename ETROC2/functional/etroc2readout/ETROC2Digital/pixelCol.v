//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Quan Sun
// 
// Create Date:    Sun Dec 19th 2021 
// Module Name:    pixelCol
// Project Name:   ETROC2
// Description: a column of pixel including 16 pixels
//
// Dependencies: 
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////

module pixelCol #(
    parameter L1ADDRWIDTH = 7,
    parameter BCSTWIDTH = 27
)
(
	input [3:0] colAddrIn,
	input [15:0] clkRO,
	input [15:0] clkTDC,
	input [15:0] strobeTDC,
	input [15:0] QInj,
	output [45:0] 	        dnData,   //TDCdata 29 bits (no hit), E2A,E1A, PixelID 8 bits
	output [4:0]	        dnHits,
	input 			        dnRead,
	input [BCSTWIDTH-1:0] 	dnBCST  //load, L1A, Reset
);

    wire [45:0] dataChain [16:0];
    wire [4:0] hitChain [16:0];
    wire [16:0] readChain;
    wire [BCSTWIDTH-1:0] BCSTChain [16:0];

    wire [3:0] rowIDs[15:0];
    generate
        genvar k;
        for (k = 0; k < 16; k = k+1 )
        begin
            assign rowIDs[k] = k;
        end
    endgenerate

    generate
        genvar i;
        for (i = 0; i < 16; i = i+1)
        begin : pixelLoop
            
		pixel pixel_Inst(
			.rowAddrIn(rowIDs[i]),
			.colAddrIn(colAddrIn),
			.clkRO(clkRO[i]),
			.clkTDC(clkTDC[i]),
			.strobeTDC(strobeTDC[i]),
			.QInj(QInj[i]),
			.upData(dataChain[i+1]),  //TDCdata 29 bits (no hit), E2A,E1A, PixelID 8 bits
			.dnData(dataChain[i]),
			.upHits(hitChain[i+1]),
			.dnHits(hitChain[i]),
			.upRead(readChain[i+1]),
			.dnRead(readChain[i]),
			.upBCST(BCSTChain[i+1]),  //load, L1A, Reset
			.dnBCST(BCSTChain[i])   //
		);
        end
    endgenerate

//for debug purpose
	wire [45:0] 	upData;
	wire [4:0]		upHits;
    wire 	        upRead;
    wire [L1ADDRWIDTH*2+11+2:0]      upBCST;
    assign upHits   = 5'b00000;
    assign upData   = {31'h00000000,colAddrIn,4'h0}; //
//    assign upUnreadHit = 1'b0;  //has to be zero.

    assign dataChain[16]    = upData;
    assign dnData           = dataChain[0];
    assign hitChain[16]     = upHits;
    assign dnHits           = hitChain[0];
    assign upRead           = readChain[16];
    assign readChain[0]     = dnRead;
    assign upBCST           = BCSTChain[16];
    assign BCSTChain[0]     = dnBCST;


endmodule
