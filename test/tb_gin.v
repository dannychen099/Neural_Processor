`timescale 1ns/10ps

module tb();
    parameter BITWIDTH              = 16;
    parameter TAG_LENGTH            = 10;
    parameter X_LENGTH              = 4;
    parameter Y_LENGTH              = 4;
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
    wire [BITWIDTH*X_LENGTH*Y_LENGTH-1:0] pe_value;   // Value sent to (or retrieved from) PE

    // Simulate scan chain data stored in memory;
    wire [TAG_LENGTH-1:0]   scan_chain_data [0:Y_LENGTH+Y_LENGTH*X_LENGTH-1];

    // There's gotta be a better way...
    assign scan_chain_data[19] = 'd0;
    assign scan_chain_data[18] = 'd1;
    assign scan_chain_data[17] = 'd2;
    assign scan_chain_data[16] = 'd3;
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
        .scan_tag_in    (scan_tag_in),
        .scan_tag_out   (scan_tag_out),
        .gin_enable     (gin_enable),
        .gin_ready      (gin_ready),
        .data_packet    (data_packet),
        .pe_enable      (pe_enable),
        .pe_ready       (pe_ready),
        .pe_value       (pe_value)
    );

    always #(CLK_PERIOD) clk = ~clk;

    // Construct the data packet
    assign data_packet = {row_tag, col_tag, data};

    integer row;
    integer col;
    integer i;

    initial begin
        $monitor(tb_gin.y_bus.scan_tag_next_bus);
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
/*
        $display("Scan Chain Data Memory Contents:");
        for (i = 0; i < Y_LENGTH+Y_LENGTH*X_LENGTH; i = i + 1) begin
            $display("\tscan_chain_data[%2d]: %2d", i, scan_chain_data[i]);
        end
*/
        // Begin programming
        gin_enable  <= 'b1;
        pe_ready    <= ~'b0;    // Simulate that all PEs are ready
        $display("Programming...");
        program     <= 'b1;
        for (i = 0; i < Y_LENGTH+Y_LENGTH*X_LENGTH; i = i + 1) begin
            //scan_tag_in <= scan_chain_data[i];
            scan_tag_in <= i;
            repeat (1) @(posedge clk);
            #1;$display("scan_tag_in:       %2d\nscan_tag_next_bus", tb_gin.y_bus.scan_tag_in, tb_gin.y_bus.scan_tag_next_bus, tb_gin.y_bus.mc_vector[1].mc.scan_tag_in);
            $display("Y-bus programmed tag_id: ",
                tb_gin.y_bus.mc_vector[0].mc.tag_id_reg, " ",
                tb_gin.y_bus.mc_vector[1].mc.tag_id_reg, " ",
                tb_gin.y_bus.mc_vector[2].mc.tag_id_reg, " ",
                tb_gin.y_bus.mc_vector[3].mc.tag_id_reg, " ",
                "\n");
        end
        program     <= 'b0;
        

/*
        $display("Sending data...");
        row_tag <= 'd1;
        col_tag <= 'd1;
        data    <= 'd9;

        repeat(1) @(posedge clk);
        for (row = 0; row < Y_LENGTH; row = row + 1) begin
            for (col = 0; col < X_LENGTH; col = col + 1) begin
                $write("%2d ", pe_value[row+col]);
            end
            $display();
        end
*/

        $finish;
    end
endmodule
