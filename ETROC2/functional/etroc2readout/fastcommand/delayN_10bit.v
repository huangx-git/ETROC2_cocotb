//`timescale 1ps/100fs
module delayN_10bit #( parameter InputDelay = 7)(
	input rstn,
	input clk1280,
	input [9:0] fc_para_In,
	output [9:0] fc_para_InDelay
);


delayN #(.N(InputDelay)) delayN_inst0 (
	.rstn(rstn),
    .DataIn(fc_para_In[9]),
    .clk(clk1280),
    .delayOut(fc_para_InDelay[9])
);

delayN #(.N(InputDelay)) delayN_inst1 (
	.rstn(rstn),
    .DataIn(fc_para_In[8]),
    .clk(clk1280),
    .delayOut(fc_para_InDelay[8])
);

delayN #(.N(InputDelay)) delayN_inst2 (
	.rstn(rstn),
    .DataIn(fc_para_In[7]),
    .clk(clk1280),
    .delayOut(fc_para_InDelay[7])
);

delayN #(.N(InputDelay)) delayN_inst3 (
	.rstn(rstn),
    .DataIn(fc_para_In[6]),
    .clk(clk1280),
    .delayOut(fc_para_InDelay[6])
);

delayN #(.N(InputDelay)) delayN_inst4 (
	.rstn(rstn),
    .DataIn(fc_para_In[5]),
    .clk(clk1280),
    .delayOut(fc_para_InDelay[5])
);

delayN #(.N(InputDelay)) delayN_inst5 (
	.rstn(rstn),
    .DataIn(fc_para_In[4]),
    .clk(clk1280),
    .delayOut(fc_para_InDelay[4])
);

delayN #(.N(InputDelay)) delayN_inst6 (
	.rstn(rstn),
    .DataIn(fc_para_In[3]),
    .clk(clk1280),
    .delayOut(fc_para_InDelay[3])
);

delayN #(.N(InputDelay)) delayN_inst7 (
	.rstn(rstn),
    .DataIn(fc_para_In[2]),
    .clk(clk1280),
    .delayOut(fc_para_InDelay[2])
);

delayN #(.N(InputDelay)) delayN_inst8 (
	.rstn(rstn),
    .DataIn(fc_para_In[1]),
    .clk(clk1280),
    .delayOut(fc_para_InDelay[1])
);

delayN #(.N(InputDelay)) delayN_inst9 (
	.rstn(rstn),
    .DataIn(fc_para_In[0]),
    .clk(clk1280),
    .delayOut(fc_para_InDelay[0])
);

endmodule
