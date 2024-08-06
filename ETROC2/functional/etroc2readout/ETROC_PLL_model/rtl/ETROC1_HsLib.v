// Verilog for library /projects/TSMC65/GBT65/V4.0/workAreas/skulis/LPGBT/digital/lpGbtxHsLib/work/../verilog/lpGbtxHsLib_1.2V_25C_tt_norad created by Liberate 13.1.4 on Thu Mar  2 16:32:59 CET 2017 for SDF version 2.1

// type:  
`timescale 1ns/10ps
`celldefine
module CKBD16_LVT_ELT (Z, I, VDD, VSS);
	inout VDD;
	inout VSS;

	output Z;
	input I;

	// Function
	buf (Z, I);

	// Timing
	specify
		specparam tpd_I_Z_r = 0.0295804:0.042618:0.0776488;
		specparam tpd_I_Z_f = 0.026758:0.041657:0.0817063;

		(I => Z) = ( tpd_I_Z_r , tpd_I_Z_f );
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module CKBD1_LVT_ELT (Z, I, VDD, VSS);
	inout VDD;
	inout VSS;

	output Z;
	input I;

	// Function
	buf (Z, I);

	// Timing
	specify
		specparam tpd_I_Z_r = 0.0138013:0.047955:0.168192;
		specparam tpd_I_Z_f = 0.0131415:0.056157:0.210254;

		(I => Z) = ( tpd_I_Z_r , tpd_I_Z_f );
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module CKBD2_LVT_ELT (Z, I, VDD, VSS);
	inout VDD;
	inout VSS;

	output Z;
	input I;

	// Function
	buf (Z, I);

	// Timing
	specify
		specparam tpd_I_Z_r = 0.0185244:0.041908:0.115332;
		specparam tpd_I_Z_f = 0.0172816:0.045798:0.138123;

		(I => Z) = ( tpd_I_Z_r , tpd_I_Z_f );
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module CKBD4_LVT_ELT (Z, I, VDD, VSS);
	inout VDD;
	inout VSS;

	output Z;
	input I;

	// Function
	buf (Z, I);

	// Timing
	specify
		specparam tpd_I_Z_r = 0.0190993:0.035599:0.0834048;
		specparam tpd_I_Z_f = 0.0178113:0.037494:0.0959073;

		(I => Z) = ( tpd_I_Z_r , tpd_I_Z_f );
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DCAP_LVT_ELT (VDD, VSS);
	inout VDD;
	inout VSS;

	// Timing
	specify

	endspecify
endmodule
`endcelldefine


// type:  
`timescale 1ns/10ps
`celldefine
module DDFQD1_LVT_ELT (Q, D, CP, VDD, VSS);
	inout VDD;
	inout VSS;

	output Q;
	input D, CP;
	reg notifier;
	wire delayed_D, delayed_CP;

	// Function
	wire int_fwire_IQ, xcr_0;

	altos_dff_err (xcr_0, delayed_CP, delayed_D);
	altos_dff (int_fwire_IQ, notifier, delayed_CP, delayed_D, xcr_0);
	buf (Q, int_fwire_IQ);

	// Timing
	specify
		specparam tpd_CP_Q_posedge_r = 0.0127833:0.032670:0.0905116;
		specparam tpd_CP_Q_posedge_f = 0.0297266:0.053681:0.126935;
		specparam tsetup_D_CP_posedge_posedge = -0.00050464:0.004225:0.00975824;
		specparam thold_D_CP_posedge_posedge = -0.00050464:0.004225:0.00975824;
		specparam tsetup_D_CP_negedge_posedge = -0.00050464:0.004225:0.00975824;
		specparam thold_D_CP_negedge_posedge = -0.00050464:0.004225:0.00975824;
		specparam tpw_CP_posedge = 0.0234375:0.023438:0.0234375;
		specparam tpw_CP_negedge = 0.0234375:0.023438:0.0234375;

		(posedge CP => (Q+:D)) = ( tpd_CP_Q_posedge_r , tpd_CP_Q_posedge_f );
		$setuphold (posedge CP, posedge D, 
			 tsetup_D_CP_posedge_posedge, 
			 thold_D_CP_posedge_posedge, notifier,,, delayed_CP, delayed_D);
		$setuphold (posedge CP, negedge D, 
			 tsetup_D_CP_negedge_posedge, 
			 thold_D_CP_negedge_posedge, notifier,,, delayed_CP, delayed_D);
		$width (posedge CP, tpw_CP_posedge, 0, notifier);
		$width (negedge CP, tpw_CP_negedge, 0, notifier);
	endspecify
endmodule
`endcelldefine


