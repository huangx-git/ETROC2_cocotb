/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ../output/freqDividerSamplerTMR.v                                                      *
 *                                                                                                  *
 * user    : skulis                                                                                 *
 * host    : lnxmicv45.cern.ch                                                                      *
 * date    : 29/09/2017 13:44:30                                                                    *
 *                                                                                                  *
 * workdir : /projects/TSMC65/GBT65/V5.0/workAreas/skulis/LPGBT/digital_implementation/lpGBTX/implementation/feedbackDivider/tmr/work *
 * cmd     : /homedir/skulis/tmrg/bin/tmrg --log tmrg.log --lib /projects/TSMC65/GBT65/V5.0/workAreas/s *
 *           kulis/LPGBT/lpgbt_rtl_2/lpGBTX/../lpGbtxHsLib/verilog/lpGbtxHsLib_tmr.v --lib /projects/TS *
 *           MC65/GBT65/V5.0/workAreas/skulis/LPGBT/lpgbt_rtl_2/lpGBTX/../serializerLib/verilog/seriali *
 *           zerLib_tmr.v -c ../config/tmrg.cnf                                                     *
 * tmrg rev: 02fb1657d85f571e565447ebefb12adf39144fb4                                               *
 *                                                                                                  *
 * src file: /projects/TSMC65/GBT65/V5.0/workAreas/skulis/LPGBT/lpgbt_rtl_2/lpGBTX/../feedbackDivider/rtl/freqDividerSampler.v *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2017-09-14 13:17:02.450387                                         *
 *           File Size         : 1932                                                               *
 *           MD5 hash          : 3eb652c750464bd1c5ea49ea8bbbd325                                   *
 *                                                                                                  *
 ****************************************************************************************************/

module freqDividerSamplerTMR(
  input  clk2G56inA,
  input  clk2G56inB,
  input  clk2G56inC,
  input  enableA,
  input  enableB,
  input  enableC,
  input [5:0] dividedA,
  input [5:0] dividedB,
  input [5:0] dividedC,
  output  clk40MA,
  output  clk40MB,
  output  clk40MC,
  output  clk40MpllA,
  output  clk40MpllB,
  output  clk40MpllC,
  output  clk80MA,
  output  clk80MB,
  output  clk80MC,
  output  clk160MA,
  output  clk160MB,
  output  clk160MC,
  output  clk320MA,
  output  clk320MB,
  output  clk320MC,
  output  clk640MA,
  output  clk640MB,
  output  clk640MC,
  output  clk1G28A,
  output  clk1G28B,
  output  clk1G28C,
  output  clk2G56A,
  output  clk2G56B,
  output  clk2G56C,
  inout VDD,
  inout VSS
);
wire clk2G56inbA;
wire clk2G56inbB;
wire clk2G56inbC;

CKBD16_LVT_ELT ckb_preserveA (
    .I(clk2G56inA),
    .Z(clk2G56inbA)
    );

CKBD16_LVT_ELT ckb_preserveB (
    .I(clk2G56inB),
    .Z(clk2G56inbB)
    );

CKBD16_LVT_ELT ckb_preserveC (
    .I(clk2G56inC),
    .Z(clk2G56inbC)
    );
wire divided0_delA;
wire divided0_delB;
wire divided0_delC;

CKBD1_LVT_ELT ckdel_preserveA (
    .I(dividedA[0] ),
    .Z(divided0_delA)
    );

CKBD1_LVT_ELT ckdel_preserveB (
    .I(dividedB[0] ),
    .Z(divided0_delB)
    );

CKBD1_LVT_ELT ckdel_preserveC (
    .I(dividedC[0] ),
    .Z(divided0_delC)
    );

DDFKLND1_LVT_ELT FF40M_preserveA (
    .CP(clk2G56inbA),
    .D(dividedA[5] ),
    .KLN(enableA),
    .Q(clk40MA)
    );

DDFKLND1_LVT_ELT FF40M_preserveB (
    .CP(clk2G56inbB),
    .D(dividedB[5] ),
    .KLN(enableB),
    .Q(clk40MB)
    );

DDFKLND1_LVT_ELT FF40M_preserveC (
    .CP(clk2G56inbC),
    .D(dividedC[5] ),
    .KLN(enableC),
    .Q(clk40MC)
    );

