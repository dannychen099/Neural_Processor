`timescale 1ns/10ps

module tb();
    parameter   BITWIDTH        = 16;
    parameter   TAG_LENGTH      = 4;
    parameter   NUM_CONTROLLERS = 10;
    parameter   CLK_PERIOD      = 10;

    reg                         clk;
    reg                         rstb;
    reg                         program;
    reg  [TAG_LENGTH-1:0]       scan_tag_in;
    reg                         bus_enable;
    reg  [TAG_LENGTH-1:0]       tag;
    reg  [TAG_LENGTH-1:0]       data_source;
    reg  [NUM_CONTROLLERS-1:0]  target_ready;
    
    wire [BITWIDTH-1:0]                     input_value;
    wire [(BITWIDTH*NUM_CONTROLLERS)-1:0]   output_value;
    wire                                    bus_ready;
    wire [NUM_CONTROLLERS-1:0]              target_enable;
    wire [TAG_LENGTH-1:0]                   scan_tag_next_bus;

    gin_bus
    #(
        .BITWIDTH           (BITWIDTH),
        .TAG_LENGTH         (TAG_LENGTH),
        .NUM_CONTROLLERS    (NUM_CONTROLLERS)
    )
    tb_gin_bus(
        .clk                (clk),
        .rstb               (rstb),
        .program            (program),
        .scan_tag_in        (scan_tag_in),
        .scan_tag_next_bus  (scan_tag_next_bus),
        .bus_enable         (bus_enable),
        .bus_ready          (bus_ready),
        .tag                (tag),
        .data_source        (input_value),
        .target_enable      (target_enable),
        .output_value       (output_value),
        .target_ready       (target_ready)
    );

    assign input_value = data_source;

    always #(CLK_PERIOD) clk = ~clk;

    integer i;

    initial begin
        
        $monitor("tag: ", tag,
            "\tdata_source ", data_source,
            "\nprogrammed tag_id:\t",
                tb_gin_bus.mc_vector[0].mc.tag_id_reg, " ",
                tb_gin_bus.mc_vector[1].mc.tag_id_reg, " ",
                tb_gin_bus.mc_vector[2].mc.tag_id_reg, " ",
                tb_gin_bus.mc_vector[3].mc.tag_id_reg, " ",
                tb_gin_bus.mc_vector[4].mc.tag_id_reg, " ",
                tb_gin_bus.mc_vector[5].mc.tag_id_reg, " ",
                tb_gin_bus.mc_vector[6].mc.tag_id_reg, " ",
                tb_gin_bus.mc_vector[7].mc.tag_id_reg, " ",
                tb_gin_bus.mc_vector[8].mc.tag_id_reg, " ",
                tb_gin_bus.mc_vector[9].mc.tag_id_reg, " ",
            "\noutput value:\t ",
                tb_gin_bus.mc_output[0], " ", tb_gin_bus.mc_output[1], " ",
                tb_gin_bus.mc_output[2], " ", tb_gin_bus.mc_output[3], " ",
                tb_gin_bus.mc_output[4], " ", tb_gin_bus.mc_output[5], " ",
                tb_gin_bus.mc_output[6], " ", tb_gin_bus.mc_output[7], " ",
                tb_gin_bus.mc_output[8], " ", tb_gin_bus.mc_output[9], " ",
            "\nscan_tag_next_bus: ", scan_tag_next_bus, "\n");
        
        // Initialize simulation
        clk                 <= 'b0;
        rstb                <= 'b0;
        rstb                <= 'b1;
        program             <= 'b0;
        scan_tag_in         <= 'd0;
        bus_enable          <= 'b0;
        tag                 <= 'd0;
        data_source         <= 'sd0;
        target_ready        <= 'b0;
        repeat (1) @(posedge clk);

        // Assume multicast controllers are enabled and ready
        bus_enable          <= 'b1;
        target_ready        <= ~'b0; 
        $display("Programming...");
        program         <= 'b1;
        for (i = NUM_CONTROLLERS+2; i >= 0; i = i-1) begin
            scan_tag_in <= i;
            repeat (2) @(posedge clk);
        end

        $display("\n\nProgramming ended... Sending tagged data");
        
        program         <= 'b0;
        repeat (1) @(posedge clk);
        data_source       <= 'sd13;
        tag             <= 'd3;
        #1;

        $display(target_ready);        
        $display("unit_enable = %b & %b & (%b == %b) : %b",
            tb_gin_bus.mc_vector[3].mc.controller_enable,
            tb_gin_bus.mc_vector[3].mc.target_ready,
            tb_gin_bus.mc_vector[3].mc.tag_id_reg,
            tb_gin_bus.mc_vector[3].mc.tag,
            tb_gin_bus.mc_vector[3].mc.target_enable);
        $display(tb_gin_bus.mc_vector[3].mc.output_value);
        
        data_source       <= 'sd11;
        tag             <= 'd1;
        #1;
        
        data_source       <= 'sd19;
        tag             <= 'd9;
        #1; $finish;
    end

endmodule
