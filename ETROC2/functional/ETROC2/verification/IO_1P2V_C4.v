/** ****************************************************************************
 *  lpGBTX                                                                     *
 *  Copyright (C) 2011-2016 GBTX Team, CERN                                    *
 *                                                                             *
 *  This IP block is free for HEP experiments and other scientific research    *
 *  purposes. Commercial exploitation of a chip containing the IP is not       *
 *  permitted.  You can not redistribute the IP without written permission     *
 *  from the authors. Any modifications of the IP have to be communicated back *
 *  to the authors. The use of the IP should be acknowledged in publications,  *
 *  public presentations, user manual, and other documents.                    *
 *                                                                             *
 *  This IP is distributed in the hope that it will be useful, but WITHOUT ANY *
 *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS  *
 *  FOR A PARTICULAR PURPOSE.                                                  *
 *                                                                             *
 *******************************************************************************
 *
 *  file: CERN_IO_PAD.v
 *
 *  CERN_IO_PAD
 *
 *  History:
 *  2016/05/20 Szymon Kulis    : Created
 *  2019/05/22 Szymon Kulis    : Z_h added
 *
 **/

`timescale 1ps/1ps

module IO_1P2V_C4 (
  // power supply
  inout  VDD,     // core supply voltage
  inout  VSS,
  inout  VDDPST,  // IO supply voltage
  inout  VSSPST,

  inout  IO,      // inout not supported by tmrg yet
  input  A,       // cmos input
  input  DS,      // driving strength
  input  OUT_EN,  // output enable
  input  PEN,     // pullup/pulldown enable
  input  UD,      // pull UP(1)/DOWN(0)
  output Z,       // cmos output
  output Z_h      // schmitt output
);
//tmrg do_not_touch

  wire error=DS ^ OUT_EN ^ PEN ^ UD ^ A;
  assign IO = (OUT_EN)?A:1'bz;
  assign Z=(error===1'bx)?1'bx:IO;
  assign Z_h=(error===1'bx)?1'bx:IO;
endmodule