DDFKLND1_LVT_ELT FF40MPLL_preserveA (
    .CP(clk2G56inbA),
    .D(dividedA[5] ),
    .KLN(enableA),
    .Q(clk40MpllA)
    );

DDFKLND1_LVT_ELT FF40MPLL_preserveB (
    .CP(clk2G56inbB),
    .D(dividedB[5] ),
    .KLN(enableB),
    .Q(clk40MpllB)
    );

DDFKLND1_LVT_ELT FF40MPLL_preserveC (
    .CP(clk2G56inbC),
    .D(dividedC[5] ),
    .KLN(enableC),
    .Q(clk40MpllC)
    );

DDFKLND1_LVT_ELT FF80M_preserveA (
    .CP(clk2G56inbA),
    .D(dividedA[4] ),
    .KLN(enableA),
    .Q(clk80MA)
    );

DDFKLND1_LVT_ELT FF80M_preserveB (
    .CP(clk2G56inbB),
    .D(dividedB[4] ),
    .KLN(enableB),
    .Q(clk80MB)
    );

DDFKLND1_LVT_ELT FF80M_preserveC (
    .CP(clk2G56inbC),
    .D(dividedC[4] ),
    .KLN(enableC),
    .Q(clk80MC)
    );

DDFKLND1_LVT_ELT FF160M_preserveA (
    .CP(clk2G56inbA),
    .D(dividedA[3] ),
    .KLN(enableA),
    .Q(clk160MA)
    );

DDFKLND1_LVT_ELT FF160M_preserveB (
    .CP(clk2G56inbB),
    .D(dividedB[3] ),
    .KLN(enableB),
    .Q(clk160MB)
    );

DDFKLND1_LVT_ELT FF160M_preserveC (
    .CP(clk2G56inbC),
    .D(dividedC[3] ),
    .KLN(enableC),
    .Q(clk160MC)
    );

DDFKLND1_LVT_ELT FF320M_preserveA (
    .CP(clk2G56inbA),
    .D(dividedA[2] ),
    .KLN(enableA),
    .Q(clk320MA)
    );

DDFKLND1_LVT_ELT FF320M_preserveB (
    .CP(clk2G56inbB),
    .D(dividedB[2] ),
    .KLN(enableB),
    .Q(clk320MB)
    );

DDFKLND1_LVT_ELT FF320M_preserveC (
    .CP(clk2G56inbC),
    .D(dividedC[2] ),
    .KLN(enableC),
    .Q(clk320MC)
    );

DDFKLND1_LVT_ELT FF640M_preserveA (
    .CP(clk2G56inbA),
    .D(dividedA[1] ),
    .KLN(enableA),
    .Q(clk640MA)
    );

DDFKLND1_LVT_ELT FF640M_preserveB (
    .CP(clk2G56inbB),
    .D(dividedB[1] ),
    .KLN(enableB),
    .Q(clk640MB)
    );

DDFKLND1_LVT_ELT FF640M_preserveC (
    .CP(clk2G56inbC),
    .D(dividedC[1] ),
    .KLN(enableC),
    .Q(clk640MC)
    );

DDFKLND1_LVT_ELT FF1G28_preserveA (
    .CP(clk2G56inbA),
    .D(divided0_delA),
    .KLN(enableA),
    .Q(clk1G28A)
    );

DDFKLND1_LVT_ELT FF1G28_preserveB (
    .CP(clk2G56inbB),
    .D(divided0_delB),
    .KLN(enableB),
    .Q(clk1G28B)
    );

DDFKLND1_LVT_ELT FF1G28_preserveC (
    .CP(clk2G56inbC),
    .D(divided0_delC),
    .KLN(enableC),
    .Q(clk1G28C)
    );

DELKLND1_LVT_ELT clk2G56buf_preserveA (
    .I(clk2G56inbA),
    .Z(clk2G56A)
    );

DELKLND1_LVT_ELT clk2G56buf_preserveB (
    .I(clk2G56inbB),
    .Z(clk2G56B)
    );

DELKLND1_LVT_ELT clk2G56buf_preserveC (
    .I(clk2G56inbC),
    .Z(clk2G56C)
    );
endmodule

