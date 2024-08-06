//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Quan Sun
// 
// Create Date:    Sun Dec 19th 2021 
// Module Name:    sixteenCols
// Project Name:   ETROC2
// Description: 16 columns
//
// Dependencies: 
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////

module sixteenCols #(
    parameter L1ADDRWIDTH = 7,
    parameter BCSTWIDTH  = 27
)
(
	input [255:0] clkRO,
	input [255:0] clkTDC,
	input [255:0] strobeTDC,
	input [255:0] QInj,
	output [735:0] 	colDataChain,         //46*16
	output [15:0]   colHitChain,
    	output [63:0]   trigHitsColumn,       //output to global readout
	input  [15:0]	colReadChain,
	input [BCSTWIDTH*16-1:0]     colBCSTChain
);


    wire [3:0] colIDs[15:0];
    generate
        genvar k;
        for (k = 0; k < 16; k = k+1 )
        begin
            assign colIDs[k] = k;
        end
    endgenerate

    wire [45:0] colDataChain2D [15:0];
    wire [BCSTWIDTH-1:0] colBCSTChain2D [15:0];
    generate
        genvar jj;
        for (jj = 0; jj < 16; jj = jj+1) 
        begin 
            assign colBCSTChain2D[jj] = colBCSTChain[jj*BCSTWIDTH+BCSTWIDTH-1:jj*BCSTWIDTH];
        end
    endgenerate

    generate
        genvar i;
        for (i = 0; i < 16; i = i+1)  
        begin : colLoop
		pixelCol pixelCol_Inst(
			.colAddrIn(colIDs[i]),
			.clkRO(clkRO[i*16+15:i*16]),
			.clkTDC(clkTDC[i*16+15:i*16]),
			.strobeTDC(strobeTDC[i*16+15:i*16]),
			.QInj(QInj[i*16+15:i*16]),
			.dnData(colDataChain2D[i]),   //TDCdata 29 bits (no hit), E2A,E1A, PixelID 8 bits
			.dnHits({trigHitsColumn[i*4+3:i*4],colHitChain[i]}),
			.dnRead(colReadChain[i]),
			.dnBCST(colBCSTChain2D[i])  //load, L1A, Reset
		);
        end
    endgenerate

    generate
        genvar ii;
        for (ii = 0; ii < 16; ii = ii+1) 
        begin 
            assign  colDataChain[46*ii+45:46*ii] = colDataChain2D[ii];
        end
    endgenerate

endmodule
