`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Thu Feb 11 12:58:07 CST 2021
// Module Name: serializer
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// LSB first serializer


//////////////////////////////////////////////////////////////////////////////////

module serializerClockGen(
    input           dis,
    input           clk1280,            //1280 MHz
    input           clk40syn,           //40M clock for sync, pll clock
	output          clk40Out,           //
	output          clk320Out,           //
	output          clk640Out,           //
	output          clk1280Out,           //
    output          load40,
    output          load640,
    output          load1280            //load sginal
);
// tmrg default triplicate

    localparam rdClkPhase = 5'b10000;

    // wire load40; //load signal for first stage serializers
    // wire load640; //load signal for second serializers
    // wire load1280; //load signal for last stage serializer
    wire reset;         //periodic reset
    reg [4:0] counter;
    reg clk40syncLater;
    reg clk40syncLater1D;
    assign reset = ~(~clk40syncLater & clk40syncLater1D);  //low active 
    wire [4:0] nextCounter = counter + 1;
    wire [4:0] nextCounterVoted = nextCounter;
    always @(posedge clk1280) 
    begin
        if(~dis)
        begin
            clk40syncLater <= clk40syn;
            clk40syncLater1D <= clk40syncLater;
        end
        else
        begin //reset is true when dis is true
            clk40syncLater      <= 1'b0;
            clk40syncLater1D    <= 1'b1;              
        end
    end

    always @(posedge clk1280) 
    begin
        if(~reset)
        begin
            counter <= rdClkPhase;
        end
        else
        begin
            counter <= nextCounterVoted;
        end
    end

    assign clk1280Out = clk1280;
    assign clk640Out = counter[0];
    assign clk320Out = counter[1];
    assign clk40Out  = counter[4];
    assign load40   = ~counter[4] & ~counter[3] & ~counter[2]; 
    assign load640  = ~clk320Out;
    assign load1280 = ~clk640Out; 

endmodule 


module serializer(
    input           link_reset_ref,   //synch to reference clock
    input           dis,
    input           link_reset_testPatternSel,     //0: PRBS7, 1: fixed pattern specified by user
    input [31:0]    link_reset_fixedTestPattern,   //user specified test pattern
    input           clk1280,            //1280 MHz
    input           clk40syn,           //40M clock for sync, pll clock
    input [1:0]     rate,               //00: 320 Mbps, 01: 640Mbps, 10/11: 1280 Mbps
	input [31:0]    din,                //input data
	output          sout                //output serial data
);
// tmrg default triplicate
// tmrg do_not_triplicate sout

    localparam rdClkPhase = 5'b10000;

    reg [31:0] dinReg;
    always @(negedge clk40syn) 
    begin
        if(~dis)
        begin
            dinReg <= din;
        end
        else
        begin
            dinReg <= 32'd0;
        end
    end

    wire testPatternSel = link_reset_testPatternSel;
    wire [31:0] fixedTestPattern = link_reset_fixedTestPattern;

    wire clk40Out;
    wire clk320Out;
    wire clk640Out;
    wire clk1280Out;
    wire load40; //load signal for first stage serializers
    wire load640; //load signal for second serializers
    wire load1280; //load signal for last stage serializer

serializerClockGen clkgen(
    .dis(dis),
    .clk1280(clk1280),            //1280 MHz
    .clk40syn(clk40syn),           //40M clock for sync, pll clock
	.clk40Out(clk40Out),           // output clock for serializing operation
	.clk320Out(clk320Out),           //
	.clk640Out(clk640Out),           //
	.clk1280Out(clk1280Out),           //
    .load40(load40),        //load signals
    .load640(load640),
    .load1280(load1280)            
);

    // reg [1:0] slow_ctrl_link_reset_delay;
    reg link_reset;
    always @(posedge clk40Out) 
    begin
        // if(~dis)
        // begin
            // slow_ctrl_link_reset_delay <= {slow_ctrl_link_reset_delay[0],link_reset_slowControl};        
            // link_reset <= slow_ctrl_link_reset_delay[1] | link_reset_fastCommand;
            link_reset <= link_reset_ref;  //switch polarity
        // end
    end

//    assign rdClk = clk40;       //read clock 

    wire [3:0] enSer320;
    wire [1:0] enSer640;
    wire enSer1280;
    assign enSer320     = (rate == 2'b00) ? 4'h1  : ((rate == 2'b01) ? 4'h3  : 4'hF);
    assign enSer640     = (rate == 2'b00) ? 2'b00 : ((rate == 2'b01) ? 2'b01 : 2'b11);
//    assign enSer1280    = (rate == 1'b0)  ? 1'b0  : ((rate == 1'b01) ? 1'b0  : 1'b1);
    assign enSer1280    = rate[1];

    wire disPRBS8;
    wire disPRBS16;
    wire disPRBS32;
    assign disPRBS8     = ~link_reset | testPatternSel | (rate != 2'b00);
    assign disPRBS16    = ~link_reset | testPatternSel | (rate != 2'b01);
    assign disPRBS32    = ~link_reset | testPatternSel | (rate[1] != 1'b1);

    wire [7:0] PRBSData8;
    wire [15:0] PRBSData16;
    wire [31:0] PRBSData32;

    wire resetPRBS;
    reg link_reset1D;
    always @(posedge clk40Out) 
    begin
        link_reset1D <= link_reset;        
    end
    // assign resetPRBS = ~(link_reset & ~link_reset1D); //reset PRBS for the first link_reset
    assign resetPRBS = link_reset & ~link_reset1D; //reset PRBS for the first link_reset

    PRBS7 #(.WORDWIDTH(8)) prbs7_8 (
        .clk(clk40Out),
        .reset(resetPRBS),
        .dis(disPRBS8),
        .seed(7'H3F),
        .prbs(PRBSData8)
    );

    PRBS7 #(.WORDWIDTH(16)) prbs7_16 (
        .clk(clk40Out),
        .reset(resetPRBS),
        .dis(disPRBS16),
        .seed(7'H3F),
        .prbs(PRBSData16)
    );

    PRBS7 #(.WORDWIDTH(32)) prbs7_32 (
        .clk(clk40Out),
        .reset(resetPRBS),
        .dis(disPRBS32),
        .seed(7'H3F),
        .prbs(PRBSData32)
    );

    wire [31:0] PRBSDataCombine;
    assign PRBSDataCombine = (rate == 2'b00) ? {24'd0,PRBSData8} : 
                            ((rate == 2'b01) ? {16'd0,PRBSData16} : PRBSData32);
    wire [31:0] testPattern;
    assign testPattern = testPatternSel ? fixedTestPattern : PRBSDataCombine;
    wire [31:0] source = link_reset ? testPattern : dinReg;
    wire [3:0] s320;
    wire [1:0] s640;
    wire s1280;
    wire data40[31:0];
    genvar n;
    generate
        for(n = 0 ; n < 8; n = n+1)
        begin
            assign data40 [n]      = (rate == 2'b00) ? source[n]    : (rate == 2'b01 ? source[n*2]      : source[n*4]);
            assign data40 [n+8]    = (rate == 2'b00) ? 1'b0         : (rate == 2'b01 ? source[n*2+1]    : source[n*4+2]);
            assign data40 [n+16]   = (rate == 2'b00) ? 1'b0         : (rate == 2'b01 ? 1'b0             : source[n*4+1]);
            assign data40 [n+24]   = (rate == 2'b00) ? 1'b0         : (rate == 2'b01 ? 1'b0             : source[n*4+3]);
        end
    endgenerate

    genvar i;
    wire [7:0] data8In [3:0];
    generate
        for(i = 0 ; i < 4; i = i+1)
        begin:loop_s1
            assign data8In[i] = {data40[7+8*i],data40[6+8*i],data40[5+8*i],data40[4+8*i],
                      data40[3+8*i],data40[2+8*i],data40[1+8*i],data40[8*i]};
            serializerBlock #(.WORDWIDTH(8))s320Inst (
                .enable(enSer320[i]),
                .load(load40),
                .bitCK(clk320Out),
                .din(data8In[i]),
                .sout(s320[i])
            );
        end      
    endgenerate

    genvar j;
    wire [1:0] data2In [1:0];
    generate
        for(j = 0 ; j < 2; j = j+1)
        begin:loop_s2
        assign data2In[j] = {s320[2*j+1],s320[2*j]};
        serializerBlock #(.WORDWIDTH(2))s640Inst(
            .enable(enSer640[j]),
            .load(load640),
            .bitCK(clk640Out),
            .din(data2In[j]),
            .sout(s640[j])
        );
        end
    endgenerate

  //  wire inv_clk;
  //  assign inv_clk = !clk;
 //   wire usedClk;
  //  assign usedClk = clkPolarity ? inv_clk:clk;
    serializerBlock #(.WORDWIDTH(2))s128Inst(
        .enable(enSer1280),
        .load(load1280),
        .bitCK(clk1280Out),
        .din(s640),
        .sout(s1280)
    );

    wire soutMUX = dis? 1'b0 : ((rate[1] == 1'b1) ? s1280 : (rate == 2'b01 ? s640[0] : s320[0]));
    assign sout = soutMUX;

endmodule