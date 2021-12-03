`timescale 1ns/10ps

module gin_bus
    #(
        parameter BITWIDTH          = 16,
        parameter TAG_LENGTH        = 4,
        parameter NUM_CONTROLLERS   = 10
    )
    (
        input                           clk,
        input                           rstb,
        input                           program,
        input  [TAG_LENGTH-1:0]         scan_tag_in,
        input                           controller_enable,
        output [NUM_CONTROLLERS-1:0]    controller_ready,
        input  [TAG_LENGTH-1:0]         tag,
        inout  [BITWIDTH-1:0]           data_source,
        output [NUM_CONTROLLERS-1:0]    target_enable,
        inout  [(BITWIDTH*NUM_CONTROLLERS)-1:0] output_value,
        input  [NUM_CONTROLLERS-1:0]    target_ready
    );

        wire   [TAG_LENGTH-1:0]         scan_tag_out    [0:NUM_CONTROLLERS];
        wire   [BITWIDTH-1:0]           mc_output       [0:NUM_CONTROLLERS-1];
        wire   [BITWIDTH-1:0]           input_value;

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
                    .clk                (clk),
                    .rstb               (rstb),
                    .program            (program),
                    .scan_tag_in        (scan_tag_out[i]),
                    .scan_tag_out       (scan_tag_out[i+1]),
                    .controller_enable  (controller_enable),
                    .controller_ready   (controller_ready[i]),
                    .tag                (tag),
                    .input_value        (data_source),
                    .target_enable      (target_enable[i]),
                    .target_ready       (target_ready[i]),
                    .output_value       (mc_output[i])
                );
            end
        endgenerate
endmodule