// type:  
`timescale 1ns/10ps
`celldefine
module DDFCNQD1UBC_LVT_ELT (Q, D, CDN, CP, VDD, VSS);
	inout VDD;
	inout VSS;

	output Q;
	input D, CDN, CP;
	reg notifier;
	wire delayed_D, delayed_CP;

	// Function
	wire int_fwire_IQ, int_fwire_r, xcr_0;

	not (int_fwire_r, CDN);
	altos_dff_r_err (xcr_0, delayed_CP, delayed_D, int_fwire_r);
  pulldown   (int_fwire_s);

  initial
    begin
      notifier=1'b0;
      if ({$random} % 2 )
      begin
        $display ("#TMRG# %.1f Setting DFF (%m) after power up to 1 ",$time);
			  force int_fwire_s=1;
        #(0.01);
			  release int_fwire_s;
		  end
    else
      begin
        $display ("#TMRG# %.1f Setting DFF (%m) after power up to 0 ",$time);
			  force int_fwire_r=1;
        #(0.01);
			  release int_fwire_r;
		  end
	end

  always @(posedge notifier)
    begin
      notifier=1'b0;
      #(0.1); // metastability time
      if ({$random} % 2 )
      begin
        $display ("#TMRG# %.1f Setting DFF (%m) after meta stability to 1 ",$time);
			  force int_fwire_s=1;
        #(0.01);
			  release int_fwire_s;
		  end
    else
      begin
        $display ("#TMRG# %.1f Setting DFF (%m) after meta stability to 0 ",$time);
			  force int_fwire_r=1;
        #(0.01);
			  release int_fwire_r;
		  end

	end
  altos_dff_sr_0 (int_fwire_IQ, notifier, delayed_CP, delayed_D,  int_fwire_s, int_fwire_r, xcr_0);
	buf (Q, int_fwire_IQ);

	// Timing
	specify
		specparam tpd_CDN_Q_CP_negedge_r = 0.043083:0.087575:0.241316;
		specparam tpd_CDN_Q_CP_negedge_f = 0.043083:0.087575:0.241316;
		specparam tpd_CDN_Q_NTB_CP_negedge_r = 0.0356655:0.079466:0.231911;
		specparam tpd_CDN_Q_NTB_CP_negedge_f = 0.0356655:0.079466:0.231911;
		specparam tpd_CDN_Q_negedge_r = 0.043083:0.087575:0.241316;
		specparam tpd_CDN_Q_negedge_f = 0.043083:0.087575:0.241316;
		specparam tpd_CP_Q_posedge_r = 0.0162829:0.050025:0.165179;
		specparam tpd_CP_Q_posedge_f = 0.0404753:0.083461:0.232866;
		specparam tsetup_D_CP_posedge_posedge = -0.00818445:0.000458:0.00479822;
		specparam thold_D_CP_posedge_posedge = -0.00818445:0.000458:0.00479822;
		specparam tsetup_D_CP_negedge_posedge = -0.00818445:0.000458:0.00479822;
		specparam thold_D_CP_negedge_posedge = -0.00818445:0.000458:0.00479822;
		specparam trecovery_CDN_CP_posedge_posedge = 0.0361466:0.048327:0.0679659;
		specparam tremoval_CDN_CP_posedge_posedge = -0.0444344:-0.027359:-0.0151594;
		specparam tpw_CDN_negedge = 0.0130208:0.013021:0.0130208;
		specparam tpw_CP_posedge = 0.0234375:0.023438:0.0234375;
		specparam tpw_CP_negedge = 0.0234375:0.023438:0.0234375;

		if (CP)
			(negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_CP_negedge_r , tpd_CDN_Q_CP_negedge_f );
		if (~(CP))
			(negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_NTB_CP_negedge_r , tpd_CDN_Q_NTB_CP_negedge_f );
		ifnone (negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_negedge_r , tpd_CDN_Q_negedge_f );
		(posedge CP => (Q+:D)) = ( tpd_CP_Q_posedge_r , tpd_CP_Q_posedge_f );
		$setuphold (posedge CP, posedge D, 
			 tsetup_D_CP_posedge_posedge, 
			 thold_D_CP_posedge_posedge, notifier,,, delayed_CP, delayed_D);
		$setuphold (posedge CP, negedge D, 
			 tsetup_D_CP_negedge_posedge, 
			 thold_D_CP_negedge_posedge, notifier,,, delayed_CP, delayed_D);
		$recovery (posedge CDN, posedge CP, 
			 trecovery_CDN_CP_posedge_posedge, notifier);
		$hold (posedge CP, posedge CDN, 
			 tremoval_CDN_CP_posedge_posedge, notifier);
		$width (negedge CDN &&& Q, tpw_CDN_negedge, 0, notifier);
		$width (posedge CP, tpw_CP_posedge, 0, notifier);
		$width (negedge CP, tpw_CP_negedge, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DDFCNQD1_LVT_ELT (Q, D, CDN, CP, VDD, VSS);
	inout VDD;
	inout VSS;

	output Q;
	input D, CDN, CP;
	reg notifier;
	wire delayed_D, delayed_CP;

	// Function
	wire int_fwire_IQ, int_fwire_r, xcr_0;

	not (int_fwire_r, CDN);
	altos_dff_r_err (xcr_0, delayed_CP, delayed_D, int_fwire_r);
  pulldown   (int_fwire_s);

  initial
    begin
      notifier=1'b0;
      if ({$random} % 2 )
      begin
        $display ("#TMRG# %.1f Setting DFF (%m) after power up to 1 ",$time);
			  force int_fwire_s=1;
        #(0.01);
			  release int_fwire_s;
		  end
    else
      begin
        $display ("#TMRG# %.1f Setting DFF (%m) after power up to 0 ",$time);
			  force int_fwire_r=1;
        #(0.01);
			  release int_fwire_r;
		  end
	end

  always @(posedge notifier)
    begin
      notifier=1'b0;
      #(0.1); // metastability time
      if ({$random} % 2 )
      begin
        $display ("#TMRG# %.1f Setting DFF (%m) after meta stability to 1 ",$time);
			  force int_fwire_s=1;
        #(0.01);
			  release int_fwire_s;
		  end
    else
      begin
        $display ("#TMRG# %.1f Setting DFF (%m) after meta stability to 0 ",$time);
			  force int_fwire_r=1;
        #(0.01);
			  release int_fwire_r;
		  end

	end
  altos_dff_sr_0 (int_fwire_IQ, notifier, delayed_CP, delayed_D,  int_fwire_s, int_fwire_r, xcr_0);
	buf (Q, int_fwire_IQ);

	// Timing
	specify
		specparam tpd_CDN_Q_CP_negedge_r = 0.0278088:0.081731:0.260808;
		specparam tpd_CDN_Q_CP_negedge_f = 0.0278088:0.081731:0.260808;
		specparam tpd_CDN_Q_cond1_negedge_r = 0.0264255:0.076257:0.245193;
		specparam tpd_CDN_Q_cond1_negedge_f = 0.0264255:0.076257:0.245193;
		specparam tpd_CDN_Q_cond2_negedge_r = 0.0264519:0.076270:0.245213;
		specparam tpd_CDN_Q_cond2_negedge_f = 0.0264519:0.076270:0.245213;
		specparam tpd_CDN_Q_negedge_r = 0.0278088:0.081731:0.260808;
		specparam tpd_CDN_Q_negedge_f = 0.0278088:0.081731:0.260808;
		specparam tpd_CP_Q_posedge_r = 0.0615596:0.100242:0.227183;
		specparam tpd_CP_Q_posedge_f = 0.0393289:0.085428:0.243167;
		specparam tsetup_D_CP_posedge_posedge = 0.0121991:0.018620:0.0289617;
		specparam thold_D_CP_posedge_posedge = 0.0121991:0.018620:0.0289617;
		specparam tsetup_D_CP_negedge_posedge = 0.0121991:0.018620:0.0289617;
		specparam thold_D_CP_negedge_posedge = 0.0121991:0.018620:0.0289617;
		specparam trecovery_CDN_CP_posedge_posedge = 0.00462531:0.016996:0.0292935;
		specparam tremoval_CDN_CP_posedge_posedge = -0.00248617:0.002677:0.0154094;
		specparam trecovery_CDN_CP_posedge_negedge = -0.0159391:0.002320:0.0213461;
		specparam tremoval_CDN_CP_posedge_negedge = -0.00681397:0.011099:0.0307837;
		specparam tpw_CDN_negedge = 0.0286458:0.028646:0.0286458;
		specparam tpw_CP_posedge = 0.0390625:0.039062:0.0390625;
		specparam tpw_CP_negedge = 0.0390625:0.039062:0.0390625;

		if (CP)
			(negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_CP_negedge_r , tpd_CDN_Q_CP_negedge_f );
		if ((~(CP) & D))
			(negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_cond1_negedge_r , tpd_CDN_Q_cond1_negedge_f );
		if ((~(CP) & ~(D)))
			(negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_cond2_negedge_r , tpd_CDN_Q_cond2_negedge_f );
		ifnone (negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_negedge_r , tpd_CDN_Q_negedge_f );
		(posedge CP => (Q+:D)) = ( tpd_CP_Q_posedge_r , tpd_CP_Q_posedge_f );
		$setuphold (posedge CP, posedge D, 
			 tsetup_D_CP_posedge_posedge, 
			 thold_D_CP_posedge_posedge, notifier,,, delayed_CP, delayed_D);
		$setuphold (posedge CP, negedge D, 
			 tsetup_D_CP_negedge_posedge, 
			 thold_D_CP_negedge_posedge, notifier,,, delayed_CP, delayed_D);
		$recovery (posedge CDN, posedge CP, 
			 trecovery_CDN_CP_posedge_posedge, notifier);
		$hold (posedge CP, posedge CDN, 
			 tremoval_CDN_CP_posedge_posedge, notifier);
		$recovery (posedge CDN, negedge CP, 
			 trecovery_CDN_CP_posedge_negedge, notifier);
		$hold (negedge CP, posedge CDN, 
			 tremoval_CDN_CP_posedge_negedge, notifier);
		$width (negedge CDN &&& Q, tpw_CDN_negedge, 0, notifier);
		$width (posedge CP, tpw_CP_posedge, 0, notifier);
		$width (negedge CP, tpw_CP_negedge, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DDFNCNQD1_LVT_ELT (Q, D, CDN, CPN, VDD, VSS);
	inout VDD;
	inout VSS;

	output Q;
	input D, CDN, CPN;
	reg notifier;
	wire delayed_D, delayed_CPN;

	// Function
	wire int_fwire_clk, int_fwire_IQ, int_fwire_r;
	wire xcr_0;

	not (int_fwire_clk, delayed_CPN);
	not (int_fwire_r, CDN);
	altos_dff_r_err (xcr_0, int_fwire_clk, delayed_D, int_fwire_r);
	altos_dff_r (int_fwire_IQ, notifier, int_fwire_clk, delayed_D, int_fwire_r, xcr_0);
	buf (Q, int_fwire_IQ);

	// Timing
	specify
		specparam tpd_CDN_Q_CPN_negedge_r = 0.0356663:0.079465:0.231904;
		specparam tpd_CDN_Q_CPN_negedge_f = 0.0356663:0.079465:0.231904;
		specparam tpd_CDN_Q_NTB_CPN_negedge_r = 0.0430423:0.087539:0.241272;
		specparam tpd_CDN_Q_NTB_CPN_negedge_f = 0.0430423:0.087539:0.241272;
		specparam tpd_CDN_Q_negedge_r = 0.0430423:0.087539:0.241272;
		specparam tpd_CDN_Q_negedge_f = 0.0430423:0.087539:0.241272;
		specparam tpd_CPN_Q_negedge_r = 0.025191:0.062336:0.186503;
		specparam tpd_CPN_Q_negedge_f = 0.0501924:0.095486:0.2512;
		specparam tsetup_D_CPN_posedge_negedge = -0.0238306:-0.012009:-0.00414555;
		specparam thold_D_CPN_posedge_negedge = -0.0238306:-0.012009:-0.00414555;
		specparam tsetup_D_CPN_negedge_negedge = -0.0238306:-0.012009:-0.00414555;
		specparam thold_D_CPN_negedge_negedge = -0.0238306:-0.012009:-0.00414555;
		specparam trecovery_CDN_CPN_posedge_negedge = 0.0243375:0.033992:0.0468197;
		specparam tremoval_CDN_CPN_posedge_negedge = -0.0215625:-0.013873:-0.00686715;
		specparam tpw_CDN_negedge = 0.0130208:0.013021:0.0130208;
		specparam tpw_CPN_posedge = 0.0286458:0.028646:0.0286458;
		specparam tpw_CPN_negedge = 0.0286458:0.028646:0.0286458;

		if (CPN)
			(negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_CPN_negedge_r , tpd_CDN_Q_CPN_negedge_f );
		if (~(CPN))
			(negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_NTB_CPN_negedge_r , tpd_CDN_Q_NTB_CPN_negedge_f );
		ifnone (negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_negedge_r , tpd_CDN_Q_negedge_f );
		(negedge CPN => (Q+:D)) = ( tpd_CPN_Q_negedge_r , tpd_CPN_Q_negedge_f );
		$setuphold (negedge CPN, posedge D, 
			 tsetup_D_CPN_posedge_negedge, 
			 thold_D_CPN_posedge_negedge, notifier,,, delayed_CPN, delayed_D);
		$setuphold (negedge CPN, negedge D, 
			 tsetup_D_CPN_negedge_negedge, 
			 thold_D_CPN_negedge_negedge, notifier,,, delayed_CPN, delayed_D);
		$recovery (posedge CDN, negedge CPN, 
			 trecovery_CDN_CPN_posedge_negedge, notifier);
		$hold (negedge CPN, posedge CDN, 
			 tremoval_CDN_CPN_posedge_negedge, notifier);
		$width (negedge CDN &&& Q, tpw_CDN_negedge, 0, notifier);
		$width (posedge CPN, tpw_CPN_posedge, 0, notifier);
		$width (negedge CPN, tpw_CPN_negedge, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DDFSND1_LVT_ELT (Q, D, SDN, CP, VDD, VSS);
	inout VDD;
	inout VSS;

	output Q;
	input D, SDN, CP;
	reg notifier;
	wire delayed_D, delayed_CP;

	// Function
	wire int_fwire_IQ, int_fwire_s, xcr_0;

	not (int_fwire_s, SDN);
	altos_dff_s_err (xcr_0, delayed_CP, delayed_D, int_fwire_s);
	altos_dff_s (int_fwire_IQ, notifier, delayed_CP, delayed_D, int_fwire_s, xcr_0);
	buf (Q, int_fwire_IQ);

	// Timing
	specify
		specparam tpd_SDN_Q_CP_negedge_r = 0.0486295:0.089745:0.226999;
		specparam tpd_SDN_Q_CP_negedge_f = 0.0486295:0.089745:0.226999;
		specparam tpd_SDN_Q_NTB_CP_negedge_r = 0.0352737:0.075070:0.210533;
		specparam tpd_SDN_Q_NTB_CP_negedge_f = 0.0352737:0.075070:0.210533;
		specparam tpd_SDN_Q_negedge_r = 0.0486295:0.089745:0.226999;
		specparam tpd_SDN_Q_negedge_f = 0.0486295:0.089745:0.226999;
		specparam tpd_CP_Q_posedge_r = 0.0550813:0.091796:0.216962;
		specparam tpd_CP_Q_posedge_f = 0.0345302:0.079714:0.236187;
		specparam tsetup_D_CP_posedge_posedge = 0.0106953:0.017071:0.0262061;
		specparam thold_D_CP_posedge_posedge = 0.0106953:0.017071:0.0262061;
		specparam tsetup_D_CP_negedge_posedge = 0.0106953:0.017071:0.0262061;
		specparam thold_D_CP_negedge_posedge = 0.0106953:0.017071:0.0262061;
		specparam trecovery_SDN_CP_posedge_posedge = 0.00440588:0.014471:0.0309164;
		specparam tremoval_SDN_CP_posedge_posedge = -0.013531:-0.001308:0.00981373;
		specparam tpw_SDN_negedge = 0.0286458:0.028646:0.0286458;
		specparam tpw_CP_posedge = 0.0338542:0.033854:0.0338542;
		specparam tpw_CP_negedge = 0.0338542:0.033854:0.0338542;

		if (CP)
			(negedge SDN => (Q+:1'b1)) = ( tpd_SDN_Q_CP_negedge_r , tpd_SDN_Q_CP_negedge_f );
		if (~(CP))
			(negedge SDN => (Q+:1'b1)) = ( tpd_SDN_Q_NTB_CP_negedge_r , tpd_SDN_Q_NTB_CP_negedge_f );
		ifnone (negedge SDN => (Q+:1'b1)) = ( tpd_SDN_Q_negedge_r , tpd_SDN_Q_negedge_f );
		(posedge CP => (Q+:D)) = ( tpd_CP_Q_posedge_r , tpd_CP_Q_posedge_f );
		$setuphold (posedge CP, posedge D, 
			 tsetup_D_CP_posedge_posedge, 
			 thold_D_CP_posedge_posedge, notifier,,, delayed_CP, delayed_D);
		$setuphold (posedge CP, negedge D, 
			 tsetup_D_CP_negedge_posedge, 
			 thold_D_CP_negedge_posedge, notifier,,, delayed_CP, delayed_D);
		$recovery (posedge SDN, posedge CP, 
			 trecovery_SDN_CP_posedge_posedge, notifier);
		$hold (posedge CP, posedge SDN, 
			 tremoval_SDN_CP_posedge_posedge, notifier);
//		$width (negedge SDN &&& NOT_Q, tpw_SDN_NOT_Q_negedge, 0, notifier);
		$width (posedge CP, tpw_CP_posedge, 0, notifier);
		$width (negedge CP, tpw_CP_negedge, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DEL0D1_LVT_ELT (Z, I, VDD, VSS);
	inout VDD;
	inout VSS;

	output Z;
	input I;

	// Function
	buf (Z, I);

	// Timing
	specify
		specparam tpd_I_Z_r = 0.064537:0.102471:0.229267;
		specparam tpd_I_Z_f = 0.0735594:0.122882:0.295603;

		(I => Z) = ( tpd_I_Z_r , tpd_I_Z_f );
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DFCNQD1_LVT_ELT (Q, D, CDN, CP, VDD, VSS);
	inout VDD;
	inout VSS;

	output Q;
	input D, CDN, CP;
	reg notifier;
	wire delayed_D, delayed_CP;

	// Function
	wire int_fwire_IQ, int_fwire_r, xcr_0;

	not (int_fwire_r, CDN);
	altos_dff_r_err (xcr_0, delayed_CP, delayed_D, int_fwire_r);
  pulldown   (int_fwire_s);

  initial
    begin
      notifier=1'b0;
      if ({$random} % 2 )
      begin
        $display ("#TMRG# %.1f Setting DFF (%m) after power up to 1 ",$time);
			  force int_fwire_s=1;
        #(0.01);
			  release int_fwire_s;
		  end
    else
      begin
        $display ("#TMRG# %.1f Setting DFF (%m) after power up to 0 ",$time);
			  force int_fwire_r=1;
        #(0.01);
			  release int_fwire_r;
		  end
	end

  always @(posedge notifier)
    begin
      notifier=1'b0;
      #(0.1); // metastability time
      if ({$random} % 2 )
      begin
        $display ("#TMRG# %.1f Setting DFF (%m) after meta stability to 1 ",$time);
			  force int_fwire_s=1;
        #(0.01);
			  release int_fwire_s;
		  end
    else
      begin
        $display ("#TMRG# %.1f Setting DFF (%m) after meta stability to 0 ",$time);
			  force int_fwire_r=1;
        #(0.01);
			  release int_fwire_r;
		  end

	end
  altos_dff_sr_0 (int_fwire_IQ, notifier, delayed_CP, delayed_D,  int_fwire_s, int_fwire_r, xcr_0);
	buf (Q, int_fwire_IQ);

	// Timing
	specify
		specparam tpd_CDN_Q_CP_negedge_r = 0.0373912:0.087424:0.258733;
		specparam tpd_CDN_Q_CP_negedge_f = 0.0373912:0.087424:0.258733;
		specparam tpd_CDN_Q_cond1_negedge_r = 0.0380973:0.089786:0.264911;
		specparam tpd_CDN_Q_cond1_negedge_f = 0.0380973:0.089786:0.264911;
		specparam tpd_CDN_Q_cond2_negedge_r = 0.0381261:0.089461:0.264359;
		specparam tpd_CDN_Q_cond2_negedge_f = 0.0381261:0.089461:0.264359;
		specparam tpd_CDN_Q_negedge_r = 0.0380973:0.089786:0.264911;
		specparam tpd_CDN_Q_negedge_f = 0.0380973:0.089786:0.264911;
		specparam tpd_CP_Q_posedge_r = 0.0584599:0.097522:0.225055;
		specparam tpd_CP_Q_posedge_f = 0.0666457:0.115332:0.2771;
		specparam tsetup_D_CP_posedge_posedge = 0.0171891:0.029522:0.0466174;
		specparam thold_D_CP_posedge_posedge = 0.0171891:0.029522:0.0466174;
		specparam tsetup_D_CP_negedge_posedge = 0.0171891:0.029522:0.0466174;
		specparam thold_D_CP_negedge_posedge = 0.0171891:0.029522:0.0466174;
		specparam trecovery_CDN_CP_posedge_posedge = 0.0223453:0.030645:0.0457503;
		specparam tremoval_CDN_CP_posedge_posedge = -0.0340454:-0.021391:-0.0131941;
		specparam tpw_CDN_negedge = 0.0338542:0.033854:0.0338542;
		specparam tpw_CP_posedge = 0.0546875:0.054688:0.0546875;
		specparam tpw_CP_negedge = 0.0546875:0.054688:0.0546875;

		if (CP)
			(negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_CP_negedge_r , tpd_CDN_Q_CP_negedge_f );
		if ((~(CP) & D))
			(negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_cond1_negedge_r , tpd_CDN_Q_cond1_negedge_f );
		if ((~(CP) & ~(D)))
			(negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_cond2_negedge_r , tpd_CDN_Q_cond2_negedge_f );
		ifnone (negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_negedge_r , tpd_CDN_Q_negedge_f );
		(posedge CP => (Q+:D)) = ( tpd_CP_Q_posedge_r , tpd_CP_Q_posedge_f );
		$setuphold (posedge CP, posedge D, 
			 tsetup_D_CP_posedge_posedge, 
			 thold_D_CP_posedge_posedge, notifier,,, delayed_CP, delayed_D);
		$setuphold (posedge CP, negedge D, 
			 tsetup_D_CP_negedge_posedge, 
			 thold_D_CP_negedge_posedge, notifier,,, delayed_CP, delayed_D);
		$recovery (posedge CDN, posedge CP, 
			 trecovery_CDN_CP_posedge_posedge, notifier);
		$hold (posedge CP, posedge CDN, 
			 tremoval_CDN_CP_posedge_posedge, notifier);
		$width (negedge CDN &&& Q, tpw_CDN_negedge, 0, notifier);
		$width (posedge CP, tpw_CP_posedge, 0, notifier);
		$width (negedge CP, tpw_CP_negedge, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DFCNQD2_LVT_ELT (Q, D, CDN, CP, VDD, VSS);
	inout VDD;
	inout VSS;

	output Q;
	input D, CDN, CP;
	reg notifier;
	wire delayed_D, delayed_CP;

	// Function
	wire int_fwire_IQ, int_fwire_r, xcr_0;

	not (int_fwire_r, CDN);
	altos_dff_r_err (xcr_0, delayed_CP, delayed_D, int_fwire_r);
  pulldown   (int_fwire_s);

  initial
    begin
      notifier=1'b0;
      if ({$random} % 2 )
      begin
        $display ("#TMRG# %.1f Setting DFF (%m) after power up to 1 ",$time);
			  force int_fwire_s=1;
        #(0.01);
			  release int_fwire_s;
		  end
    else
      begin
        $display ("#TMRG# %.1f Setting DFF (%m) after power up to 0 ",$time);
			  force int_fwire_r=1;
        #(0.01);
			  release int_fwire_r;
		  end
	end

  always @(posedge notifier)
    begin
      notifier=1'b0;
      #(0.1); // metastability time
      if ({$random} % 2 )
      begin
        $display ("#TMRG# %.1f Setting DFF (%m) after meta stability to 1 ",$time);
			  force int_fwire_s=1;
        #(0.01);
			  release int_fwire_s;
		  end
    else
      begin
        $display ("#TMRG# %.1f Setting DFF (%m) after meta stability to 0 ",$time);
			  force int_fwire_r=1;
        #(0.01);
			  release int_fwire_r;
		  end

	end
  altos_dff_sr_0 (int_fwire_IQ, notifier, delayed_CP, delayed_D,  int_fwire_s, int_fwire_r, xcr_0);
	buf (Q, int_fwire_IQ);

	// Timing
	specify
		specparam tpd_CDN_Q_CP_negedge_r = 0.0587654:0.090210:0.192845;
		specparam tpd_CDN_Q_CP_negedge_f = 0.0587654:0.090210:0.192845;
		specparam tpd_CDN_Q_cond1_negedge_r = 0.0597129:0.091090:0.193586;
		specparam tpd_CDN_Q_cond1_negedge_f = 0.0597129:0.091090:0.193586;
		specparam tpd_CDN_Q_cond2_negedge_r = 0.0596013:0.091047:0.193613;
		specparam tpd_CDN_Q_cond2_negedge_f = 0.0596013:0.091047:0.193613;
		specparam tpd_CDN_Q_negedge_r = 0.0596013:0.091047:0.193613;
		specparam tpd_CDN_Q_negedge_f = 0.0596013:0.091047:0.193613;
		specparam tpd_CP_Q_posedge_r = 0.0964715:0.120500:0.193333;
		specparam tpd_CP_Q_posedge_f = 0.084408:0.112095:0.202021;
		specparam tsetup_D_CP_posedge_posedge = 0.0171891:0.029501:0.0465578;
		specparam thold_D_CP_posedge_posedge = 0.0171891:0.029501:0.0465578;
		specparam tsetup_D_CP_negedge_posedge = 0.0171891:0.029501:0.0465578;
		specparam thold_D_CP_negedge_posedge = 0.0171891:0.029501:0.0465578;
		specparam trecovery_CDN_CP_posedge_posedge = 0.0223453:0.030609:0.0457078;
		specparam tremoval_CDN_CP_posedge_posedge = -0.0340454:-0.021391:-0.0131941;
		specparam tpw_CDN_negedge = 0.0286458:0.028646:0.0286458;
		specparam tpw_CP_posedge = 0.0494792:0.049479:0.0494792;
		specparam tpw_CP_negedge = 0.0494792:0.049479:0.0494792;

		if (CP)
			(negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_CP_negedge_r , tpd_CDN_Q_CP_negedge_f );
		if ((~(CP) & D))
			(negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_cond1_negedge_r , tpd_CDN_Q_cond1_negedge_f );
		if ((~(CP) & ~(D)))
			(negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_cond2_negedge_r , tpd_CDN_Q_cond2_negedge_f );
		ifnone (negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_negedge_r , tpd_CDN_Q_negedge_f );
		(posedge CP => (Q+:D)) = ( tpd_CP_Q_posedge_r , tpd_CP_Q_posedge_f );
		$setuphold (posedge CP, posedge D, 
			 tsetup_D_CP_posedge_posedge, 
			 thold_D_CP_posedge_posedge, notifier,,, delayed_CP, delayed_D);
		$setuphold (posedge CP, negedge D, 
			 tsetup_D_CP_negedge_posedge, 
			 thold_D_CP_negedge_posedge, notifier,,, delayed_CP, delayed_D);
		$recovery (posedge CDN, posedge CP, 
			 trecovery_CDN_CP_posedge_posedge, notifier);
		$hold (posedge CP, posedge CDN, 
			 tremoval_CDN_CP_posedge_posedge, notifier);
		$width (negedge CDN &&& Q, tpw_CDN_negedge, 0, notifier);
		$width (posedge CP, tpw_CP_posedge, 0, notifier);
		$width (negedge CP, tpw_CP_negedge, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DLHCNQD1_LVT_ELT (Q, D, CDN, E, VDD, VSS);
	inout VDD;
	inout VSS;

	output Q;
	input D, CDN, E;
	reg notifier;
	wire delayed_D, delayed_E;

	// Function
	wire int_fwire_IQ, int_fwire_r;

	not (int_fwire_r, CDN);
	altos_latch_r (int_fwire_IQ, notifier, delayed_E, delayed_D, int_fwire_r);
	buf (Q, int_fwire_IQ);

	// Timing
	specify
		specparam tpd_D_Q_r = 0.0575786:0.093493:0.214281;
		specparam tpd_D_Q_f = 0.048208:0.092948:0.246273;
		specparam tpd_CDN_Q_cond0_negedge_r = 0.0218365:0.069583:0.235315;
		specparam tpd_CDN_Q_cond0_negedge_f = 0.0218365:0.069583:0.235315;
		specparam tpd_CDN_Q_NTB_E_negedge_r = 0.022073:0.069594:0.231591;
		specparam tpd_CDN_Q_NTB_E_negedge_f = 0.022073:0.069594:0.231591;
		specparam tpd_CDN_Q_negedge_r = 0.0218365:0.069583:0.235315;
		specparam tpd_CDN_Q_negedge_f = 0.0218365:0.069583:0.235315;
		specparam tpd_E_Q_posedge_r = 0.0512839:0.087765:0.209989;
		specparam tpd_E_Q_posedge_f = 0.0410651:0.081967:0.22567;
		specparam tsetup_D_E_posedge_negedge = 0.0495548:0.067301:0.0985653;
		specparam thold_D_E_posedge_negedge = 0.0495548:0.067301:0.0985653;
		specparam tsetup_D_E_negedge_negedge = 0.0495548:0.067301:0.0985653;
		specparam thold_D_E_negedge_negedge = 0.0495548:0.067301:0.0985653;
		specparam trecovery_CDN_E_posedge_negedge = 0.0181014:0.031100:0.0537489;
		specparam tremoval_CDN_E_posedge_negedge = -0.0179834:-0.010865:-0.00239574;
		specparam tpw_CDN_negedge = 0.0234375:0.023438:0.0234375;
		specparam tpw_E_posedge = 0.0494792:0.049479:0.0494792;

		(D => Q) = ( tpd_D_Q_r , tpd_D_Q_f );
		if ((D & E))
			(negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_cond0_negedge_r , tpd_CDN_Q_cond0_negedge_f );
		if (~(E))
			(negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_NTB_E_negedge_r , tpd_CDN_Q_NTB_E_negedge_f );
		ifnone (negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_negedge_r , tpd_CDN_Q_negedge_f );
		(posedge E => (Q+:D)) = ( tpd_E_Q_posedge_r , tpd_E_Q_posedge_f );
		$setuphold (negedge E, posedge D, 
			 tsetup_D_E_posedge_negedge, 
			 thold_D_E_posedge_negedge, notifier,,, delayed_E, delayed_D);
		$setuphold (negedge E, negedge D, 
			 tsetup_D_E_negedge_negedge, 
			 thold_D_E_negedge_negedge, notifier,,, delayed_E, delayed_D);
		$recovery (posedge CDN, negedge E, 
			 trecovery_CDN_E_posedge_negedge, notifier);
		$hold (negedge E, posedge CDN, 
			 tremoval_CDN_E_posedge_negedge, notifier);
		$width (negedge CDN &&& Q, tpw_CDN_negedge, 0, notifier);
		$width (posedge E, tpw_E_posedge, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module INVD1_LVT_ELT (ZN, I, VDD, VSS);
	inout VDD;
	inout VSS;

	output ZN;
	input I;

	// Function
	not (ZN, I);

	// Timing
	specify
		specparam tpd_I_ZN_r = 0.0039426:0.039438:0.188735;
		specparam tpd_I_ZN_f = 0.00497058:0.046530:0.221004;

		(I => ZN) = ( tpd_I_ZN_r , tpd_I_ZN_f );
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module INVD2_LVT_ELT (ZN, I, VDD, VSS);
	inout VDD;
	inout VSS;

	output ZN;
	input I;

	// Function
	not (ZN, I);

	// Timing
	specify
		specparam tpd_I_ZN_r = 0.00445318:0.025949:0.124361;
		specparam tpd_I_ZN_f = 0.00550874:0.029754:0.139282;

		(I => ZN) = ( tpd_I_ZN_r , tpd_I_ZN_f );
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module INVD4_LVT_ELT (ZN, I, VDD, VSS);
	inout VDD;
	inout VSS;

	output ZN;
	input I;

	// Function
	not (ZN, I);

	// Timing
	specify
		specparam tpd_I_ZN_r = 0.00607125:0.020374:0.0879925;
		specparam tpd_I_ZN_f = 0.00720484:0.022053:0.0945174;

		(I => ZN) = ( tpd_I_ZN_r , tpd_I_ZN_f );
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module LHCNQD1_LVT_ELT (Q, D, CDN, E, VDD, VSS);
	inout VDD;
	inout VSS;

	output Q;
	input D, CDN, E;
	reg notifier;
	wire delayed_D, delayed_E;

	// Function
	wire int_fwire_IQ, int_fwire_r;

	not (int_fwire_r, CDN);
	altos_latch_r (int_fwire_IQ, notifier, delayed_E, delayed_D, int_fwire_r);
	buf (Q, int_fwire_IQ);

	// Timing
	specify
		specparam tpd_D_Q_r = 0.0389802:0.076586:0.203631;
		specparam tpd_D_Q_f = 0.0601369:0.110880:0.282582;
		specparam tpd_CDN_Q_cond0_negedge_r = 0.0373178:0.088262:0.262724;
		specparam tpd_CDN_Q_cond0_negedge_f = 0.0373178:0.088262:0.262724;
		specparam tpd_CDN_Q_NTB_E_negedge_r = 0.0381248:0.089473:0.264392;
		specparam tpd_CDN_Q_NTB_E_negedge_f = 0.0381248:0.089473:0.264392;
		specparam tpd_CDN_Q_negedge_r = 0.0381248:0.089473:0.264392;
		specparam tpd_CDN_Q_negedge_f = 0.0381248:0.089473:0.264392;
		specparam tpd_E_Q_posedge_r = 0.0520312:0.090212:0.215001;
		specparam tpd_E_Q_posedge_f = 0.0639666:0.112036:0.271976;
		specparam tsetup_D_E_posedge_negedge = -0.00121424:0.019204:0.033566;
		specparam thold_D_E_posedge_negedge = -0.00121424:0.019204:0.033566;
		specparam tsetup_D_E_negedge_negedge = -0.00121424:0.019204:0.033566;
		specparam thold_D_E_negedge_negedge = -0.00121424:0.019204:0.033566;
		specparam trecovery_CDN_E_posedge_negedge = 0.00263885:0.020662:0.0364681;
		specparam tremoval_CDN_E_posedge_negedge = -0.0187214:-0.004757:0.0106829;
		specparam tpw_CDN_negedge = 0.0338542:0.033854:0.0338542;
		specparam tpw_E_posedge = 0.0546875:0.054688:0.0546875;

		(D => Q) = ( tpd_D_Q_r , tpd_D_Q_f );
		if ((D & E))
			(negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_cond0_negedge_r , tpd_CDN_Q_cond0_negedge_f );
		if (~(E))
			(negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_NTB_E_negedge_r , tpd_CDN_Q_NTB_E_negedge_f );
		ifnone (negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_negedge_r , tpd_CDN_Q_negedge_f );
		(posedge E => (Q+:D)) = ( tpd_E_Q_posedge_r , tpd_E_Q_posedge_f );
		$setuphold (negedge E, posedge D, 
			 tsetup_D_E_posedge_negedge, 
			 thold_D_E_posedge_negedge, notifier,,, delayed_E, delayed_D);
		$setuphold (negedge E, negedge D, 
			 tsetup_D_E_negedge_negedge, 
			 thold_D_E_negedge_negedge, notifier,,, delayed_E, delayed_D);
		$recovery (posedge CDN, negedge E, 
			 trecovery_CDN_E_posedge_negedge, notifier);
		$hold (negedge E, posedge CDN, 
			 tremoval_CDN_E_posedge_negedge, notifier);
		$width (negedge CDN &&& Q, tpw_CDN_negedge, 0, notifier);
		$width (posedge E, tpw_E_posedge, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module LHCNQD2_LVT_ELT (Q, D, CDN, E, VDD, VSS);
	inout VDD;
	inout VSS;

	output Q;
	input D, CDN, E;
	reg notifier;
	wire delayed_D, delayed_E;

	// Function
	wire int_fwire_IQ, int_fwire_r;

	not (int_fwire_r, CDN);
	altos_latch_r (int_fwire_IQ, notifier, delayed_E, delayed_D, int_fwire_r);
	buf (Q, int_fwire_IQ);

	// Timing
	specify
		specparam tpd_D_Q_r = 0.0769334:0.099326:0.169732;
		specparam tpd_D_Q_f = 0.0783015:0.107757:0.205926;
		specparam tpd_CDN_Q_cond0_negedge_r = 0.058981:0.090411:0.19306;
		specparam tpd_CDN_Q_cond0_negedge_f = 0.058981:0.090411:0.19306;
		specparam tpd_CDN_Q_NTB_E_negedge_r = 0.0598985:0.091357:0.194011;
		specparam tpd_CDN_Q_NTB_E_negedge_f = 0.0598985:0.091357:0.194011;
		specparam tpd_CDN_Q_negedge_r = 0.0598985:0.091357:0.194011;
		specparam tpd_CDN_Q_negedge_f = 0.0598985:0.091357:0.194011;
		specparam tpd_E_Q_posedge_r = 0.0904055:0.113556:0.183665;
		specparam tpd_E_Q_posedge_f = 0.0820886:0.109171:0.197315;
		specparam tsetup_D_E_posedge_negedge = 0.00920999:0.025562:0.0440188;
		specparam thold_D_E_posedge_negedge = 0.00920999:0.025562:0.0440188;
		specparam tsetup_D_E_negedge_negedge = 0.00920999:0.025562:0.0440188;
		specparam thold_D_E_negedge_negedge = 0.00920999:0.025562:0.0440188;
		specparam trecovery_CDN_E_posedge_negedge = 0.0100024:0.027091:0.0431463;
		specparam tremoval_CDN_E_posedge_negedge = -0.029571:-0.015437:0.00520924;
		specparam tpw_CDN_negedge = 0.0286458:0.028646:0.0286458;
		specparam tpw_E_posedge = 0.0494792:0.049479:0.0494792;

		(D => Q) = ( tpd_D_Q_r , tpd_D_Q_f );
		if ((D & E))
			(negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_cond0_negedge_r , tpd_CDN_Q_cond0_negedge_f );
		if (~(E))
			(negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_NTB_E_negedge_r , tpd_CDN_Q_NTB_E_negedge_f );
		ifnone (negedge CDN => (Q+:1'b0)) = ( tpd_CDN_Q_negedge_r , tpd_CDN_Q_negedge_f );
		(posedge E => (Q+:D)) = ( tpd_E_Q_posedge_r , tpd_E_Q_posedge_f );
		$setuphold (negedge E, posedge D, 
			 tsetup_D_E_posedge_negedge, 
			 thold_D_E_posedge_negedge, notifier,,, delayed_E, delayed_D);
		$setuphold (negedge E, negedge D, 
			 tsetup_D_E_negedge_negedge, 
			 thold_D_E_negedge_negedge, notifier,,, delayed_E, delayed_D);
		$recovery (posedge CDN, negedge E, 
			 trecovery_CDN_E_posedge_negedge, notifier);
		$hold (negedge E, posedge CDN, 
			 tremoval_CDN_E_posedge_negedge, notifier);
		$width (negedge CDN &&& Q, tpw_CDN_negedge, 0, notifier);
		$width (posedge E, tpw_E_posedge, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module MAOI222BD1_LVT_ELT (ZN, A, B, C, VDD, VSS);
	inout VDD;
	inout VSS;

	output ZN;
	input A, B, C;

	// Function
	wire A__bar, B__bar, C__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	not (C__bar, C);
	not (B__bar, B);
	and (int_fwire_0, B__bar, C__bar);
	not (A__bar, A);
	and (int_fwire_1, A__bar, C__bar);
	and (int_fwire_2, A__bar, B__bar);
	or (ZN, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		specparam tpd_A_ZN_cond0_r = 0.021244:0.085187:0.332722;
		specparam tpd_A_ZN_cond0_f = 0.0274509:0.096869:0.364962;
		specparam tpd_A_ZN_cond1_r = 0.019174:0.083852:0.334105;
		specparam tpd_A_ZN_cond1_f = 0.0254686:0.093135:0.357042;
		specparam tpd_A_ZN_r = 0.019174:0.083852:0.334105;
		specparam tpd_A_ZN_f = 0.0274509:0.096869:0.364962;
		specparam tpd_B_ZN_cond2_r = 0.0190281:0.083598:0.333461;
		specparam tpd_B_ZN_cond2_f = 0.025227:0.092866:0.356599;
		specparam tpd_B_ZN_cond3_r = 0.0210786:0.085124:0.333006;
		specparam tpd_B_ZN_cond3_f = 0.0273814:0.096827:0.365068;
		specparam tpd_B_ZN_r = 0.0190281:0.083598:0.333461;
		specparam tpd_B_ZN_f = 0.0273814:0.096827:0.365068;
		specparam tpd_C_ZN_cond4_r = 0.0209964:0.084951:0.332471;
		specparam tpd_C_ZN_cond4_f = 0.0275347:0.096974:0.365261;
		specparam tpd_C_ZN_cond5_r = 0.0192052:0.083768:0.333639;
		specparam tpd_C_ZN_cond5_f = 0.0253061:0.092982:0.356835;
		specparam tpd_C_ZN_r = 0.0192052:0.083768:0.333639;
		specparam tpd_C_ZN_f = 0.0275347:0.096974:0.365261;

		if ((B & ~(C)))
			(A => ZN) = ( tpd_A_ZN_cond0_r , tpd_A_ZN_cond0_f );
		if ((~(B) & C))
			(A => ZN) = ( tpd_A_ZN_cond1_r , tpd_A_ZN_cond1_f );
		ifnone (A => ZN) = ( tpd_A_ZN_r , tpd_A_ZN_f );
		if ((A & ~(C)))
			(B => ZN) = ( tpd_B_ZN_cond2_r , tpd_B_ZN_cond2_f );
		if ((~(A) & C))
			(B => ZN) = ( tpd_B_ZN_cond3_r , tpd_B_ZN_cond3_f );
		ifnone (B => ZN) = ( tpd_B_ZN_r , tpd_B_ZN_f );
		if ((A & ~(B)))
			(C => ZN) = ( tpd_C_ZN_cond4_r , tpd_C_ZN_cond4_f );
		if ((~(A) & B))
			(C => ZN) = ( tpd_C_ZN_cond5_r , tpd_C_ZN_cond5_f );
		ifnone (C => ZN) = ( tpd_C_ZN_r , tpd_C_ZN_f );
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module MAOI222D1_LVT_ELT (ZN, A, B, C, VDD, VSS);
	inout VDD;
	inout VSS;

	output ZN;
	input A, B, C;

	// Function
	wire A__bar, B__bar, C__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	not (C__bar, C);
	not (B__bar, B);
	and (int_fwire_0, B__bar, C__bar);
	not (A__bar, A);
	and (int_fwire_1, A__bar, C__bar);
	and (int_fwire_2, A__bar, B__bar);
	or (ZN, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		specparam tpd_A_ZN_cond0_r = 0.0164:0.079939:0.328174;
		specparam tpd_A_ZN_cond0_f = 0.0237895:0.093111:0.361726;
		specparam tpd_A_ZN_cond1_r = 0.0153416:0.079193:0.328019;
		specparam tpd_A_ZN_cond1_f = 0.0155653:0.081957:0.346599;
		specparam tpd_A_ZN_r = 0.0164:0.079939:0.328174;
		specparam tpd_A_ZN_f = 0.0237895:0.093111:0.361726;
		specparam tpd_B_ZN_cond2_r = 0.0183063:0.082398:0.330179;
		specparam tpd_B_ZN_cond2_f = 0.022591:0.090174:0.354226;
		specparam tpd_B_ZN_cond3_r = 0.0179612:0.081843:0.329425;
		specparam tpd_B_ZN_cond3_f = 0.0212107:0.088509:0.35242;
		specparam tpd_B_ZN_r = 0.0183063:0.082398:0.330179;
		specparam tpd_B_ZN_f = 0.022591:0.090174:0.354226;
		specparam tpd_C_ZN_cond4_r = 0.0133022:0.076937:0.325725;
		specparam tpd_C_ZN_cond4_f = 0.013534:0.081562:0.350295;
		specparam tpd_C_ZN_cond5_r = 0.0113246:0.075121:0.325581;
		specparam tpd_C_ZN_cond5_f = 0.0190096:0.087785:0.355797;
		specparam tpd_C_ZN_r = 0.0133022:0.076937:0.325725;
		specparam tpd_C_ZN_f = 0.0190096:0.087785:0.355797;

		if ((B & ~(C)))
			(A => ZN) = ( tpd_A_ZN_cond0_r , tpd_A_ZN_cond0_f );
		if ((~(B) & C))
			(A => ZN) = ( tpd_A_ZN_cond1_r , tpd_A_ZN_cond1_f );
		ifnone (A => ZN) = ( tpd_A_ZN_r , tpd_A_ZN_f );
		if ((A & ~(C)))
			(B => ZN) = ( tpd_B_ZN_cond2_r , tpd_B_ZN_cond2_f );
		if ((~(A) & C))
			(B => ZN) = ( tpd_B_ZN_cond3_r , tpd_B_ZN_cond3_f );
		ifnone (B => ZN) = ( tpd_B_ZN_r , tpd_B_ZN_f );
		if ((A & ~(B)))
			(C => ZN) = ( tpd_C_ZN_cond4_r , tpd_C_ZN_cond4_f );
		if ((~(A) & B))
			(C => ZN) = ( tpd_C_ZN_cond5_r , tpd_C_ZN_cond5_f );
		ifnone (C => ZN) = ( tpd_C_ZN_r , tpd_C_ZN_f );
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module MUX2ISO_LVT_ELT (out, in0, in1, s, VDD, VSS);
	inout VDD;
	inout VSS;

	output out;
	input in0, in1, s;

	// Function
	wire in0__bar, in1__bar, int_fwire_0;
	wire int_fwire_1, s__bar;

	not (in1__bar, in1);
	and (int_fwire_0, in1__bar, s);
	not (s__bar, s);
	not (in0__bar, in0);
	and (int_fwire_1, in0__bar, s__bar);
	or (out, int_fwire_1, int_fwire_0);

	// Timing
	specify
		specparam tpd_in0_out_r = 0.0166236:0.079856:0.32643;
		specparam tpd_in0_out_f = 0.0192656:0.085410:0.34577;
		specparam tpd_in1_out_r = 0.0164342:0.079753:0.326343;
		specparam tpd_in1_out_f = 0.0192996:0.085405:0.345763;
		specparam tpd_s_out_cond0_r = 0.0238106:0.086604:0.318394;
		specparam tpd_s_out_cond0_f = 0.0224163:0.091700:0.34699;
		specparam tpd_s_out_cond1_r = 0.0335844:0.095539:0.326934;
		specparam tpd_s_out_cond1_f = 0.0369554:0.102897:0.351153;

		(in0 => out) = ( tpd_in0_out_r , tpd_in0_out_f );
		(in1 => out) = ( tpd_in1_out_r , tpd_in1_out_f );
		if ((in0 & ~(in1)))
			(s => out) = ( tpd_s_out_cond0_r , tpd_s_out_cond0_f );
		if ((~(in0) & in1))
			(s => out) = ( tpd_s_out_cond1_r , tpd_s_out_cond1_f );
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module MUX2_LVT_ELT (out, in0, in1, s, VDD, VSS);
	inout VDD;
	inout VSS;

	output out;
	input in0, in1, s;

	// Function
	wire int_fwire_0, int_fwire_1, s__bar;

	and (int_fwire_0, in1, s);
	not (s__bar, s);
	and (int_fwire_1, in0, s__bar);
	or (out, int_fwire_1, int_fwire_0);

	// Timing
	specify
		specparam tpd_in0_out_cond0_r = 0.026161:0.065161:0.195712;
		specparam tpd_in0_out_cond0_f = 0.0268271:0.073944:0.237498;
		specparam tpd_in0_out_cond1_r = 0.0310542:0.070060:0.20132;
		specparam tpd_in0_out_cond1_f = 0.0253957:0.074772:0.24213;
		specparam tpd_in0_out_r = 0.0310542:0.070060:0.20132;
		specparam tpd_in0_out_f = 0.0253957:0.074772:0.24213;
		specparam tpd_in1_out_cond2_r = 0.0261587:0.065138:0.195652;
		specparam tpd_in1_out_cond2_f = 0.0266887:0.073806:0.237357;
		specparam tpd_in1_out_cond3_r = 0.0310645:0.070060:0.201301;
		specparam tpd_in1_out_cond3_f = 0.0252347:0.074621:0.241994;
		specparam tpd_in1_out_r = 0.0310645:0.070060:0.201301;
		specparam tpd_in1_out_f = 0.0252347:0.074621:0.241994;
		specparam tpd_s_out_cond4_r = 0.0577174:0.096348:0.222831;
		specparam tpd_s_out_cond4_f = 0.0547897:0.102219:0.262312;
		specparam tpd_s_out_cond5_r = 0.0460283:0.086206:0.21688;
		specparam tpd_s_out_cond5_f = 0.047287:0.093549:0.25143;

		if ((in1 & ~(s)))
			(in0 => out) = ( tpd_in0_out_cond0_r , tpd_in0_out_cond0_f );
		if ((~(in1) & ~(s)))
			(in0 => out) = ( tpd_in0_out_cond1_r , tpd_in0_out_cond1_f );
		ifnone (in0 => out) = ( tpd_in0_out_r , tpd_in0_out_f );
		if ((in0 & s))
			(in1 => out) = ( tpd_in1_out_cond2_r , tpd_in1_out_cond2_f );
		if ((~(in0) & s))
			(in1 => out) = ( tpd_in1_out_cond3_r , tpd_in1_out_cond3_f );
		ifnone (in1 => out) = ( tpd_in1_out_r , tpd_in1_out_f );
		if ((~(in0) & in1))
			(s => out) = ( tpd_s_out_cond4_r , tpd_s_out_cond4_f );
		if ((in0 & ~(in1)))
			(s => out) = ( tpd_s_out_cond5_r , tpd_s_out_cond5_f );
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module ND2D1_LVT_ELT (ZN, A1, A2, VDD, VSS);
	inout VDD;
	inout VSS;

	output ZN;
	input A1, A2;

	// Function
	wire A1__bar, A2__bar;

	not (A2__bar, A2);
	not (A1__bar, A1);
	or (ZN, A1__bar, A2__bar);

	// Timing
	specify
		specparam tpd_A1_ZN_r = 0.00535594:0.041151:0.189998;
		specparam tpd_A1_ZN_f = 0.0107545:0.077190:0.343399;
		specparam tpd_A2_ZN_r = 0.00629403:0.043127:0.192292;
		specparam tpd_A2_ZN_f = 0.0129218:0.078376:0.34107;

		(A1 => ZN) = ( tpd_A1_ZN_r , tpd_A1_ZN_f );
		(A2 => ZN) = ( tpd_A2_ZN_r , tpd_A2_ZN_f );
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module ND4D1_LVT_ELT (ZN, A1, A2, A3, A4, VDD, VSS);
	inout VDD;
	inout VSS;

	output ZN;
	input A1, A2, A3, A4;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire A4__bar;

	not (A4__bar, A4);
	not (A3__bar, A3);
	not (A2__bar, A2);
	not (A1__bar, A1);
	or (ZN, A1__bar, A2__bar, A3__bar, A4__bar);

	// Timing
	specify
		specparam tpd_A1_ZN_r = 0.0107338:0.049695:0.197441;
		specparam tpd_A1_ZN_f = 0.021071:0.081915:0.321789;
		specparam tpd_A2_ZN_r = 0.0117205:0.050298:0.197568;
		specparam tpd_A2_ZN_f = 0.0228841:0.083869:0.326461;
		specparam tpd_A3_ZN_r = 0.0121455:0.050638:0.197757;
		specparam tpd_A3_ZN_f = 0.0230602:0.084030:0.326582;
		specparam tpd_A4_ZN_r = 0.0105879:0.049496:0.197025;
		specparam tpd_A4_ZN_f = 0.0207281:0.081670:0.321607;

		(A1 => ZN) = ( tpd_A1_ZN_r , tpd_A1_ZN_f );
		(A2 => ZN) = ( tpd_A2_ZN_r , tpd_A2_ZN_f );
		(A3 => ZN) = ( tpd_A3_ZN_r , tpd_A3_ZN_f );
		(A4 => ZN) = ( tpd_A4_ZN_r , tpd_A4_ZN_f );
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module NR2D1_LVT_ELT (ZN, A1, A2, VDD, VSS);
	inout VDD;
	inout VSS;

	output ZN;
	input A1, A2;

	// Function
	wire A1__bar, A2__bar;

	not (A2__bar, A2);
	not (A1__bar, A1);
	and (ZN, A1__bar, A2__bar);

	// Timing
	specify
		specparam tpd_A1_ZN_r = 0.00768721:0.069965:0.317486;
		specparam tpd_A1_ZN_f = 0.00597676:0.047841:0.222919;
		specparam tpd_A2_ZN_r = 0.0116472:0.074276:0.321012;
		specparam tpd_A2_ZN_f = 0.00844812:0.052145:0.226379;

		(A1 => ZN) = ( tpd_A1_ZN_r , tpd_A1_ZN_f );
		(A2 => ZN) = ( tpd_A2_ZN_r , tpd_A2_ZN_f );
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module NR4D1_LVT_ELT (ZN, A1, A2, A3, A4, VDD, VSS);
	inout VDD;
	inout VSS;

	output ZN;
	input A1, A2, A3, A4;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire A4__bar;

	not (A4__bar, A4);
	not (A3__bar, A3);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (ZN, A1__bar, A2__bar, A3__bar, A4__bar);

	// Timing
	specify
		specparam tpd_A1_ZN_r = 0.0194886:0.084218:0.327525;
		specparam tpd_A1_ZN_f = 0.0154797:0.063178:0.239684;
		specparam tpd_A2_ZN_r = 0.0258067:0.089134:0.334982;
		specparam tpd_A2_ZN_f = 0.0192178:0.065636:0.240418;
		specparam tpd_A3_ZN_r = 0.0260373:0.089316:0.335093;
		specparam tpd_A3_ZN_f = 0.0196635:0.065995:0.240649;
		specparam tpd_A4_ZN_r = 0.0191516:0.083886:0.327227;
		specparam tpd_A4_ZN_f = 0.0152464:0.062937:0.239344;

		(A1 => ZN) = ( tpd_A1_ZN_r , tpd_A1_ZN_f );
		(A2 => ZN) = ( tpd_A2_ZN_r , tpd_A2_ZN_f );
		(A3 => ZN) = ( tpd_A3_ZN_r , tpd_A3_ZN_f );
		(A4 => ZN) = ( tpd_A4_ZN_r , tpd_A4_ZN_f );
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module NR4UB2AD1_LVT_ELT (ZN, A1, A2, A3, A4, VDD, VSS);
	inout VDD;
	inout VSS;

	output ZN;
	input A1, A2, A3, A4;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire A4__bar;

	not (A4__bar, A4);
	not (A3__bar, A3);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (ZN, A1__bar, A2__bar, A3__bar, A4__bar);

	// Timing
	specify
		specparam tpd_A1_ZN_r = 0.00950267:0.070880:0.313136;
		specparam tpd_A1_ZN_f = 0.0106311:0.054276:0.229615;
		specparam tpd_A2_ZN_r = 0.0219047:0.084399:0.329519;
		specparam tpd_A2_ZN_f = 0.0175569:0.062993:0.237347;
		specparam tpd_A3_ZN_r = 0.0301938:0.092807:0.333784;
		specparam tpd_A3_ZN_f = 0.0217874:0.068942:0.244154;
		specparam tpd_A4_ZN_r = 0.0337841:0.096732:0.334921;
		specparam tpd_A4_ZN_f = 0.0238366:0.072825:0.250097;

		(A1 => ZN) = ( tpd_A1_ZN_r , tpd_A1_ZN_f );
		(A2 => ZN) = ( tpd_A2_ZN_r , tpd_A2_ZN_f );
		(A3 => ZN) = ( tpd_A3_ZN_r , tpd_A3_ZN_f );
		(A4 => ZN) = ( tpd_A4_ZN_r , tpd_A4_ZN_f );
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module OR2D1_LVT_ELT (Z, A1, A2, VDD, VSS);
	inout VDD;
	inout VSS;

	output Z;
	input A1, A2;

	// Function
	or (Z, A1, A2);

	// Timing
	specify
		specparam tpd_A1_Z_r = 0.0151563:0.049899:0.171304;
		specparam tpd_A1_Z_f = 0.0213507:0.067545:0.230522;
		specparam tpd_A2_Z_r = 0.0187615:0.055274:0.180792;
		specparam tpd_A2_Z_f = 0.0252349:0.071794:0.234177;

		(A1 => Z) = ( tpd_A1_Z_r , tpd_A1_Z_f );
		(A2 => Z) = ( tpd_A2_Z_r , tpd_A2_Z_f );
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module TIEH_LVT_ELT (ZN, VDD, VSS);
	inout VDD;
	inout VSS;

	output ZN;

	// Function
	buf (ZN, 1'b1);

	// Timing
	specify

	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module TIEL_LVT_ELT (ZN, VDD, VSS);
	inout VDD;
	inout VSS;

	output ZN;

	// Function
	buf (ZN, 1'b0);

	// Timing
	specify

	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module XOR2D1_LVT_ELT (Z, A1, A2, VDD, VSS);
	inout VDD;
	inout VSS;

	output Z;
	input A1, A2;

	// Function
	wire A1__bar, A2__bar, int_fwire_0;
	wire int_fwire_1;

	not (A1__bar, A1);
	and (int_fwire_0, A1__bar, A2);
	not (A2__bar, A2);
	and (int_fwire_1, A1, A2__bar);
	or (Z, int_fwire_1, int_fwire_0);

	// Timing
	specify
		specparam tpd_A1_Z_NTB_A2_r = 0.0478945:0.082467:0.202432;
		specparam tpd_A1_Z_NTB_A2_f = 0.0484535:0.092545:0.248403;
		specparam tpd_A1_Z_A2_r = 0.0354728:0.072630:0.20158;
		specparam tpd_A1_Z_A2_f = 0.0370623:0.080667:0.237924;
		specparam tpd_A2_Z_NTB_A1_r = 0.0536372:0.088936:0.21017;
		specparam tpd_A2_Z_NTB_A1_f = 0.0549267:0.098975:0.254826;
		specparam tpd_A2_Z_A1_r = 0.0428478:0.080587:0.210193;
		specparam tpd_A2_Z_A1_f = 0.0455499:0.088951:0.246368;

		if (~(A2))
			(A1 => Z) = ( tpd_A1_Z_NTB_A2_r , tpd_A1_Z_NTB_A2_f );
		if (A2)
			(A1 => Z) = ( tpd_A1_Z_A2_r , tpd_A1_Z_A2_f );
		if (~(A1))
			(A2 => Z) = ( tpd_A2_Z_NTB_A1_r , tpd_A2_Z_NTB_A1_f );
		if (A1)
			(A2 => Z) = ( tpd_A2_Z_A1_r , tpd_A2_Z_A1_f );
	endspecify
endmodule
`endcelldefine

`celldefine
module PGD1_LVT_ELT ( VDD, VSS, Z, E, EN, I );

  input EN;
  input E;
  inout Z;
  inout VDD;
  input I;
  inout VSS;

assign Z = (EN == 1'b0 & E == 1'b1) ? I : 1'bZ;

endmodule
`endcelldefine


`ifdef _udp_def_altos_latch_
`else
`define _udp_def_altos_latch_
primitive altos_latch (q, v, clk, d);
	output q;
	reg q;
	input v, clk, d;

	table
		* ? ? : ? : x;
		? 1 0 : ? : 0;
		? 1 1 : ? : 1;
		? x 0 : 0 : -;
		? x 1 : 1 : -;
		? 0 ? : ? : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_err_
`else
`define _udp_def_altos_dff_err_
primitive altos_dff_err (q, clk, d);
	output q;
	reg q;
	input clk, d;

	table
		(0x) ? : ? : 0;
		(1x) ? : ? : 1;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_
`else
`define _udp_def_altos_dff_
primitive altos_dff (q, v, clk, d, xcr);
	output q;
	reg q;
	input v, clk, d, xcr;

	table
		*  ?   ? ? : ? : x;
		? (x1) 0 0 : ? : 0;
		? (x1) 1 0 : ? : 1;
		? (x1) 0 1 : 0 : 0;
		? (x1) 1 1 : 1 : 1;
		? (x1) ? x : ? : -;
		? (bx) 0 ? : 0 : -;
		? (bx) 1 ? : 1 : -;
		? (x0) b ? : ? : -;
		? (x0) ? x : ? : -;
		? (01) 0 ? : ? : 0;
		? (01) 1 ? : ? : 1;
		? (10) ? ? : ? : -;
		?  b   * ? : ? : -;
		?  ?   ? * : ? : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_r_err_
`else
`define _udp_def_altos_dff_r_err_
primitive altos_dff_r_err (q, clk, d, r);
	output q;
	reg q;
	input clk, d, r;

	table
		 ?   0 (0x) : ? : -;
		 ?   0 (x0) : ? : -;
		(0x) ?  0   : ? : 0;
		(0x) 0  x   : ? : 0;
		(1x) ?  0   : ? : 1;
		(1x) 0  x   : ? : 1;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_r_
`else
`define _udp_def_altos_dff_r_
primitive altos_dff_r (q, v, clk, d, r, xcr);
	output q;
	reg q;
	input v, clk, d, r, xcr;

	table
		*  ?   ?  ?   ? : ? : x;
		?  ?   ?  1   ? : ? : 0;
		?  b   ? (1?) ? : 0 : -;
		?  x   0 (1?) ? : 0 : -;
		?  ?   ? (10) ? : ? : -;
		?  ?   ? (x0) ? : ? : -;
		?  ?   ? (0x) ? : 0 : -;
		? (x1) 0  ?   0 : ? : 0;
		? (x1) 1  0   0 : ? : 1;
		? (x1) 0  ?   1 : 0 : 0;
		? (x1) 1  0   1 : 1 : 1;
		? (x1) ?  ?   x : ? : -;
		? (bx) 0  ?   ? : 0 : -;
		? (bx) 1  0   ? : 1 : -;
		? (x0) 0  ?   ? : ? : -;
		? (x0) 1  0   ? : ? : -;
		? (x0) ?  0   x : ? : -;
		? (01) 0  ?   ? : ? : 0;
		? (01) 1  0   ? : ? : 1;
		? (10) ?  ?   ? : ? : -;
		?  b   *  ?   ? : ? : -;
		?  ?   ?  ?   * : ? : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_s_err_
`else
`define _udp_def_altos_dff_s_err_
primitive altos_dff_s_err (q, clk, d, s);
	output q;
	reg q;
	input clk, d, s;

	table
		 ?   1 (0x) : ? : -;
		 ?   1 (x0) : ? : -;
		(0x) ?  0   : ? : 0;
		(0x) 1  x   : ? : 0;
		(1x) ?  0   : ? : 1;
		(1x) 1  x   : ? : 1;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_s_
`else
`define _udp_def_altos_dff_s_
primitive altos_dff_s (q, v, clk, d, s, xcr);
	output q;
	reg q;
	input v, clk, d, s, xcr;

	table
		*  ?   ?  ?   ? : ? : x;
		?  ?   ?  1   ? : ? : 1;
		?  b   ? (1?) ? : 1 : -;
		?  x   1 (1?) ? : 1 : -;
		?  ?   ? (10) ? : ? : -;
		?  ?   ? (x0) ? : ? : -;
		?  ?   ? (0x) ? : 1 : -;
		? (x1) 0  0   0 : ? : 0;
		? (x1) 1  ?   0 : ? : 1;
		? (x1) 1  ?   1 : 1 : 1;
		? (x1) 0  0   1 : 0 : 0;
		? (x1) ?  ?   x : ? : -;
		? (bx) 1  ?   ? : 1 : -;
		? (bx) 0  0   ? : 0 : -;
		? (x0) 1  ?   ? : ? : -;
		? (x0) 0  0   ? : ? : -;
		? (x0) ?  0   x : ? : -;
		? (01) 1  ?   ? : ? : 1;
		? (01) 0  0   ? : ? : 0;
		? (10) ?  ?   ? : ? : -;
		?  b   *  ?   ? : ? : -;
		?  ?   ?  ?   * : ? : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_sr_err_
`else
`define _udp_def_altos_dff_sr_err_
primitive altos_dff_sr_err (q, clk, d, s, r);
	output q;
	reg q;
	input clk, d, s, r;

	table
		 ?   1 (0x)  ?   : ? : -;
		 ?   0  ?   (0x) : ? : -;
		 ?   0  ?   (x0) : ? : -;
		(0x) ?  0    0   : ? : 0;
		(0x) 1  x    0   : ? : 0;
		(0x) 0  0    x   : ? : 0;
		(1x) ?  0    0   : ? : 1;
		(1x) 1  x    0   : ? : 1;
		(1x) 0  0    x   : ? : 1;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_sr_0
`else
`define _udp_def_altos_dff_sr_0
primitive altos_dff_sr_0 (q, v, clk, d, s, r, xcr);
	output q;
	reg q;
	input v, clk, d, s, r, xcr;

	table
	//	v,  clk, d, s, r : q' : q;

		*  ?   ?   ?   ?   ? : ? : x;
		?  ?   ?   ?   1   ? : ? : 0;
		?  ?   ?   1   0   ? : ? : 1;
		?  b   ? (1?)  0   ? : 1 : -;
		?  x   1 (1?)  0   ? : 1 : -;
		?  ?   ? (10)  0   ? : ? : -;
		?  ?   ? (x0)  0   ? : ? : -;
		?  ?   ? (0x)  0   ? : 1 : -;
		?  b   ?  0   (1?) ? : 0 : -;
		?  x   0  0   (1?) ? : 0 : -;
		?  ?   ?  0   (10) ? : ? : -;
		?  ?   ?  0   (x0) ? : ? : -;
		?  ?   ?  0   (0x) ? : 0 : -;
		? (x1) 0  0    ?   0 : ? : 0;
		? (x1) 1  ?    0   0 : ? : 1;
		? (x1) 0  0    ?   1 : 0 : 0;
		? (x1) 1  ?    0   1 : 1 : 1;
		? (x1) ?  ?    0   x : ? : -;
		? (x1) ?  0    ?   x : ? : -;
		? (1x) 0  0    ?   ? : 0 : -;
		? (1x) 1  ?    0   ? : 1 : -;
		? (x0) 0  0    ?   ? : ? : -;
		? (x0) 1  ?    0   ? : ? : -;
		? (x0) ?  0    0   x : ? : -;
		? (0x) 0  0    ?   ? : 0 : -;
		? (0x) 1  ?    0   ? : 1 : -;
		? (01) 0  0    ?   ? : ? : 0;
		? (01) 1  ?    0   ? : ? : 1;
		? (10) ?  0    ?   ? : ? : -;
		? (10) ?  ?    0   ? : ? : -;
		?  b   *  0    ?   ? : ? : -;
		?  b   *  ?    0   ? : ? : -;
		?  ?   ?  ?    ?   * : ? : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_sr_1
`else
`define _udp_def_altos_dff_sr_1
primitive altos_dff_sr_1 (q, v, clk, d, s, r, xcr);
	output q;
	reg q;
	input v, clk, d, s, r, xcr;

	table
	//	v,  clk, d, s, r : q' : q;

		*  ?   ?   ?   ?   ? : ? : x;
		?  ?   ?   0   1   ? : ? : 0;
		?  ?   ?   1   ?   ? : ? : 1;
		?  b   ? (1?)  0   ? : 1 : -;
		?  x   1 (1?)  0   ? : 1 : -;
		?  ?   ? (10)  0   ? : ? : -;
		?  ?   ? (x0)  0   ? : ? : -;
		?  ?   ? (0x)  0   ? : 1 : -;
		?  b   ?  0   (1?) ? : 0 : -;
		?  x   0  0   (1?) ? : 0 : -;
		?  ?   ?  0   (10) ? : ? : -;
		?  ?   ?  0   (x0) ? : ? : -;
		?  ?   ?  0   (0x) ? : 0 : -;
		? (x1) 0  0    ?   0 : ? : 0;
		? (x1) 1  ?    0   0 : ? : 1;
		? (x1) 0  0    ?   1 : 0 : 0;
		? (x1) 1  ?    0   1 : 1 : 1;
		? (x1) ?  ?    0   x : ? : -;
		? (x1) ?  0    ?   x : ? : -;
		? (1x) 0  0    ?   ? : 0 : -;
		? (1x) 1  ?    0   ? : 1 : -;
		? (x0) 0  0    ?   ? : ? : -;
		? (x0) 1  ?    0   ? : ? : -;
		? (x0) ?  0    0   x : ? : -;
		? (0x) 0  0    ?   ? : 0 : -;
		? (0x) 1  ?    0   ? : 1 : -;
		? (01) 0  0    ?   ? : ? : 0;
		? (01) 1  ?    0   ? : ? : 1;
		? (10) ?  0    ?   ? : ? : -;
		? (10) ?  ?    0   ? : ? : -;
		?  b   *  0    ?   ? : ? : -;
		?  b   *  ?    0   ? : ? : -;
		?  ?   ?  ?    ?   * : ? : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_latch_r_
`else
`define _udp_def_altos_latch_r_
primitive altos_latch_r (q, v, clk, d, r);
	output q;
	reg q;
	input v, clk, d, r;

	table
		* ? ? ? : ? : x;
		? ? ? 1 : ? : 0;
		? 0 ? 0 : ? : -;
		? 0 ? x : 0 : -;
		? 1 0 0 : ? : 0;
		? 1 0 x : ? : 0;
		? 1 1 0 : ? : 1;
		? x 0 0 : 0 : -;
		? x 0 x : 0 : -;
		? x 1 0 : 1 : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_latch_s_
`else
`define _udp_def_altos_latch_s_
primitive altos_latch_s (q, v, clk, d, s);
	output q;
	reg q;
	input v, clk, d, s;

	table
		* ? ? ? : ? : x;
		? ? ? 1 : ? : 1;
		? 0 ? 0 : ? : -;
		? 0 ? x : 1 : -;
		? 1 1 0 : ? : 1;
		? 1 1 x : ? : 1;
		? 1 0 0 : ? : 0;
		? x 1 0 : 1 : -;
		? x 1 x : 1 : -;
		? x 0 0 : 0 : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_latch_sr_0
`else
`define _udp_def_altos_latch_sr_0
primitive altos_latch_sr_0 (q, v, clk, d, s, r);
	output q;
	reg q;
	input v, clk, d, s, r;

	table
		* ? ? ? ? : ? : x;
		? 1 1 ? 0 : ? : 1;
		? 1 0 0 ? : ? : 0;
		? ? ? 1 0 : ? : 1;
		? ? ? ? 1 : ? : 0;
		? 0 * ? ? : ? : -;
		? 0 ? * 0 : 1 : 1;
		? 0 ? 0 * : 0 : 0;
		? * 1 ? 0 : 1 : 1;
		? * 0 0 ? : 0 : 0;
		? ? 1 * 0 : 1 : 1;
		? ? 0 0 * : 0 : 0;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_latch_sr_1
`else
`define _udp_def_altos_latch_sr_1
primitive altos_latch_sr_1 (q, v, clk, d, s, r);
	output q;
	reg q;
	input v, clk, d, s, r;

	table
		* ? ? ? ? : ? : x;
		? 1 1 ? 0 : ? : 1;
		? 1 0 0 ? : ? : 0;
		? ? ? 1 ? : ? : 1;
		? ? ? 0 1 : ? : 0;
		? 0 * ? ? : ? : -;
		? 0 ? * 0 : 1 : 1;
		? 0 ? 0 * : 0 : 0;
		? * 1 ? 0 : 1 : 1;
		? * 0 0 ? : 0 : 0;
		? ? 1 * 0 : 1 : 1;
		? ? 0 0 * : 0 : 0;
	endtable
endprimitive
`endif

