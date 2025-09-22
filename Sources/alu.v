
// Simple 8-bit ALU for + - * / (quotient).
// op: 3'b000=ADD, 001=SUB, 010=MUL, 011=DIV (quotient). Others -> 0.
// 'div_by_zero' flag asserted when dividing by zero.
module alu8 (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [2:0] op,
    output reg  [15:0] y,
    output reg        div_by_zero
);
    always @* begin
        div_by_zero = 1'b0;
        case (op)
            3'b000: y = a + b;               // add
            3'b001: y = a - b;               // sub
            3'b010: y = a * b;               // mul
            3'b011: begin                    // div (quotient)
                if (b == 8'd0) begin
                    y = 16'h0000;
                    div_by_zero = 1'b1;
                end else begin
                    y = {8'd0, (a / b)};
                end
            end
            default: y = 16'h0000;
        endcase
    end
endmodule
