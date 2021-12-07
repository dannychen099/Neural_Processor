`timescale 1ns/10ps

module tb;
    parameter BITWIDTH      = 16;
    parameter RF_ADDR_WIDTH = 3;
    parameter CLK_PERIOD    = 10;
    
    reg                         clk;
    reg                         rstb;
    reg                         ifmap_enable;
    reg                         filter_enable;
    wire                        ready;

    reg  signed [BITWIDTH-1:0]  filter;
    reg  signed [BITWIDTH-1:0]  ifmap;
    //reg  signed [BITWIDTH-1:0]  input_psum;
    
    wire signed [BITWIDTH-1:0]  output_psum1;
    wire signed [BITWIDTH-1:0]  output_psum2;
    wire signed [BITWIDTH-1:0]  output_psum3;
    reg  signed [BITWIDTH-1:0]  output_psum4;

    pe #(
        .BITWIDTH       (BITWIDTH),
        .RF_ADDR_WIDTH  (RF_ADDR_WIDTH)
    )
    tb_pe1( 
        .clk            (clk),
        .rstb           (rstb),
        .ifmap_enable   (ifmap_enable),
        .filter_enable  (filter_enable),
        .ready          (ready),
        .ifmap          (ifmap),
        .filter         (filter),
        .input_psum     (output_psum2),
        .output_psum    (output_psum1)
    );

    pe #(
        .BITWIDTH       (BITWIDTH),
        .RF_ADDR_WIDTH  (RF_ADDR_WIDTH)
    )
    tb_pe2( 
        .clk            (clk),
        .rstb           (rstb),
        .ifmap_enable   (ifmap_enable),
        .filter_enable  (filter_enable),
        .ready          (ready),
        .ifmap          (ifmap),
        .filter         (filter),
        .input_psum     (output_psum3),
        .output_psum    (output_psum2)
    );

    pe #(
        .BITWIDTH       (BITWIDTH),
        .RF_ADDR_WIDTH  (RF_ADDR_WIDTH),
        .WHEN_TO_ACC_PSUM(5)
    )
    tb_pe3( 
        .clk            (clk),
        .rstb           (rstb),
        .ifmap_enable   (ifmap_enable),
        .filter_enable  (filter_enable),
        .ready          (ready),
        .ifmap          (ifmap),
        .filter         (filter),
        .input_psum     (output_psum4),
        .output_psum    (output_psum3)
    );
    integer i;
    
    task display_rf_mem;
        begin
            $display("Register File Contents:\n",
                "filter:\tifmap\tpsum\n",
                "%5d %5d %5d\n",
                tb_pe1.filter_fifo.memory[0], tb_pe1.ifmap_fifo.memory[0], tb_pe1.psum_fifo.memory[0],
                "%5d %5d %5d\n",
                tb_pe1.filter_fifo.memory[1], tb_pe1.ifmap_fifo.memory[1], tb_pe1.psum_fifo.memory[1],
                "%5d %5d %5d\n",
                tb_pe1.filter_fifo.memory[2], tb_pe1.ifmap_fifo.memory[2], tb_pe1.psum_fifo.memory[2],
                "%5d %5d %5d\n",
                tb_pe1.filter_fifo.memory[3], tb_pe1.ifmap_fifo.memory[3], tb_pe1.psum_fifo.memory[3],
                "%5d %5d %5d\n",
                tb_pe1.filter_fifo.memory[4], tb_pe1.ifmap_fifo.memory[4], tb_pe1.psum_fifo.memory[4],
                "%5d %5d %5d\n",
                tb_pe1.filter_fifo.memory[5], tb_pe1.ifmap_fifo.memory[5], tb_pe1.psum_fifo.memory[5],
                "%5d %5d %5d\n",
                tb_pe1.filter_fifo.memory[6], tb_pe1.ifmap_fifo.memory[6], tb_pe1.psum_fifo.memory[6],
                "%5d %5d %5d\n",
                tb_pe1.filter_fifo.memory[7], tb_pe1.ifmap_fifo.memory[7], tb_pe1.psum_fifo.memory[7],
                "\n");
        end
    endtask

    task display_control;
        begin
            $display("Control Signals:\n",
                "acc_input_psum = %1b\nacc_reset = %1d\n",
                tb_pe1.acc_input_psum, tb_pe1.acc_reset,
                "filter_select = %2d\nifmap_select = %2d\npsum_select = %2d\n",
                tb_pe1.filter_select, tb_pe1.ifmap_select, tb_pe1.psum_select,
                "filter_from_fifo = %5d\nifmap_from_fifo = %5d\npsum_from_fifo = %5d\n",
                tb_pe1.filter_from_fifo, tb_pe1.ifmap_from_fifo, tb_pe1.psum_from_fifo,
                "pe_state = %1d\ncount = %1d\n", tb_pe1.pe_state, tb_pe1.count);
        end
    endtask

    task display_mac;
        begin
            $display("MAC contents\n",
                "%5d * %5d = %5d\n",
                tb_pe1.mac_multiplier.operand_a,
                tb_pe1.mac_multiplier.operand_b,
                tb_pe1.mac_multiplier.result,
                "%5d + %5d = %5d\n",
                tb_pe1.mac_accumulator.operand_a, 
                tb_pe1.mac_accumulator.operand_b,
                tb_pe1.mac_accumulator.result,
                "input_psum = %5d\n",  tb_pe1.input_psum);
        end
    endtask
    
    always #(CLK_PERIOD) clk = ~clk;
    initial begin
        // Initialize everything to zero
        clk             <= 'b0;         // Start clock
        rstb            <= 'b0;         // Begin reset
        ifmap_enable    <= 'b0;
        filter_enable   <= 'b0;
        filter          <= 'sd0;
        ifmap           <= 'sd0;
        output_psum4    <= 'sd0;
        repeat (1) @(posedge clk);
        
        rstb            <= 'b1;         // Stop reset

        repeat (1) @(posedge clk);

        //---------------------------------------------------------------------
        //  Load filter and ifmap weights
        //---------------------------------------------------------------------

        // Row 1 Cycle 1 values
        filter_enable   <= 'b1;     // filter 1
        filter          <= 'sd1;
        repeat (1) @(posedge clk);
        filter_enable   <= 'b0;
        $display("Loading filter1 %5d", filter);
        #1 display_rf_mem;
        display_control;
        
        // Row 1 Cycle 2 values
        ifmap_enable    <= 'b1;     // ifmap 1
        ifmap           <= 'sd1;    
        repeat (1) @(posedge clk);
        ifmap_enable    <= 'b0;
        $display("Loading ifmap1 %5d", ifmap);
        #1 display_rf_mem;
        display_control;
       
        
        // Row 1 Cycle 3 values
        filter_enable   <= 'b1;     // filter 2
        filter          <= 'sd2;
        repeat (1) @(posedge clk);
        filter_enable   <= 'b0;
        $display("Loading filter2 %5d", filter);
        #1 display_rf_mem;
        display_control;
        
        ifmap_enable    <= 'b1;     // ifmap 2
        ifmap           <= 'sd2;
        repeat (1) @(posedge clk);
        ifmap_enable    <= 'b0;
        $display("Loading ifmap2 %5d", ifmap);
        #1 display_rf_mem;
        display_control;

        
        filter_enable   <= 'b1;     // filter 3
        filter          <= 'sd3;
        repeat (1) @(posedge clk);
        filter_enable   <= 'b0;
        $display("Loading filter3 %5d", filter);
        #1 display_rf_mem;
        display_control;
        
        ifmap_enable    <= 'b1;     // ifmap 3
        ifmap           <= 'sd3;
        repeat (1) @(posedge clk);
        $display("Loading ifmap3 %5d", ifmap);
        #1 display_rf_mem;
        ifmap_enable    <= 'b0;
        display_control;
       
        repeat(1) @(posedge clk);

        $display("PE Calculating MAC...\n");
        for (i = 0; i < 3; i = i + 1) begin
            #1 display_control;
            display_rf_mem;
            display_mac;
            repeat(1) @(posedge clk);
        end

        $display("PE Accumulating Column...\n");
        for (i = 0; i < 2; i = i + 1) begin
            repeat(1) @(posedge clk);
            #1 display_control;
            display_rf_mem;
            display_mac;
        end
        $finish;
    end
endmodule
