//all verilog files for pixelReadoutWithSWCell.v 
//This version is special for debug purpose

`include "./rtl/commonDefinition.v"
`include "./rtl/pixelReadoutTMR/pixelReadoutWithSWCell_include.v"
`include "./pixelReadout_tb_ocp01.v"

`include "./rtl/globalReadoutForPixelTest.v"
`include "./rtl/TestL1Generator.v"
`include "./rtl/TDCTestPatternGen.v"
`include "./rtl/BCIDCounter.v"
`include "./rtl/BCIDBuffer.v"
`include "./rtl/globalReadoutController.v"
`include "./rtl/CircularBufferAddr.v"
`include "./rtl/L1BufferAddr.v"
`include "./rtl/FIFOWRCtrlerDDR.v"
`include "./rtl/memBlock/cb_data_mem_decoder.v"
`include "./rtl/memBlock/BCID_mem_rtl.v"
`include "./rtl/PRBS31.v"
