`timescale 1ns/10ps

module tb;
    parameter ADDRESS_WIDTH = 4;
    parameter BITWIDTH = 16;
    parameter CLK_PERIOD = 10;

    reg                     rstb;
    reg                     clk;
    reg                     program;
    reg                     enable;
    reg                     pe_ready;
    reg [ADDRESS_WIDTH-1:0] tag;
    reg [ADDRESS_WIDTH-1:0] tag_id;
    reg [BITWIDTH-1:0]      input_value;
    
    wire [BITWIDTH-1:0]     output_value;
    wire                    pe_enable;

    multicast_controller #(
        .ADDRESS_WIDTH  (ADDRESS_WIDTH),
        .BITWIDTH       (BITWIDTH)
    )
    mc (
        .rstb           (rstb),
        .clk            (clk),
        .program        (program),
        .enable         (enable),
        .pe_ready       (pe_ready),
        .tag            (tag),
        .tag_id         (tag_id),
        .input_value    (input_value),
        .output_value   (output_value),
        .pe_enable      (pe_enable)
    );

    always #(CLK_PERIOD) clk = ~clk;

    initial begin
        clk             <= 'b0;
        rstb            <= 'b1;
        program         <= 'b0;
        enable          <= 'b0;
        pe_ready        <= 'b0;
        tag             <= 'd0;
        tag_id          <= 'd0;
        input_value     <= 'd0;

        repeat (1) @(posedge clk);
        
        $display("Programming...");
        program         <= 'b1;
        tag_id          <= 'd3;
        repeat(1) @(posedge clk);
        program         <= 'b0;
        $display("Programmed ID: ", mc.tag_id_reg);

        enable          <= 'd1;
        pe_ready        <= 'd1;
        
        repeat(1) @(posedge clk);
        
        tag             <= 'd2; // Should do nothing...
        input_value     <= 'd512;
        #1; $display("\nTag: ", tag, "\t Input Value: ", input_value);
        $display("PE Enable: ", pe_enable, "\tOutput Value: ", output_value);
        
        
        tag             <= 'd3;
        input_value     <= 'd257;
        #1; $display("\nTag: ", tag, "\t Input Value: ", input_value);
        $display("PE Enable: ", pe_enable, "\tOutput Value: ", output_value);
        
        tag             <= 'd4;
        input_value     <= 'd33;
        #1; $display("\nTag: ", tag, "\t Input Value: ", input_value);
        $display("PE Enable: ", pe_enable, "\tOutput Value: ", output_value);

        $display("\n");
        #1 $finish;

    end

endmodule
