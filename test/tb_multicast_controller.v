`timescale 1ns/10ps

`define TEST_FORWARD

module tb;
    parameter ADDRESS_WIDTH = 4;
    parameter TAG_WIDTH     = 4;
    parameter BITWIDTH      = 16;
    parameter CLK_PERIOD    = 10;

    // Clock and reset ports
    reg                             clk;
    reg                             rstb;

    // Scan chain configuration
    reg                             program;
    reg  [ADDRESS_WIDTH-1:0]        scan_chain_in;
    wire [ADDRESS_WIDTH-1:0]        scan_chain_out; // Unused port

    // Incoming data side (coming into conroller)
    reg                             controller_enable;
    wire                            controller_ready;
    reg  [ADDRESS_WIDTH-1:0]        tag;
    wire [TAG_WIDTH+BITWIDTH-1:0]   input_value;    // Connection to module
    reg  [BITWIDTH-1:0]             data_source;    // Source of input value
    
    // Outgoing data side (to PE or other bus)
    wire                            target_enable;
    reg                             target_ready;
    wire [TAG_WIDTH+BITWIDTH-1:0]   output_value;
    reg  [TAG_WIDTH-1:0]            next_tag_id;    // Tag address to pass on

    // Test a forward value-passing controller
    multicast_controller #(
        .ADDRESS_WIDTH  (ADDRESS_WIDTH),
        .BITWIDTH       (TAG_WIDTH+BITWIDTH)
    )
    mc (
        .clk                (clk),
        .rstb               (rstb),
        .program            (program),
        .scan_tag_in        (scan_chain_in),
        .scan_tag_out       (scan_chain_out),
        .controller_enable  (controller_enable),
        .controller_ready   (controller_ready),
        .tag                (tag),
        .input_value        (input_value),
        .target_enable      (target_enable),
        .target_ready       (target_ready),
        .output_value       (output_value)
    );

    always #(CLK_PERIOD) clk = ~clk;

    // Check for the forward data passing and reverse data passing, while
    // keeping the next_tag_id intact. Note that for reverse data passing, the
    // output is high z instead of zero.
    `ifdef TEST_FORWARD
        assign input_value[BITWIDTH-1:0]    = data_source;
    `else
        assign output_value[BITWIDTH-1:0]   = data_source;
    `endif
    
    assign input_value[TAG_WIDTH+BITWIDTH-1:BITWIDTH]   = next_tag_id;

    integer i;

    initial begin
        clk                 <= 'b0;
        rstb                <= 'b1;
        program             <= 'b0;
        controller_enable   <= 'b0;
        tag                 <= 'd0;
        data_source         <= 'd0;
        scan_chain_in       <= 'd0;
        next_tag_id         <= 'd0;
        target_ready        <= 'b0;

        repeat (1) @(posedge clk);

        // Test scan chain input/output
        $display("Programming...");
        program             <= 'b1;
        for (i = 0; i < 4; i=i+1) begin
            scan_chain_in   <= i;
            repeat(1) @(posedge clk);
            $display("Programmed ID: ", mc.tag_id_reg,
                "\nScan chain ID output: ", scan_chain_out);
        end
        $display("Programmed ID: ", mc.tag_id_reg);
        
        program             <= 'b0;
        controller_enable   <= 'd1;
        target_ready        <= 'd1;
        repeat(1) @(posedge clk);
        
        tag                 <= 'd2; // Should do nothing...
        data_source         <= 'd512;
        next_tag_id         <= 'd1;
        repeat(1) @(posedge clk);

        #1; $display("\nTag: ", tag, "\t Input Value: ", data_source);
        $display("Unit Enable: ", target_enable,
            "\nNext Tag ID: ", output_value[TAG_WIDTH+BITWIDTH-1:BITWIDTH],
            "\tOutput Value: ", output_value[BITWIDTH-1:0]);
        
        tag                 <= 'd3; // ID should match
        data_source         <= 'd257;
        next_tag_id         <= 'd2;
        repeat(1) @(posedge clk);
        
        #1; $display("\nTag: ", tag, "\t Input Value: ", data_source);
        $display("Unit Enable: ", target_enable,
            "\nNext Tag ID: ", output_value[TAG_WIDTH+BITWIDTH-1:BITWIDTH],
            "\tOutput Value: ", output_value[BITWIDTH-1:0]);
        
        tag                 <= 'd4; // Should do nothing...
        data_source         <= 'd33;
        next_tag_id         <= 'd3;
        repeat(1) @(posedge clk);
        
        #1; $display("\nTag: ", tag, "\t Input Value: ", data_source);
        $display("Unit Enable: ", target_enable,
            "\nNext Tag ID: ", output_value[TAG_WIDTH+BITWIDTH-1:BITWIDTH],
            "\tOutput Value: ", output_value[BITWIDTH-1:0]);
        
        $display("\n");
        #1 $finish;

    end

endmodule
