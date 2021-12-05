`timescale 1ns/10ps

module tb
    #(
    )
    (
    );



    // External memory access
    single_port_sram
    #(
        .ADDR_WIDTH (SRAM_ADDR_LENGTH),
        .DATA_WIDTH (BITWIDTH),
        .DEPTH      (2**SRAM_ADDR_LENGTH)
    )
    sram(
        .clk    (clk),
        .addr   (sram_addr),
        .data   (sram_data),
        .cs     (sram_cs),
        .we     (sram_we),
        .oe     (sram_oe)
    );

endmodule
