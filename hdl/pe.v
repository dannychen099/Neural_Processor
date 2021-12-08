`timescale 1ns/10ps

module pe
    #(
        parameter BITWIDTH      = 16,
        parameter RF_ADDR_WIDTH = 3,
        parameter RF_DATA_DEPTH = 2**RF_ADDR_WIDTH,
        parameter   LOAD    = 0,
                    MAC     = 1,
                    ACC     = 2,
                    NEXT_ROW= 3
    )
    (
        input   clk,            // Clock input
        input   rstb,           // Active-low reset
        input   ifmap_enable,   // Signal for multicast controller
        input   filter_enable,  // Signal for multicast controller
        output reg ready,          // Signal for multicast controller

        input   signed [BITWIDTH-1:0] ifmap,
        input   signed [BITWIDTH-1:0] filter,
        input   signed [BITWIDTH-1:0] input_psum,
        
        output  signed [BITWIDTH-1:0] output_psum
    );

    wire signed [BITWIDTH-1:0]          ifmap_from_fifo;
    wire signed [BITWIDTH-1:0]          filter_from_fifo;
    wire signed [BITWIDTH-1:0]          psum_from_fifo;
    reg                                 psum_enable;
    
    wire signed [BITWIDTH-1:0]          adder_input1;
    wire signed [BITWIDTH-1:0]          adder_input2;
    wire signed [BITWIDTH-1:0]          multiplier_output;
    wire signed [BITWIDTH-1:0]          acc_output;
    
    reg         [RF_ADDR_WIDTH-1:0]     ifmap_select;
    reg         [RF_ADDR_WIDTH-1:0]     filter_select;
    reg         [RF_ADDR_WIDTH-1:0]     psum_select;

    reg                                 acc_input_psum;
    reg                                 acc_reset;

    // Control information
    reg         [RF_ADDR_WIDTH-1:0]     filter_size;
    reg         [RF_ADDR_WIDTH-1:0]     final_psum_select;
    reg         [RF_ADDR_WIDTH-1:0]     count;
    reg         [2:0]                   pe_state;

    // MAC unit is multiplier and accumulator
    multiplier
        #(
            .WIDTH(BITWIDTH)
        )
        mac_multiplier(
            .operand_a  (filter_from_fifo),
            .operand_b  (ifmap_from_fifo),
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

    // Register files
    fifo
        #(
            .ADDR_WIDTH (RF_ADDR_WIDTH),
            .DATA_WIDTH (BITWIDTH),
            .DEPTH      (RF_DATA_DEPTH)
        )
        ifmap_fifo
        (
            .clk        (clk),
            .rstb       (rstb),
            .load_enable(ifmap_enable),
            .value_in   (ifmap),
            .reg_select (ifmap_select),
            .value_out  (ifmap_from_fifo)
        );

    fifo
        #(
            .ADDR_WIDTH (RF_ADDR_WIDTH),
            .DATA_WIDTH (BITWIDTH),
            .DEPTH      (RF_DATA_DEPTH)
        )
        filter_fifo
        (
            .clk        (clk),
            .rstb       (rstb),
            .load_enable(filter_enable),
            .value_in   (filter),
            .reg_select (filter_select),
            .value_out  (filter_from_fifo)
        );
    
        fifo
        #(
            .ADDR_WIDTH (RF_ADDR_WIDTH),
            .DATA_WIDTH (BITWIDTH),
            .DEPTH      (RF_DATA_DEPTH)
        )
        psum_fifo
        (
            .clk        (clk),
            .rstb       (rstb),
            .load_enable(psum_enable),
            .value_in   (acc_output),  // Get the psum at the output
            .reg_select (psum_select),
            .value_out  (psum_from_fifo)
        );

    // Select adder input1; either mult output or bottom PE psum
    // Select adder input2; either 0 (reset accumulation) or psum_from_fifo
    // Adder inputs are selectable. 1st input is multiplier output or the psum
    // from the lower PE. 2nd input is either the accumulated psum or zero
    assign adder_input1 = (acc_input_psum) ? input_psum : multiplier_output; 
    assign adder_input2 = (acc_reset) ? 'sd0 : psum_from_fifo;
    assign output_psum = acc_output;

    always @(posedge clk or negedge rstb) begin
        if (!rstb) begin
            ifmap_select        <= 'b0;
            filter_select       <= 'b0;
            psum_select         <= 'b0;
            psum_enable         <= 'b0;
            acc_input_psum      <= 'b0;
            acc_reset           <= 'b1;
            filter_size         <= 'd3; // 'Size' of filter to cycle through
            count               <= 'b0;
            pe_state            <= LOAD;
        end else begin

            case (pe_state)
                LOAD: begin
                    if (count < filter_size) begin
                        count <= (ifmap_enable) ? count + 'b1 : count;
                        acc_input_psum  <= 'b0;
                        acc_reset       <= 'b1;
                        filter_select   <= 'b0;
                        ifmap_select    <= 'b0;
                        psum_select     <= 'b0;
                        psum_enable     <= 'b1;
                        ready           <= 'b1;
                        pe_state        <= LOAD;
                    end else begin
                        count           <= 'b0;     // Reset count
                        pe_state        <= MAC;     // Go to LOAD state
                    end
                end

                MAC: begin
                    if (count < filter_size) begin
                        count           <= count + 'b1;
                        acc_input_psum  <= 'b0;
                        acc_reset       <= 'b0;
                        filter_select   <= filter_select + 'b1;
                        ifmap_select    <= ifmap_select + 'b1;
                        psum_select     <= 'b0;
                        psum_enable     <= 'b1;
                        ready           <= 'b0;
                        pe_state        <= MAC;
                    end else begin
                        acc_input_psum  <= 'b0;     // was 1, but 0 allows synthesis to work?
                        count           <= 'b0;     // Reset count
                        pe_state        <= ACC;     // Go to LOAD state
                    end
                end

                ACC: begin
                    if (count < filter_size) begin
                        count           <= count + 'b1;
                        acc_input_psum  <= 'b1;
                        acc_reset       <= 'b0;
                        filter_select   <= 'b0;
                        ifmap_select    <= 'b0;
                        psum_select     <= count + 'b1;
                        psum_enable     <= 'b1;
                        ready           <= 'b0;
                        pe_state        <= ACC;
                    end else begin
                        acc_input_psum  <= 'b0;
                        acc_reset       <= 'b1;
                        psum_select     <= 'b0;
                        pe_state        <= NEXT_ROW;
                    end
                end
                
                NEXT_ROW: begin
                    if (count < filter_size) begin
                        count <= (filter_enable) ? count + 'b1 : count;
                        acc_input_psum  <= 'b0;
                        acc_reset       <= 'b0;
                        filter_select   <= 'b0;
                        ifmap_select    <= 'b0;
                        psum_select     <= 'b0;
                        psum_enable     <= 'b1;
                        ready           <= 'b1;
                        pe_state        <= NEXT_ROW;
                    end else begin
                        acc_input_psum  <= 'b0;
                        acc_reset       <= 'b1;
                        count           <= 'b1;     // Reset count
                        pe_state        <= MAC;
                    end
                end
                default: begin
                end

            endcase
        end
    end
endmodule
