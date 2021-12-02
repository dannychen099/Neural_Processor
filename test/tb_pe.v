`timescale 1ns/10ps

module tb;
    parameter BITWIDTH = 16;
    parameter CLK_PERIOD = 10;
    
    reg         clk;
    reg         rstb;
    reg         enable;
    reg [2:0]   control;
    wire        ready;

    reg signed [BITWIDTH-1:0] filter;
    reg signed [BITWIDTH-1:0] ifmap;
    reg signed [BITWIDTH-1:0] input_psum;
    
    wire signed [BITWIDTH-1:0] output_psum;

    pe #(
        .BITWIDTH       (BITWIDTH)
    )
    tb_pe(
        .clk            (clk),
        .rstb           (rstb),
        .enable         (enable),
        .control        (control),
        .ready          (ready),
        .ifmap          (ifmap),
        .filter         (filter),
        .input_psum     (input_psum),
        .output_psum    (output_psum)
    );

    integer i;
    
    always #(CLK_PERIOD) clk = ~clk;
    initial begin
        // Initialize everything to zero
        clk         <= 'b0;         // Start clock
        rstb        <= 'b0;         // Begin reset
        enable      <= 'b0;
        control     <= 'b0;
        filter      <= 'sd0;
        ifmap       <= 'sd0;
        input_psum  <= 'sd0;
        repeat (1) @(posedge clk);
        
        rstb        <= 'b1;         // Stop reset
        control     <= 'b00;        // Use mult output, acc psum
        enable      <= 'b1;
        filter      <= 'sd5;
        ifmap       <= 'sd2;
        repeat(1) @(posedge clk);
        #1; $display(filter, " * ", ifmap, " + ", tb_pe.psum_reg, " = ", output_psum);

        control     <= 'b00;        // Use mult output, acc psum
        filter      <= 'sd2;
        ifmap       <= 'sd4;
        
        repeat(1) @(posedge clk);
        #1; $display(filter, " * ", ifmap, " + ", tb_pe.psum_reg, " = ", output_psum);
        
        
        
        
        
        /*
        // Weight ID programming
        $display("Programming filter_id and ifmap_id");
        filter_id   <= 'd2;
        ifmap_id    <= 'd3;
        control     <= tb_pe.CTRL_PROG;
        repeat (1) @(posedge clk);
        #1; $display("\tFilter ID: ", tb_pe.filter_id_reg, 
            "\tIfmap ID: ", tb_pe.ifmap_id_reg);

        // Listening for weight ID (to load weights based on ID)
        $display("\nListening for matching filter_id and weight_id");
        $display("\tfilter_id | ifmap_id | ",
                "filter | ifmap | ",
                "tb_pe.filter | tb_pe.ifmap");
        control <= tb_pe.CTRL_LISTEN;
        for (i = 0; i < 5; i = i+1) begin
            // Cycle through a short list of 3 IDs
            filter_id   <= i;
            ifmap_id    <= i;
            filter      <= i+1;
            ifmap       <= i+1;
            repeat (1) @(posedge clk);
            #1; $display("\t", filter_id, " ", ifmap_id, " ", 
                        filter, " ", ifmap, " ",
                        tb_pe.filter_reg, " ", tb_pe.ifmap_reg, "\n");
        end

        // Perform MAC operation
        $display("\nPerforming MAC operation");
        control <= tb_pe.CTRL_MAC;
        repeat (1) @(posedge clk);  // Takes THREE clock cycles?
                                    // Not sure where why...
        #1; $display("\tpsum reg after MAC:", tb_pe.psum_reg, "\n",
                     "\tpsum_output:", psum_output);
        $display(tb_pe.mac_output, "\n");

        // Perform Accumulation
        $display("\nPerforming Accumulation with below psum");
        below_psum <= 'd5;
        control <= tb_pe.CTRL_ACC;
        repeat(1) @(posedge clk);
        #1; $display("\tpsum reg after ACC:", tb_pe.psum_reg, "\n",
                     "\tpsum_output:", psum_output);

        // Broadcast final psum
        $display("\nBroadcasting final psum value");
        control <= tb_pe.CTRL_PSUM;
        repeat(1) @(posedge clk);
        #1; $display("\tpsum_output: ", psum_output);
        */

        $finish;
    end
endmodule
