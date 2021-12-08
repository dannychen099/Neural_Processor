`timescale 1ns/10ps

module tb;
    parameter BITWIDTH          = 16;
    parameter PE_Y_SIZE         = 3;
    parameter PE_X_SIZE         = 3;
    parameter TAG_LENGTH        = 4;
    parameter PACKET_LENGTH     = 2*TAG_LENGTH + BITWIDTH;
    parameter NUM_PE            = PE_Y_SIZE*PE_X_SIZE;
    parameter CLK_PERIOD        = 10;

    reg                                     clk;
    reg                                     rstb;
    reg                                     pe_reset;
    wire        [PACKET_LENGTH-1:0]         data_packet_ifmap;
    wire        [PACKET_LENGTH-1:0]         data_packet_filter;
    reg  signed [BITWIDTH-1:0]              ifmap;
    reg  signed [BITWIDTH-1:0]              filter;
    reg         [TAG_LENGTH-1:0]            ifmap_row;
    reg         [TAG_LENGTH-1:0]            ifmap_col;
    reg         [TAG_LENGTH-1:0]            filter_row;
    reg         [TAG_LENGTH-1:0]            filter_col;
    wire signed [BITWIDTH*PE_X_SIZE-1:0]    ofmap;

    reg  [TAG_LENGTH-1:0]             scan_chain_input_ifmap;
    reg  [TAG_LENGTH-1:0]             scan_chain_input_filter;

    reg                     program;
    reg                     gin_enable_ifmap;
    reg                     gin_enable_filter;
    wire                    ready;

    wire [TAG_LENGTH-1:0]   ifmap_scan  [0:NUM_PE+PE_X_SIZE-1];
    wire [TAG_LENGTH-1:0]   filter_scan [0:NUM_PE+PE_X_SIZE-1];


    // Load memory contents for ifmap
    // src
    //  |
    //  0 ->  0 1 2
    //  0 ->  1 2 3
    //  0 ->  2 3 4
    assign ifmap_scan[11] = 'd0;   // Y-Bus
    assign ifmap_scan[10] = 'd0;
    assign ifmap_scan[9]  = 'd0;

    assign ifmap_scan[8]  = 'd0;   // X-Bus 1
    assign ifmap_scan[7]  = 'd1;
    assign ifmap_scan[6]  = 'd2;

    assign ifmap_scan[5]  = 'd1;   // X-Bus 2
    assign ifmap_scan[4]  = 'd2;
    assign ifmap_scan[3]  = 'd3;

    assign ifmap_scan[2]  = 'd2;   // X-Bus 3
    assign ifmap_scan[1]  = 'd3;
    assign ifmap_scan[0]  = 'd4;

    // Load memory contents for filter
    // src
    //  |
    //  0 ->  0 0 0
    //  0 ->  1 1 1
    //  0 ->  2 2 2
    assign filter_scan[11] = 'd0;   // Y-Bus
    assign filter_scan[10] = 'd0;
    assign filter_scan[9]  = 'd0;

    assign filter_scan[8]  = 'd0;   // X-Bus 1
    assign filter_scan[7]  = 'd0;
    assign filter_scan[6]  = 'd0;

    assign filter_scan[5]  = 'd1;   // X-Bus 2
    assign filter_scan[4]  = 'd1;
    assign filter_scan[3]  = 'd1;

    assign filter_scan[2]  = 'd2;   // X-Bus 3
    assign filter_scan[1]  = 'd2;
    assign filter_scan[0]  = 'd2;

    ml_accelerator tb_dut
    (
        .clk                (clk),
        .rstb               (rstb),
        .data_packet_ifmap  (data_packet_ifmap),
        .data_packet_filter (data_packet_filter),
        .ofmap              (ofmap),
        .scan_chain_input_ifmap(scan_chain_input_ifmap),
        .scan_chain_input_filter(scan_chain_input_filter),
        .gin_enable_ifmap             (gin_enable_ifmap),
        .gin_enable_filter            (gin_enable_filter),
        .ready              (ready),
        .program            (program),
        .pe_reset           (pe_reset)
    );
    
    genvar k;
    integer i;
    integer j;

    // Create the data packets for GIN distribution
    assign data_packet_ifmap  = {ifmap_row, ifmap_col, ifmap};
    assign data_packet_filter = {filter_row, filter_col, filter};

   
   
    task display_input
        (
            input   [BITWIDTH-1:0]  filter,
            input   [BITWIDTH-1:0]  ifmap
        );
        $display("filter=%2d, ifmap=%2d", filter, ifmap);
    endtask

    
    
    always #(CLK_PERIOD) clk = ~clk;

    initial begin
        $monitor("ofmap:\t%5d %5d %5d", ofmap[0 +: BITWIDTH], ofmap[BITWIDTH +: BITWIDTH], ofmap[2*BITWIDTH +: BITWIDTH]);

        clk         <= 'b0;
        rstb        <= 'b0;
        pe_reset    <= 'b0;
        ifmap_row   <= 'b0;
        ifmap_col   <= 'b0;
        filter_row  <= 'b0;
        filter_col  <= 'b0;
        ifmap       <= 'sd0;
        filter      <= 'sd0;
        gin_enable_filter      <= 'b0;
        gin_enable_ifmap      <= 'b0;
        program     <= 'b0;

        repeat (1) @(posedge clk);
        rstb        <= 'b1;
        pe_reset    <= 'b1;

        repeat (1) @(posedge clk);

        program     <= 'b1;

        // Push the Y-bus values into the scan chain
        for (i = 0; i < PE_Y_SIZE; i = i + 1) begin
            scan_chain_input_ifmap  <= ifmap_scan[i];
            scan_chain_input_filter <= filter_scan[i];
            repeat (2) @(posedge clk);
        end
        
        // Push each X-bus values into the scan chain
        for (i = PE_Y_SIZE; i < PE_Y_SIZE+PE_Y_SIZE*PE_X_SIZE; i = i + 1) begin
            scan_chain_input_ifmap  <= ifmap_scan[i];
            scan_chain_input_filter <= filter_scan[i];
            repeat (2) @(posedge clk);
        end
        program     <= 'b0;

        repeat (1) @(posedge clk);
        
        //---------------------------------------------------------------------
        //  Load 1st cycle
        //---------------------------------------------------------------------
        gin_enable_filter      <= 'b1;
        gin_enable_ifmap      <= 'b1;
        
        filter_row  <= 'd0;     // f11, f12, f13
        filter_col  <= 'd0;
        filter      <= 'sd0;
        
        ifmap_row   <= 'd0;     // if11
        ifmap_col   <= 'd0;
        ifmap       <= 'sd0;
        repeat (1) @(posedge clk);
        #1 display_input(filter, ifmap);

        filter_row  <= 'd0;     // f21, f22, f23
        filter_col  <= 'd0;
        filter      <= 'sd1;
        
        ifmap_row   <= 'd0;     // if12, if21
        ifmap_col   <= 'd1;
        ifmap       <= 'sd1;
        repeat (1) @(posedge clk);
        #1 display_input(filter, ifmap);

        filter_row  <= 'd0;     // f31, f32, f33
        filter_col  <= 'd0;
        filter      <= 'sd2;
        
        ifmap_row   <= 'd0;     // if31, if22, if13
        ifmap_col   <= 'd2;
        ifmap       <= 'sd2;
        repeat (1) @(posedge clk);
        #1 display_input(filter, ifmap);
        gin_enable_filter <= 'b0;
        
        ifmap_row   <= 'd0;     // if32, if23
        ifmap_col   <= 'd3;
        ifmap       <= 'sd3;
        repeat (1) @(posedge clk);
        display_input('bz, ifmap);
        
        ifmap_row   <= 'd0;     // if33
        ifmap_col   <= 'd4;
        ifmap       <= 'sd4;
        repeat (1) @(posedge clk);
        gin_enable_ifmap    <= 'b0;
        display_input('bz, ifmap);


        //---------------------------------------------------------------------
        //  Load 2nd cycle
        //---------------------------------------------------------------------
        gin_enable_filter      <= 'b1;
        gin_enable_ifmap      <= 'b1;
        
        filter_row  <= 'd0;     // f11, f12, f13
        filter_col  <= 'd1;
        filter      <= 'sd1;
        
        ifmap_row   <= 'd0;     // if11
        ifmap_col   <= 'd0;
        ifmap       <= 'sd1;
        repeat (1) @(posedge clk);
        
        filter_row  <= 'd0;     // f21, f22, f23
        filter_col  <= 'd1;
        filter      <= 'sd2;
        
        ifmap_row   <= 'd0;     // if12, if21
        ifmap_col   <= 'd1;
        ifmap       <= 'sd2;
        repeat (1) @(posedge clk);

        filter_row  <= 'd0;     // f31, f32, f33
        filter_col  <= 'd1;
        filter      <= 'sd3;
        
        ifmap_row   <= 'd0;     // if31, if22, if13
        ifmap_col   <= 'd2;
        ifmap       <= 'sd3;
        display_input(filter, ifmap);
        repeat (1) @(posedge clk);
        gin_enable_filter <= 'b0;
        
        ifmap_row   <= 'd0;     // if32, if23
        ifmap_col   <= 'd3;
        ifmap       <= 'sd4;
        repeat (1) @(posedge clk);
        
        ifmap_row   <= 'd0;     // if33
        ifmap_col   <= 'd4;
        ifmap       <= 'sd5;
        repeat (1) @(posedge clk);
        gin_enable_ifmap    <= 'b0;

        
        //---------------------------------------------------------------------
        //  Load 3rd cycle
        //---------------------------------------------------------------------
        gin_enable_filter   <= 'b1;
        gin_enable_ifmap     <= 'b1;
        
        filter_row  <= 'd0;     // f11, f12, f13
        filter_col  <= 'd2;
        filter      <= 'sd2;
        
        ifmap_row   <= 'd0;     // if11
        ifmap_col   <= 'd0;
        ifmap       <= 'sd2;
        repeat (1) @(posedge clk);
        
        filter_row  <= 'd0;     // f21, f22, f23
        filter_col  <= 'd2;
        filter      <= 'sd3;
        
        ifmap_row   <= 'd0;     // if12, if21
        ifmap_col   <= 'd1;
        ifmap       <= 'sd3;
        repeat (1) @(posedge clk);

        filter_row  <= 'd0;     // f31, f32, f33
        filter_col  <= 'd2;
        filter      <= 'sd4;
        
        ifmap_row   <= 'd0;     // if31, if22, if13
        ifmap_col   <= 'd2;
        ifmap       <= 'sd4;
        repeat (1) @(posedge clk);
        gin_enable_filter <= 'b0;
        
        $display("--- NOTE ---\nChange state on next cycle\n");
        ifmap_row   <= 'd0;     // if32, if23
        ifmap_col   <= 'd3;
        ifmap       <= 'sd5;
        repeat (1) @(posedge clk);
        
        ifmap_row   <= 'd0;     // if33
        ifmap_col   <= 'd4;
        ifmap       <= 'sd6;
        repeat (1) @(posedge clk);
        gin_enable_ifmap    <= 'b0;

        // Takes 3 clock cycles to calculate a single row
        repeat(3) @(posedge clk);

        // Display the 1st row results
        $display("ofmap %5d %5d %5d",
            ofmap[0 +: BITWIDTH],
            ofmap[BITWIDTH +: BITWIDTH],
            ofmap[2*BITWIDTH +: BITWIDTH]
        );

        // The 2nd and 3rd ofmap columns were delayed by 1 clock cycle during
        // programming, so we need 2 more clock cycles to finish the ofmap
        // row. Note that more than 2 clock cycles will mess with things
        repeat(2) @(posedge clk);

        $display("--- FINAL OUTPUT ---\nofmap %5d %5d %5d\n",
            ofmap[0 +: BITWIDTH],
            ofmap[BITWIDTH +: BITWIDTH],
            ofmap[2*BITWIDTH +: BITWIDTH]
        );

        pe_reset    <= 'b0;
        repeat(1) @(posedge clk);
        pe_reset    <= 'b1;
        repeat(1) @(posedge clk);

        //---------------------------------------------------------------------
        //  Load 1st cycle
        //---------------------------------------------------------------------
        gin_enable_filter      <= 'b1;
        gin_enable_ifmap      <= 'b1;
        
        filter_row  <= 'd0;     // f11, f12, f13
        filter_col  <= 'd0;
        filter      <= 'sd0;
        
        ifmap_row   <= 'd0;     // if11
        ifmap_col   <= 'd0;
        ifmap       <= 'sd1;
        repeat (1) @(posedge clk);
        #1 display_input(filter, ifmap);

        filter_row  <= 'd0;     // f21, f22, f23
        filter_col  <= 'd0;
        filter      <= 'sd1;
        
        ifmap_row   <= 'd0;     // if12, if21
        ifmap_col   <= 'd1;
        ifmap       <= 'sd2;
        repeat (1) @(posedge clk);
        #1 display_input(filter, ifmap);

        filter_row  <= 'd0;     // f31, f32, f33
        filter_col  <= 'd0;
        filter      <= 'sd2;
        
        ifmap_row   <= 'd0;     // if31, if22, if13
        ifmap_col   <= 'd2;
        ifmap       <= 'sd3;
        repeat (1) @(posedge clk);
        #1 display_input(filter, ifmap);
        gin_enable_filter <= 'b0;
        
        ifmap_row   <= 'd0;     // if32, if23
        ifmap_col   <= 'd3;
        ifmap       <= 'sd4;
        repeat (1) @(posedge clk);
        display_input('bz, ifmap);
        
        ifmap_row   <= 'd0;     // if33
        ifmap_col   <= 'd4;
        ifmap       <= 'sd5;
        repeat (1) @(posedge clk);
        gin_enable_ifmap    <= 'b0;
        display_input('bz, ifmap);


        //---------------------------------------------------------------------
        //  Load 2nd cycle
        //---------------------------------------------------------------------
        gin_enable_filter      <= 'b1;
        gin_enable_ifmap      <= 'b1;
        
        filter_row  <= 'd0;     // f11, f12, f13
        filter_col  <= 'd1;
        filter      <= 'sd1;
        
        ifmap_row   <= 'd0;     // if11
        ifmap_col   <= 'd0;
        ifmap       <= 'sd2;
        repeat (1) @(posedge clk);
        
        filter_row  <= 'd0;     // f21, f22, f23
        filter_col  <= 'd1;
        filter      <= 'sd2;
        
        ifmap_row   <= 'd0;     // if12, if21
        ifmap_col   <= 'd1;
        ifmap       <= 'sd3;
        repeat (1) @(posedge clk);

        filter_row  <= 'd0;     // f31, f32, f33
        filter_col  <= 'd1;
        filter      <= 'sd3;
        
        ifmap_row   <= 'd0;     // if31, if22, if13
        ifmap_col   <= 'd2;
        ifmap       <= 'sd4;
        display_input(filter, ifmap);
        repeat (1) @(posedge clk);
        gin_enable_filter <= 'b0;
        
        ifmap_row   <= 'd0;     // if32, if23
        ifmap_col   <= 'd3;
        ifmap       <= 'sd5;
        repeat (1) @(posedge clk);
        
        ifmap_row   <= 'd0;     // if33
        ifmap_col   <= 'd4;
        ifmap       <= 'sd6;
        repeat (1) @(posedge clk);
        gin_enable_ifmap    <= 'b0;

        
        //---------------------------------------------------------------------
        //  Load 3rd cycle
        //---------------------------------------------------------------------
        gin_enable_filter   <= 'b1;
        gin_enable_ifmap     <= 'b1;
        
        filter_row  <= 'd0;     // f11, f12, f13
        filter_col  <= 'd2;
        filter      <= 'sd2;
        
        ifmap_row   <= 'd0;     // if11
        ifmap_col   <= 'd0;
        ifmap       <= 'sd3;
        repeat (1) @(posedge clk);
        
        filter_row  <= 'd0;     // f21, f22, f23
        filter_col  <= 'd2;
        filter      <= 'sd3;
        
        ifmap_row   <= 'd0;     // if12, if21
        ifmap_col   <= 'd1;
        ifmap       <= 'sd4;
        repeat (1) @(posedge clk);

        filter_row  <= 'd0;     // f31, f32, f33
        filter_col  <= 'd2;
        filter      <= 'sd4;
        
        ifmap_row   <= 'd0;     // if31, if22, if13
        ifmap_col   <= 'd2;
        ifmap       <= 'sd5;
        repeat (1) @(posedge clk);
        gin_enable_filter <= 'b0;
        
        $display("--- NOTE ---\nChange state on next cycle\n");
        ifmap_row   <= 'd0;     // if32, if23
        ifmap_col   <= 'd3;
        ifmap       <= 'sd6;
        repeat (1) @(posedge clk);
        
        ifmap_row   <= 'd0;     // if33
        ifmap_col   <= 'd4;
        ifmap       <= 'sd7;
        repeat (1) @(posedge clk);
        gin_enable_ifmap    <= 'b0;

        // Takes 3 clock cycles to calculate a single row
        repeat(3) @(posedge clk);

        // Display the 1st row results
        $display("ofmap %5d %5d %5d",
            ofmap[0 +: BITWIDTH],
            ofmap[BITWIDTH +: BITWIDTH],
            ofmap[2*BITWIDTH +: BITWIDTH]
        );
        repeat(3) @(posedge clk);

        $display("--- FINAL OUTPUT ---\nofmap %5d %5d %5d\n\n",
            ofmap[0 +: BITWIDTH],
            ofmap[BITWIDTH +: BITWIDTH],
            ofmap[2*BITWIDTH +: BITWIDTH]
        );
        $finish;
    end

endmodule
