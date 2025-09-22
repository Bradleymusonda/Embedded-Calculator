
// Simple FSM to latch operands and select operation via buttons.
// Buttons: U=ADD, D=SUB, L=MUL, R=DIV, C=Compute/Reset.
// Switches: sw[7:0] -> A, sw[15:8] -> B.
module fsm_controller (
    input  wire       clk,
    input  wire       resetn,     // active-low
    input  wire [15:0] sw,
    input  wire       btnU, btnD, btnL, btnR, btnC,
    output reg  [7:0] A,
    output reg  [7:0] B,
    output reg  [2:0] op,
    output reg        do_compute, // one-cycle pulse
    output reg  [1:0] state_dbg   // for LEDs if desired
);
    localparam S_IDLE = 2'd0;
    localparam S_OP   = 2'd1;
    localparam S_GO   = 2'd2;

    reg btnC_d, btnC_q;
    wire btnC_rise;

    // edge detect for Compute
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            btnC_q <= 1'b0;
            btnC_d <= 1'b0;
        end else begin
            btnC_q <= btnC_d;
            btnC_d <= btnC;
        end
    end
    assign btnC_rise = (btnC_d & ~btnC_q);

    // Latch buttons directly into op code
    // debouncing is very light here; for lab use this is fine.
    function [2:0] op_from_buttons;
        input U,D,L,R;
        begin
            if (U) op_from_buttons = 3'b000;       // ADD
            else if (D) op_from_buttons = 3'b001;  // SUB
            else if (L) op_from_buttons = 3'b010;  // MUL
            else if (R) op_from_buttons = 3'b011;  // DIV
            else op_from_buttons = 3'b000;
        end
    endfunction

    reg [1:0] state, nstate;

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= S_IDLE;
            A <= 8'd0;
            B <= 8'd0;
            op <= 3'b000;
        end else begin
            state <= nstate;
            if (state == S_IDLE) begin
                A <= sw[7:0];
                B <= sw[15:8];
            end
            if (state == S_OP) begin
                op <= op_from_buttons(btnU, btnD, btnL, btnR);
            end
        end
    end

    always @* begin
        nstate = state;
        do_compute = 1'b0;
        case (state)
            S_IDLE: begin
                // Wait for any operation selection (or just stay)
                if (btnU | btnD | btnL | btnR)
                    nstate = S_OP;
            end
            S_OP: begin
                if (btnC) nstate = S_GO;   // center triggers compute
            end
            S_GO: begin
                do_compute = 1'b1;         // single-cycle pulse
                nstate = S_IDLE;
            end
        endcase
    end

    always @* begin
        case(state)
            S_IDLE: state_dbg = 2'b00;
            S_OP:   state_dbg = 2'b01;
            S_GO:   state_dbg = 2'b10;
            default:state_dbg = 2'b11;
        endcase
    end
endmodule
