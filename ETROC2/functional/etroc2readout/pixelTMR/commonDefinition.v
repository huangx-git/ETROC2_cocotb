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
//////////////////////////////////////////////////////////////////////////////////
`ifndef COMMON_DEFINITION
`define COMMON_DEFINITION
//`define DEBUG
//`define DEBUG_CIRCULAR_BUFFER
//`define CHECK_DATA_BEFORE_FRAME
//`define SIMULATION_RANDOM
//Select hit SRAM for Circular buffer, choose one of 4.
//`define CIRCULAR_BUFFER_HITSRAM_1BIT_SIMPLE_MODEL
//`define CIRCULAR_BUFFER_HITSRAM_4BITWIDTH_HAMMING
`define CIRCULAR_BUFFER_HITSRAM_8BITWIDTH_HAMMING
//`define CIRCULAR_BUFFER_HITSRAM_16BITWIDTH_HAMMING
//`define CIRCULAR_BUFFER_HITSRAM_4BITWIDTH_NOHAMMING
//`define CIRCULAR_BUFFER_HITSRAM_8BITWIDTH_NOHAMMING
//`define CIRCULAR_BUFFER_HITSRAM_16BITWIDTH_NOHAMMING

//`define CIRCULAR_BUFFER_HITSRAM_4BIT_REDUNDANCY


`define pixelTMR
//`define globalTMR

//`define CHECK_DATA_AFTER_FRAME
`define CHECK_DATA_AFTER_RECEIVER

`define MAX_BCID_NUMBER 12'd3563
`define L1A_THRESHOLD 15'd820
`define DEFAULT_L1A_LATENCY 9'd501
`define L1BUFFER_ADDRWIDTH 7
`endif
