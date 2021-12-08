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

    ml_accelerator
    #(
        .BITWIDTH           (BITWIDTH),
        .PE_Y_SIZE          (PE_Y_SIZE),
        .PE_X_SIZE          (PE_X_SIZE),
        .TAG_LENGTH         (TAG_LENGTH)
    )
    tb_dut
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


    task display_gin_diag;
        begin
            $display("X-bus target_enable = %b & %b & (%b == %b) : %b",
                tb_dut.gin_filter.y_bus.mc_vector[0].mc.controller_enable,
                tb_dut.gin_filter.y_bus.mc_vector[0].mc.target_ready,
                tb_dut.gin_filter.y_bus.mc_vector[0].mc.tag_id_reg,
                tb_dut.gin_filter.y_bus.mc_vector[0].mc.tag,
                tb_dut.gin_filter.y_bus.mc_vector[0].mc.target_enable);
            $display("PE target_enable = %b & %b & (%b == %b) : %b",
                tb_dut.gin_filter.x_bus_vector[1].x_bus.mc_vector[0].mc.controller_enable,
                tb_dut.gin_filter.x_bus_vector[1].x_bus.mc_vector[0].mc.target_ready,
                tb_dut.gin_filter.x_bus_vector[1].x_bus.mc_vector[0].mc.tag_id_reg,
                tb_dut.gin_filter.x_bus_vector[1].x_bus.mc_vector[0].mc.tag,
                tb_dut.gin_filter.x_bus_vector[1].x_bus.mc_vector[0].mc.target_enable);

            $display("y_bus_output:%b", tb_dut.gin_filter.y_bus.output_value);
            $display("x_data_packet[0]:%b", tb_dut.gin_filter.x_data_packet[0]);
            $display("x_value_to_pass[0]:%b", tb_dut.gin_filter.x_value_to_pass[0]);
            $display("x_bus_output[0]:%b", tb_dut.gin_filter.x_bus_output[0]);

            $display("\nX-Bus Vector Given from Y:\n\tEnable:%b, Ready:%b",
                tb_dut.gin_filter.x_bus_enable, tb_dut.gin_filter.x_bus_ready);
            $display("PE vector given from Xbus0:\n\tEnable:%b, Ready:%b",
                tb_dut.gin_filter.x_bus_vector[0].x_bus.target_enable,
                tb_dut.gin_filter.x_bus_vector[0].x_bus.target_ready);
            $display("\nX-Bus0 Controller Status\n\tEnable:%b, Ready:%b",
                tb_dut.gin_filter.x_bus_vector[0].x_bus.mc_vector[0].mc.controller_enable,
                tb_dut.gin_filter.x_bus_vector[0].x_bus.mc_vector[0].mc.controller_ready);
            $display("X-Bus0 Target Status (PE0)\n\tEnable:%b, Ready:%b",
                tb_dut.gin_filter.x_bus_vector[0].x_bus.mc_vector[0].mc.target_enable,
                tb_dut.gin_filter.x_bus_vector[0].x_bus.mc_vector[0].mc.target_ready);
        end
    endtask


    task display_pe_memory;
        begin
            $display(
                "%5d %5d %5d\t%5d %5d %5d\n",
                tb_dut.pe_row[0].pe_col[0].pe_unit.filter_fifo.memory[0],
                tb_dut.pe_row[0].pe_col[1].pe_unit.filter_fifo.memory[0],
                tb_dut.pe_row[0].pe_col[2].pe_unit.filter_fifo.memory[0],
                tb_dut.pe_row[0].pe_col[0].pe_unit.ifmap_fifo.memory[0],
                tb_dut.pe_row[0].pe_col[1].pe_unit.ifmap_fifo.memory[0],
                tb_dut.pe_row[0].pe_col[2].pe_unit.ifmap_fifo.memory[0],
                "%5d %5d %5d\t%5d %5d %5d\n",
                tb_dut.pe_row[1].pe_col[0].pe_unit.filter_fifo.memory[0],
                tb_dut.pe_row[1].pe_col[1].pe_unit.filter_fifo.memory[0],
                tb_dut.pe_row[1].pe_col[2].pe_unit.filter_fifo.memory[0],
                tb_dut.pe_row[1].pe_col[0].pe_unit.ifmap_fifo.memory[0],
                tb_dut.pe_row[1].pe_col[1].pe_unit.ifmap_fifo.memory[0],
                tb_dut.pe_row[1].pe_col[2].pe_unit.ifmap_fifo.memory[0],
                "%5d %5d %5d\t%5d %5d %5d\n",
                tb_dut.pe_row[2].pe_col[0].pe_unit.filter_fifo.memory[0],
                tb_dut.pe_row[2].pe_col[1].pe_unit.filter_fifo.memory[0],
                tb_dut.pe_row[2].pe_col[2].pe_unit.filter_fifo.memory[0],
                tb_dut.pe_row[2].pe_col[0].pe_unit.ifmap_fifo.memory[0],
                tb_dut.pe_row[2].pe_col[1].pe_unit.ifmap_fifo.memory[0],
                tb_dut.pe_row[2].pe_col[2].pe_unit.ifmap_fifo.memory[0]);
        end
    endtask

    task display_gin_ifmap;
        begin
            $display("GIN (ifmap) Y-Bus and X-Bus Programmed Tag IDs:");
            $write(" |\n%2d----->", tb_dut.gin_ifmap.y_bus.mc_vector[0].mc.tag_id_reg);
            $write("%d ", tb_dut.gin_ifmap.x_bus_vector[0].x_bus.mc_vector[0].mc.tag_id_reg);
            $write("%d ", tb_dut.gin_ifmap.x_bus_vector[0].x_bus.mc_vector[1].mc.tag_id_reg);
            $write("%d ", tb_dut.gin_ifmap.x_bus_vector[0].x_bus.mc_vector[2].mc.tag_id_reg, "\n |");
            $write("\n%2d----->", tb_dut.gin_ifmap.y_bus.mc_vector[1].mc.tag_id_reg);
            $write("%d ", tb_dut.gin_ifmap.x_bus_vector[1].x_bus.mc_vector[0].mc.tag_id_reg);
            $write("%d ", tb_dut.gin_ifmap.x_bus_vector[1].x_bus.mc_vector[1].mc.tag_id_reg);
            $write("%d ", tb_dut.gin_ifmap.x_bus_vector[1].x_bus.mc_vector[2].mc.tag_id_reg, "\n |");
            $write("\n%2d----->", tb_dut.gin_ifmap.y_bus.mc_vector[2].mc.tag_id_reg);
            $write("%d ", tb_dut.gin_ifmap.x_bus_vector[2].x_bus.mc_vector[0].mc.tag_id_reg);
            $write("%d ", tb_dut.gin_ifmap.x_bus_vector[2].x_bus.mc_vector[1].mc.tag_id_reg);
            $write("%d ", tb_dut.gin_ifmap.x_bus_vector[2].x_bus.mc_vector[2].mc.tag_id_reg, "\n\n");
        end
    endtask

    task display_gin_filter;
        begin
            $display("GIN (filter) Y-Bus and X-Bus Programmed Tag IDs:");
            $write(" |\n%2d----->", tb_dut.gin_filter.y_bus.mc_vector[0].mc.tag_id_reg);
            $write("%d ", tb_dut.gin_filter.x_bus_vector[0].x_bus.mc_vector[0].mc.tag_id_reg);
            $write("%d ", tb_dut.gin_filter.x_bus_vector[0].x_bus.mc_vector[1].mc.tag_id_reg);
            $write("%d ", tb_dut.gin_filter.x_bus_vector[0].x_bus.mc_vector[2].mc.tag_id_reg, "\n |");
            $write("\n%2d----->", tb_dut.gin_filter.y_bus.mc_vector[1].mc.tag_id_reg);
            $write("%d ", tb_dut.gin_filter.x_bus_vector[1].x_bus.mc_vector[0].mc.tag_id_reg);
            $write("%d ", tb_dut.gin_filter.x_bus_vector[1].x_bus.mc_vector[1].mc.tag_id_reg);
            $write("%d ", tb_dut.gin_filter.x_bus_vector[1].x_bus.mc_vector[2].mc.tag_id_reg, "\n |");
            $write("\n%2d----->", tb_dut.gin_filter.y_bus.mc_vector[2].mc.tag_id_reg);
            $write("%d ", tb_dut.gin_filter.x_bus_vector[2].x_bus.mc_vector[0].mc.tag_id_reg);
            $write("%d ", tb_dut.gin_filter.x_bus_vector[2].x_bus.mc_vector[1].mc.tag_id_reg);
            $write("%d ", tb_dut.gin_filter.x_bus_vector[2].x_bus.mc_vector[2].mc.tag_id_reg, "\n\n");
        end
    endtask

    task gin_diag;
        begin
            $display("Top Level GIN:");
            $display("\tfilter\n\t\tenable: %1b, ready: %1b\n\t\tdata_packet %24b",
                tb_dut.gin_filter.gin_enable,
                tb_dut.gin_filter.gin_ready,
                tb_dut.gin_filter.data_packet,
                "\n\tifmap\n\t\tenable: %1b, ready: %1b\n\t\tdata_packet %24b",
                tb_dut.gin_ifmap.gin_enable,
                tb_dut.gin_ifmap.gin_ready,
                tb_dut.gin_ifmap.data_packet);
            
            $display("Y-bus:");
            $display("\tfilter\n\t\tenable: %1b, ready: %1b\n\t\tdata_packet %24b",
                tb_dut.gin_filter.y_bus.bus_enable,
                tb_dut.gin_filter.y_bus.bus_ready,
                tb_dut.gin_filter.y_bus.data_source,
                "\n\tifmap\n\t\tenable: %1b, ready: %1b\n\t\tdata_packet %24b",
                tb_dut.gin_ifmap.y_bus.bus_enable,
                tb_dut.gin_ifmap.y_bus.bus_ready,
                tb_dut.gin_ifmap.y_bus.data_source);

            $display("X-bus:");
            $display("\tfilter\n\t\tenable: %1b, ready: %1b\n\t\tdata_packet %24b",
                tb_dut.gin_filter.x_bus_vector[2].x_bus.bus_enable,
                tb_dut.gin_filter.x_bus_vector[2].x_bus.bus_ready,
                tb_dut.gin_filter.x_bus_vector[2].x_bus.data_source,
                "\n\tifmap\n\t\tenable: %1b, ready: %1b\n\t\tdata_packet %24b",
                tb_dut.gin_ifmap.x_bus_vector[2].x_bus.bus_enable,
                tb_dut.gin_ifmap.x_bus_vector[2].x_bus.bus_ready,
                tb_dut.gin_ifmap.x_bus_vector[2].x_bus.data_source);
        end
    endtask

    task display_input
        (
            input   [BITWIDTH-1:0]  filter,
            input   [BITWIDTH-1:0]  ifmap
        );
        $display("filter=%2d, ifmap=%2d", filter, ifmap);
    endtask

    task pe_diag;
        begin
            $display("filter:     %5d\nifmap:      %5d\ninput_psum: %5d\noutput_psum:%5d\nstate:     \t%1d\n", 
                tb_dut.pe_row[1].pe_col[0].pe_unit.filter,
                tb_dut.pe_row[1].pe_col[0].pe_unit.ifmap,
                tb_dut.pe_row[1].pe_col[0].pe_unit.input_psum,
                tb_dut.pe_row[1].pe_col[0].pe_unit.output_psum,
                tb_dut.pe_row[1].pe_col[0].pe_unit.pe_state);
        end
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

        display_gin_ifmap;
        display_gin_filter;

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
        pe_diag;
        display_pe_memory;
        //gin_diag;

        filter_row  <= 'd0;     // f21, f22, f23
        filter_col  <= 'd0;
        filter      <= 'sd1;
        
        ifmap_row   <= 'd0;     // if12, if21
        ifmap_col   <= 'd1;
        ifmap       <= 'sd1;
        repeat (1) @(posedge clk);
        #1 display_input(filter, ifmap);
        pe_diag;
        display_pe_memory;

        filter_row  <= 'd0;     // f31, f32, f33
        filter_col  <= 'd0;
        filter      <= 'sd2;
        
        ifmap_row   <= 'd0;     // if31, if22, if13
        ifmap_col   <= 'd2;
        ifmap       <= 'sd2;
        repeat (1) @(posedge clk);
        #1 display_input(filter, ifmap);
        gin_enable_filter <= 'b0;
        pe_diag;
        display_pe_memory;
        
        ifmap_row   <= 'd0;     // if32, if23
        ifmap_col   <= 'd3;
        ifmap       <= 'sd3;
        repeat (1) @(posedge clk);
        display_input('bz, ifmap);
        pe_diag;
        display_pe_memory;
        
        ifmap_row   <= 'd0;     // if33
        ifmap_col   <= 'd4;
        ifmap       <= 'sd4;
        repeat (1) @(posedge clk);
        gin_enable_ifmap    <= 'b0;
        display_input('bz, ifmap);
        pe_diag;
        display_pe_memory;


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
        pe_diag;
        display_pe_memory;
        
        filter_row  <= 'd0;     // f21, f22, f23
        filter_col  <= 'd1;
        filter      <= 'sd2;
        
        ifmap_row   <= 'd0;     // if12, if21
        ifmap_col   <= 'd1;
        ifmap       <= 'sd2;
        repeat (1) @(posedge clk);
        pe_diag;
        display_pe_memory;

        filter_row  <= 'd0;     // f31, f32, f33
        filter_col  <= 'd1;
        filter      <= 'sd3;
        
        ifmap_row   <= 'd0;     // if31, if22, if13
        ifmap_col   <= 'd2;
        ifmap       <= 'sd3;
        display_input(filter, ifmap);
        repeat (1) @(posedge clk);
        pe_diag;
        gin_enable_filter <= 'b0;
        display_pe_memory;
        
        ifmap_row   <= 'd0;     // if32, if23
        ifmap_col   <= 'd3;
        ifmap       <= 'sd4;
        repeat (1) @(posedge clk);
        pe_diag;
        display_pe_memory;
        
        ifmap_row   <= 'd0;     // if33
        ifmap_col   <= 'd4;
        ifmap       <= 'sd5;
        repeat (1) @(posedge clk);
        pe_diag;
        gin_enable_ifmap    <= 'b0;
        display_pe_memory;

        
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
        pe_diag;
        display_pe_memory;
        
        filter_row  <= 'd0;     // f21, f22, f23
        filter_col  <= 'd2;
        filter      <= 'sd3;
        
        ifmap_row   <= 'd0;     // if12, if21
        ifmap_col   <= 'd1;
        ifmap       <= 'sd3;
        repeat (1) @(posedge clk);
        pe_diag;
        display_pe_memory;

        filter_row  <= 'd0;     // f31, f32, f33
        filter_col  <= 'd2;
        filter      <= 'sd4;
        
        ifmap_row   <= 'd0;     // if31, if22, if13
        ifmap_col   <= 'd2;
        ifmap       <= 'sd4;
        repeat (1) @(posedge clk);
        pe_diag;
        gin_enable_filter <= 'b0;
        display_pe_memory;
        
        $display("--- NOTE ---\nChange state on next cycle\n");
        ifmap_row   <= 'd0;     // if32, if23
        ifmap_col   <= 'd3;
        ifmap       <= 'sd5;
        repeat (1) @(posedge clk);
        pe_diag;
        display_pe_memory;
        
        ifmap_row   <= 'd0;     // if33
        ifmap_col   <= 'd4;
        ifmap       <= 'sd6;
        repeat (1) @(posedge clk);
        pe_diag;
        gin_enable_ifmap    <= 'b0;
        display_pe_memory;

        // Takes 3 clock cycles to calculate a single row
        repeat(3) @(posedge clk) pe_diag;

        // Display the 1st row results
        $display("ofmap %5d %5d %5d",
            ofmap[0 +: BITWIDTH],
            ofmap[BITWIDTH +: BITWIDTH],
            ofmap[2*BITWIDTH +: BITWIDTH]
        );

        // The 2nd and 3rd ofmap columns were delayed by 1 clock cycle during
        // programming, so we need 2 more clock cycles to finish the ofmap
        // row. Note that more than 2 clock cycles will mess with things
        repeat(2) @(posedge clk)
        pe_diag;

        $display("--- FINAL OUTPUT --- ofmap %5d %5d %5d",
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
        pe_diag;
        display_pe_memory;
        //gin_diag;

        filter_row  <= 'd0;     // f21, f22, f23
        filter_col  <= 'd0;
        filter      <= 'sd1;
        
        ifmap_row   <= 'd0;     // if12, if21
        ifmap_col   <= 'd1;
        ifmap       <= 'sd2;
        repeat (1) @(posedge clk);
        #1 display_input(filter, ifmap);
        pe_diag;
        display_pe_memory;

        filter_row  <= 'd0;     // f31, f32, f33
        filter_col  <= 'd0;
        filter      <= 'sd2;
        
        ifmap_row   <= 'd0;     // if31, if22, if13
        ifmap_col   <= 'd2;
        ifmap       <= 'sd3;
        repeat (1) @(posedge clk);
        #1 display_input(filter, ifmap);
        gin_enable_filter <= 'b0;
        pe_diag;
        display_pe_memory;
        
        ifmap_row   <= 'd0;     // if32, if23
        ifmap_col   <= 'd3;
        ifmap       <= 'sd4;
        repeat (1) @(posedge clk);
        display_input('bz, ifmap);
        pe_diag;
        display_pe_memory;
        
        ifmap_row   <= 'd0;     // if33
        ifmap_col   <= 'd4;
        ifmap       <= 'sd5;
        repeat (1) @(posedge clk);
        gin_enable_ifmap    <= 'b0;
        display_input('bz, ifmap);
        pe_diag;
        display_pe_memory;


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
        pe_diag;
        display_pe_memory;
        
        filter_row  <= 'd0;     // f21, f22, f23
        filter_col  <= 'd1;
        filter      <= 'sd2;
        
        ifmap_row   <= 'd0;     // if12, if21
        ifmap_col   <= 'd1;
        ifmap       <= 'sd3;
        repeat (1) @(posedge clk);
        pe_diag;
        display_pe_memory;

        filter_row  <= 'd0;     // f31, f32, f33
        filter_col  <= 'd1;
        filter      <= 'sd3;
        
        ifmap_row   <= 'd0;     // if31, if22, if13
        ifmap_col   <= 'd2;
        ifmap       <= 'sd4;
        display_input(filter, ifmap);
        repeat (1) @(posedge clk);
        pe_diag;
        gin_enable_filter <= 'b0;
        display_pe_memory;
        
        ifmap_row   <= 'd0;     // if32, if23
        ifmap_col   <= 'd3;
        ifmap       <= 'sd5;
        repeat (1) @(posedge clk);
        pe_diag;
        display_pe_memory;
        
        ifmap_row   <= 'd0;     // if33
        ifmap_col   <= 'd4;
        ifmap       <= 'sd6;
        repeat (1) @(posedge clk);
        pe_diag;
        gin_enable_ifmap    <= 'b0;
        display_pe_memory;

        
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
        pe_diag;
        display_pe_memory;
        
        filter_row  <= 'd0;     // f21, f22, f23
        filter_col  <= 'd2;
        filter      <= 'sd3;
        
        ifmap_row   <= 'd0;     // if12, if21
        ifmap_col   <= 'd1;
        ifmap       <= 'sd4;
        repeat (1) @(posedge clk);
        pe_diag;
        display_pe_memory;

        filter_row  <= 'd0;     // f31, f32, f33
        filter_col  <= 'd2;
        filter      <= 'sd4;
        
        ifmap_row   <= 'd0;     // if31, if22, if13
        ifmap_col   <= 'd2;
        ifmap       <= 'sd5;
        repeat (1) @(posedge clk);
        pe_diag;
        gin_enable_filter <= 'b0;
        display_pe_memory;
        
        $display("--- NOTE ---\nChange state on next cycle\n");
        ifmap_row   <= 'd0;     // if32, if23
        ifmap_col   <= 'd3;
        ifmap       <= 'sd6;
        repeat (1) @(posedge clk);
        pe_diag;
        display_pe_memory;
        
        ifmap_row   <= 'd0;     // if33
        ifmap_col   <= 'd4;
        ifmap       <= 'sd7;
        repeat (1) @(posedge clk);
        pe_diag;
        gin_enable_ifmap    <= 'b0;
        display_pe_memory;

        // Takes 3 clock cycles to calculate a single row
        repeat(3) @(posedge clk) pe_diag;

        // Display the 1st row results
        $display("ofmap: %5d %5d %5d",
            tb_dut.pe_row[0].pe_col[0].pe_unit.output_psum,
            tb_dut.pe_row[0].pe_col[1].pe_unit.output_psum,
            tb_dut.pe_row[0].pe_col[2].pe_unit.output_psum);

        repeat(2) @(posedge clk)
        pe_diag;
        $display("ofmap: %5d %5d %5d",
            tb_dut.pe_row[0].pe_col[0].pe_unit.output_psum,
            tb_dut.pe_row[0].pe_col[1].pe_unit.output_psum,
            tb_dut.pe_row[0].pe_col[2].pe_unit.output_psum);

        $display("--- FINAL OUTPUT --- ofmap %5d %5d %5d",
            ofmap[0 +: BITWIDTH],
            ofmap[BITWIDTH +: BITWIDTH],
            ofmap[2*BITWIDTH +: BITWIDTH]
        );
        $finish;
    end

endmodule
