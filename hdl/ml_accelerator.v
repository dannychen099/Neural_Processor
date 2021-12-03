`timescale 1ns/10ps

module ml_accelerator
    #(
        parameter BITWIDTH          = 16;
        
        parameter SRAM_ADDR_LENGTH  = 8;    // External memory
        parameter GLB_ADDR_LENGTH   = 8;    // Internal memory

        parameter IFMAP_TAG_LENGTH  = 5;
        parameter FILTER_TAG_LENGTH = 4;
        parameter PSUM_TAG_LENGTH   = 4;
    )
    (
        input   clk;
        input   rstb;

        inout  [BITWIDTH-1:0]               sram_data;
        output [SRAM_ADDR_LENGTH-1:0]       sram_addr;
        output                              sram_cs;
        output                              sram_we;
        output                              sram_oe;
    );

    reg [GLB_ADDR_LENGTH-1:0]   glb_addr;
    reg [BITWIDTH-1:0]          glb_data;
    reg                         glb_cs;
    reg                         glb_we;
    reg                         glb_oe;

    // Internal buffer
    single_port_sram
    #(
        .ADDR_WIDTH (SRAM_ADDR_LENGTH),
        .DATA_WIDTH (BITWIDTH),
        .DEPTH      (2**SRAM_ADDR_LENGTH)
    )
    glb(
        .clk    (clk),
        .addr   (glb_addr),
        .data   (glb_data),
        .cs     (glb_cs),
        .we     (glb_we),
        .oe     (glb_oe)
    );
endmodule
