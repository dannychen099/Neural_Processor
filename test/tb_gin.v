`timescale 1ns/10ps

//`define DIAG  // Uncomment for more verbose output

module tb();
    parameter BITWIDTH              = 16;
    parameter TAG_LENGTH            = 4;
    parameter X_LENGTH              = 4;
    parameter Y_LENGTH              = 4;
    parameter COL_TAG_MAX           = 6;
    parameter ROW_TAG_MAX           = 4;
    parameter INPUT_PACKET_LENGTH   = 2*TAG_LENGTH+BITWIDTH;
    parameter NUM_PE                = X_LENGTH*Y_LENGTH;
    parameter CLK_PERIOD            = 10;

    reg                     clk;
    reg                     rstb;

    // GIN bus connections
    reg                             program;
    reg  [TAG_LENGTH-1:0]           scan_tag_in;
    wire [TAG_LENGTH-1:0]           scan_tag_out;
    reg                             gin_enable;
    wire                            gin_ready;
    wire [INPUT_PACKET_LENGTH-1:0]  data_packet;
    reg  [TAG_LENGTH-1:0]           row_tag;
    reg  [TAG_LENGTH-1:0]           col_tag;
    reg  [BITWIDTH-1:0]             data;

    // PE connections
    wire [NUM_PE-1:0]               pe_enable;
    reg  [NUM_PE-1:0]               pe_ready;         // Simulate PE status
    wire [BITWIDTH*X_LENGTH*Y_LENGTH-1:0] pe_value;

    // Simulate scan chain data stored in memory;
    wire [TAG_LENGTH-1:0]   scan_chain_data [0:Y_LENGTH+Y_LENGTH*X_LENGTH-1];

    // Load memory contents. There's gotta be a better way...
    assign scan_chain_data[19] = 'd0;
    assign scan_chain_data[18] = 'd0;
    assign scan_chain_data[17] = 'd0;
    assign scan_chain_data[16] = 'd0;
    assign scan_chain_data[15] = 'd0;
    assign scan_chain_data[14] = 'd1;
    assign scan_chain_data[13] = 'd2;
    assign scan_chain_data[12] = 'd3;
    assign scan_chain_data[11] = 'd1;
    assign scan_chain_data[10] = 'd2;
    assign scan_chain_data[9] = 'd3;
    assign scan_chain_data[8] = 'd4;
    assign scan_chain_data[7] = 'd2;
    assign scan_chain_data[6] = 'd3;
    assign scan_chain_data[5] = 'd4;
    assign scan_chain_data[4] = 'd5;
    assign scan_chain_data[3] = 'd3;
    assign scan_chain_data[2] = 'd4;
    assign scan_chain_data[1] = 'd5;
    assign scan_chain_data[0] = 'd6;
    
    gin
    #(
        .BITWIDTH       (BITWIDTH),
        .TAG_LENGTH     (TAG_LENGTH),
        .X_BUS_SIZE     (X_LENGTH),
        .Y_BUS_SIZE     (Y_LENGTH)
    )
    tb_gin
    (
        .clk            (clk),
        .rstb           (rstb),
        .program        (program),
        .scan_tag_in    (scan_tag_in),
        .scan_tag_out   (scan_tag_out),
        .gin_enable     (gin_enable),
        .gin_ready      (gin_ready),
        .data_packet    (data_packet),
        .pe_enable      (pe_enable),
        .pe_ready       (pe_ready),
        .pe_value       (pe_value)
    );
    
    // Some variables for for() loops
    integer row;
    integer col;
    integer i;
    integer j;
   
    //-------------------------------------------------------------------------
    //  Include some task definitions to clean up the test bench code
    //-------------------------------------------------------------------------
    
    // Task definition to display the 0th row and 0th col ID. Includes lots of
    // diagnostic signals that affect signal propogation.
    task display_diag;
        begin
            $display("X-bus target_enable = %b & %b & (%b == %b) : %b",
                tb_gin.y_bus.mc_vector[0].mc.controller_enable,
                tb_gin.y_bus.mc_vector[0].mc.target_ready,
                tb_gin.y_bus.mc_vector[0].mc.tag_id_reg,
                tb_gin.y_bus.mc_vector[0].mc.tag,
                tb_gin.y_bus.mc_vector[0].mc.target_enable);
            $display("PE target_enable = %b & %b & (%b == %b) : %b",
                tb_gin.x_bus_vector[0].x_bus.mc_vector[0].mc.controller_enable,
                tb_gin.x_bus_vector[0].x_bus.mc_vector[0].mc.target_ready,
                tb_gin.x_bus_vector[0].x_bus.mc_vector[0].mc.tag_id_reg,
                tb_gin.x_bus_vector[0].x_bus.mc_vector[0].mc.tag,
                tb_gin.x_bus_vector[0].x_bus.mc_vector[0].mc.target_enable);

            $display("y_data_packet:%24b = {%4b %20b} %24b", 
                tb_gin.data_packet, tb_gin.row_id,
                tb_gin.y_value_to_pass, data_packet);
            $display("y_bus_output:%b", tb_gin.y_bus.output_value);
            $display("x_data_packet[0]:%b", tb_gin.x_data_packet[0]);
            $display("x_value_to_pass[0]:%b", tb_gin.x_value_to_pass[0]);
            $display("x_bus_output[0]:%b", tb_gin.x_bus_output[0]);
            $display("pe_enable:%b\tpe_ready:%b", pe_enable, pe_ready);

            $display("\nX-Bus Vector Given from Y:\n\tEnable:%b, Ready:%b",
                tb_gin.x_bus_enable, tb_gin.x_bus_ready);
            $display("PE vector given from Xbus0:\n\tEnable:%b, Ready:%b",
                tb_gin.x_bus_vector[0].x_bus.target_enable,
                tb_gin.x_bus_vector[0].x_bus.target_ready);
            $display("\nX-Bus0 Controller Status\n\tEnable:%b, Ready:%b",
                tb_gin.x_bus_vector[0].x_bus.mc_vector[0].mc.controller_enable,
                tb_gin.x_bus_vector[0].x_bus.mc_vector[0].mc.controller_ready);
            $display("X-Bus0 Target Status (PE0)\n\tEnable:%b, Ready:%b",
                tb_gin.x_bus_vector[0].x_bus.mc_vector[0].mc.target_enable,
                tb_gin.x_bus_vector[0].x_bus.mc_vector[0].mc.target_ready);
        end
    endtask

    // Task definition to display the scan_chain_data memory
    task display_memory_contents;
        begin
            $display("Scan Chain Data Memory Contents:");
            for (i = 0; i < Y_LENGTH+Y_LENGTH*X_LENGTH; i = i + 1) begin
                $display("\tscan_chain_data[%2d]: %2d", i, scan_chain_data[i]);
            end
        end
    endtask

    // Task definition to display the programmed tag IDs in the GIN
    task display_tag_id;
        begin
            $display("Y-Bus and X-Bus Programmed Tag IDs:");
            $write(" |\n%2d----->", tb_gin.y_bus.mc_vector[0].mc.tag_id_reg);
            $write("%d ", tb_gin.x_bus_vector[0].x_bus.mc_vector[0].mc.tag_id_reg);
            $write("%d ", tb_gin.x_bus_vector[0].x_bus.mc_vector[1].mc.tag_id_reg);
            $write("%d ", tb_gin.x_bus_vector[0].x_bus.mc_vector[2].mc.tag_id_reg);
            $write("%d ", tb_gin.x_bus_vector[0].x_bus.mc_vector[3].mc.tag_id_reg, "\n |");
            $write("\n%2d----->", tb_gin.y_bus.mc_vector[1].mc.tag_id_reg);
            $write("%d ", tb_gin.x_bus_vector[1].x_bus.mc_vector[0].mc.tag_id_reg);
            $write("%d ", tb_gin.x_bus_vector[1].x_bus.mc_vector[1].mc.tag_id_reg);
            $write("%d ", tb_gin.x_bus_vector[1].x_bus.mc_vector[2].mc.tag_id_reg);
            $write("%d ", tb_gin.x_bus_vector[1].x_bus.mc_vector[3].mc.tag_id_reg, "\n |");
            $write("\n%2d----->", tb_gin.y_bus.mc_vector[2].mc.tag_id_reg);
            $write("%d ", tb_gin.x_bus_vector[2].x_bus.mc_vector[0].mc.tag_id_reg);
            $write("%d ", tb_gin.x_bus_vector[2].x_bus.mc_vector[1].mc.tag_id_reg);
            $write("%d ", tb_gin.x_bus_vector[2].x_bus.mc_vector[2].mc.tag_id_reg);
            $write("%d ", tb_gin.x_bus_vector[2].x_bus.mc_vector[3].mc.tag_id_reg, "\n |");
            $write("\n%2d----->", tb_gin.y_bus.mc_vector[3].mc.tag_id_reg);
            $write("%d ", tb_gin.x_bus_vector[3].x_bus.mc_vector[0].mc.tag_id_reg);
            $write("%d ", tb_gin.x_bus_vector[3].x_bus.mc_vector[1].mc.tag_id_reg);
            $write("%d ", tb_gin.x_bus_vector[3].x_bus.mc_vector[2].mc.tag_id_reg);
            $write("%d ", tb_gin.x_bus_vector[3].x_bus.mc_vector[3].mc.tag_id_reg, "\n\n");
        end
    endtask
       

    //-------------------------------------------------------------------------
    //  Simulation section
    //-------------------------------------------------------------------------

    always #(CLK_PERIOD) clk = ~clk;

    // Construct the data packet
    assign data_packet = {row_tag, col_tag, data};

    initial begin
        clk         <= 'b0;
        rstb        <= 'b0;
        rstb        <= 'b1;
        program     <= 'b0;
        scan_tag_in <= 'd0;
        gin_enable  <= 'b0;
        row_tag     <= 'd0;
        col_tag     <= 'd0;
        data        <= 'sd0;
        pe_ready    <= 'b0;
        repeat (1) @(posedge clk);
        
        // Begin programming
        $display("Programming...");
        program     <= 'b1;

        // Push the Y-bus values into the scan chain
        for (i = 0; i < Y_LENGTH; i = i + 1) begin
            scan_tag_in <= scan_chain_data[i];
            repeat (2) @(posedge clk);
        end
        
        // Push each X-bus values into the scan chain
        for (i = Y_LENGTH; i < Y_LENGTH+Y_LENGTH*X_LENGTH; i = i + 1) begin
            scan_tag_in <= scan_chain_data[i];
            repeat (2) @(posedge clk);
        end
        program     <= 'b0;

        `ifdef DIAG
            display_memory_contents;
        `endif
       
        display_tag_id;

        $display("Sending data...");
        gin_enable  <= 'b1;
        pe_ready    <= ~'b0;    // Simulate that all PEs are ready

        for (row = 0; row < 1; row = row + 1) begin // Use ROW_TAG_MAX for full range
            for (col = 0; col <= COL_TAG_MAX; col = col + 1) begin
                data    <= 'd65535;
                row_tag <= row;
                col_tag <= col;
                repeat (1) @(posedge clk);
                
                `ifdef DIAG
                    display_diag;
                `endif

                $display("row_id %2d col_id %2d data %5d\n", row_tag, col_tag, data);

                for (i = 0; i < Y_LENGTH; i = i + 1) begin
                    for (j = 0; j < X_LENGTH; j = j + 1) begin
                        $write("%5d ", pe_value[BITWIDTH*(i*Y_LENGTH+j)+:BITWIDTH]);
                    end
                    $display();
                end
            $display();
            end
            $display();
        end

        $finish;
    end


endmodule

