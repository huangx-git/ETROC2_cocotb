//Verilog HDL for "ETROC_PLL_Core_AFC", "AFCfsm_TMR" "functional"


module AFCfsm_TMR ( resetA, resetB, resetC, AFCstartA, AFCstartB, AFCstartC,
ckrefA, ckrefB, ckrefC, ckfbA, ckfbB, ckfbC, overridecontrol, overridecontrol_val,
control, AFCbusy, VDD, VSS );

  input ckfbB;
  output AFCbusy;
  input ckrefB;
  input AFCstartB;
  output  [8:0] control;
  input resetB;
  input ckrefA;
  input AFCstartA;
  input resetA;
  input ckrefC;
  input  [5:0] overridecontrol_val;
  inout VDD;
  input ckfbC;
  input ckfbA;
  input resetC;
  input overridecontrol;
  input AFCstartC;
  inout VSS;


	// wire variables for _next

	wire [3:0] FSMstate_nextA,FSMstate_nextB,FSMstate_nextC;
	wire ctrEnable_nextA,ctrEnable_nextB,ctrEnable_nextC;
	wire ctrReset_nextA,ctrReset_nextB,ctrReset_nextC;
	wire [5:0] bitState_nextA,bitState_nextB,bitState_nextC;
	wire [5:0] control_nextA,control_nextB,control_nextC;

	//FSM states
	wire [3:0] FSMstateA,FSMstateB,FSMstateC;
	wire ctrEnableA,ctrEnableB,ctrEnableC;
	wire ctrResetA,ctrResetB,ctrResetC;
	wire [5:0] controlA,controlB,controlC;		//binary + binary
	wire AFCbusyA,AFCbusyB,AFCbusyC;

	//voted outputs from counters
	wire ckrefDoneA_v,ckrefDoneB_v,ckrefDoneC_v;
	wire ckfbDoneA_v,ckfbDoneB_v,ckfbDoneC_v;

	//unvoted counters output
	wire ckrefDoneA,ckrefDoneB,ckrefDoneC;
	wire ckfbDoneA,ckfbDoneB,ckfbDoneC;

	//voted reset and enable signals for counters
	wire ctrEnableA_v,ctrEnableB_v,ctrEnableC_v;
	wire ctrResetA_v,ctrResetB_v,ctrResetC_v;

	wire [5:0] controlA_ov,controlB_ov,controlC_ov; //These are control bits for the vco that can be overwritteb by the SPI programmer. binary + binary
	wire [5:0] controlA_TH,controlB_TH,controlC_TH;	//Thermo portion of the control bits
	wire AFCbusyA_ov,AFCbusyB_ov,AFCbusyC_ov;


//voters ctrEnable
voter V_CTR_A_enable (ctrEnableA,ctrEnableB,ctrEnableC,ctrEnableA_v);
voter V_CTR_B_enable (ctrEnableA,ctrEnableB,ctrEnableC,ctrEnableB_v);
voter V_CTR_C_enable (ctrEnableA,ctrEnableB,ctrEnableC,ctrEnableC_v);

//voters ctrReset
voter V_CTR_A_reset (ctrResetA,ctrResetB,ctrResetC,ctrResetA_v);
voter V_CTR_B_reset (ctrResetA,ctrResetB,ctrResetC,ctrResetB_v);
voter V_CTR_C_reset (ctrResetA,ctrResetB,ctrResetC,ctrResetC_v);

//ckfbDone voter
voter V_ckfbDoneA (ckfbDoneA,ckfbDoneB,ckfbDoneC,ckfbDoneA_v);
voter V_ckfbDoneB (ckfbDoneA,ckfbDoneB,ckfbDoneC,ckfbDoneB_v);
voter V_ckfbDoneC (ckfbDoneA,ckfbDoneB,ckfbDoneC,ckfbDoneC_v);

