`timescale 1ns/10ps

//------------------------------------------------------------------------------
//  Single-port SRAM test bench
//
//  This design was found at:
//      https://www.chipverify.com/verilog/verilog-single-port-ram
//------------------------------------------------------------------------------

module tb;
    parameter ADDR_WIDTH = 2;
    parameter DATA_WIDTH = 8;
    parameter DEPTH = 2**2;

    reg clk;
    reg cs;
    reg we;
    reg oe;
    reg [ADDR_WIDTH-1:0] addr;
    reg [DATA_WIDTH-1:0] tb_data;
    wire [DATA_WIDTH-1:0] data;

    single_port_sram #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
        ) 
        sram(
            .clk    (clk),
            .addr   (addr),
            .data   (data),
            .cs     (cs),
            .we     (we),
            .oe     (oe)
        );

    always #10 clk = ~clk;
    assign data = !oe ? tb_data : 'hz;

    integer i;

    initial begin
        {clk, cs, we, addr, tb_data, oe} <= 0;

        repeat (2) @(posedge clk);

        for (i = 0; i < 2**ADDR_WIDTH; i = i+1) begin
            repeat (1) @(posedge clk) addr <= i; we <= 1; cs <= 1; oe <= 0; tb_data <= $random;
        end

        for (i = 0; i < 2**ADDR_WIDTH; i = i+1) begin
            repeat (1) @(posedge clk) addr <= i; we <= 0; cs <= 1; oe <= 1;
        end

        #40 $finish;
    end
endmodule
