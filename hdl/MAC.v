`timescale 1ns/10ps

module MAC
    #(
        parameter WIDTH = 16                        // Bit width of operands
    )
    (
        input signed [WIDTH-1:0]    in,             // Input
        input signed [WIDTH-1:0]    w,              // Weight
        input                       clk,            // Clock input
        input                       rstb,           // Active-low reset

        output reg signed [WIDTH-1:0]    out        // Output
    );

    reg signed  [WIDTH-1:0]   in_buffer;            // Input buffer
    reg signed  [WIDTH-1:0]   w_buffer;             // Weight buffer
    reg signed  [WIDTH-1:0]  mult_buffer_output;    // Multiplier buffer
    reg signed  [WIDTH-1:0]  acc_buffer_output;     // Accumulater buffer

    wire signed [WIDTH-1:0]  mult_output;           // Multipler output
    wire signed [WIDTH-1:0]  acc_output;            // Accumulator output

    // Multipler module. Multiplies input by a weight.
    Multiplier 
        #(
            .WIDTH(WIDTH)
        )
        multiplier(
            .operand_a  (in_buffer),
            .operand_b  (w_buffer),
            .result     (mult_output)
        );     
    
    // Accumulator module. Adds buffered multipler output with that
    // most-recently-calculated accumulator output.
    Accumulator 
        #(
            .WIDTH(WIDTH)
        )
        accumulator(
            .operand_a  (mult_buffer_output),
            .operand_b  (acc_buffer_output),
            .result     (acc_output)
        );

    always @(posedge clk or negedge rstb) begin
        if (!rstb) begin
            in_buffer           <= 3'b0;
            w_buffer            <= 3'b0;
            mult_buffer_output  <= 11'b0;
            acc_buffer_output   <= 11'b0;
            out                 <= 11'b0;
        end else begin
            in_buffer           <= in;
            w_buffer            <= w;
            mult_buffer_output  <= mult_output;
            acc_buffer_output   <= acc_output;
            out                 <= acc_output;
        end
    end

endmodule