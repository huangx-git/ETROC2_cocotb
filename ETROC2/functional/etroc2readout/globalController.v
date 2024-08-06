`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Wed Jan  5 11:29:29 CST 2022
// Module Name: globalController
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////

module globalController
(
	input           clk40Ref,               //40 MHz, reference clock
    input           POR,                     //POR, high active
    input           softBoot,                //from I2C
    input           disPowerSequence,            //no automatical power up sequence, controled by I2C
//input status or fast command
    input  [9:0]    decodedFastcommand,
    input           pllCalibrationDone,     //
    input           pllLocked,              //
    input           fastcommandAligned,
    input           invalidFastcommand,    //synchronous signal
    input           fcSelfAlign,           //determine if skip self alignment mode.
//decoded fastcommand
    output reg      fcL1A,
    output reg      fcL1ARst,
    output reg      fcBCR,
    output reg      fcWSStart,
    output reg      fcWSStop,
    output reg      fcChargeInjCmd,               //fast command,
//monitor status
    output reg [3:0]    state,
    output reg [11:0]   pllUnlockCount,                //PLL unlock counter
    output reg [11:0]   invalidFCCount,             //invalidate fastcommand count
//synchronous command output and asynchronous command input
    input           asyLinkReset,
    output reg      synLinkReset,
    input           asyPLLReset,
    output reg      synPLLReset,
    input           asyAlignFastcommand,
    output reg      synAlignFastcommand,
    input           asyStartCalibration,
    output reg      synStartCalibration,    //
    input           asyResetFastcommand,
    output reg      synResetFastcommand,
    input           asyResetLockDetect,
    output reg      synResetLockdetect,        //
    input           asyResetGlobalReadout,
    output reg      synResetGlobalReadout,
    input           asyResetChargeInj,
    output reg      synResetChargeInj
);
// tmrg default triplicate

localparam smINIT0          = 4'd0;
localparam smINIT1          = 4'd1;
localparam smRESETPLL0      = 4'd2;
localparam smRESETPLL1      = 4'd3;
localparam smPLLCAL0        = 4'd4;
localparam smPLLCAL1        = 4'd5;
localparam smPLLCAL2        = 4'd6;

localparam smLOCKDETECT     = 4'd7;
localparam smRESETFC0       = 4'd8;
localparam smRESETFC1       = 4'd9;
localparam smINITFC         = 4'd10;
localparam smDONE           = 4'd11;

reg [3:0] nextState;
wire [3:0] nextStateVoted = nextState;

wire boot = POR | softBoot;
reg [2:0] bootReg;
reg [2:0] pllLocked_reg;
always@(negedge clk40Ref) 
begin
    bootReg         <= {bootReg[1:0],boot};
    pllLocked_reg   <= {pllLocked_reg[1:0],pllLocked};
end

wire pllLocked_fallingEdge = pllLocked_reg[2]&~pllLocked_reg[1];

reg [1:0] asyAlignFastcommandReg;
reg [1:0] asyLinkResetReg;
reg [1:0] asyStartCalibrationReg;
reg [1:0] asyResetFastcommandReg;
reg [1:0] asyResetLockDetectReg;
reg [1:0] asyResetGlobalReadoutReg;
reg [1:0] asyResetChargeInjReg;
reg [1:0] asyPLLResetReg;
reg [11:0] nextUnlockCount;
reg [11:0] nextInvalidFCCount;
wire[3:0] stateVoted = state;
wire invalidFastcommandVoted = invalidFastcommand;
always @*
    begin
        case(stateVoted)
        smINIT0:
            begin
            synPLLReset                     <= 1'b1;    //high active
            synStartCalibration             <= 1'b0; 
            synResetLockdetect              <= 1'b0;
            synAlignFastcommand             <= 1'b0;
            synResetFastcommand             <= 1'b0;
            synResetGlobalReadout           <= 1'b0;
            synResetChargeInj               <= 1'b0;
            nextUnlockCount                 <= 12'd0;
            nextInvalidFCCount              <= 12'd0;
            nextState  <= disPowerSequence ? smDONE : smINIT1;                
            end
        smINIT1:
            begin
            synPLLReset                     <= 1'b1;
            synStartCalibration             <= 1'b0; 
            synResetLockdetect              <= 1'b0;
            synAlignFastcommand             <= 1'b0;
            synResetFastcommand             <= 1'b0;
            synResetGlobalReadout           <= 1'b0;
            synResetChargeInj               <= 1'b0;
            nextUnlockCount                 <= 12'd0;
            nextInvalidFCCount              <= 12'd0;
            nextState  <= disPowerSequence ? smDONE : smRESETPLL0;                
            end
        smRESETPLL0:
            begin
            synPLLReset                     <= 1'b0; 
            synStartCalibration             <= 1'b0; 
            synResetLockdetect              <= 1'b0;
            synAlignFastcommand             <= 1'b0;
            synResetFastcommand             <= 1'b0;
            synResetGlobalReadout           <= 1'b0;
            synResetChargeInj               <= 1'b0;
            nextUnlockCount                 <= 12'd0;
            nextInvalidFCCount              <= 12'd0;
            nextState  <= disPowerSequence ? smDONE : smRESETPLL1;                
            end
        smRESETPLL1:
            begin
            synPLLReset                     <= 1'b0;  
            synStartCalibration             <= 1'b0; 
            synResetLockdetect              <= 1'b0;
            synAlignFastcommand             <= 1'b0;
            synResetFastcommand             <= 1'b0;
            synResetGlobalReadout           <= 1'b0;
            synResetChargeInj               <= 1'b0;
            nextUnlockCount                 <= 12'd0;
            nextInvalidFCCount              <= 12'd0;
            nextState  <= disPowerSequence ? smDONE : smPLLCAL0;                
            end
        smPLLCAL0:
            begin
            synPLLReset                     <= 1'b0;
            synStartCalibration             <= 1'b1; 
            synResetLockdetect              <= 1'b0;
            synAlignFastcommand             <= 1'b0;
            synResetFastcommand             <= 1'b0;
            synResetGlobalReadout           <= 1'b0;
            synResetChargeInj               <= 1'b0;
            nextUnlockCount                 <= 12'd0;
            nextInvalidFCCount              <= 12'd0;
            nextState  <= disPowerSequence ? smDONE : smPLLCAL1;
            end
        smPLLCAL1:
            begin
            synPLLReset                     <= 1'b0;
            synStartCalibration             <= 1'b1; 
            synResetLockdetect              <= 1'b0;
            synAlignFastcommand             <= 1'b0;
            synResetFastcommand             <= 1'b0;
            synResetGlobalReadout           <= 1'b0;
            synResetChargeInj               <= 1'b0;
            nextUnlockCount                 <= 12'd0;
            nextInvalidFCCount              <= 12'd0;
            nextState  <= disPowerSequence ? smDONE : smPLLCAL2;
            end
        smPLLCAL2:
            begin
            synPLLReset                     <= 1'b0;
            synStartCalibration             <= 1'b1; 
            synResetLockdetect              <= 1'b0;
            synAlignFastcommand             <= 1'b0;
            synResetFastcommand             <= 1'b0;
            synResetGlobalReadout           <= 1'b0;
            synResetChargeInj               <= 1'b0;
            nextUnlockCount                 <= 12'd0;
            nextInvalidFCCount              <= 12'd0;
            nextState  <= disPowerSequence ? smDONE : 
                        (pllCalibrationDone ? smLOCKDETECT : smPLLCAL2);
            end
        smLOCKDETECT:
            begin
            synPLLReset                     <= 1'b0;
            synStartCalibration             <= 1'b1; //rising edge detection 
            synResetLockdetect              <= 1'b1; //release LOCKDETECT
            synAlignFastcommand             <= 1'b0;
            synResetFastcommand             <= 1'b0;
            synResetGlobalReadout           <= 1'b0;
            synResetChargeInj               <= 1'b0;
            nextUnlockCount                 <= 12'd0;
            nextInvalidFCCount              <= 12'd0;
            nextState  <= disPowerSequence ? smDONE : 
                                (pllLocked ? smRESETFC0 : smLOCKDETECT);
            end   
        smRESETFC0:
            begin
            synPLLReset                     <= 1'b0;
            synStartCalibration             <= 1'b1; 
            synResetLockdetect              <= 1'b1;
            synAlignFastcommand             <= 1'b0;
            synResetFastcommand             <= 1'b1;
            synResetGlobalReadout           <= 1'b0;
            synResetChargeInj               <= 1'b0;
            nextUnlockCount                 <= pllLocked_fallingEdge ? pllUnlockCount + 1 : pllUnlockCount;
            nextInvalidFCCount              <= 12'd0;
            nextState  <= disPowerSequence ? smDONE : smRESETFC1;
            end 
        smRESETFC1:
            begin
            synPLLReset                     <= 1'b0;
            synStartCalibration             <= 1'b1; 
            synResetLockdetect              <= 1'b1;
            synAlignFastcommand             <= 1'b0;
            synResetFastcommand             <= 1'b1;
            synResetGlobalReadout           <= 1'b0;
            synResetChargeInj               <= 1'b1;
            nextUnlockCount                 <= pllLocked_fallingEdge ? pllUnlockCount + 1 : pllUnlockCount;
            nextInvalidFCCount              <= 12'd0;
            nextState  <= disPowerSequence ? smDONE : smINITFC;
            end 
        smINITFC:
            begin
            synPLLReset                     <= 1'b0;
            synStartCalibration             <= 1'b1; 
            synResetLockdetect              <= 1'b1;
            synAlignFastcommand             <= fcSelfAlign ? 1'b1 : 1'b0;
            synResetFastcommand             <= 1'b1;
            synResetGlobalReadout           <= 1'b0;
            synResetChargeInj               <= 1'b0;
            nextUnlockCount                 <= pllLocked_fallingEdge ? pllUnlockCount + 1 : pllUnlockCount;
            nextInvalidFCCount              <= 12'd0;
            nextState <= (disPowerSequence | ~fcSelfAlign) ? smDONE :    
                        (fastcommandAligned ? smDONE : smINITFC);
            end
        smDONE:
            begin
            synPLLReset                     <= ~asyPLLResetReg[1];
            synStartCalibration             <= asyStartCalibrationReg[1]; 
            synResetLockdetect              <= asyResetLockDetectReg[1];
            synAlignFastcommand             <= asyAlignFastcommandReg[1];
            synResetFastcommand             <= asyResetFastcommandReg[1];
            synResetGlobalReadout           <= asyResetGlobalReadoutReg[1];
            synResetChargeInj               <= asyResetChargeInjReg[1];
            nextUnlockCount                 <= pllLocked_fallingEdge ? pllUnlockCount + 1 : pllUnlockCount;
            nextInvalidFCCount              <= invalidFastcommandVoted ? invalidFCCount + 1 : invalidFCCount;
            nextState <= smDONE;
            end
        default:    //default in DONE state
            begin
            synPLLReset                     <= ~asyPLLResetReg[1];
            synStartCalibration             <= asyStartCalibrationReg[1]; 
            synResetLockdetect              <= asyResetLockDetectReg[1];
            synAlignFastcommand             <= asyAlignFastcommandReg[1];
            synResetFastcommand             <= asyResetFastcommandReg[1];
            synResetGlobalReadout           <= asyResetGlobalReadoutReg[1];
            synResetChargeInj               <= asyResetChargeInjReg[1];
            nextUnlockCount                 <= pllLocked_fallingEdge ? pllUnlockCount + 1 : pllUnlockCount;
            nextInvalidFCCount              <= invalidFastcommandVoted ? invalidFCCount + 1 : invalidFCCount;
            nextState <= smDONE;
            end
        endcase
    end

wire bootup                         = bootReg[2]; 
wire bootupVoted                    = bootup;
wire [11:0] nextUnlockCountVoted    = nextUnlockCount;
wire [11:0] nextInvalidFCCountVoted = nextInvalidFCCount;

always@(negedge clk40Ref) 
begin
    if(bootupVoted)
        begin
        state           <= smINIT0;
        pllUnlockCount  <= 12'd0;
        invalidFCCount  <= 12'd0;
        end
    else 
        begin
        state                           <= nextStateVoted;
//convert asynchronous signals to synchronous signals
        asyPLLResetReg                  <= {asyPLLResetReg[0],asyPLLReset};
        asyLinkResetReg                 <= {asyLinkResetReg[0],asyLinkReset};
        asyAlignFastcommandReg          <= {asyAlignFastcommandReg[0],asyAlignFastcommand};
        asyStartCalibrationReg          <= {asyStartCalibrationReg[0],asyStartCalibration};
        asyResetFastcommandReg          <= {asyResetFastcommandReg[0],asyResetFastcommand};
        asyResetLockDetectReg           <= {asyResetLockDetectReg[0],asyResetLockDetect};
        asyResetGlobalReadoutReg        <= {asyResetGlobalReadoutReg[0],asyResetGlobalReadout};
        asyResetChargeInjReg            <= {asyResetChargeInjReg[0],asyResetChargeInj};
//fastcommand decode
        // fcBCR                           <=      decodedFastcommand[2] | decodedFastcommand[7];
        // fcL1ARst                        <=      decodedFastcommand[4];
        // fcL1A                           <=      decodedFastcommand[6] | decodedFastcommand[7];
        // fcChargeInjCmd                  <=      decodedFastcommand[5];
        // fcWSStart                       <=      decodedFastcommand[8];
        // fcWSStop                        <=      decodedFastcommand[9];
        // synLinkReset                    <=      decodedFastcommand[1] | asyLinkResetReg[1];
//maintain a counter for slow control access
        pllUnlockCount                     <= nextUnlockCountVoted;
        invalidFCCount                  <= nextInvalidFCCountVoted;
        end
end

always@(posedge clk40Ref) 
begin
        fcBCR                           <=      decodedFastcommand[2] | decodedFastcommand[7];
        fcL1ARst                        <=      decodedFastcommand[4];
        fcL1A                           <=      decodedFastcommand[6] | decodedFastcommand[7];
        fcChargeInjCmd                  <=      decodedFastcommand[5];
        fcWSStart                       <=      decodedFastcommand[8];
        fcWSStop                        <=      decodedFastcommand[9];
        synLinkReset                    <=      decodedFastcommand[1] | asyLinkResetReg[1];
end

endmodule
