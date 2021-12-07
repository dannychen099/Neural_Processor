`timescale 1ns/10ps

module ml_accelerator
    #(
        parameter BITWIDTH              = 16,
        parameter SRAM_ADDR_LENGTH      = 3,    // External memory
        parameter GLB_ADDR_LENGTH       = 3,    // Internal memory
        parameter PE_Y_SIZE             = 4,
        parameter PE_X_SIZE             = 4,
        parameter TAG_LENGTH            = 4,
        parameter PACKET_LENGTH         = 2*TAG_LENGTH+BITWIDTH,
        parameter NUM_PE                = PE_Y_SIZE*PE_X_SIZE
    )
    (
        input   clk,
        input   rstb,

        inout  [BITWIDTH-1:0]               sram_data,
        output [SRAM_ADDR_LENGTH-1:0]       sram_addr,
        output                              sram_cs,
        output                              sram_we,
        output                              sram_oe
    );

    genvar i;
    genvar j;

    // Control connections
    
    // Ifmap connections
    wire [TAG_LENGTH-1:0]       scan_chain_input_ifmap;
    wire [TAG_LENGTH-1:0]       scan_chain_output_ifmap;
    reg                         gin_enable_ifmap;
    wire                        gin_ready_ifmap;
    wire [PACKET_LENGTH-1:0]    data_packet_ifmap;
    wire [NUM_PE-1:0]           pe_enable_ifmap;
    wire [NUM_PE-1:0]           pe_ready_ifmap;
    wire [BITWIDTH*NUM_PE-1:0]  pe_value_ifmap;

    reg  [GLB_ADDR_LENGTH-1:0]  glb_addr_ifmap;
    wire [BITWIDTH-1:0]         glb_data_ifmap;
    reg                         glb_cs_ifmap;
    reg                         glb_we_ifmap;
    reg                         glb_oe_ifmap;


    // Filter connections
    wire [TAG_LENGTH-1:0]       scan_chain_input_filter;
    wire [TAG_LENGTH-1:0]       scan_chain_output_filter;
    reg                         gin_enable_filter;
    wire                        gin_ready_filter;
    wire [PACKET_LENGTH-1:0]    data_packet_filter;
    wire [NUM_PE-1:0]           pe_enable_filter;
    wire [NUM_PE-1:0]           pe_ready_filter;
    wire [BITWIDTH*NUM_PE-1:0]  pe_value_filter;
    
    reg  [GLB_ADDR_LENGTH-1:0]  glb_addr_filter;
    wire [BITWIDTH-1:0]         glb_data_filter;
    reg                         glb_cs_filter;
    reg                         glb_we_filter;
    reg                         glb_oe_filter;


    // PE connections
    wire [NUM_PE-1:0]           pe_enable;
    wire [NUM_PE-1:0]           pe_ready;
    wire [BITWIDTH-1:0]         pe_psum                 [0:NUM_PE-1];
    wire [2:0]                  pe_control              [0:NUM_PE-1];
    wire [BITWIDTH-1:0]         pe_value_psum           [0:NUM_PE+PE_X_SIZE]; // Last PE_X_SIZE values are unused
    
    assign pe_enable = pe_enable_ifmap | pe_enable_filter;
    assign pe_ready = pe_ready_ifmap & pe_ready_filter;

    //-------------------------------------------------------------------------
    //  Ifmap GLB register and GIN
    //-------------------------------------------------------------------------
    single_port_sram
    #(
        .ADDR_WIDTH (SRAM_ADDR_LENGTH),
        .DATA_WIDTH (BITWIDTH),
        .DEPTH      (2**SRAM_ADDR_LENGTH)
    )
    glb_ifmap(
        .clk    (clk),
        .addr   (glb_addr_ifmap),
        .data   (glb_data_ifmap),
        .cs     (glb_cs_ifmap),
        .we     (glb_we_ifmap),
        .oe     (glb_oe_ifmap)
    );

    gin
    #(
        .BITWIDTH           (BITWIDTH),
        .TAG_LENGTH         (TAG_LENGTH),
        .Y_BUS_SIZE         (PE_Y_SIZE),
        .X_BUS_SIZE         (PE_X_SIZE)
    )
    gin_ifmap
    (
        .clk                (clk),
        .rstb               (rstb),
        .scan_tag_in        (scan_chain_input_ifmap),
        .scan_tag_out       (scan_chain_output_ifmap),
        .gin_enable         (gin_enable_ifmap),
        .gin_ready          (gin_ready_ifmap),
        .data_packet        (data_packet_ifmap),
        .pe_enable          (pe_enable_ifmap),
        .pe_ready           (pe_ready_ifmap),
        .pe_value           (pe_value_ifmap)
    );
    
    //-------------------------------------------------------------------------
    //  Filter GLB register and GIN
    //-------------------------------------------------------------------------
    single_port_sram
    #(
        .ADDR_WIDTH (SRAM_ADDR_LENGTH),
        .DATA_WIDTH (BITWIDTH),
        .DEPTH      (2**SRAM_ADDR_LENGTH)
    )
    glb_filter(
        .clk    (clk),
        .addr   (glb_addr_filter),
        .data   (glb_data_filter),
        .cs     (glb_cs_filter),
        .we     (glb_we_filter),
        .oe     (glb_oe_filter)
    );

    gin
    #(
        .BITWIDTH           (BITWIDTH),
        .TAG_LENGTH         (TAG_LENGTH),
        .Y_BUS_SIZE         (PE_Y_SIZE),
        .X_BUS_SIZE         (PE_X_SIZE)
    )
    gin_filter
    (
        .clk                (clk),
        .rstb               (rstb),
        .scan_tag_in        (scan_chain_input_filter),
        .scan_tag_out       (scan_chain_output_filter),
        .gin_enable         (gin_enable_filter),
        .gin_ready          (gin_ready_filter),
        .data_packet        (data_packet_filter),
        .pe_enable          (pe_enable_filter),
        .pe_ready           (pe_ready_filter),
        .pe_value           (pe_value_filter)
    );

    //-------------------------------------------------------------------------
    //  PE array
    //-------------------------------------------------------------------------
    generate
        for (i = 0; i < PE_Y_SIZE; i = i + 1) begin : pe_row
            for (j = 0; j < PE_X_SIZE; j = j + 1) begin : pe_col

                pe
                #(
                    .BITWIDTH       (BITWIDTH)
                )
                pe_array
                (
                    .clk        (clk),
                    .rstb       (rstb),
                    .enable     (pe_enable[i*PE_X_SIZE+j]),
                    .control    (pe_control[i*PE_X_SIZE+j]),
                    .ifmap      (pe_value_ifmap[(i*PE_X_SIZE + j)*BITWIDTH +: BITWIDTH]),
                    .filter     (pe_value_filter[(i*PE_X_SIZE + j)*BITWIDTH +: BITWIDTH]),
                    .input_psum (pe_value_psum[i*PE_X_SIZE + j]),
                    .output_psum(pe_value_psum[(i+1)*PE_X_SIZE + j])
                );
            end
        end
    endgenerate
endmodule
