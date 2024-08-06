/*
Downstream signals are from/to global readout.
Upstream signals are from/to pixels.
Current signals are from/to current pixel(or )

                    upstream signals (prefix("up")) 
                                |  
                                V
                    /-----------------------\
                    |                       | 
  					|                       | 
  					|                       | 
  current signals-> |         SWCell        |  
  (prefix"ct"")		|                       | 
  					|                       | 
  					|                       | 
  					|                       | 
                    \-----------------------/
								|
								V
					downstream signals (prefix "dn")


*/

`timescale 1ns / 10ps
//low level cell
`ifdef SWCELL_MAP_LOGICCELL
module inverter 
(
	input A,
	output Y //
);
//tmrg do_not_touch

	assign #0.05 Y  = ~A;

endmodule

module norGate
(
	input A1,
	input A2,
	output Y  //
);
//tmrg do_not_touch

	assign #0.06 Y = ~(A1|A2);

endmodule

module triStateInv 
(
	input en,
	input enB,
	input A,
	output Y //
);
//tmrg do_not_touch

	wire [2:0] sel = {en,enB,A};
	assign #0.06 	Y = (sel == 3'b000)  ? 1'b1 : 
	           			((sel == 3'b001) ? 1'bZ :
	           			((sel == 3'b010) ? 1'bZ :
	           			((sel == 3'b011) ? 1'bZ :
	           			((sel == 3'b100) ? 1'b1 :
	           			((sel == 3'b101) ? 1'b0 :
	           			((sel == 3'b110) ? 1'bZ : 1'b0 ))))));

	// always @(sel)
	// begin
	// 	case (sel)
	// 		3'b000 : #0.06 Y = 1'b1;
	// 		3'b001 : #0.06 Y = 1'bZ;
	// 		3'b010 : #0.06 Y = 1'bZ;
	// 		3'b011 : #0.06 Y = 1'bZ;
	// 		3'b100 : #0.06 Y = 1'b1;
	// 		3'b101 : #0.06 Y = 1'b0;
	// 		3'b110 : #0.06 Y = 1'bZ;
	// 		3'b111 : #0.06 Y = 1'b0;
	// 	endcase
	// end
endmodule

//3 basic cells

module readCell(
	input dnRead,
	input hit,
	input hitB,
	output ctRead,
	output upRead //
);
//tmrg do_not_touch

	wire iReadB;
	inverter invInst(
		.A(dnRead),
		.Y(iReadB)
	);

	norGate norInstCT(
		.A1(hitB),    //hit connect to A1 is better
		.A2(iReadB),
		.Y(ctRead)
	);

	norGate norInstUp(
		.A1(hit),    //hit connect to A1 is better
		.A2(iReadB),
		.Y(upRead)
	);

endmodule

module dataCell(
	input ctData,
	input upData,
	input hit,
	input hitB,
	output dnData //
);
//tmrg do_not_touch

	wire iData;
	wire iData1;
	wire iData2;
	triStateInv triCt
	(
		.en(hit),
		.enB(hitB),
		.A(ctData),
		.Y(iData)
	);

	triStateInv triUp
	(
		.en(hitB),
		.enB(hit),
		.A(upData),
		.Y(iData)
	);

	inverter inv(
		.A(iData),
		.Y(dnData)
	);

endmodule

module broadcastCell(
	input dnLoad,
	output ctLoad,
	output upLoad //
);
//tmrg do_not_touch

	wire iLoad;
	inverter inv1(
		.A(dnLoad),
		.Y(iLoad)
	);

	inverter inv2(
		.A(iLoad),
		.Y(ctLoad)
	);

	inverter inv3(
		.A(iLoad),
		.Y(upLoad)
	);

endmodule
`endif 

module SWCell #(parameter DATAWIDTH=46, parameter BCSTWIDTH = 12, parameter HITSWIDTH = 5)(
	input [DATAWIDTH-1:0] 	ctData,
	input [DATAWIDTH-1:0] 	upData,
	output [DATAWIDTH-1:0] 	dnData,
	input [HITSWIDTH-1:0]	ctHits,  //unReadHits and trigHit
	input [HITSWIDTH-1:0]	upHits,
	output [HITSWIDTH-1:0]	dnHits,
	input 					dnRead,
	output 					ctRead,
	output 					upRead,
	input [BCSTWIDTH-1:0] 	dnBCST,
	output [BCSTWIDTH-1:0]	ctBCST,
	output [BCSTWIDTH-1:0]	upBCST //
);
//tmrg do_not_touch
`ifdef SWCELL_MAP_LOGICCELL
	wire [HITSWIDTH-1 : 0] ctHitsB;
	assign ctHitsB = ~ctHits;  
	//ctHits[0] is for data, ctHits[4:1] for trigger only
	//for hits
	generate
		genvar i;
		for(i = 0; i < HITSWIDTH; i = i + 1)
		begin : loopHits
			dataCell hitCellInst(
			.ctData(ctHits[i]),
			.upData(upHits[i]),
			.hit(ctHits[i]),
			.hitB(ctHitsB[i]),
			.dnData(dnHits[i]) 
		);		
		end
	endgenerate

	//for data
	generate
		genvar j;
		for(j = 0; j < DATAWIDTH; j = j + 1)
		begin : loopData
			dataCell dataCellInst(
			.ctData(ctData[j]),
			.upData(upData[j]),
			.hit(ctHits[0]),  
			.hitB(ctHitsB[0]),
			.dnData(dnData[j]) 
		);		
		end
	endgenerate

	//broadcast signals
	generate
		genvar k;
		for(k = 0; k < BCSTWIDTH; k = k + 1)
		begin : loopBCST
			broadcastCell broadcastCellInst(
			.dnLoad(dnBCST[k]),
			.ctLoad(ctBCST[k]),
			.upLoad(upBCST[k]) //
		);		
		end
	endgenerate
	
	//read signal 
	readCell readCellInst(
		.dnRead(dnRead),
		.hit(ctHits[0]),
		.hitB(ctHitsB[0]),
		.ctRead(ctRead),
		.upRead(upRead) //
	);
`else
	wire ctUnreadHit = ctHits[0];
	assign #(0.1:0.25:0.4) dnHits = ctHits | upHits;  //0.4 ns delay, bitwise or
	assign #(0.1:0.25:0.4) dnData = (ctUnreadHit == 1'b1) ? ctData : upData;
	assign #(0.1:0.25:0.4) ctRead = (ctUnreadHit == 1'b1) ? dnRead : 1'b0;
	assign #(0.1:0.25:0.4) upRead = (ctUnreadHit == 1'b1) ? 1'b0 : dnRead;
	assign #(0.1:0.25:0.4) ctBCST = dnBCST;
	assign #(0.1:0.25:0.4) upBCST = dnBCST;
`endif
endmodule

