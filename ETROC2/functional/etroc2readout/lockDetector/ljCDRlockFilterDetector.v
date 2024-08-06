/* ******************************************************************************
 *  GBTX Project, Copyright (C) CERN                                           *
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
 *                                                                             *
 *  History:                                                                   *
 *  2016/07/25	Pedro Leitao    : Created                                      *
 *                                                                             *
 **************************************************************************** */
`timescale 1ps/1ps

module ljCDRlockFilterDetector(
	// Inputs:
    input wire		 smClock,		
    input wire 		 reset,

	input wire 		 selectFD_PFD,
	input wire 	  	 PFDInstLock,
	input wire  	 FDInstLock,
	
	input wire [3:0] lfLockThrCounter,
	input wire [3:0] lfReLockThrCounter,
	input wire [3:0] lfUnLockThrCounter,
	
	// Outputs:
	output wire	[1:0] state,
	output reg		  instantLock,
    output wire 	  locked,
    output wire [7:0] lossOfLockCount
);
// tmrg default triplicate
 
/*
// synopsys dc_script_begin
// synopsys dc_script_end
*/

// -------------------------------------------------------------------------------------------------------------- //
//  input balanced MUX ABC                                                                                        //
// -------------------------------------------------------------------------------------------------------------- //

wire instantLock_sync0;
assign #10 instantLock_sync0 	= selectFD_PFD ? PFDInstLock : FDInstLock;

// instant 3-stage sync for the clock crossing
reg instantLock_sync1, instantLock_sync2;
always @(posedge smClock) begin
	instantLock_sync1 	<= #10 instantLock_sync0;
	instantLock_sync2 	<= #10 instantLock_sync1;
	instantLock 		<= #10 instantLock_sync2;
end

// -------------------------------------------------------------------------------------------------------------- //
//  Lock Filter instantiation                                                                                     //
// -------------------------------------------------------------------------------------------------------------- //


ljCDRLockFilter ljCDRLockFilter_inst(
    .clock(smClock),
    .reset(reset),
    .instantLock(instantLock),
	.lfLockThrCounter(lfLockThrCounter),
	.lfReLockThrCounter(lfReLockThrCounter),
	.lfUnLockThrCounter(lfUnLockThrCounter),
	
    // Outputs:
    .state(state),
    .locked(locked),
    .lossOfLockCount(lossOfLockCount)
);
endmodule

// -------------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------------- //


 // Orignal by Paulo Moreira, adapted by Pedro Leitao for tmrg
module ljCDRLockFilter (
    // Inputs:
    input wire clock,
    input wire reset,
    input wire instantLock,
	input wire [3:0] lfLockThrCounter,
	input wire [3:0] lfReLockThrCounter,
	input wire [3:0] lfUnLockThrCounter,
	
    // Outputs:
    output reg [1:0] state,
    output reg locked,
    output reg [7:0] lossOfLockCount	// this should be voted out?
    );
 // tmrg default triplicate
   
// ------------------------------------------------------------------------------- //
// ------------------------------------------------------------------------------- //
    //////////// LockFilterLogic
    
localparam 	lfUnlfLockedState 		= 2'b00;
localparam 	lfConfirmLockState		= 2'b01;
localparam 	lfLockedState 			= 2'b10;
localparam 	lfConfirmUnlockState	= 2'b11;

/*    
    localparam 
    	LOCKEDTHRESHOLD 		= 10'd800,
    	RELOCKTHRESHOLD			= 10'h01F,
    	UNLOCKEDTHRESHOLD   	=  5'h1F;
*/
    
wire [15:0] lfLockThrCounterReg;
wire [15:0] lfReLockThrCounterReg;
wire [15:0] lfUnLockThrCounterReg;

assign lfLockThrCounterReg 		= 16'h0001 << lfLockThrCounter;
assign lfReLockThrCounterReg 	= 16'h0001 << lfReLockThrCounter;
assign lfUnLockThrCounterReg 	= 16'h0001 << lfUnLockThrCounter;

// ------------------------------------------------------------------------------- //
// Flow control:                                                                   //
// ------------------------------------------------------------------------------- //

//reg [ 1:0] state;
reg [15:0] unLockedCount;
reg [15:0] lockedCount;
/////////////////////////////////////////////////////////////////////////////////////
reg [ 1:0] 	nextState;
reg  		nextLocked;
reg [15:0] 	nextUnLockedCount;
reg [15:0]	nextLockedCount;
reg [ 7:0]	nextLossOfLockCount;
/////////////////////////////////////////////////////////////////////////////////////
wire [ 1:0] stateVoted 				= state;
wire 		instantLockVoted 		= instantLock;

wire [15:0] lockedCountVoted 		= lockedCount;
wire [15:0] unLockedCountVoted 		= unLockedCount;
wire [7:0] 	lossOfLockCountVoted 	= lossOfLockCount;
wire 		resetVoted = reset;


wire [15:0] lfLockThrCounterRegVoted	= lfLockThrCounterReg;
wire [15:0] lfReLockThrCounterRegVoted	= lfReLockThrCounterReg;
wire [15:0] lfUnLockThrCounterRegVoted	= lfUnLockThrCounterReg;

always @*
    begin
        case(stateVoted)
        //------------------------------------------------------------------------ //
        lfUnlfLockedState : 
		    begin
            if (instantLockVoted)
                begin
                nextState 				<= #10 lfConfirmLockState;
                nextLocked 				<= #10 1'b0;
                nextUnLockedCount 		<= #10 16'h0000;
                nextLockedCount 		<= #10 lockedCountVoted + 16'h0001;
				nextLossOfLockCount 	<= #10 lossOfLockCountVoted;
                end
            else
                begin
                nextState 				<= #10 lfUnlfLockedState;
                nextLocked 				<= #10 1'b0;
                nextUnLockedCount 		<= #10 16'h0000;
                nextLockedCount 		<= #10 16'h0000;
				nextLossOfLockCount 	<= #10 lossOfLockCountVoted;
                end
            end
        //------------------------------------------------------------------------ //
        lfConfirmLockState : 
		    begin
            if (lockedCountVoted == lfLockThrCounterRegVoted)		
                begin
                nextState 			<= #10 lfLockedState;
                nextLocked 			<= #10 1'b1;
                nextUnLockedCount 		<= #10 16'h0000;
                nextLockedCount 		<= #10 16'h0000;
				nextLossOfLockCount <= #10 lossOfLockCountVoted;
                end
            else
                begin
                if(instantLockVoted)
                    begin
                    nextState 				<= #10 lfConfirmLockState;
                    nextLocked 				<= #10 1'b0;
                    nextUnLockedCount 		<= #10 16'h0000;
                    nextLockedCount 		<= #10 lockedCountVoted + 16'h0001;
		    		nextLossOfLockCount 	<= #10 lossOfLockCountVoted;
                    end
                else
                    begin
                    nextState 				<= #10 lfUnlfLockedState;
                    nextLocked 				<= #10 1'b0;
                    nextUnLockedCount 		<= #10 16'h0000;
                    nextLockedCount 		<= #10 16'h0000;
		    		nextLossOfLockCount 	<= #10 lossOfLockCountVoted;
                    end
                end

            end
        //------------------------------------------------------------------------ //
        lfLockedState : 
		    begin
            if (instantLockVoted == 1'b1)
                begin
                nextState <= #10 lfLockedState;
                nextLocked <= #10 1'b1;
                nextUnLockedCount <= #10 16'h0000;
                nextLockedCount <= #10  16'h0000;
				nextLossOfLockCount <= #10 lossOfLockCountVoted;
                end
            else
                begin
                nextState <= #10 lfConfirmUnlockState;
                nextLocked <= #10 1'b1;
                nextUnLockedCount <= #10 16'h0001;
                nextLockedCount <= #10 16'h0000;
				nextLossOfLockCount <= #10 lossOfLockCountVoted;
                end
            end
        //------------------------------------------------------------------------ //
        lfConfirmUnlockState : 
		    begin
            if (lockedCountVoted ==  lfReLockThrCounterRegVoted)
                begin
                nextState <= #10 lfLockedState;
                nextLocked <= #10 1'b1;
                nextUnLockedCount <= #10 16'h0000;
                nextLockedCount <= #10 16'h0000;
				nextLossOfLockCount <= #10 lossOfLockCountVoted;
                end
            else
                begin
                if (unLockedCountVoted == lfUnLockThrCounterRegVoted)
                    begin
                    nextState <= #10 lfUnlfLockedState;
                    nextLocked <= #10 1'b0;
                    nextUnLockedCount <= #10  16'h0000;
                    nextLockedCount <= #10  16'h0000;
		    		nextLossOfLockCount <= #10 lossOfLockCountVoted + 8'h01;
                    end
                else
                    begin
                    if (instantLockVoted == 1'b1)
                        begin
                        nextState <= #10 lfConfirmUnlockState;
                        nextLocked <= #10 1'b1;
                        nextUnLockedCount <= #10 unLockedCountVoted;
                        nextLockedCount <= #10 lockedCountVoted + 16'h0001;
						nextLossOfLockCount <= #10 lossOfLockCountVoted;
                        end
                    else
                        begin
                        nextState <= #10 lfConfirmUnlockState;
                        nextLocked <= #10 1'b1;
                        nextUnLockedCount <= #10 unLockedCountVoted + 16'h0001;
                        nextLockedCount  <= #10 16'h0000;
						nextLossOfLockCount <= #10 lossOfLockCountVoted;
                        end
                    end
                end
            
            end
        endcase
    end
    
// ------------------------------------------------------------------------------- //
// ------------------------------------------------------------------------------- //
// ------------------------------------------------------------------------------- //
// Registers:                                                                      //
// ------------------------------------------------------------------------------- //

// 2nd stage voting
wire [ 1:0]	nextStateVoted 				= nextState;
wire  		nextLockedVoted 			= nextLocked;
wire [15:0]	nextUnLockedCountVoted 		= nextUnLockedCount;
wire [15:0]	nextLockedCountVoted 		= nextLockedCount;
wire [ 7:0]	nextLossOfLockCountVoted	= nextLossOfLockCount;


always @(posedge clock or posedge resetVoted)
    begin
    if(resetVoted == 1'b1) begin
	    locked 			<= #10 1'b0;
	    state 			<= #10 lfUnlfLockedState;
	    unLockedCount 	<= #10 16'h0000;
	    lockedCount 	<= #10 16'h0000;
	    lossOfLockCount <= #10 nextLossOfLockCountVoted;
    
    end else begin
	    locked 			<= #10 nextLockedVoted;
	    state 			<= #10 nextStateVoted;
	    unLockedCount 	<= #10 nextUnLockedCountVoted;
	    lockedCount 	<= #10 nextLockedCountVoted;
	    lossOfLockCount <= #10 nextLossOfLockCountVoted;
    end
end

  // synopsys translate_off
  initial 
    begin
      nextLossOfLockCount=$random;
    end
  // synopsys translate_on


// ------------------------------------------------------------------------------- //
// ------------------------------------------------------------------------------- //

    
    
    
endmodule   

