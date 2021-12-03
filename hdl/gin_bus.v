`timescale 1ns/10ps

module gin_bus
    #(
        parameter BITWIDTH          = 16,
        parameter TAG_LENGTH        = 4,
        parameter NUM_CONTROLLERS   = 10
    )
    (
        input                       clk,
        input                       rstb,
        input                       program,
        input                       enable,
        input                       unit_ready,
        input  [TAG_LENGTH-1:0]     tag,
        input  [TAG_LENGTH-1:0]     scan_tag_in,
        inout  [BITWIDTH-1:0]       input_value,    // use inout for psum?

        output [(BITWIDTH)*(NUM_CONTROLLERS)-1:0]   output_value,
        output [NUM_CONTROLLERS-1:0]                unit_enable
    );

        wire   [TAG_LENGTH-1:0]     scan_tag_out    [0:NUM_CONTROLLERS];
        wire   [BITWIDTH-1:0]       mc_output       [0:NUM_CONTROLLERS-1];

        assign scan_tag_out[0] = scan_tag_in;

        generate
            genvar i;
            for (i = 0; i < NUM_CONTROLLERS; i = i+1) begin : mc_vector

                // Assign each mc's output to the output port vector 
                assign output_value[BITWIDTH*(i+1)-1:(BITWIDTH*i)] = mc_output[i];
                
                multicast_controller
                #(
                    .ADDRESS_WIDTH  (TAG_LENGTH),
                    .BITWIDTH       (BITWIDTH)
                )
                mc (
                    .clk            (clk),
                    .rstb           (rstb),
                    .program        (program),
                    .enable         (enable),
                    .unit_ready     (unit_ready),
                    .tag            (tag),
                    .scan_tag_in    (scan_tag_out[i]),
                    .scan_tag_out   (scan_tag_out[i+1]),
                    .input_value    (input_value),
                    .output_value   (mc_output[i]),
                    .unit_enable    (unit_enable[i])
                );
            end
        endgenerate
endmodule
