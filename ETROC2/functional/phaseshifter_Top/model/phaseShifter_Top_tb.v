`timescale 1ps/1ps
module phaseShifter_Top_tb();

	reg clk1G28;
	//reg dllCapResetA; 
	//reg dllCapResetB; 
	//reg dllCapResetC;
	//reg [3:0] dllChargePumpCurrent;
	//reg dllEnableA;
	//reg dllEnableB;
	//reg dllEnableC;
	//reg dllForceDown;
	reg [7:0] s;
	reg syncCK40;
	//reg rstn; 
 
	wire clk40MOut;
	wire clk320MOut;
	//wire dllLateA;
	//wire dllLateB;
	//wire dllLateC;

	//wire vCtrl;
	//wire VDD;
	//wire VSS;


phaseShifter_Top phaseShifter_Top_inst(
	.clk1G28(clk1G28),
	.dllCapResetA(), 
	.dllCapResetB(), 
	.dllCapResetC(),
	.dllChargePumpCurrent(),
	.dllEnableA(),
	.dllEnableB(),
	.dllEnableC(),
	.dllForceDown(),
	.s(s),
	.syncCK40(syncCK40),
	//.rstn(rstn), 
	.clk40MOut(clk40MOut),
	.clk320MOut(clk320MOut),
	.dllLateA(),
	.dllLateB(),
	.dllLateC(),
	.vCtrl(),
	.VDD(),
	.VSS()
);


always #(784/2*32) syncCK40 = ~syncCK40;
always #(784/2) clk1G28 = ~clk1G28;


initial begin
syncCK40 = 0;
clk1G28 = 0;
s = 8'b00000_000;
//rstn = 1;
//#(784*2); rstn = 0;
//#(784*2); rstn = 1;
#10000000;
	s = 8'b00000_001;
#10000000;
	s = 8'b00000_010;
#10000000;
	s = 8'b00000_011;
#10000000;
	s = 8'b00000_100;
#10000000;
	s = 8'b00000_101;
#10000000;
	s = 8'b00000_110;
#10000000;
	s = 8'b00000_111;

#10000000 $finish;
end 

endmodule
