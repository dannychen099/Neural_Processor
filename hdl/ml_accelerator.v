`timescale 1ns/10ps

module ml_accelerator
    #(
        parameter BITWIDTH              = 16,
        parameter SRAM_ADDR_LENGTH      = 3,    // External memory
        parameter GLB_ADDR_LENGTH       = 3,    // Internal memory
        parameter PE_Y_SIZE             = 3,
        parameter PE_X_SIZE             = 3,
        parameter TAG_LENGTH            = 4,
        parameter PACKET_LENGTH         = 2*TAG_LENGTH+BITWIDTH,
        parameter NUM_PE                = PE_Y_SIZE*PE_X_SIZE
    )
    (
        input   clk,
        input   rstb,

/* Left out for simpler design
        inout  [BITWIDTH-1:0]               sram_data,
        output [SRAM_ADDR_LENGTH-1:0]       sram_addr,
        output                              sram_cs,
        output                              sram_we,
        output                              sram_oe,
*/
        
        // Included for testing:
        input  [PACKET_LENGTH-1:0]          data_packet_ifmap,
        input  [PACKET_LENGTH-1:0]          data_packet_filter,
        output [BITWIDTH*PE_X_SIZE-1:0]     ofmap,
        input  [TAG_LENGTH-1:0]             scan_chain_input_ifmap,
        input  [TAG_LENGTH-1:0]             scan_chain_output_ifmap,
        input  [TAG_LENGTH-1:0]             scan_chain_input_filter,
        input  [TAG_LENGTH-1:0]             scan_chain_output_filter,
        input                               enable,
        output                              ready,
        input                               program,
        input                               gin_enable_filter,
        input                               gin_enable_ifmap,
        input                               pe_reset

    );

    genvar i;
    genvar j;

    // Control connections
    //reg                         program;
   

    // Ifmap connections
    //wire [TAG_LENGTH-1:0]       scan_chain_input_ifmap;
    //wire [TAG_LENGTH-1:0]       scan_chain_output_ifmap;
    //wire                        gin_enable_ifmap; // Used as input for now
    wire                        gin_ready_ifmap;
    //wire [PACKET_LENGTH-1:0]    data_packet_ifmap; // Used as input for now
    wire [NUM_PE-1:0]           pe_enable_ifmap;
    wire [NUM_PE-1:0]           pe_ready_ifmap;
    wire [BITWIDTH*NUM_PE-1:0]  pe_value_ifmap;

    reg  [GLB_ADDR_LENGTH-1:0]  glb_addr_ifmap;
    wire [BITWIDTH-1:0]         glb_data_ifmap;
    reg                         glb_cs_ifmap;
    reg                         glb_we_ifmap;
    reg                         glb_oe_ifmap;


    // Filter connections
    //wire [TAG_LENGTH-1:0]       scan_chain_input_filter;
    //wire [TAG_LENGTH-1:0]       scan_chain_output_filter;
    //wire                        gin_enable_filter;
    wire                        gin_ready_filter;
    //wire [PACKET_LENGTH-1:0]    data_packet_filter; // Used as input for now
    wire [NUM_PE-1:0]           pe_enable_filter; // Used as input for now
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
    wire [BITWIDTH*NUM_PE-1:0]  pe_psum;
        // Last PE_X_SIZE values on bottom are unused:
    wire [BITWIDTH*(NUM_PE+PE_X_SIZE)-1:0] pe_bottom_psum;    
    wire                        pe_reset_signal;

    assign ready = gin_ready_filter & gin_ready_ifmap;
    assign pe_reset_signal = rstb & pe_reset; // Active low
    
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
        .program            (program),
        .scan_tag_in        (scan_chain_input_ifmap),
        .scan_tag_out       (scan_chain_output_ifmap),
        .gin_enable         (gin_enable_ifmap),
        .gin_ready          (gin_ready_ifmap),
        .data_packet        (data_packet_ifmap),
        .pe_enable          (pe_enable_ifmap),
        .pe_ready           (pe_ready),
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
        .program            (program),
        .scan_tag_in        (scan_chain_input_filter),
        .scan_tag_out       (scan_chain_output_filter),
        .gin_enable         (gin_enable_filter),
        .gin_ready          (gin_ready_filter),
        .data_packet        (data_packet_filter),
        .pe_enable          (pe_enable_filter),
        .pe_ready           (pe_ready),
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
                pe_unit
                (
                    .clk            (clk),
                    .rstb           (pe_reset),
                    .ifmap_enable   (pe_enable_ifmap[i*PE_X_SIZE+j]),
                    .filter_enable  (pe_enable_filter[i*PE_X_SIZE+j]),
                    .ifmap          (pe_value_ifmap[(i*PE_X_SIZE + j)*BITWIDTH +: BITWIDTH]),
                    .filter         (pe_value_filter[(i*PE_X_SIZE + j)*BITWIDTH +: BITWIDTH]),
                    .input_psum     (pe_bottom_psum[((i+1)*PE_X_SIZE + j)*BITWIDTH +: BITWIDTH]),
                    .ready          (pe_ready[i*PE_X_SIZE+j]),
                    .output_psum    (pe_bottom_psum[(i*PE_X_SIZE + j)*BITWIDTH +: BITWIDTH])
                );
            end
        end
    endgenerate
    // Assign the psum inputs to the bottom row of PEs in the array to zero
    assign pe_bottom_psum[BITWIDTH*(NUM_PE+PE_X_SIZE)-1 : BITWIDTH*NUM_PE] = 'b0;

    // Assign the top psum outputs to the output ports for now
    generate
        for (i = 0; i < PE_X_SIZE; i = i + 1) begin
            //assign ofmap[i*BITWIDTH +: BITWIDTH] = pe_bottom_psum[i*PE_X_SIZE*BITWIDTH +: BITWIDTH];
        end
    endgenerate

endmodule
