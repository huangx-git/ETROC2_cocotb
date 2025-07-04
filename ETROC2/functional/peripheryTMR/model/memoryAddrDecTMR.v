/****************************************************************************************************
 *                          ! THIS FILE WAS AUTO-GENERATED BY TMRG TOOL !                           *
 *                                   ! DO NOT EDIT IT MANUALLY !                                    *
 *                                                                                                  *
 * file    : ../output/memoryAddrDecTMR.v                                                           *
 *                                                                                                  *
 * user    : qsun                                                                                   *
 * host    : sphy7asic02.smu.edu                                                                    *
 * date    : 24/01/2022 12:04:52                                                                    *
 *                                                                                                  *
 * workdir : /users/qsun/workarea/tsmc65nm/ETROC_PLL/digital_work/i2c_backend_v5/tmr/work           *
 * cmd     : /users/qsun/workarea/tsmc65nm/ETROC_PLL/digital_work/tmrg/bin/tmrg --log tmrg.log      *
 *           --include --inc-dir /users/qsun/workarea/tsmc65nm/ETROC_PLL/digital_work/git1/etroc2/rtl *
 *           --lib ../simplified_std_cell_lib.v --lib                                               *
 *           /users/qsun/workarea/tsmc65nm/ETROC_PLL/digital_work/git1/etroc2/libs/powerOnResetLong.v *
 *           --lib /users/qsun/workarea/tsmc65nm/ETROC_PLL/digital_work/git1/etroc2/libs/IO_1P2V_C4.v *
 *           --lib                                                                                  *
 *           /users/qsun/workarea/tsmc65nm/ETROC_PLL/digital_work/git1/etroc2/libs/customDigitalLib.v *
 *           -c ../config/tmrg.cnf                                                                  *
 * tmrg rev:                                                                                        *
 *                                                                                                  *
 * src file: /users/qsun/workarea/tsmc65nm/ETROC_PLL/digital_work/git2/etroc2/rtl/memoryAddrDec.v   *
 *           File is NOT under version control!                                                     *
 *           Modification time : 2022-01-20 11:50:53.520698                                         *
 *           File Size         : 289                                                                *
 *           MD5 hash          : c80f2bdc4afc25d30ed17d625f45c2b9                                   *
 *                                                                                                  *
 ****************************************************************************************************/

`timescale  1ps/1ps
module memoryAddrDecTMR(
     addressA,
     addressB,
     addressC,
     enableA,
     enableB,
     enableC
);
parameter    MEMLEN=24;
input [15:0] addressA;
input [15:0] addressB;
input [15:0] addressC;
output reg   [MEMLEN-1:0] enableA;
output reg   [MEMLEN-1:0] enableB;
output reg   [MEMLEN-1:0] enableC;

always @( addressA )
     begin
          enableA =  {MEMLEN{1'b0}};
          if (addressA<MEMLEN)
               enableA[addressA]  =  1'b1;
     end

always @( addressB )
     begin
          enableB =  {MEMLEN{1'b0}};
          if (addressB<MEMLEN)
               enableB[addressB]  =  1'b1;
     end

always @( addressC )
     begin
          enableC =  {MEMLEN{1'b0}};
          if (addressC<MEMLEN)
               enableC[addressC]  =  1'b1;
     end
endmodule

