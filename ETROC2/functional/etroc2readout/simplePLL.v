`timescale 1ps/100fs

//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Thu Jan  6 18:03:16 CST 2022
// Module Name: simplePLL
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////

module phaseCounterSimplePLL
(
	input               clk40,            //40MHz
    input               clk1280,
    input               enable,
    output reg [4:0]    phaseCount      //
);
    reg clk40D1;                     //delay clk40
    reg clk40D2;                     //delay clk40
    wire risingClk40;
    assign risingClk40 = ~clk40D2 & clk40D1;
    wire [4:0] nextCount = phaseCount + 1;
    wire [4:0] nextCountVoted = nextCount;
    reg syncClk40;
    always @(negedge clk1280) 
    begin
        if(enable)
            syncClk40 <= clk40;
    end

    always @(posedge clk1280) 
    begin
        if(enable)
        begin
            clk40D1 <= syncClk40;
            clk40D2 <= clk40D1;
            if(risingClk40)
            begin
                phaseCount <= 5'd3;   //align phasECounter == 0 to rising edge of clk40
            end
            else 
            begin
                phaseCount <= nextCountVoted;           
            end
        end
    end
endmodule

module pulseGeneratorClk40
(
    input           clk1280,
    input           enable,
    input [4:0]     phaseCount,
    input [4:0]     clockDelay,     //phase from clk40 rising edge to rising edge
    input [4:0]     pulseWidth,     //phase from rising edge to falling
    output          clkout          //output clock
);
    reg clkoutReg;
    wire [4:0] risingAt;
    assign risingAt     =  clockDelay;

    wire [4:0] fallingAt;
    assign fallingAt    = (risingAt + pulseWidth)%32;

    always @(posedge clk1280) 
    begin
        if(enable)
        begin
            if(phaseCount == risingAt)
            begin
                clkoutReg <= 1'b1;
            end
            else if (phaseCount == fallingAt)
            begin
                clkoutReg <= 1'b0;                
            end
        end
    end
    assign clkout = clkoutReg;
endmodule

module simplePLL
(
	input           clk40Ref,               //40 MHz, reference clock
    input           asynReset,              //reset, high active !!!
    input           clk1280In,
    input [11:0]    calibrationTime,        //define calibration time
    input [11:0]    lockTime,
    output          pllCalibrationDone,     //
    input           startCalibration,    //
    output          clk1280,
    output          clk40,               //
    output          instantLock             //
);


wire [4:0] phaseCount;
phaseCounterSimplePLL phaseCounterSimplePLLInst
(
        .clk40(clk40Ref),
        .clk1280(clk1280In),
        .enable(1'b1),
        .phaseCount(phaseCount)
);

wire [4:0] clockDelay;
wire [4:0] pulseWidth;
wire clkout1;

pulseGeneratorClk40 pulseGeneratorClk40Inst
(
    .clk1280(clk1280In),
    .enable(1'b1),
    .phaseCount(phaseCount),
    .clockDelay(clockDelay),
    .pulseWidth(pulseWidth),
    .clkout(clkout1)
);

wire reset;
wire [15:0] prbs1;
PRBS31 #(.WORDWIDTH(16),.FORWARDSTEPS(1))PRBS31Inst1
(
    .clkTMR(clk40Ref),
    .resetTMR(reset),
    .disTMR(1'b0),
    .seedTMR(31'H12345678),
    .prbsTMR(prbs1)
);

wire [15:0] prbs2;
PRBS31 #(.WORDWIDTH(16),.FORWARDSTEPS(1))PRBS31Inst2
(
    .clkTMR(clk40Ref),
    .resetTMR(reset),
    .disTMR(1'b0),
    .seedTMR(31'H12347856),
    .prbsTMR(prbs2)
);

reg [1:0] asynReset_reg;
reg [1:0] startCalibration_reg;
wire asynReset_fallingEdge = asynReset_reg[1] & ~asynReset_reg[0];
assign reset = ~asynReset_fallingEdge;
wire startCalibration_risingEdge = ~startCalibration_reg[1]&startCalibration_reg[0];
always@(posedge clk40Ref)
begin
    asynReset_reg           <= {asynReset_reg[0],asynReset}; // high active
    startCalibration_reg    <= {startCalibration_reg[0],startCalibration};
end

reg [1:0] clk40RefReg;
wire clk40Ref_risingEdge = ~clk40RefReg[1]&clk40RefReg[0];
always@(posedge clk1280In)
begin
    clk40RefReg             <= {clk40RefReg[0],clk40Ref};
end

wire [31:0] prbs32 = {prbs2, prbs1};
reg [31:0] prbsShiftReg;
always@(posedge clk1280In)
begin
    if(clk40Ref_risingEdge)
    begin
        prbsShiftReg <= prbs32;
    end
    else 
    begin
        prbsShiftReg <= {prbsShiftReg[30:0],prbsShiftReg[31]};
    end
end

reg calibrated;
reg locked;
reg [11:0] timeCount;
reg calibrationSessionStart;
reg lockSessionStart;

assign clockDelay = locked ? 32'd0 : {16'd0,prbs1};
assign pulseWidth = locked ? 32'd16 : {16'd0,prbs2};

assign clk1280 = calibrated ? ~clk1280In : prbsShiftReg[31];
reg clkout;
always @(posedge clk1280)
begin
    clkout <= clkout1;
end
assign clk40    = clkout;
assign instantLock = ~(clkout ^ clk40Ref);

always@(posedge clk40Ref)
begin
    if(~reset)
    begin
        calibrated  <= 1'b0;
        locked      <= 1'b0;
        timeCount   <= 12'd0;
        calibrationSessionStart <= 1'b0;
        lockSessionStart        <= 1'b0;
    end
    else if(~calibrated)
    begin
        if(startCalibration_risingEdge)begin
            calibrationSessionStart <= 1'b1;
            timeCount <= 12'd0;
        end
        else if(calibrationSessionStart)begin
            if(timeCount < calibrationTime)begin
                timeCount <= timeCount + 1;
            end
            else
            begin
                calibrated <= 1'b1;
                calibrationSessionStart <= 1'b0;
                timeCount <= 12'd0;
                lockSessionStart <= 1'b1;
            end
        end
    end
    else begin
        if(~locked)
        begin
            if(lockSessionStart)
            begin
                if(timeCount < lockTime)
                begin
                    timeCount <= timeCount + 1;
                end
                else
                begin
                    lockSessionStart <= 1'b0;
                    locked <= 1'b1;
                end
            end
        end
    end
end

assign pllCalibrationDone = calibrated;

endmodule
