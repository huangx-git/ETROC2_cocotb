
//all verilog files needed for globalReadout_tb.v
`include "./etroc2readout/globalReadout_tb.v"
`include "./etroc2readout/pixelReadoutWithSWCell_rtl.v"
`include "./etroc2readout/globalReadout_rtl.v"

`include "./etroc2readout/fullChainDataCheck.v"
`include "./etroc2readout/pixelReadoutCol.v"
`include "./etroc2readout/SixteenColChain.v"
`include "./etroc2readout/DataExtract.v"
`include "./etroc2readout/DataExtractUnit.v"
`include "./etroc2readout/Descrambler.v"
`include "./etroc2readout/Deserializer.v"
`include "./etroc2readout/DeserializerWithTriggerData.v"
`include "./etroc2readout/dataRecordCheck.v"
`include "./etroc2readout/delayLine.v"
`include "./etroc2readout/multiplePixelL1TDCDataCheck.v"
`include "./etroc2readout/PRBS7.v"
