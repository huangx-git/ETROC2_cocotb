//Verilog HDL for "ETROC2_customDigitalLib", "DDFKLND1_LVT_ELT" "functional"


// type:  
`timescale 1ns/1fs
`celldefine
module DDFKLND1_LVT_ELT (Q, D, KLN, CP);
	output Q;
	input D, KLN, CP;
	reg notifier;
	wire delayed_D, delayed_KLN, delayed_CP;

	// Function
	wire int_fwire_IQ, int_fwire_r, xcr_0;

	not (int_fwire_r, KLN);
	altos_dff_r_err (xcr_0, delayed_CP, delayed_D, int_fwire_r);
	altos_dff_r (int_fwire_IQ, notifier, delayed_CP, delayed_D, int_fwire_r, xcr_0);
	buf (Q, int_fwire_IQ);

	// Timing

	// Additional timing wires
	wire adacond_D, adacond_D_AND_KLN, adacond_KLN;
	wire adacond_NOT_CP, adacond_NOT_D_AND_KLN, CP__bar;
	wire D__bar;


	// Additional timing gates
	buf (adacond_KLN, KLN);
	buf (adacond_D, D);
	not (CP__bar, CP);
	and (adacond_NOT_CP, CP__bar, Q);
	and (adacond_D_AND_KLN, D, KLN);
	not (D__bar, D);
	and (adacond_NOT_D_AND_KLN, D__bar, KLN);

  initial 
    notifier=0;

	specify
		specparam tpd_KLN_Q_negedge_r = 0.02:0.02:0.02;
		specparam tpd_KLN_Q_negedge_f = 0.02:0.02:0.02;
		specparam tpd_CP_Q_posedge_r = 0.02:0.02:0.02;
		specparam tpd_CP_Q_posedge_f = 0.02:0.02:0.02;
		specparam tsetup_D_CP_adacond_KLN_posedge_adacond_KLN_posedge = 0.0:0.0:0.0;
		specparam thold_D_CP_adacond_KLN_posedge_adacond_KLN_posedge = 0.0:0.0:0.0;
		specparam tsetup_D_CP_adacond_KLN_negedge_adacond_KLN_posedge = 0.0:0.0:0.0;
		specparam thold_D_CP_adacond_KLN_negedge_adacond_KLN_posedge = 0.0:0.0:0.0;
		specparam tsetup_KLN_CP_adacond_D_posedge_adacond_D_posedge = 0.0:0.0:0.0;
		specparam thold_KLN_CP_adacond_D_posedge_adacond_D_posedge = 0.0:0.0:0.0;
		specparam tsetup_KLN_CP_adacond_D_negedge_adacond_D_posedge = -0.0302759:-0.018853:-0.0108039;
		specparam thold_KLN_CP_adacond_D_negedge_adacond_D_posedge = -0.0302759:-0.018853:-0.0108039;
//		specparam tpw_KLN_adacond_NOT_CP_negedge = 0.0208333:0.049479:0.125;
//		specparam tpw_CP_adacond_D_AND_KLN_posedge = 0.015625:0.046007:0.125;
//		specparam tpw_CP_adacond_D_AND_KLN_negedge = 0.015625:0.046007:0.125;
//		specparam tpw_CP_adacond_NOT_D_AND_KLN_posedge = 0.0208333:0.046875:0.125;
//		specparam tpw_CP_adacond_NOT_D_AND_KLN_negedge = 0.0208333:0.046875:0.125;

//	(SETUPHOLD (posedge D) (COND KLN (posedge CP)) (0.034126:0.034584:0.035631) (0.027344:0.026949:0.026066))
//	(SETUPHOLD (negedge D) (COND KLN (posedge CP)) (0.049464:0.050549:0.052629) (-0.026863:-0.027809:-0.029621))

//$setuphold(data, posedge clk , 1, 1);

// $setuphold(posedge clk , data, 1, 1);


		(negedge KLN => (Q+:1'b0)) = ( tpd_KLN_Q_negedge_r , tpd_KLN_Q_negedge_f );
		(posedge CP => (Q+:D)) = ( tpd_CP_Q_posedge_r , tpd_CP_Q_posedge_f );
		$setuphold (posedge CP  &&& KLN, posedge D, 
			 tsetup_D_CP_adacond_KLN_posedge_adacond_KLN_posedge, 
			 thold_D_CP_adacond_KLN_posedge_adacond_KLN_posedge, notifier,,, delayed_CP, delayed_D);
		$setuphold (posedge CP &&& KLN , negedge D, 
			 tsetup_D_CP_adacond_KLN_negedge_adacond_KLN_posedge, 
			 thold_D_CP_adacond_KLN_negedge_adacond_KLN_posedge, notifier,,, delayed_CP, delayed_D);

//		$setuphold (posedge CP &&& adacond_D, posedge KLN &&& adacond_D, 
//			 tsetup_KLN_CP_adacond_D_posedge_adacond_D_posedge, 
//			 thold_KLN_CP_adacond_D_posedge_adacond_D_posedge, notifier,,, delayed_CP, delayed_KLN);
//		$setuphold (posedge CP &&& adacond_D, negedge KLN &&& adacond_D, 
//			 tsetup_KLN_CP_adacond_D_negedge_adacond_D_posedge, 
//			 thold_KLN_CP_adacond_D_negedge_adacond_D_posedge, notifier,,, delayed_CP, delayed_KLN);
//		$width (negedge KLN &&& adacond_NOT_CP, tpw_KLN_adacond_NOT_CP_negedge, 0, notifier);
//		$width (posedge CP &&& adacond_D_AND_KLN, tpw_CP_adacond_D_AND_KLN_posedge, 0, notifier);
//		$width (negedge CP &&& adacond_D_AND_KLN, tpw_CP_adacond_D_AND_KLN_negedge, 0, notifier);
//		$width (posedge CP &&& adacond_NOT_D_AND_KLN, tpw_CP_adacond_NOT_D_AND_KLN_posedge, 0, notifier);
//		$width (negedge CP &&& adacond_NOT_D_AND_KLN, tpw_CP_adacond_NOT_D_AND_KLN_negedge, 0, notifier);
	endspecify
endmodule
`endcelldefine

