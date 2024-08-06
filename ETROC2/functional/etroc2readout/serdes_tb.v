`timescale 1ns / 1fs
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Fri Feb 12 12:42:10 CST 202
// Module Name: serdes
// Project Name: ETROC2 readout
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module serdes_tb;

    reg clk; //40M
    reg reset;
    reg dis;
    reg clk1280; //1280 M
    reg clk320;
    reg clk640;
    reg [6:0] seed;
    reg [1:0] rate;

    wire[7:0] prbs8;
    PRBS7 #(.WORDWIDTH(8)) prbs1
    (
        .clk(clk),
        .reset(reset),
        .dis(dis),
        .seed(seed),
        .prbs(prbs8)
    );

    wire errorFlag0;
    PRBS7Check #(.WORDWIDTH(8)) pbchk0
    (
        .clk(clk),
        .din(prbs8),
        .error(errorFlag0)
    );

    wire rdClk;         //not used here.
    wire s320;

//test ser320
    serializer ser8
    (
        .clk1280(clk1280),
        .rate(2'b00),  //8bit
        .clk40syn(clk),
        .din({24'H000000,prbs8}),
        .rdClk(rdClk),
        .sout(s320)
    );

    reg [5:0] delay;
    wire wordCK;
    wire [39:0] word40b;
    deserializer #(.WORDWIDTH(40),.WIDTH(6))dser40
    (
        .bitCK(clk320),
        .reset(reset),
        .delay(delay),
        .sin(s320),
        .wordCK(wordCK),
        .dout(word40b)
    );

    wire errorFlag;
    PRBS7Check #(.WORDWIDTH(40)) pbchk8
    (
        .clk(wordCK),
        .din(word40b),
        .error(errorFlag)
    );

//test ser640

    wire[15:0] prbs16;
    PRBS7 #(.WORDWIDTH(16)) prbs2
    (
        .clk(clk),
        .reset(reset),
        .dis(dis),
        .seed(seed),
        .prbs(prbs16)
    );

    wire rdClk2;
    wire s640;
    serializer ser_16
    (
        .clk1280(clk1280),
        .rate(2'b01),  //16bit
        .clk40syn(clk),
        .din({16'H0000,prbs16}),
        .rdClk(rdClk2),
        .sout(s640)
    );

    wire wordCK2;
    wire [39:0] word40b2;
    deserializer #(.WORDWIDTH(40),.WIDTH(6))dser40_2
    (
        .bitCK(clk640),
        .reset(reset),
        .delay(delay),
        .sin(s640),
        .wordCK(wordCK2),
        .dout(word40b2)
    );

   wire errorFlag2;
    PRBS7Check #(.WORDWIDTH(40)) pbchk16
    (
        .clk(wordCK2),
        .din(word40b2),
        .error(errorFlag2)
    );

//test ser1280

    wire[31:0] prbs32;
    PRBS7 #(.WORDWIDTH(32)) prbs3
    (
        .clk(clk),
        .reset(reset),
        .dis(dis),
        .seed(seed),
        .prbs(prbs32)
    );

    wire rdClk3;
    wire s1280;
    serializer ser_32
    (
        .clk1280(clk1280),
        .rate(2'b10),  //32bit
        .clk40syn(clk),
        .din(prbs32),
        .rdClk(rdClk3),
        .sout(s1280)
    );

    wire wordCK3;
    wire [39:0] word40b3;
    deserializer #(.WORDWIDTH(40),.WIDTH(6))dser40_3
    (
        .bitCK(clk1280),
        .reset(reset),
        .delay(delay),
        .sin(s1280),
        .wordCK(wordCK3),
        .dout(word40b3)
    );

   wire errorFlag3;
    PRBS7Check #(.WORDWIDTH(40)) pbchk32
    (
        .clk(wordCK3),
        .din(word40b3),
        .error(errorFlag3)
    );

    initial begin
        clk = 0;
        clk1280 = 0;
        clk640 = 0;
        clk320 = 0 ;
        reset = 0;
        rate = 2'b00;
        seed = 7'b1111111;
        dis = 1'b0;
        delay = 6'h02;
        #25 reset = 1'b1;
        #50 reset = 1'b0;
        #2500000
        $stop;
    end

    always 
        #12.5 clk = !clk; //25 ns clock period
    
    always
        #0.390625 clk1280 = !clk1280;

    always
        #1.5625 clk320 = !clk320;

    always
        #0.78125 clk640 = !clk640;


endmodule
