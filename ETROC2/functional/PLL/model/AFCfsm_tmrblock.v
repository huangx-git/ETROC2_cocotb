//Verilog HDL for "MODELS_qsun", "AFCfsm_tmrblock" "functional"



//`timescale 10ps / 1ps
//`include "voter.v"
//`include "voter5bit.v"
//`include "voter4bit.v"

module AFCfsm_tmrblock (

	//inputs
	input reset,
	input AFCstart, 
	
	input ckrefDone,
	input ckfbDone, 

	input ckref,

	// FSM outputs
	output reg [5:0] control ,
	output reg ctrEnable,
	output reg ctrReset,
	output reg [3:0] FSMstate,
	output AFCbusy,

	//_next outputs for reduncancy of other FSM
	output reg [3:0] FSMstate_nextA,
	output reg ctrEnable_nextA,
	output reg ctrReset_nextA,
	output reg [5:0] bitState_nextA ,
	output reg [5:0] control_nextA,

	//redundancy inputs
	input  [3:0] FSMstate_nextB,
	input  ctrEnable_nextB,
	input  ctrReset_nextB,
	input  [5:0] bitState_nextB ,
	input  [5:0] control_nextB, 

	input  [3:0] FSMstate_nextC,
	input  ctrEnable_nextC,
	input  ctrReset_nextC,
	input  [5:0] bitState_nextC ,
	input  [5:0] control_nextC ,
	inout VDD,
	inout VSS
);


	//internal states
		
	 
	reg[5:0] bitState;

	reg ckrefDone_buf, ckfbDone_buf, ckrefDone_buf_nextA, ckfbDone_buf_nextA;


	
	
	//Voted _next states

	wire [3:0] FSMstate_next;
	wire ctrReset_next;
	wire ctrEnable_next;
	wire [5:0] bitState_next;
	wire [5:0] control_next;


	localparam IDLE = 4'h0;
	localparam RESETFSM = 4'h1;
	localparam RESETCOUNTERS = 4'h2;
	localparam ENABLECOUNTERS = 4'h3;
	localparam WAITFORCOUNTERS = 4'h4;
	localparam DISABLECOUNTERS = 4'h5;
	localparam DISABLECOUNTERS_STAB = 4'h6;
	localparam UPDATECONTROLVAL = 4'h7;
	localparam SHIFTBITSTATE = 4'h8;
	localparam SETBITSTATE = 4'h9;
	localparam CLEARBITSTATE = 4'hA;
	localparam FINISH = 4'hB;
		


	




	always @(FSMstate,ckrefDone,ckfbDone,AFCstart) begin
	   
	
		
			case (FSMstate)

			IDLE: 
				begin
					ctrEnable_nextA<=1'b0;
					bitState_nextA<=bitState;
					control_nextA<=control;
					ctrReset_nextA<=1'b0;
					ckrefDone_buf_nextA<= 1'b0;
					ckfbDone_buf_nextA<= 1'b0;

					if(AFCstart) begin
						FSMstate_nextA<=RESETFSM;			
					end else begin
						FSMstate_nextA<=IDLE;

					end
				end

			RESETFSM:
				begin
					ctrEnable_nextA<=1'b0;
					bitState_nextA<=6'b100000;
					control_nextA<=6'b100000;
					ctrReset_nextA<=1'b0;
					FSMstate_nextA<=RESETCOUNTERS;
					ckrefDone_buf_nextA<= 1'b0;
					ckfbDone_buf_nextA<= 1'b0;
				end

			RESETCOUNTERS:
				begin
					FSMstate_nextA<=ENABLECOUNTERS;
					ctrReset_nextA<=1'b1;
					ctrEnable_nextA<=1'b0;
					bitState_nextA<=bitState;
					control_nextA<=control;
					ckrefDone_buf_nextA<= 1'b0;
					ckfbDone_buf_nextA<= 1'b0;
				end

			ENABLECOUNTERS:
				begin
					FSMstate_nextA<=WAITFORCOUNTERS;
					ctrReset_nextA<=1'b0;
					ctrEnable_nextA<=1'b1;
					bitState_nextA<=bitState;
					control_nextA<=control;
					ckrefDone_buf_nextA<= 1'b0;
					ckfbDone_buf_nextA<= 1'b0;

				end

			WAITFORCOUNTERS:
				begin
					ctrReset_nextA<=1'b0;
					bitState_nextA<=bitState;
					control_nextA<=control;
					ctrEnable_nextA<=1'b1;
					ckrefDone_buf_nextA<= ckrefDone;
					ckfbDone_buf_nextA<= ckfbDone;
					if (ckrefDone || ckfbDone) begin
						FSMstate_nextA<=DISABLECOUNTERS;
						
					end else begin
						FSMstate_nextA<=WAITFORCOUNTERS;
			
					end
						
				end

			DISABLECOUNTERS:		
				begin
					FSMstate_nextA<=DISABLECOUNTERS_STAB;
					ctrReset_nextA<=1'b0;
					ctrEnable_nextA<=1'b0;	
					bitState_nextA<=bitState;
					control_nextA<=control;
					ckrefDone_buf_nextA<= ckrefDone_buf;
					ckfbDone_buf_nextA<= ckfbDone_buf;

				end	
			DISABLECOUNTERS_STAB:	
				begin
					FSMstate_nextA<=UPDATECONTROLVAL;
					ctrReset_nextA<=1'b0;
					ctrEnable_nextA<=1'b0;
					bitState_nextA<=bitState;
					control_nextA<=control;
					ckrefDone_buf_nextA<= ckrefDone_buf;
					ckfbDone_buf_nextA<= ckfbDone_buf;
				end

			UPDATECONTROLVAL:
				begin
					ctrReset_nextA<=1'b0;
					ctrEnable_nextA<=1'b0;
					bitState_nextA<=bitState;
					control_nextA<=control;
					ckrefDone_buf_nextA<= ckrefDone_buf;
					ckfbDone_buf_nextA<= ckfbDone_buf;
					if(ckfbDone_buf) begin
						FSMstate_nextA<=SHIFTBITSTATE;		
					end else begin
						FSMstate_nextA<=CLEARBITSTATE;
					end

				end

			SHIFTBITSTATE:
				begin
					ctrReset_nextA<=1'b0;
					ctrEnable_nextA<=1'b0;
					bitState_nextA<=bitState>>1;
					control_nextA<=control;
					ckrefDone_buf_nextA<= ckrefDone_buf;
					ckfbDone_buf_nextA<= ckfbDone_buf;

					if(bitState[0] == 1'b1) begin //end of sequence
						FSMstate_nextA<=FINISH;
					end else begin		//set the next bit
						FSMstate_nextA<=SETBITSTATE;
					end
					
				end

			SETBITSTATE:
				begin
					ctrReset_nextA<=1'b0;
					ctrEnable_nextA<=1'b0;
					bitState_nextA<=bitState;
					control_nextA<=control | bitState;		
					FSMstate_nextA<=RESETCOUNTERS;
					ckrefDone_buf_nextA<= ckrefDone_buf;
					ckfbDone_buf_nextA<= ckfbDone_buf;
				end
			CLEARBITSTATE:
				begin
					ctrReset_nextA<=1'b0;
					ctrEnable_nextA<=1'b0;
					FSMstate_nextA<=SHIFTBITSTATE;
					bitState_nextA<=bitState;	
					control_nextA<=control & (~bitState);
					ckrefDone_buf_nextA<= ckrefDone_buf;
					ckfbDone_buf_nextA<= ckfbDone_buf;
					
				end
			FINISH:
				begin
					ctrEnable_nextA<=1'b0;
					bitState_nextA<=bitState;
					control_nextA<=control;
					ctrReset_nextA<=1'b0;
					ckrefDone_buf_nextA<=1'b0;
					ckfbDone_buf_nextA<=1'b0;
					if(AFCstart)
						FSMstate_nextA<=FINISH;//wait until idle goes to zero
					else
						FSMstate_nextA<=IDLE;

				end
		
		
			
			
			default: 
				begin
					ctrEnable_nextA<=1'b0;
					bitState_nextA<=bitState;
					control_nextA<=control;
					ctrReset_nextA<=1'b0;
					FSMstate_nextA<=IDLE;
					ckrefDone_buf_nextA<=1'b0;
					ckfbDone_buf_nextA<=1'b0;
				end

			endcase
		

	end


	always @(posedge ckref) begin
		if(reset) begin
				FSMstate<=IDLE;
				ctrReset<=1'b0;
				ctrEnable<=1'b0;
				control<=6'b100000;
				bitState<=6'b100000;
				ckrefDone_buf<=1'b0;
				ckfbDone_buf<=1'b0;
			end
		else
			begin
				FSMstate<=FSMstate_next; //these _next are voted using _nextA _nextB _nextC
				ctrReset<=ctrReset_next;
				ctrEnable<=ctrEnable_next;
				bitState<=bitState_next;
				control<=control_next;
				ckrefDone_buf<=ckrefDone_buf_nextA;
				ckfbDone_buf<=ckfbDone_buf_nextA;
			end
	end


	//1 bit voters
	voter V_ctrReset_next (ctrReset_nextA,ctrReset_nextB,ctrReset_nextC,ctrReset_next);
	voter V_ctrEnable_next (ctrEnable_nextA,ctrEnable_nextB,ctrEnable_nextC,ctrEnable_next);

	//6 bit voters
	voter6bit V_bitstate_next (bitState_nextA,bitState_nextB,bitState_nextC,bitState_next);
	voter6bit V_control_next (control_nextA,control_nextB,control_nextC,control_next);

	//4 bit voters
	voter4bit V_FSMstate_next (FSMstate_nextA,FSMstate_nextB,FSMstate_nextC,FSMstate_next);


	assign AFCbusy = (FSMstate==IDLE || FSMstate==FINISH) ? 1'b0 : 1'b1 ;
	



endmodule
