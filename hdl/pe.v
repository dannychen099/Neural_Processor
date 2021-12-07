`timescale 1ns/10ps

module pe
    #(
        parameter BITWIDTH = 16
    )
    (
        input   clk,            // Clock input
        input   rstb,           // Active-low reset
        input   ifmap_enable,   // Signal for multicast controller
        input   filter_enable,  // Signal for multicast controller
        input   psum_enable,    // Signal for multicast controller
        input [2:0] control,
        output  ready,          // Signal for multicast controller

        input   signed [BITWIDTH-1:0] ifmap,
        input   signed [BITWIDTH-1:0] filter,
        input   signed [BITWIDTH-1:0] input_psum,
        
        output  signed [BITWIDTH-1:0] output_psum
    );

    reg signed [BITWIDTH-1:0] ifmap_reg;
    reg signed [BITWIDTH-1:0] filter_reg;
    reg signed [BITWIDTH-1:0] psum_reg;

    reg acc_input_psum;
    reg acc_reset;

    wire signed [BITWIDTH-1:0] adder_input1;
    wire signed [BITWIDTH-1:0] adder_input2;
    wire signed [BITWIDTH-1:0] multiplier_output;
    wire signed [BITWIDTH-1:0] acc_output;

    multiplier
        #(
            .WIDTH(BITWIDTH)
        )
        mac_multiplier(
            .operand_a  (ifmap_reg),
            .operand_b  (filter_reg),
            .result     (multiplier_output)
        );     
    
    accumulator 
        #(
            .WIDTH(BITWIDTH)
        )
        mac_accumulator(
            .operand_a  (adder_input1),
            .operand_b  (adder_input2),
            .result     (acc_output)
        );

    // Select adder input1; either mult output or bottom PE psum
    assign adder_input1 = (acc_input_psum == 0) ? multiplier_output : input_psum;

    // Select adder input2; either 0 (reset accumulation) or psum_reg
    assign adder_input2 = (acc_reset == 0) ? psum_reg : 'sd0;

    assign output_psum = acc_output;

    always @(posedge clk or negedge rstb) begin
        if (!rstb) begin
            ifmap_reg       <= 'sd0;
            filter_reg      <= 'sd0;
            psum_reg        <= 'sd0;
            acc_input_psum  <= 'sd0;
            acc_reset       <= 'sd0;
        end else begin
            if (enable) begin
                ifmap_reg       <= ifmap;
                filter_reg      <= filter;
                psum_reg        <= output_psum;

                acc_input_psum <= control[1:0];
                acc_reset <= control[2:1];
            end
        end
    end
endmodule
