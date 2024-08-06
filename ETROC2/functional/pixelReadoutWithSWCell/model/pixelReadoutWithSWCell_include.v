`ifdef pixelReadoutWithSWCell
    `include "ETROC2/functional/pixelReadoutWithSWCell/model/pixelReadoutWithSWCell_rtl.v"
`else
    `include "ETROC2/functional/pixelReadoutWithSWCell/model/pixelReadoutWithSWCell_rtl_empty.v"
`endif