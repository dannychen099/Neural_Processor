`timescale 1ns/10ps

module tb;
    parameter ADDRESS_WIDTH     = 4;
    parameter NEXT_TAG_WIDTH    = 4;
    parameter BITWIDTH          = 16;
    parameter CLK_PERIOD    = 10;

    reg                         rstb;
    reg                         clk;
    reg                         program;
    reg                         enable;
    reg                         unit_ready;
    reg [ADDRESS_WIDTH-1:0]     tag;
    reg [ADDRESS_WIDTH-1:0]     tag_id;
    reg [NEXT_TAG_WIDTH-1:0]    next_tag_id;
    reg [BITWIDTH-1:0]          mc_input_value; 
    
    wire [NEXT_TAG_WIDTH+BITWIDTH-1:0]  input_value;
    wire [NEXT_TAG_WIDTH+BITWIDTH-1:0]  output_value;
    wire                                unit_enable;

    // Test a forward value-passing controller
    multicast_controller #(
        .ADDRESS_WIDTH  (ADDRESS_WIDTH),
        .BITWIDTH       (NEXT_TAG_WIDTH+BITWIDTH)
    )
    mc (
        .rstb           (rstb),
        .clk            (clk),
        .program        (program),
        .enable         (enable),
        .unit_ready     (unit_ready),
        .tag            (tag),
        .tag_id         (tag_id),
        .input_value    (input_value),
        .output_value   (output_value),
        .unit_enable    (unit_enable)
    );

    always #(CLK_PERIOD) clk = ~clk;
    
    // The value 'passed' through is bidrectional. Split the wire in two
    // parts: one containing the value to be passed to the output, but also
    // another containing the tag ID for other controllers backwards on the
    // chain
    assign input_value[BITWIDTH-1:0] = mc_input_value;
    assign output_value[NEXT_TAG_WIDTH+BITWIDTH-1:BITWIDTH] = next_tag_id;

    initial begin
        clk             <= 'b0;
        rstb            <= 'b1;
        program         <= 'b0;
        enable          <= 'b0;
        unit_ready      <= 'b0;
        tag             <= 'd0;
        tag_id          <= 'd0;
        mc_input_value  <= 'd0;
        next_tag_id     <= 'd0;

        repeat (1) @(posedge clk);
        
        $display("Programming...");
        program         <= 'b1;
        tag_id          <= 'd3;
        repeat(1) @(posedge clk);
        program         <= 'b0;
        $display("Programmed ID: ", mc.tag_id_reg);

        enable          <= 'd1;
        unit_ready      <= 'd1;
        
        repeat(1) @(posedge clk);
        
        tag             <= 'd2; // Should do nothing...
        mc_input_value  <= 'd512;
        next_tag_id     <= 'd1;
        repeat(1) @(posedge clk);
        #1; $display("\nTag: ", tag, "\t Input Value: ", mc_input_value);
        $display("Unit Enable: ", unit_enable,
            "\nNext Tag ID: ", output_value[NEXT_TAG_WIDTH+BITWIDTH-1:BITWIDTH],
            "\tOutput Value: ", output_value[BITWIDTH-1:0]);
        
        tag             <= 'd3;
        mc_input_value  <= 'd257;
        next_tag_id     <= 'd2;
        repeat(1) @(posedge clk);
        #1; $display("\nTag: ", tag, "\t Input Value: ", mc_input_value);
        $display("Unit Enable: ", unit_enable,
            "\nNext Tag ID: ", output_value[NEXT_TAG_WIDTH+BITWIDTH-1:BITWIDTH],
            "\tOutput Value: ", output_value[BITWIDTH-1:0]);
        
        tag             <= 'd4;
        mc_input_value  <= 'd33;
        next_tag_id     <= 'd3;
        repeat(1) @(posedge clk);
        #1; $display("\nTag: ", tag, "\t Input Value: ", mc_input_value);
        $display("Unit Enable: ", unit_enable,
            "\nNext Tag ID: ", output_value[NEXT_TAG_WIDTH+BITWIDTH-1:BITWIDTH],
            "\tOutput Value: ", output_value[BITWIDTH-1:0]);
        
        $display("\n");
        #1 $finish;

    end

endmodule