//ckrefDone voter
voter V_ckrefDoneA (ckrefDoneA,ckrefDoneB,ckrefDoneC,ckrefDoneA_v);
voter V_ckrefDoneB (ckrefDoneA,ckrefDoneB,ckrefDoneC,ckrefDoneB_v);
voter V_ckrefDoneC (ckrefDoneA,ckrefDoneB,ckrefDoneC,ckrefDoneC_v);


assign controlA_ov = (overridecontrol) ? overridecontrol_val : controlA;
assign controlB_ov = (overridecontrol) ? overridecontrol_val : controlB;
assign controlC_ov = (overridecontrol) ? overridecontrol_val : controlC;



bin2thermo3bits B2TA (controlA_ov[5:3],controlA_TH);
bin2thermo3bits B2TB (controlB_ov[5:3],controlB_TH);
bin2thermo3bits B2TC (controlC_ov[5:3],controlC_TH);

voter6bit V_control_TH (controlA_TH,controlB_TH,controlC_TH,control[8:3]);
voter3bit V_control_bin (.A(controlA_ov[2:0]), .B(controlB_ov[2:0]), .C(controlC_ov[2:0]), .Q(control[2:0]), .VDD(VDD), .VSS(VSS));

//voter V_BT0 (~controlA_ov[0],~controlB_ov[0],~controlC_ov[0],BT0); // if the control is high, frequency is higher, but BT high gives lower frequency so invert the LSB

assign AFCbusyA_ov = (overridecontrol) ? 1'b0 : AFCbusyA;
assign AFCbusyB_ov = (overridecontrol) ? 1'b0 : AFCbusyB;
assign AFCbusyC_ov = (overridecontrol) ? 1'b0 : AFCbusyC;

