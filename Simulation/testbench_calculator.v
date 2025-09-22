
`timescale 1ns/1ps

module testbench_calculator;
    reg CLK100MHZ = 0;
    always #5 CLK100MHZ = ~CLK100MHZ; // 100 MHz

    reg  [15:0] sw = 16'h0000;
    reg  btnC=0, btnU=0, btnL=0, btnR=0, btnD=0;
    wire [15:0] led;
    wire [7:0]  an;
    wire [6:0]  seg;
    wire        dp;

    calculator dut(
        .CLK100MHZ(CLK100MHZ),
        .sw(sw),
        .btnC(btnC), .btnU(btnU), .btnL(btnL), .btnR(btnR), .btnD(btnD),
        .led(led), .an(an), .seg(seg), .dp(dp)
    );

    task compute;
        begin
            btnC = 1; #20; btnC = 0; #20;
        end
    endtask

    initial begin
        // Reset pulse
        btnC = 1; #100; btnC = 0;

        // A=0x0A, B=0x03 (10 and 3)
        sw[7:0]  = 8'h0A;   // A
        sw[15:8] = 8'h03;   // B
        // ADD
        btnU=1; #40; btnU=0;
        compute();
        #200;

        // SUB
        btnD=1; #40; btnD=0;
        compute();
        #200;

        // MUL
        btnL=1; #40; btnL=0;
        compute();
        #200;

        // DIV
        btnR=1; #40; btnR=0;
        compute();
        #200;

        // DIV by zero -> dEAd
        sw[15:8]=8'h00;
        btnR=1; #40; btnR=0;
        compute();
        #500;

        $finish;
    end
endmodule
