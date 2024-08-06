
//all verilog files needed for globalDigital_tb.v
//`define GLOBALTMR

`include "./etroc2readout/globalDigital_tb.v"
`ifdef PIXEL_POST_SIM
// `include "from_LBNL/par/pixelReadoutWithSWCell/pixelReadoutWithSWCell.signoff.v"
 `include "pixelReadoutImp/pixelReadoutWithSWCell.signoff.v"
`else
`include "./etroc2readout/pixelReadoutWithSWCell_rtl.v"
`endif

`ifdef GLOBALTMR
    `ifdef GLOBAL_POST_SIM
    // `include "from_LBNL/par/globalDigitalTMR_GC/globalDigitalTMR.signoff.v"
       `include "/users/dtgong/workarea/tsmc65/ETLROC/digital/ETROC2Readout/gitlab/etroc2readout/testGlobalDigital/tmpfile4/globalDigitalTMR.signoff.v"
    `else
        `include "./etroc2readout/globalDigitalTMR_include.v"
        `ifdef PIXEL_POST_SIM
            `include "./etroc2readout/latchedBasedRAM.v"
            `include "./etroc2readout/SWCell.v"
            `include "./etroc2readout/gateClockCell.v"
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
        `endif
    `endif
`else
    `include "./etroc2readout/globalDigital_rtl.v"
    `include "./etroc2readout/PRBS7.v"
    `include "./etroc2readout/lockDetector/ljCDRlockFilterDetector.v"
    `include "./etroc2readout/gateClockCell.v"
`endif
`include "./etroc2readout/triggerSynchronizer.v"
`include "./etroc2readout/fullChainDataCheck.v"
`include "./etroc2readout/dataStreamCheck.v"
`include "./etroc2readout/pixelReadoutCol.v"
`include "./etroc2readout/SixteenColPixels.v"
`include "./etroc2readout/DataExtract.v"
`include "./etroc2readout/DataExtractUnit.v"
`include "./etroc2readout/Descrambler.v"
`include "./etroc2readout/Deserializer.v"
`include "./etroc2readout/DeserializerWithTriggerData.v"
`include "./etroc2readout/dataRecordCheck.v"
`include "./etroc2readout/delayLine.v"
`include "./etroc2readout/multiplePixelL1TDCDataCheck.v"
`include "./etroc2readout/CRC8.v"
`include "./etroc2readout/simplePLL.v"
`include "./etroc2readout/PRBS31.v"


