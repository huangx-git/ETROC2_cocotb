`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Southern Methodist University
// Author: Datao Gong 
// 
// Create Date: Tue Nov 16 15:49:54 CST 2021
// Module Name: chargeInjectionPulseGen_tb
// Project Name: ETROC2 readout
// Description: 
// Dependencies: No
// 
// Revision:
// Revision 0.01 - File Created

// 
//////////////////////////////////////////////////////////////////////////////////
module chargeInjectionPulseGen_tb;

	reg clk40;
    reg clk1280;
    reg reset;
    reg [4:0] pulseDelay;
    reg chargeInjectionCmd;

    wire pulse;
    chargeInjectionPulseGen dg
    (
        .clk40(clk40),
        .clk1280(clk1280),
        .reset(reset),
        .delay(pulseDelay),
        .chargeInjectionCmd(chargeInjectionCmd),
        .pulse(pulse)
    );

    // wire pulseRef;
    // wire delt = pulseRef ^ pulse;
    // chargeInjectionPulseGenRef dgRef
    // (
    //     .clk40(clk40),
    //     .clk1280(clk1280),
    //     .reset(reset),
    //     .delay(pulseDelay),
    //     .chargeInjectionCmd(chargeInjectionCmd),
    //     .pulse(pulseRef)
    // );

    reg [2:0] count;
    always @(posedge clk40)
    begin
        if(~reset)
        begin
            count <= 3'd0;
        end
        else
        begin
            count <= count + 1;
        end
        if (count == 3'd1) chargeInjectionCmd <= 1'b1;
        else chargeInjectionCmd <= 1'b0;
    end


    initial begin
        clk40 = 0;
        clk1280 = 1;
        reset = 1;
        #25 reset = 0;
        #25 reset = 1;
        #500 pulseDelay = 5'd0;
        #500 pulseDelay = 5'd1;
        #500 pulseDelay = 5'd2;
        #500 pulseDelay = 5'd3;
        #500 pulseDelay = 5'd3;
        #500 pulseDelay = 5'd4;
        #500 pulseDelay = 5'd5;
        #500 pulseDelay = 5'd6;
        #500 pulseDelay = 5'd7;
        #500 pulseDelay = 5'd8;
        #500 pulseDelay = 5'd9;
        #500 pulseDelay = 5'd10;
        #500 pulseDelay = 5'd11;
        #500 pulseDelay = 5'd12;
        #500 pulseDelay = 5'd13;
        #500 pulseDelay = 5'd14;
        #500 pulseDelay = 5'd15;
        #500 pulseDelay = 5'd16;
        #500 pulseDelay = 5'd17;
        #500 pulseDelay = 5'd18;
        #500 pulseDelay = 5'd19;
        #500 pulseDelay = 5'd20;
        #500 pulseDelay = 5'd21;
        #500 pulseDelay = 5'd22;
        #500 pulseDelay = 5'd23;
        #500 pulseDelay = 5'd24;
        #500 pulseDelay = 5'd25;
        #500 pulseDelay = 5'd26;
        #500 pulseDelay = 5'd27;
        #500 pulseDelay = 5'd28;

        #500 pulseDelay = 5'd29;
        #500 pulseDelay = 5'd30;
        #500 pulseDelay = 5'd31;

        #500 $stop;
    end

    always 
        #12.48 clk40 = ~clk40; //25 ns clock period
    
    always
        #0.390 clk1280 = ~clk1280;


endmodule
