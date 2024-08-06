//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Sat Feb  6 12:09:51 CST 2021
// Module Name: commonDefinition
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created
//
// 
//////////////////////////////////////////////////////////////////////////////////
`ifndef COMMON_DEFINITION
`define COMMON_DEFINITION
`define SYNTHESIS   //gateClockCell
`define LATCH_RAM
`define ICG_LMEM
`define INITIALIZE_MEMORY
`define HTreeDLY_ON
`define GLOBALTMR

//  `define GLOBAL_POST_SIM
  `define PIXEL_POST_SIM

//`define DEBUG
//`define DEBUG_CIRCULAR_BUFFER
//`define CHECK_DATA_BEFORE_FRAME
//`define SIMULATION_RANDOM
//Select hit SRAM for Circular buffer, choose one of 4.
//`define CIRCULAR_BUFFER_HITSRAM_1BIT_SIMPLE_MODEL
//`define CIRCULAR_BUFFER_HITSRAM_4BITWIDTH_HAMMING
//`define CIRCULAR_BUFFER_HITSRAM_8BITWIDTH_HAMMING   //for ARM memory, obsolete
//`define CIRCULAR_BUFFER_HITSRAM_16BITWIDTH_HAMMING
//`define CIRCULAR_BUFFER_HITSRAM_4BITWIDTH_NOHAMMING
//`define CIRCULAR_BUFFER_HITSRAM_8BITWIDTH_NOHAMMING
//`define CIRCULAR_BUFFER_HITSRAM_16BITWIDTH_NOHAMMING

//`define CIRCULAR_BUFFER_HITSRAM_4BIT_REDUNDANCY
//`define DEBUG_TRIGGERPATH

`define pixelTMR

//`define CHECK_DATA_AFTER_FRAME
`define CHECK_DATA_AFTER_RECEIVER

`define MAX_BCID_NUMBER 12'd3563
`define L1A_THRESHOLD 15'd820
`define DEFAULT_L1A_LATENCY 9'd501
`define L1BUFFER_ADDRWIDTH 7
// `define HTREE_MAX_DELAY 7.985
// `define HTREE_TYP_DELAY 6.000
// `define HTREE_MIN_DELAY 3.269
`ifdef PIXEL_POST_SIM
  `define PIXEL_CTS_MAX_DELAY 0.85
  `define PIXEL_CTS_TYP_DELAY 0.5
  `define PIXEL_CTS_MIN_DELAY 0.35
`else 
  `define PIXEL_CTS_MAX_DELAY 0
  `define PIXEL_CTS_TYP_DELAY 0
  `define PIXEL_CTS_MIN_DELAY 0
`endif

`define HTREE_MAX_DELAY 8.0
`define HTREE_TYP_DELAY 4.8
`define HTREE_MIN_DELAY 3.2


// `ifdef PIXEL_POST_SIM
//   `define HTREE_MAX_DELAY 8.0
//   `define HTREE_TYP_DELAY 4.8
//   `define HTREE_MIN_DELAY 3.2
// `else
//   `define HTREE_MAX_DELAY 8.85
//   `define HTREE_TYP_DELAY 6.6
//   `define HTREE_MIN_DELAY 3.2
// `endif

`endif
