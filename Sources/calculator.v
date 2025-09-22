
// Top-level for Nexys A7 Embedded Calculator.
// Ports are named to match the Digilent master XDC conventions.
//
// sw[7:0]   = operand A
// sw[15:8]  = operand B
// Buttons: U(add), D(sub), L(mul), R(div), C(compute/reset)
module calculator (
    input  wire        CLK100MHZ,
    input  wire [15:0] sw,
    input  wire        btnC, btnU, btnL, btnR, btnD,
    output wire [15:0] led,
    output wire [7:0]  an,
    output wire [6:0]  seg,
    output wire        dp
);
    wire resetn = ~btnC; // hold center to reset

    // Slow clocks for display multiplexing
    wire clk_div;
    clock_divider #(.N(15)) u_div (.clk_in(CLK100MHZ), .resetn(resetn), .clk_out(clk_div));

    // FSM to latch A,B and choose operation
    wire [7:0] A, B;
    wire [2:0] op;
    wire       do_compute;
    wire [1:0] state_dbg;

    fsm_controller u_fsm (
        .clk(CLK100MHZ), .resetn(resetn),
        .sw(sw), .btnU(btnU), .btnD(btnD), .btnL(btnL), .btnR(btnR), .btnC(btnC),
        .A(A), .B(B), .op(op), .do_compute(do_compute), .state_dbg(state_dbg)
    );

    // ALU (combinational)
    wire [15:0] y;
    wire div0;
    alu8 u_alu (.a(A), .b(B), .op(op), .y(y), .div_by_zero(div0));

    // Result register (latch on do_compute)
    reg [15:0] result;
    always @(posedge CLK100MHZ or negedge resetn) begin
        if (!resetn) result <= 16'h0000;
        else if (do_compute) result <= (div0 ? 16'hdEAd : y);
    end

    // Display: map 16-bit result into 8 hex digits (pad with zeros)
    wire [31:0] disp_value = {16'h0000, result};
    wire [7:0]  dp_mask    = 8'b0000_0000;

    seven_segment_driver u_disp (
        .clk(clk_div), .resetn(resetn),
        .value(disp_value), .dp_mask(dp_mask),
        .an(an), .seg(seg), .dp(dp)
    );

    // LEDs show: operand A on [7:0], FSM state on [9:8]
    assign led[7:0]   = A;
    assign led[15:8]  = B;

endmodule
