`timescale 1ns/10ps

module tb();
    parameter   BITWIDTH        = 16;
    parameter   TAG_LENGTH      = 4;
    parameter   NUM_CONTROLLERS = 10;
    parameter   CLK_PERIOD      = 10;

    reg                       clk;
    reg                       rstb;
    reg                       program;
    reg                       enable;
    reg                       unit_ready;
    reg  [TAG_LENGTH-1:0]     tag;
    reg  [TAG_LENGTH-1:0]     scan_tag_in;
    reg  [TAG_LENGTH-1:0]     input_reg;
    wire [BITWIDTH-1:0]       input_value;
    wire [(BITWIDTH)*(NUM_CONTROLLERS)-1:0] output_value;
    wire [NUM_CONTROLLERS-1:0]              unit_enable;

    gin_bus
    #(
        .BITWIDTH           (BITWIDTH),
        .TAG_LENGTH         (TAG_LENGTH),
        .NUM_CONTROLLERS    (NUM_CONTROLLERS)
    )
    tb_gin_bus(
        .clk            (clk),
        .rstb           (rstb),
        .program        (program),
        .enable         (enable),
        .unit_ready     (unit_ready),
        .tag            (tag),
        .scan_tag_in    (scan_tag_in),
        .input_value    (input_value),
        .output_value   (output_value),
        .unit_enable    (unit_enable)
    );

    assign input_value = input_reg;

    always #(CLK_PERIOD) clk = ~clk;

    integer i;

    initial begin
        
        $monitor("tag: ", tag,
            "\tinput_reg ", input_reg,
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
                tb_gin_bus.mc_output[8], " ", tb_gin_bus.mc_output[9], "\n");
        // Initialize simulation
        clk             <= 'b0;
        rstb            <= 'b0;
        rstb            <= 'b1;
        program         <= 'b0;
        enable          <= 'b0;
        unit_ready      <= 'b0;
        tag             <= 'd0;
        scan_tag_in     <= 'd0;
        input_reg       <= 'sd0;
        repeat (1) @(posedge clk);

        // Assume multicast controllers are enabled and ready
        enable          <= 'b1;
        unit_ready      <= 'b1; 
        
        $display("Programming...");
        program         <= 'b1;
        for (i = NUM_CONTROLLERS-1; i >= 0; i = i-1) begin
            scan_tag_in <= i;
            repeat (1) @(posedge clk);
        end

        $display("\n\nProgramming ended... Sending tagged data");
        
        program         <= 'b0;
        repeat (1) @(posedge clk);
        input_reg       <= 'sd13;
        tag             <= 'd3;
        #1;

        $display("unit_enable = %b & (%b == %b) & %b    : %b",
            tb_gin_bus.mc_vector[3].mc.enable,
            tb_gin_bus.mc_vector[3].mc.tag,
            tb_gin_bus.mc_vector[3].mc.tag_id_reg,
            tb_gin_bus.mc_vector[3].mc.unit_ready,
            tb_gin_bus.mc_vector[3].mc.unit_enable);
        $display(tb_gin_bus.mc_vector[3].mc.output_value);
        
        input_reg       <= 'sd11;
        tag             <= 'd1;
        #1;
        
        input_reg       <= 'sd19;
        tag             <= 'd9;
        #1; $finish;
    end

endmodule
