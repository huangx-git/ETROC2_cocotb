/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ../output/DEL4WRAPPERTMR.v                                                             *
 *                                                                                                  *
 * user    : qsun                                                                                   *
 * host    : fasic-beast2.fnal.gov                                                                  *
 * date    : 20/11/2020 00:16:46                                                                    *
 *                                                                                                  *
 * workdir : /fasic_home/qsun/workarea/dflow/periphery/tmr/work                                     *
 * cmd     : /fasic_home/qsun/workarea/dflow/tmrg/tmrg//bin/tmrg --log tmrg.log --include --inc-dir *
 *           /fasic_home/qsun/workarea/dflow/i2c_etroc2/gitlab_quan/etroc2/rtl --lib                *
 *           ../simplified_std_cell_lib.v --lib                                                     *
 *           /fasic_home/qsun/workarea/dflow/i2c_etroc2/gitlab_quan/etroc2/libs/powerOnResetLong.v  *
 *           --lib /fasic_home/qsun/workarea/dflow/i2c_etroc2/gitlab_quan/etroc2/libs/IO_1P2V_C4.v -c *
 *           ../config/tmrg.cnf                                                                     *
 * tmrg rev:                                                                                        *
 *                                                                                                  *
 * src file: /fasic_home/qsun/workarea/dflow/i2c_etroc2/gitlab_quan/etroc2/rtl/DEL4WRAPPER.v        *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2020-11-19 20:53:37.899037                                         *
 *           File Size         : 259                                                                *
 *           MD5 hash          : 587119bdc5d3cb13e48bb17393ada467                                   *
 *                                                                                                  *
 ****************************************************************************************************/
`define SIM
`timescale  1ns / 1ps
module DEL4WRAPPER(
     input  I,
     output  Z
);
`ifdef  SIM
assign #(0.1:0.2:0.3) Z =  I;
`else 

DEL4 DL (
          .I(I),
          .Z(Z)
          );
`endif 
endmodule

