//Verilog HDL for "ETROC_PLL_Core_AFC", "AFC4ChV2" "functional"


module AFC4ChV2 ( resetA, resetB, resetC, AFCstartA, AFCstartB, AFCstartC, extCLK40,
calSourceA, calSourceB, calSourceC, calChSelA, calChSelB, calChSelC, clkref1A,
clkref1B, clkref1C, clkref2A, clkref2B, clkref2C, clkref3A, clkref3B, clkref3C,
clkref4A, clkref4B, clkref4C, ckfb1A, ckfb1B, ckfb1C, ckfb2A, ckfb2B, ckfb2C,
ckfb3A, ckfb3B, ckfb3C, ckfb4A, ckfb4B, ckfb4C, overridecontrolA, overridecontrolB,
overridecontrolC, overridecontrol_val1, overridecontrol_val2, overridecontrol_val3,
overridecontrol_val4, control1, control2, control3, control4, calControlCode,
disDataDiv1A, disDataDiv1B, disDataDiv1C, disDataDiv2A, disDataDiv2B, disDataDiv2C,
disDataDiv3A, disDataDiv3B, disDataDiv3C, disDataDiv4A, disDataDiv4B, disDataDiv4C,
disClkDiv1A, disClkDiv1B, disClkDiv1C, disClkDiv2A, disClkDiv2B, disClkDiv2C,
disClkDiv3A, disClkDiv3B, disClkDiv3C, disClkDiv4A, disClkDiv4B, disClkDiv4C,
AFCbusy, VDD, VSS );

  input ckfb2C;
  output disClkDiv2B;
  input  [5:0] overridecontrol_val1;
  input overridecontrolC;
  input clkref3B;
  input clkref1B;
  input ckfb1C;
  input  [1:0] calChSelC;
  input clkref4C;
  input clkref2C;
  input ckfb3B;
  input calSourceA;
  output  [8:0] control3;
  output disDataDiv4B;
  output disClkDiv4B;
  output disDataDiv2A;
  input ckfb3A;
  input AFCstartC;
  input ckfb4A;
  output disClkDiv3C;
  output disClkDiv4A;
  output disDataDiv1B;
  input overridecontrolA;
  input ckfb2A;
  input AFCstartB;
  output disDataDiv3C;
  input resetB;
  input AFCstartA;
  output  [8:0] control1;
  input resetA;
  inout VDD;
  input ckfb1B;
  input resetC;
  input clkref1A;
  input ckfb2B;
  output disDataDiv4A;
  output disDataDiv3B;
  input  [1:0] calChSelB;
  output disDataDiv2B;
  input  [5:0] overridecontrol_val3;
  input clkref3C;
  output AFCbusy;
  output disDataDiv2C;
  input clkref2A;
  input  [5:0] overridecontrol_val2;
  input ckfb1A;
  input  [1:0] calChSelA;
  output disClkDiv1B;
  output disClkDiv2C;
  input clkref4B;
  output  [5:0] calControlCode;
  output disDataDiv1A;
  input clkref4A;
  output disDataDiv3A;
  input  [5:0] overridecontrol_val4;
  input ckfb4C;
  output disDataDiv4C;
  input clkref2B;
  output disClkDiv1A;
  output disClkDiv2A;
  input extCLK40;
  input ckfb3C;
  input calSourceB;
  output  [8:0] control2;
  output disClkDiv3A;
  input clkref1C;
  input ckfb4B;
  output disClkDiv3B;
  output disClkDiv1C;
  output disClkDiv4C;
  input overridecontrolB;
  inout VSS;
  input clkref3A;
  input calSourceC;
  output  [8:0] control4;
  output disDataDiv1C;



    wire [8:0] control; //current control code  
	wire [8:0] control9b1;// input code of channel 1
	wire [8:0] control9b2;// input code of channel 2
	wire [8:0] control9b3;// input code of channel 3
	wire [8:0] control9b4;// input code of channel 4
	
    wire ckrefA,ckrefB,ckrefC; //current reference clock 
	wire ckfbA,ckfbB,ckfbC; //current feedback clock from VCO
	wire overrideCh1A,overrideCh1B,overrideCh1C, overrideCh1_ov;
	wire overrideCh2A,overrideCh2B,overrideCh2C, overrideCh2_ov;	
	wire overrideCh3A,overrideCh3B,overrideCh3C, overrideCh3_ov;	
	wire overrideCh4A,overrideCh4B,overrideCh4C, overrideCh4_ov;	

	wire [5:0] overridecontrol_val;		//binary + binary, current overridecontrol_val
	wire overridecontrol_ov;		//binary + binary, current overridecontrol_val
	wire [1:0] calChSel_ov;
	voter V_overrideCh1(overrideCh1A,overrideCh1B,overrideCh1C,overrideCh1_ov);
	voter V_overrideCh2(overrideCh2A,overrideCh2B,overrideCh2C,overrideCh2_ov);
	voter V_overrideCh3(overrideCh3A,overrideCh3B,overrideCh3C,overrideCh3_ov);
	voter V_overrideCh4(overrideCh4A,overrideCh4B,overrideCh4C,overrideCh4_ov);
	
	voter V_overridecontrol(overridecontrolA,overridecontrolB,overridecontrolC,overridecontrol_ov);
	//turn off clock signl when AFC is overrided
	assign ckrefA = (overridecontrolA == 1'b1) ?  1'b0 : ((calSourceA == 1'b0) ? extCLK40 : ((calChSelA == 2'b00) ? clkref1A :((calChSelA == 2'b01) ? clkref2A : ((calChSelA == 2'b10) ? clkref3A : clkref4A))));
	assign ckrefB = (overridecontrolB == 1'b1) ?  1'b0 : ((calSourceB == 1'b0) ? extCLK40 : ((calChSelB == 2'b00) ? clkref1B :((calChSelB == 2'b01) ? clkref2B : ((calChSelB == 2'b10) ? clkref3B : clkref4B))));
	assign ckrefC = (overridecontrolC == 1'b1) ?  1'b0 : ((calSourceC == 1'b0) ? extCLK40 : ((calChSelC == 2'b00) ? clkref1C :((calChSelC == 2'b01) ? clkref2C : ((calChSelC == 2'b10) ? clkref3C : clkref4C))));	
	
	assign ckfbA = (overridecontrolA == 1'b1) ?  1'b0 : ((calChSelA == 2'b00) ? ckfb1A :((calChSelA == 2'b01) ? ckfb2A : ((calChSelA == 2'b10) ? ckfb3A : ckfb4A)));
	assign ckfbB = (overridecontrolB == 1'b1) ?  1'b0 : ((calChSelB == 2'b00) ? ckfb1B :((calChSelB == 2'b01) ? ckfb2B : ((calChSelB == 2'b10) ? ckfb3B : ckfb4B)));
	assign ckfbC = (overridecontrolC == 1'b1) ?  1'b0 : ((calChSelC == 2'b00) ? ckfb1C :((calChSelC == 2'b01) ? ckfb2C : ((calChSelC == 2'b10) ? ckfb3C : ckfb4C)));

	//  override each channel
	assign overrideCh1A = ((overridecontrolA == 1'b1) || (calChSelA != 2'b00));
	assign overrideCh1B = ((overridecontrolB == 1'b1) || (calChSelB != 2'b00));
	assign overrideCh1C = ((overridecontrolC == 1'b1) || (calChSelC != 2'b00));
	
	assign overrideCh2A = ((overridecontrolA == 1'b1) || (calChSelA != 2'b01));
	assign overrideCh2B = ((overridecontrolB == 1'b1) || (calChSelB != 2'b01));
	assign overrideCh2C = ((overridecontrolC == 1'b1) || (calChSelC != 2'b01));
	
	assign overrideCh3A = ((overridecontrolA == 1'b1) || (calChSelA != 2'b10));
	assign overrideCh3B = ((overridecontrolB == 1'b1) || (calChSelB != 2'b10));
	assign overrideCh3C = ((overridecontrolC == 1'b1) || (calChSelC != 2'b10));
	
	assign overrideCh4A = ((overridecontrolA == 1'b1) || (calChSelA != 2'b11));	
	assign overrideCh4B = ((overridecontrolB == 1'b1) || (calChSelB != 2'b11));	
	assign overrideCh4C = ((overridecontrolC == 1'b1) || (calChSelC != 2'b11));		
//current overridecontrol_val

	voter V1_calChSel(calChSelA[0],calChSelB[0],calChSelC[0],calChSel_ov[0]);
	voter V2_calChSel(calChSelA[1],calChSelB[1],calChSelC[1],calChSel_ov[1]);
	
	assign overridecontrol_val = (calChSel_ov == 2'b00) ? overridecontrol_val1 : ((calChSel_ov == 2'b01) ? overridecontrol_val2 : ((calChSel_ov == 2'b10) ? overridecontrol_val3 : overridecontrol_val4));
	
//disable clock divider in channels, if a channel is overrided, the divider in the channel are disabled.	
	assign disClkDiv1A = overrideCh1A;
	assign disClkDiv1B = overrideCh1B;
	assign disClkDiv1C = overrideCh1C;	
	assign disClkDiv2A = overrideCh2A;
	assign disClkDiv2B = overrideCh2B;
	assign disClkDiv2C = overrideCh2C;
	assign disClkDiv3A = overrideCh3A;
	assign disClkDiv3B = overrideCh3B;
	assign disClkDiv3C = overrideCh3C;	
	assign disClkDiv4A = overrideCh4A;
	assign disClkDiv4B = overrideCh4B;
	assign disClkDiv4C = overrideCh4C;	

//disable data divider in channels, if a channel is overrided or not in data calibration mode, the divider in the channel are disabled.	
	assign disDataDiv1A = overrideCh1A||(~calSourceA);
	assign disDataDiv1B = overrideCh1B||(~calSourceB);
	assign disDataDiv1C = overrideCh1C||(~calSourceC);
	assign disDataDiv2A = overrideCh2A||(~calSourceA);
	assign disDataDiv2B = overrideCh2B||(~calSourceB);
	assign disDataDiv2C = overrideCh2C||(~calSourceC);
	assign disDataDiv3A = overrideCh3A||(~calSourceA);
	assign disDataDiv3B = overrideCh3B||(~calSourceB);
	assign disDataDiv3C = overrideCh3C||(~calSourceC);	
	assign disDataDiv4A = overrideCh4A||(~calSourceA);
	assign disDataDiv4B = overrideCh4B||(~calSourceB);
	assign disDataDiv4C = overrideCh4C||(~calSourceC);	
	
	bin2thermo3bits B2T1 (overridecontrol_val1[5:3],control9b1[8:3]);
	bin2thermo3bits B2T2 (overridecontrol_val2[5:3],control9b2[8:3]);
	bin2thermo3bits B2T3 (overridecontrol_val3[5:3],control9b3[8:3]);
	bin2thermo3bits B2T4 (overridecontrol_val4[5:3],control9b4[8:3]);
	assign control9b1[2:0] = overridecontrol_val1[2:0];
	assign control9b2[2:0] = overridecontrol_val2[2:0];
	assign control9b3[2:0] = overridecontrol_val3[2:0];
	assign control9b4[2:0] = overridecontrol_val4[2:0];	
	
	assign control1 = (overrideCh1_ov == 1'b1) ? control9b1 : control;
	assign control2 = (overrideCh2_ov == 1'b1) ? control9b2 : control;
	assign control3 = (overrideCh3_ov == 1'b1) ? control9b3 : control;
	assign control4 = (overrideCh4_ov == 1'b1) ? control9b4 : control;
	
	thermo2bin6bits T2B(.in(control[8:3]),.out(calControlCode[5:3]), .VDD(VDD), .VSS(VSS)); //for I2C reading back.
	assign calControlCode[2:0] = control[2:0];	

AFCfsm_TMR AFC(

	.resetA(resetA),
	.resetB(resetB),
	.resetC(resetC),

	.AFCstartA(AFCstartA),
	.AFCstartB(AFCstartB),
	.AFCstartC(AFCstartC),

	.ckrefA(ckrefA),
	.ckrefB(ckrefB),
	.ckrefC(ckrefC),

	.ckfbA(ckfbA),
	.ckfbB(ckfbB),
	.ckfbC(ckfbC),

	.overridecontrol(overridecontrol_ov),
	.overridecontrol_val(overridecontrol_val),

	.control(control),
	.AFCbusy(AFCbusy),
	.VDD(VDD),
	.VSS(VSS)
	);
endmodule
