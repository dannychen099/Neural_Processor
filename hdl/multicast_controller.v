`timescale 1ns/10ps

module multicast_controller
    #(
        parameter ADDRESS_WIDTH = 4,
        parameter BITWIDTH      = 16
    )
    (
        input                       clk,
        input                       rstb,
        input                       program,
        input                       enable,
        input                       pe_ready,
        input  [ADDRESS_WIDTH-1:0]  tag,
        input  [ADDRESS_WIDTH-1:0]  tag_id,
        input  [BITWIDTH-1:0]       input_value,

        output wire [BITWIDTH-1:0]  output_value,
        output wire                 pe_enable
    );

    reg [ADDRESS_WIDTH-1:0] tag_id_reg;

    assign pe_enable = enable && (tag == tag_id_reg) && pe_ready;
    assign output_value = (pe_enable) ? input_value : 'b0;

    always @(clk or negedge rstb) begin
        if (!rstb) begin
            tag_id_reg  <= 'd0;
        end else begin
            // Program the tag_id if program is set
            tag_id_reg <= (program) ? tag_id : tag_id_reg;
        end
    end

endmodule
