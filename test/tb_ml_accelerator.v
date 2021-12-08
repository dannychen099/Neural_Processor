`timescale 1ns/10ps

module tb;
    parameter BITWIDTH          = 16;
    parameter SRAM_ADDR_LENGTH  = 3;
    parameter GLB_ADDR_LENGTH   = 3;
    parameter PE_Y_SIZE         = 3;
    parameter PE_X_SIZE         = 3;
    parameter TAG_LENGTH        = 4;
    parameter PACKET_LENGTH     = 2*TAG_LENGTH + BITWIDTH;
    parameter NUM_PE            = PE_Y_SIZE*PE_X_SIZE;
    parameter CLK_PERIOD        = 10;

    reg                                     clk;
    reg                                     rstb;
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
    wire [TAG_LENGTH-1:0]             scan_chain_output_ifmap;
    reg  [TAG_LENGTH-1:0]             scan_chain_input_filter;
    wire [TAG_LENGTH-1:0]             scan_chain_output_filter;

    reg                     program;
    reg                     enable;
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
        .SRAM_ADDR_LENGTH   (SRAM_ADDR_LENGTH),
        .GLB_ADDR_LENGTH    (GLB_ADDR_LENGTH),
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
        .scan_chain_output_ifmap(scan_chain_output_ifmap),
        .scan_chain_input_filter(scan_chain_input_filter),
        .scan_chain_output_filter(scan_chain_output_filter),
        .enable             (enable),
        .ready              (ready),
        .program            (program)
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
                tb_dut.gin_filter.x_bus_vector[0].x_bus.mc_vector[0].mc.controller_enable,
                tb_dut.gin_filter.x_bus_vector[0].x_bus.mc_vector[0].mc.target_ready,
                tb_dut.gin_filter.x_bus_vector[0].x_bus.mc_vector[0].mc.tag_id_reg,
                tb_dut.gin_filter.x_bus_vector[0].x_bus.mc_vector[0].mc.tag,
                tb_dut.gin_filter.x_bus_vector[0].x_bus.mc_vector[0].mc.target_enable);

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
            $display(tb_dut.pe_row[0].pe_col[0].pe_unit.filter_fifo.memory[0]);
            $display(tb_dut.pe_row[0].pe_col[1].pe_unit.filter_fifo.memory[0]);
            $display(tb_dut.pe_row[0].pe_col[2].pe_unit.filter_fifo.memory[0]);

            $display(tb_dut.pe_row[1].pe_col[0].pe_unit.filter_fifo.memory[0]);
            $display(tb_dut.pe_row[1].pe_col[1].pe_unit.filter_fifo.memory[0]);
            $display(tb_dut.pe_row[1].pe_col[2].pe_unit.filter_fifo.memory[0]);
            
            $display(tb_dut.pe_row[2].pe_col[0].pe_unit.filter_fifo.memory[0]);
            $display(tb_dut.pe_row[2].pe_col[1].pe_unit.filter_fifo.memory[0]);
            $display(tb_dut.pe_row[2].pe_col[2].pe_unit.filter_fifo.memory[0]);
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
            $display("\tfilter");
            $display("\t\tenable: %1b, ready: %1b", tb_dut.gin_filter.gin_enable, tb_dut.gin_filter.gin_ready);
            $display("\t\tdata_packet %24b", tb_dut.gin_filter.data_packet);
            $display("\tifmap:");
            $display("\t\tenable: %1b, ready: %1b", tb_dut.gin_ifmap.gin_enable, tb_dut.gin_ifmap.gin_ready);
            $display("\t\tdata_packet %24b", tb_dut.gin_ifmap.data_packet);
            
            $display("At Y-bus bus:");
            $display("enable: %1b, ready: %1b", tb_dut.gin_filter.y_bus.bus_enable, tb_dut.gin_filter.y_bus.bus_ready);
            $display("data_packet %20b", tb_dut.gin_filter.y_bus.data_source);

            $display("At X-bus:");
            $display("enable: %1b, ready: %1b", tb_dut.gin_filter.x_bus_vector[0].x_bus.bus_enable, tb_dut.gin_filter.x_bus_vector[0].x_bus.bus_ready);
            $display("data_packet %16d", tb_dut.gin_filter.x_bus_vector[0].x_bus.data_source);
        end
    endtask

    task display_input
        (
            input   [BITWIDTH-1:0]  filter,
            input   [BITWIDTH-1:0]  ifmap
        );
        $display("filter = %5d, ifmap = %5d", filter, ifmap);
    endtask

    task pe_diag;
        begin
            
            $display("filter:%5d ifmap:%5d input_psum:%5d output_psum:%5d state:%1d", 
                tb_dut.pe_row[0].pe_col[0].pe_unit.filter,
                tb_dut.pe_row[0].pe_col[0].pe_unit.ifmap,
                tb_dut.pe_row[0].pe_col[0].pe_unit.input_psum,
                tb_dut.pe_row[0].pe_col[0].pe_unit.output_psum,
                tb_dut.pe_row[0].pe_col[0].pe_unit.pe_state);

            $display("\n");
        end
    endtask


    always #(CLK_PERIOD) clk = ~clk;

    initial begin
        $monitor("ofmap:\t%5d %5d %5d", ofmap[0 +: BITWIDTH], ofmap[BITWIDTH +: BITWIDTH], ofmap[2*BITWIDTH +: BITWIDTH]);

        clk         <= 'b0;
        rstb        <= 'b0;
        ifmap_row   <= 'b0;
        ifmap_col   <= 'b0;
        filter_row  <= 'b0;
        filter_col  <= 'b0;
        ifmap       <= 'sd0;
        filter      <= 'sd0;
        enable      <= 'b0;
        program     <= 'b0;

        repeat (1) @(posedge clk);
        rstb        <= 'b1;

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

        
        
        enable      <= 'b1;
        // Send filter row 0 
        filter_row  <= 'd0;
        filter_col  <= 'd0;
        filter      <= 'sd10;    // filter(0,0)
        repeat (1) @(posedge clk);
        pe_diag;
        

        filter_row  <= 'b0;
        filter_col  <= 'b0;
        filter      <= 'sd1;    // filter(0,1)
        repeat (1) @(posedge clk);
        pe_diag;

        filter_row  <= 'b0;
        filter_col  <= 'b0;
        filter      <= 'sd2;    // filter(0,2)
        repeat (1) @(posedge clk);
        pe_diag;


        // Send filter row 1 
        filter_row  <= 'b0;
        filter_col  <= 'b0;
        filter      <= 'sd1;    // filter(1,0)
        repeat (1) @(posedge clk);
        pe_diag;

        filter_row  <= 'b0;
        filter_col  <= 'b0;
        filter      <= 'sd2;    // filter(1,1)
        repeat (1) @(posedge clk);
        pe_diag;

        filter_row  <= 'b0;
        filter_col  <= 'b0;
        filter      <= 'sd3;    // filter(1,2)
        repeat (1) @(posedge clk);
        pe_diag;

        
        // Send filter row 2 
        filter_row  <= 'b0;
        filter_col  <= 'b0;
        filter      <= 'sd2;    // filter(2,0)
        repeat (1) @(posedge clk);
        pe_diag;

        filter_row  <= 'b0;
        filter_col  <= 'b0;
        filter      <= 'sd3;    // filter(2,1)
        repeat (1) @(posedge clk);
        pe_diag;

        filter_row  <= 'b0;
        filter_col  <= 'b0;
        filter      <= 'sd4;    // filter(2,2)
        repeat (1) @(posedge clk);
        pe_diag;


        // Send ifmap row 0, columns 0 - 3
        ifmap_row   <= 'd0;
        ifmap_col   <= 'd0;
        ifmap       <= 'sd0;    // ifmap(0,0)
        repeat (1) @(posedge clk);
        pe_diag;

        ifmap_row   <= 'd0;
        ifmap_col   <= 'd1;
        ifmap       <= 'sd1;    // ifmap(0,1)
        repeat (1) @(posedge clk);
        pe_diag;

        ifmap_row   <= 'd0;
        ifmap_col   <= 'd2;
        ifmap       <= 'sd2;    // ifmap(0,2)
        repeat (1) @(posedge clk);
        pe_diag;

        ifmap_row   <= 'd0;
        ifmap_col   <= 'd0;
        ifmap       <= 'sd1;    // ifmap(0,1)
        repeat (1) @(posedge clk);

        ifmap_row   <= 'd0;
        ifmap_col   <= 'd1;
        ifmap       <= 'sd2;    // ifmap(0,2)
        repeat (1) @(posedge clk);

        ifmap_row   <= 'd0;
        ifmap_col   <= 'd2;
        ifmap       <= 'sd3;    // ifmap(0,3)
        repeat (1) @(posedge clk);

        ifmap_row   <= 'd0;
        ifmap_col   <= 'd0;
        ifmap       <= 'sd2;    // ifmap(0,2)
        repeat (1) @(posedge clk);

        ifmap_row   <= 'd0;
        ifmap_col   <= 'd1;
        ifmap       <= 'sd3;    // ifmap(0,3)
        repeat (1) @(posedge clk);

        ifmap_row   <= 'd0;
        ifmap_col   <= 'd2;
        ifmap       <= 'sd4;    // ifmap(0,4)
        repeat (1) @(posedge clk);


        /*

        // Send ifmap row 1
        ifmap_row   <= 'd0;
        ifmap_col   <= 'd3;
        ifmap       <= 'sd3;    // ifmap(1,0)
        repeat (1) @(posedge clk);


        ifmap_row   <= 'd0;
        ifmap_col   <= 'd4;
        ifmap       <= 'sd4;    // ifmap(1,1)
        repeat (1) @(posedge clk);

        ifmap_row   <= 'd0;
        ifmap_col   <= 'd5;
        ifmap       <= 'sd5;    // ifmap(1,2)
        repeat (1) @(posedge clk);

        
        // Send ifmap row 2 
        ifmap_row   <= 'd0;
        ifmap_col   <= 'd0;
        ifmap       <= 'sd2;    // ifmap(2,0)
        repeat (1) @(posedge clk);

        ifmap_row   <= 'd0;
        ifmap_col   <= 'd0;
        ifmap       <= 'sd3;    // ifmap(2,1)
        repeat (1) @(posedge clk);

        ifmap_row   <= 'd0;
        ifmap_col   <= 'd0;
        ifmap       <= 'sd4;    // ifmap(2,2)
        repeat (1) @(posedge clk);
        */

        repeat (5) @(posedge clk);

        #1 $display(tb_dut.pe_row[0].pe_col[0].pe_unit.output_psum);
        $display("ofmap: %5d", ofmap[0*BITWIDTH +: BITWIDTH]);
        $finish;
    end

endmodule
