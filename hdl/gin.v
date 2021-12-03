`timescale 1ns/10ps

module gin
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

endmodule
