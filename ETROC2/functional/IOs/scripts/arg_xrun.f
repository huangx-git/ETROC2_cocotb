#-v ETROC2/functional/PLL/model/ETROC1_HsLib.v
#-v $PDK_PATH/digital/Front_End/verilog/tcbn65lp_200a/tcbn65lp_pwr.v
#-v ETROC2/functional/peripheryTMR/model/customDigitalLib.v
../model/eRxIO.vams
../model/eRxIO_tb.vams
../../ETROC2/model/S2D.vams
-gui 
-clean
#-input probe.tcl 
-access r
-timescale 1ns/1ps
-no_analogsolver


