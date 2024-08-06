//all verilog files for pixelReadoutWithSWCell.v 
//if define pixelTMR, this includes all files for pixelReadout module for synthersis. 
//Only for latch-based memory
//define LATCH_RAM,ICG_LMEM,INITIALIZE_MEMORY

`include "./etroc2readout/commonDefinition.v"
`include "./etroc2readout/pixelReadoutWithSWCell.v"
`include "./etroc2readout/SWCell.v"
`include "./etroc2readout/pixelReadout.v"
`ifdef pixelTMR
    `include "./etroc2readout/pixelReadoutTMR/TDCTestPatternGenTMR.v"
    `include "./etroc2readout/pixelReadoutTMR/PRBS31TMR.v"
    `include "./etroc2readout/pixelReadoutTMR/TestL1GeneratorTMR.v"
    `include "./etroc2readout/pixelReadoutTMR/BCIDCounterTMR.v"
    `include "./etroc2readout/majorityVoter.v"
    `include "./etroc2readout/fanout.v"
`else
    `include "./etroc2readout/TDCTestPatternGen.v"
    `include "./etroc2readout/PRBS31.v"
    `include "./etroc2readout/TestL1Generator.v"
    `include "./etroc2readout/BCIDCounter.v"
`endif
`include "./etroc2readout/CircularBuffer.v"
`include "./etroc2readout/gateClockCell.v"
`include "./etroc2readout/memBlock/cb_data_mem_rtl.v"
`include "./etroc2readout/hitSRAMCircularBuffer.v"
`include "./etroc2readout/memBlock/cb_hit_mem8_rtl.v"
`include "./etroc2readout/L1EventBuffer.v"
`include "./etroc2readout/hitSRAML1Buffer.v"
`include "./etroc2readout/memBlock/L1_hit_mem_rtl.v"
`include "./etroc2readout/latchedBasedRAM.v"