voter V_AFCbusy (AFCbusyA_ov,AFCbusyB_ov,AFCbusyC_ov,AFCbusy);
	


 AFCfsm_tmrblock fsmA(

	//inputs
	.reset(resetA),
	.AFCstart(AFCstartA), 
	
	.ckrefDone(ckrefDoneA_v),
	.ckfbDone(ckfbDoneA_v), 

	.ckref(ckrefA),

	// FSM outputs
	.control(controlA) ,
	.ctrEnable(ctrEnableA),
	.ctrReset(ctrResetA),
	.FSMstate(FSMstateA),
	.AFCbusy(AFCbusyA),

	//_next outputs for reduncancy of other FSM
	.FSMstate_nextA(FSMstate_nextA),
	.ctrEnable_nextA(ctrEnable_nextA),
	.ctrReset_nextA(ctrReset_nextA),
	.bitState_nextA(bitState_nextA) ,
	.control_nextA(control_nextA),

	//redundancy inputs
	.FSMstate_nextB(FSMstate_nextB),
	.ctrEnable_nextB(ctrEnable_nextB),
	.ctrReset_nextB(ctrReset_nextB),
	.bitState_nextB(bitState_nextB) ,
	.control_nextB(control_nextB), 

	.FSMstate_nextC(FSMstate_nextC),
	.ctrEnable_nextC(ctrEnable_nextC),
	.ctrReset_nextC(ctrReset_nextC),
	.bitState_nextC(bitState_nextC),
	.control_nextC(control_nextC),
	.VDD(VDD),
	.VSS(VSS)
	);

 AFCfsm_tmrblock fsmB(

	//inputs
	.reset(resetB),
	.AFCstart(AFCstartB), 
	
	.ckrefDone(ckrefDoneB_v),
	.ckfbDone(ckfbDoneB_v), 

	.ckref(ckrefB),

	// FSM outputs
	.control(controlB) ,
	.ctrEnable(ctrEnableB),
	.ctrReset(ctrResetB),
	.FSMstate(FSMstateB),
	.AFCbusy(AFCbusyB),

	//_next outputs for reduncancy of other FSM
	.FSMstate_nextA(FSMstate_nextB),
	.ctrEnable_nextA(ctrEnable_nextB),
	.ctrReset_nextA(ctrReset_nextB),
	.bitState_nextA(bitState_nextB) ,
	.control_nextA(control_nextB),

	//redundancy inputs
	.FSMstate_nextB(FSMstate_nextA),
	.ctrEnable_nextB(ctrEnable_nextA),
	.ctrReset_nextB(ctrReset_nextA),
	.bitState_nextB(bitState_nextA) ,
	.control_nextB(control_nextA), 

	.FSMstate_nextC(FSMstate_nextC),
	.ctrEnable_nextC(ctrEnable_nextC),
	.ctrReset_nextC(ctrReset_nextC),
	.bitState_nextC(bitState_nextC),
	.control_nextC(control_nextC),
	.VDD(VDD),
	.VSS(VSS)
	);

 AFCfsm_tmrblock fsmC(

	//inputs
	.reset(resetC),
	.AFCstart(AFCstartC), 
	
	.ckrefDone(ckrefDoneC_v),
	.ckfbDone(ckfbDoneC_v), 

	.ckref(ckrefC),

	// FSM outputs
	.control(controlC) ,
	.ctrEnable(ctrEnableC),
	.ctrReset(ctrResetC),
	.FSMstate(FSMstateC),
	.AFCbusy(AFCbusyC),

	//_next outputs for reduncancy of other FSM
	.FSMstate_nextA(FSMstate_nextC),
	.ctrEnable_nextA(ctrEnable_nextC),
	.ctrReset_nextA(ctrReset_nextC),
	.bitState_nextA(bitState_nextC) ,
	.control_nextA(control_nextC),

	//redundancy inputs
	.FSMstate_nextB(FSMstate_nextB),
	.ctrEnable_nextB(ctrEnable_nextB),
	.ctrReset_nextB(ctrReset_nextB),
	.bitState_nextB(bitState_nextB) ,
	.control_nextB(control_nextB), 

	.FSMstate_nextC(FSMstate_nextA),
	.ctrEnable_nextC(ctrEnable_nextA),
	.ctrReset_nextC(ctrReset_nextA),
	.bitState_nextC(bitState_nextA),
	.control_nextC(control_nextA),
	.VDD(VDD),
	.VSS(VSS)
	);

//reference counter
asyncCounter CTR_ref_A (

	.ck_fsm(ckrefA),
	.ck(ckrefA), 
	.enable(ctrEnableA_v),
	.reset(ctrResetA_v),
	.doneFlag(ckrefDoneA) //unvoted output

	);
asyncCounter CTR_ref_B (

	.ck_fsm(ckrefB),
	.ck(ckrefB), 
	.enable(ctrEnableB_v),
	.reset(ctrResetB_v),
	.doneFlag(ckrefDoneB) //unvoted output

	);
asyncCounter CTR_ref_C (

	.ck_fsm(ckrefC),
	.ck(ckrefC), 
	.enable(ctrEnableC_v),
	.reset(ctrResetC_v),
	.doneFlag(ckrefDoneC) //unvoted output

	);

//fb counter
asyncCounter CTR_fb_A (

	.ck_fsm(ckrefA),
	.ck(ckfbA), 
	.enable(ctrEnableA_v),
	.reset(ctrResetA_v),
	.doneFlag(ckfbDoneA) //unvoted output

	);
asyncCounter CTR_fb_B (

	.ck_fsm(ckrefB),
	.ck(ckfbB), 
	.enable(ctrEnableB_v),
	.reset(ctrResetB_v),
	.doneFlag(ckfbDoneB) //unvoted output

	);
asyncCounter CTR_fb_C (

	.ck_fsm(ckrefC),
	.ck(ckfbC), 
	.enable(ctrEnableC_v),
	.reset(ctrResetC_v),
	.doneFlag(ckfbDoneC) //unvoted output

	);

endmodule

