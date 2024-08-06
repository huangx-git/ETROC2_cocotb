`timescale 1ns/1ps
module FCGenLocal(
        input clk40,
        output fastComSerial,
        output [7:0] fastComParallel
    );

    localparam IDLE         = 8'HF0; //8'b1111_0000; //2'hF0 -->n_fc = 0--3'h001 --- 8'HF0-->14
    localparam LinkReset    = 8'H33; //8'b0011_0011; //2'hF8 -->n_fc = 1--3'h002 --- 8'H33-->2
    localparam BCR          = 8'H5A; //8'b0101_1010; //2'hF1 -->n_fc = 2--3'h004 --- 8'H5A-->5
    localparam SyncForTrig  = 8'H55; //8'b0101_0101; //2'hF2 -->n_fc = 3--3'h008 --- 8'H55-->4
    localparam L1A_CR       = 8'H66; //8'b0110_0110; //2'hF9 -->n_fc = 4--3'h010 --- 8'H66-->6
    localparam ChargeInj    = 8'H69; //8'b0110_1001; //2'hF4 -->n_fc = 5--3'h020 --- 8'H69-->7
    localparam L1A          = 8'H96; //8'b1001_0110; //2'hF6 -->n_fc = 6--3'h040 --- 8'H96-->8
    localparam L1A_BCR      = 8'H99; //8'b1001_1001; //2'hF3 -->n_fc = 7--3'h080 --- 8'H99-->9
    localparam WS_Start     = 8'HA5; //8'b1010_0101; //2'hFC -->n_fc = 8--3'h100 --- 8'HA5-->10
    localparam WS_Stop      = 8'HAA; //8'b1010_1010; //2'hFA -->n_fc = 9--3'h200 --- 8'HAA-->11

    reg FastComBit;
    reg [7:0] FastComByte;
    reg clk320;

    assign fastComSerial = FastComBit;
    assign fastComParallel = FastComByte;

    always #1.56 clk320 = ~clk320;

    integer CounterFC;

    initial begin
        clk320 = 0;

        #(24.96-3.12)
        CounterFC = 0;
        repeat(7300) begin
            FCGenTask(IDLE);
            CounterFC = CounterFC + 1;
        end

        CounterFC = 0;
        repeat(1) begin
            FCGenTask(ChargeInj);
            CounterFC = CounterFC + 1;
        end

        CounterFC = 0;
        repeat(20) begin
            FCGenTask(IDLE);
            CounterFC = CounterFC + 1;
        end

        CounterFC = 0;
        repeat(1) begin
            FCGenTask(ChargeInj);
            CounterFC = CounterFC + 1;
        end

        CounterFC = 0;
        repeat(2500) begin
            FCGenTask(IDLE);
            CounterFC = CounterFC + 1;
        end

        CounterFC = 0;
        repeat(1) begin
            FCGenTask(BCR);
            CounterFC = CounterFC + 1;
        end

        CounterFC = 0;
        repeat(16) begin
            FCGenTask(IDLE);
            CounterFC = CounterFC + 1;
        end


        CounterFC = 0;
        repeat(1) begin
            FCGenTask(ChargeInj);
            CounterFC = CounterFC + 1;
        end


        CounterFC = 0;
        repeat(480) begin
            FCGenTask(IDLE);
            CounterFC = CounterFC + 1;
        end

        CounterFC = 0;
        repeat(45) begin
            FCGenTask(L1A);
            CounterFC = CounterFC + 1;
        end

        CounterFC = 0;
        repeat(30000) begin
            FCGenTask(IDLE);
            CounterFC = CounterFC + 1;
        end

        #100
        $display("%12d FORCE STOP (FCGenLocal)", $time);
        $stop();
    end

    task FCGenTask;
        input [7:0] FastCom;
        begin
            #3.12
            FastComByte = FastCom;
            FastComBit = FastCom[7];
            #3.12
            FastComBit = FastCom[6];
            #3.12
            FastComBit = FastCom[5];
            #3.12
            FastComBit = FastCom[4];
            #3.12
            FastComBit = FastCom[3];
            #3.12
            FastComBit = FastCom[2];
            #3.12
            FastComBit = FastCom[1];
            #3.12
            FastComBit = FastCom[0];
        end
    endtask
endmodule
