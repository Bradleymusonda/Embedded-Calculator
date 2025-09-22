
// Simple parameterizable clock divider.
// Divides input clock by 2^N, exposing a tick at ~clk_in/(2^N).
module clock_divider #(
    parameter integer N = 16
) (
    input  wire clk_in,
    input  wire resetn,        // active-low reset
    output wire clk_out
);
    reg [N-1:0] cnt = {N{1'b0}};
    always @(posedge clk_in or negedge resetn) begin
        if (!resetn)
            cnt <= {N{1'b0}};
        else
            cnt <= cnt + 1'b1;
    end
    assign clk_out = cnt[N-1];
endmodule
