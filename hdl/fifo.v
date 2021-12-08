`timescale 1ns/10ps

module fifo
    #(
        parameter ADDR_WIDTH  = 3,              // Width of address
        parameter DATA_WIDTH  = 16,             // Width of each memory element
        parameter DEPTH       = 2**ADDR_WIDTH   // Number of memory elements
    )
    (
        input                           clk,
        input                           rstb,
        input                           load_enable,// Set high to push next value
        input  signed [DATA_WIDTH-1:0]  value_in,   // The value to push
        input         [ADDR_WIDTH-1:0]  reg_select, // Select arbitrary register to read
        output signed [DATA_WIDTH-1:0]  value_out   // Value to read with reg_select
    );

    reg [DATA_WIDTH-1:0] memory [0:DEPTH];

    integer i;

    assign value_out = memory[reg_select];

    always @(posedge clk or negedge rstb) begin
        if (!rstb) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                memory[i] <= 'b0;
            end
        end else begin
            if (load_enable) begin
                // Shift contents of memory. Last memory is overwritten.
                for (i = DEPTH; i > 0; i = i - 1) begin
                    memory[i] <= memory[i-1];
                end
                memory[0] <= value_in;
            end
        end
    end
endmodule
