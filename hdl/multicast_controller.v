`timescale 1ns/10ps

module multicast_controller
#(
    parameter ADDRESS_WIDTH = 4,
    parameter BITWIDTH      = 16
)
(
    // Clock and reset ports
    input                           clk,
    input                           rstb,
    // Scan chain configuration ports
    input                           program,            // Set for programming
    input       [ADDRESS_WIDTH-1:0] scan_tag_in,
    output reg  [ADDRESS_WIDTH-1:0] scan_tag_out,
    // Ports on incoming data side (coming into conroller)
    input                           controller_enable,  // Enable the controller
    output wire                     controller_ready,   // Pass target_ready out
    input       [ADDRESS_WIDTH-1:0] tag,                // Address tag
    input       [BITWIDTH-1:0]      input_value,
    // Ports on outgoing data side (to PE or other bus)
    output wire                     target_enable,      // Enable the target
    input                           target_ready,       // Target state
    output wire [BITWIDTH-1:0]      output_value        // Data to be passed on
);

    reg [ADDRESS_WIDTH-1:0] tag_id_reg;

    assign target_enable = controller_enable & target_ready & (tag_id_reg == tag);
    assign output_value = (target_enable) ? input_value : 'b0;
    assign controller_ready = target_ready;

    always @(posedge clk or negedge rstb) begin
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
