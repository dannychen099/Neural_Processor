`timescale 1ns/10ps

module multicast_controller
    #(
        parameter ADDRESS_WIDTH = 4,
        parameter BITWIDTH      = 16
    )
    (
        input                           clk,
        input                           rstb,
        input                           program,
        input                           enable,
        input                           unit_ready,
        input       [ADDRESS_WIDTH-1:0] tag,
        input       [ADDRESS_WIDTH-1:0] scan_tag_in,    // Scan chain ID input
        output reg  [ADDRESS_WIDTH-1:0] scan_tag_out,   // Scan chain ID output
        output wire [BITWIDTH-1:0]      output_value,
        output wire                     unit_enable,
        inout       [BITWIDTH-1:0]      input_value     // Allow bidir data

    );

    reg [ADDRESS_WIDTH-1:0] tag_id_reg;

    assign unit_enable = enable & (tag_id_reg == tag) & unit_ready;
    assign output_value = (unit_enable) ? input_value : 'b0;

    always @(clk or negedge rstb) begin
        if (!rstb) begin
            tag_id_reg      <= 'd0;
            scan_tag_out    <= 'd0;
        end else begin
            // Program the tag_id if program is set
            if (program) begin
                tag_id_reg      <= scan_tag_in;
                scan_tag_out    <= tag_id_reg;
            end
        end
    end

endmodule
