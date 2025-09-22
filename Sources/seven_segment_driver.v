
// 8-digit multiplexed seven-segment display driver for Nexys A7.
// Active-low anodes on Nexys A7 -> we output 'an' active-low.
module seven_segment_driver (
    input  wire        clk,       // ~1-2 kHz recommended
    input  wire        resetn,    // active-low
    input  wire [31:0] value,     // 8 nibbles -> D7..D0 (D7 is leftmost)
    input  wire [7:0]  dp_mask,   // 1 = decimal point ON for corresponding digit
    output reg  [7:0]  an,        // active-low anode enables
    output reg  [6:0]  seg,       // active-high segment outputs (a..g)
    output reg         dp         // active-high decimal point
);
    reg [2:0] digit = 3'd0;
    wire [3:0] nibble = (digit==3'd0) ? value[3:0]   :
                        (digit==3'd1) ? value[7:4]   :
                        (digit==3'd2) ? value[11:8]  :
                        (digit==3'd3) ? value[15:12] :
                        (digit==3'd4) ? value[19:16] :
                        (digit==3'd5) ? value[23:20] :
                        (digit==3'd6) ? value[27:24] :
                                        value[31:28];

    wire [6:0] seg_raw;
    hex_to_7seg u_hex(.hex(nibble), .seg(seg_raw));

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            digit <= 3'd0;
        end else begin
            digit <= digit + 3'd1;
        end
    end

    always @* begin
        // Active-low anodes: only one low at a time
        an = 8'b1111_1111;
        an[digit] = 1'b0;

        seg = seg_raw;
        dp  = dp_mask[digit];
    end
endmodule
