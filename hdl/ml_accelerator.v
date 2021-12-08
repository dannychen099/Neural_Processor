`timescale 1ns/10ps

module ml_accelerator
    #(
        parameter BITWIDTH              = 16,
        parameter PE_Y_SIZE             = 3,
        parameter PE_X_SIZE             = 3,
        parameter TAG_LENGTH            = 4,
        parameter PACKET_LENGTH         = 2*TAG_LENGTH+BITWIDTH,
        parameter NUM_PE                = PE_Y_SIZE*PE_X_SIZE
    )
    (
        input   clk,
        input   rstb,

        // Included for testing:
        input  [PACKET_LENGTH-1:0]          data_packet_ifmap,
        input  [PACKET_LENGTH-1:0]          data_packet_filter,
        output [BITWIDTH*PE_X_SIZE-1:0]     ofmap,
        input  [TAG_LENGTH-1:0]             scan_chain_input_ifmap,
        input  [TAG_LENGTH-1:0]             scan_chain_input_filter,
        output                              ready,
        input                               program,
        input                               gin_enable_filter,
        input                               gin_enable_ifmap,
        input                               pe_reset

    );

    genvar i;
    genvar j;

    // Ifmap connections
    wire [TAG_LENGTH-1:0]       scan_chain_output_ifmap;
    wire                        gin_ready_ifmap;
    wire [NUM_PE-1:0]           pe_enable_ifmap;
    wire [NUM_PE-1:0]           pe_ready_ifmap;
    wire [BITWIDTH*NUM_PE-1:0]  pe_value_ifmap;

    // Filter connections
    wire [TAG_LENGTH-1:0]       scan_chain_output_filter;
    wire                        gin_ready_filter;
    wire [NUM_PE-1:0]           pe_enable_filter;
    wire [NUM_PE-1:0]           pe_ready_filter;
    wire [BITWIDTH*NUM_PE-1:0]  pe_value_filter;
    
    // PE connections
    wire [NUM_PE-1:0]           pe_enable;
    wire [NUM_PE-1:0]           pe_ready;
    wire [BITWIDTH*NUM_PE-1:0]  pe_psum;
        // Last PE_X_SIZE values on bottom are unused:
    wire [BITWIDTH*(NUM_PE+PE_X_SIZE):0] pe_bottom_psum;    
    wire                        pe_reset_signal;

    assign ready = gin_ready_filter & gin_ready_ifmap;
    assign pe_reset_signal = rstb & pe_reset; // Active low
    
    //-------------------------------------------------------------------------
    //  Ifmap GIN
    //-------------------------------------------------------------------------
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
    //  Filter GIN
    //-------------------------------------------------------------------------
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
                    .ready          (pe_ready[i*PE_X_SIZE + j]),
                    .output_psum    (pe_bottom_psum[(i*PE_X_SIZE + j)*BITWIDTH +: BITWIDTH])
                );
            end
        end
    endgenerate
    // Assign the psum inputs to the bottom row of PEs in the array to zero
    assign pe_bottom_psum[BITWIDTH*(NUM_PE+PE_X_SIZE) : BITWIDTH*NUM_PE] = 'b0;

    // Assign the top psum outputs to the output ports for now
    generate
        for (i = 0; i < PE_X_SIZE; i = i + 1) begin
            assign ofmap[i*BITWIDTH +: BITWIDTH] = pe_bottom_psum[i*BITWIDTH +: BITWIDTH];
        end
    endgenerate

endmodule
