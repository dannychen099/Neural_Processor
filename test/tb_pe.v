`timescale 1ns/10ps

//-----------------------------------------------------------------------------
//  Test bench module for a PE. This simulates a vertical column of PEs (1x3
//  vector). That way, each bottom calculate psum can be passed to the PE
//  above for accumulation.
//
//  This particular test bench simulates a RS data flow for a 3 column filter 
//  and a 6 column ifmap. Viewed as a matrix, the relevant data is calculated:
//
//                  0 1 2 3 4 5 6
//      0 1 2       1 2 3 4 5 6 7       48  66  84 102 120
//      1 2 3   *   2 3 4 5 6 7 8   =   X   X   X   X   X
//      2 3 4       X X X X X X X       X   X   X   X   X
//                  X X X X X X X
//
//  Note that this simulation only calculates the *first row*.
//----------------------------------------------------------------------------- 
module tb;
    parameter BITWIDTH      = 16;
    parameter RF_ADDR_WIDTH = 3;
    parameter CLK_PERIOD    = 10;
    
    reg                         clk;
    reg                         rstb;
    reg                         ifmap_enable1;
    reg                         filter_enable1;
    wire                        ready1;
    reg  signed [BITWIDTH-1:0]  filter1;
    reg  signed [BITWIDTH-1:0]  ifmap1;
    wire signed [BITWIDTH-1:0]  output_psum1;

    reg                         ifmap_enable2;
    reg                         filter_enable2;
    wire                        ready2;
    reg  signed [BITWIDTH-1:0]  filter2;
    reg  signed [BITWIDTH-1:0]  ifmap2;
    wire signed [BITWIDTH-1:0]  output_psum2;
    
    reg                         ifmap_enable3;
    reg                         filter_enable3;
    wire                        ready3;
    reg  signed [BITWIDTH-1:0]  filter3;
    reg  signed [BITWIDTH-1:0]  ifmap3;
    wire signed [BITWIDTH-1:0]  output_psum3;

    reg  signed [BITWIDTH-1:0]  output_psum4;

    pe #(
        .BITWIDTH       (BITWIDTH),
        .RF_ADDR_WIDTH  (RF_ADDR_WIDTH)
    )
    tb_pe1( 
        .clk            (clk),
        .rstb           (rstb),
        .ifmap_enable   (ifmap_enable1),
        .filter_enable  (filter_enable1),
        .ready          (ready1),
        .ifmap          (ifmap1),
        .filter         (filter1),
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
        .ifmap_enable   (ifmap_enable2),
        .filter_enable  (filter_enable2),
        .ready          (ready2),
        .ifmap          (ifmap2),
        .filter         (filter2),
        .input_psum     (output_psum3),
        .output_psum    (output_psum2)
    );

    pe #(
        .BITWIDTH       (BITWIDTH),
        .RF_ADDR_WIDTH  (RF_ADDR_WIDTH)
    )
    tb_pe3( 
        .clk            (clk),
        .rstb           (rstb),
        .ifmap_enable   (ifmap_enable3),
        .filter_enable  (filter_enable3),
        .ready          (ready3),
        .ifmap          (ifmap3),
        .filter         (filter3),
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

        ifmap_enable1    <= 'b0;
        filter_enable1   <= 'b0;
        filter1          <= 'sd0;
        ifmap1           <= 'sd0;

        ifmap_enable2    <= 'b0;
        filter_enable2   <= 'b0;
        filter2          <= 'sd0;
        ifmap2           <= 'sd0;
        
        ifmap_enable3    <= 'b0;
        filter_enable3   <= 'b0;
        filter3          <= 'sd0;
        ifmap3           <= 'sd0;
        
        output_psum4    <= 'sd0;
        repeat (1) @(posedge clk);
        
        rstb            <= 'b1;         // Stop reset

        repeat (1) @(posedge clk);

        //---------------------------------------------------------------------
        //  Load filter and ifmap weights
        //---------------------------------------------------------------------

        // Cycle 1 filter values
        filter_enable1  <= 'b1;    // filter 1 col 1,2,3
        filter_enable2  <= 'b1;
        filter_enable3  <= 'b1;
        filter1         <= 'sd0;
        filter2         <= 'sd1;
        filter3         <= 'sd2;
        repeat (1) @(posedge clk);
        filter_enable1  <= 'b0;
        filter_enable2  <= 'b0;
        filter_enable3  <= 'b0;
        $display("Loading filter1 %5d %5d %5d", filter1, filter2, filter3);
        `ifdef DIAG
            #1 display_rf_mem;
            display_control;
        `endif
        
        // Cycle 1 ifmap values
        ifmap_enable1   <= 'b1;     // ifmap 1 col 1,2,3
        ifmap_enable2   <= 'b1;
        ifmap_enable3   <= 'b1;
        ifmap1          <= 'sd0;    
        ifmap2          <= 'sd1;    
        ifmap3          <= 'sd2;    
        repeat (1) @(posedge clk);
        ifmap_enable1   <= 'b0;
        ifmap_enable2   <= 'b0;
        ifmap_enable3   <= 'b0;
        $display("Loading ifmap1  %5d %5d %5d", ifmap1, ifmap2, ifmap3);
        `ifdef DIAG
            #1 display_rf_mem;
            display_control;
        `endif
       
        
        // Cycle 2 filter values
        filter_enable1  <= 'b1;    // filter 1 row 1,2,3
        filter_enable2  <= 'b1;
        filter_enable3  <= 'b1;
        filter1         <= 'sd1;
        filter2         <= 'sd2;
        filter3         <= 'sd3;
        repeat (1) @(posedge clk);
        filter_enable1  <= 'b0;
        filter_enable2  <= 'b0;
        filter_enable3  <= 'b0;
        $display("Loading filter1 %5d %5d %5d", filter1, filter2, filter3);
        `ifdef DIAG
            #1 display_rf_mem;
            display_control;
        `endif
        
        // Cycle 2 ifmap values
        ifmap_enable1   <= 'b1;     // ifmap 1 row 1,2,3
        ifmap_enable2   <= 'b1;
        ifmap_enable3   <= 'b1;
        ifmap1          <= 'sd1;    
        ifmap2          <= 'sd2;    
        ifmap3          <= 'sd3;    
        repeat (1) @(posedge clk);
        ifmap_enable1   <= 'b0;
        ifmap_enable2   <= 'b0;
        ifmap_enable3   <= 'b0;
        $display("Loading ifmap1  %5d %5d %5d", ifmap1, ifmap2, ifmap3);
        `ifdef DIAG
            #1 display_rf_mem;
            display_control;
        `endif
       
        
        // Cycle 3 filter values
        filter_enable1  <= 'b1;    // filter 1 col 1,2,3
        filter_enable2  <= 'b1;
        filter_enable3  <= 'b1;
        filter1         <= 'sd2;
        filter2         <= 'sd3;
        filter3         <= 'sd4;
        repeat (1) @(posedge clk);
        filter_enable1  <= 'b0;
        filter_enable2  <= 'b0;
        filter_enable3  <= 'b0;
        $display("Loading filter1 %5d %5d %5d", filter1, filter2, filter3);
        `ifdef DIAG
            #1 display_rf_mem;
            display_control;
        `endif
        
        // Cycle 3 ifmap values
        ifmap_enable1   <= 'b1;     // ifmap 1 col 1,2,3
        ifmap_enable2   <= 'b1;
        ifmap_enable3   <= 'b1;
        ifmap1          <= 'sd2;    
        ifmap2          <= 'sd3;    
        ifmap3          <= 'sd4;    
        repeat (1) @(posedge clk);
        ifmap_enable1   <= 'b0;
        ifmap_enable2   <= 'b0;
        ifmap_enable3   <= 'b0;
        $display("Loading ifmap1  %5d %5d %5d", ifmap1, ifmap2, ifmap3);
        `ifdef DIAG
            #1 display_rf_mem;
            display_control;
        `endif


        repeat(1) @(posedge clk);

        $display("PE Calculating MAC...\n");
        for (i = 0; i < 3; i = i + 1) begin
            //#1 display_control;
            //display_rf_mem;
            //display_mac;
            repeat(1) @(posedge clk);
        end

        $display("PE Accumulating Column...\n");
        for (i = 0; i < 2; i = i + 1) begin
            repeat(1) @(posedge clk);
            //#1 display_control;
            //display_rf_mem;
            //display_mac;
        end

        $display("Output psum: %5d\n\n\n\n", output_psum1);
        repeat(1) @(posedge clk);
        
        //---------------------------------------------------------------------
        //  Load filter and ifmap weights
        //---------------------------------------------------------------------

        // ifmap values
        ifmap_enable1   <= 'b1;
        ifmap_enable2   <= 'b1;
        ifmap_enable3   <= 'b1;
        ifmap1          <= 'sd3;    
        ifmap2          <= 'sd4;    
        ifmap3          <= 'sd5;    
        repeat (1) @(posedge clk);
        ifmap_enable1   <= 'b0;
        ifmap_enable2   <= 'b0;
        ifmap_enable3   <= 'b0;
        $display("Loading ifmap  %5d %5d %5d", ifmap1, ifmap2, ifmap3);
       
        repeat(1) @(posedge clk);

        $display("PE Calculating MAC...");
        for (i = 0; i < 3; i = i + 1) begin
            //#1 display_control;
            //display_rf_mem;
            //display_mac;
            repeat(1) @(posedge clk);
        end

        $display("PE Accumulating Column...");
        for (i = 0; i < 2; i = i + 1) begin
            repeat(1) @(posedge clk);
            //#1 display_control;
            //display_rf_mem;
            //display_mac;
        end

        #1 $display("output_psum = %5d\n\n\n\n", output_psum1);
        repeat (1) @(posedge clk);
        
        // ifmap values
        ifmap_enable1   <= 'b1; 
        ifmap_enable2   <= 'b1;
        ifmap_enable3   <= 'b1;
        ifmap1          <= 'sd4;    
        ifmap2          <= 'sd5;    
        ifmap3          <= 'sd6;    
        repeat (1) @(posedge clk);
        ifmap_enable1   <= 'b0;
        ifmap_enable2   <= 'b0;
        ifmap_enable3   <= 'b0;
        $display("Loading ifmap  %5d %5d %5d", ifmap1, ifmap2, ifmap3);
       
        repeat(1) @(posedge clk);

        $display("PE Calculating MAC...");
        for (i = 0; i < 3; i = i + 1) begin
            //#1 display_control;
            //display_rf_mem;
            //display_mac;
            repeat(1) @(posedge clk);
        end

        $display("PE Accumulating Column...");
        for (i = 0; i < 2; i = i + 1) begin
            repeat(1) @(posedge clk);
            //#1 display_control;
            //display_rf_mem;
            //display_mac;
        end

        #1 $display("output_psum = %5d\n\n\n\n", output_psum1);
        repeat (1) @(posedge clk);
        
        // ifmap values
        ifmap_enable1   <= 'b1; 
        ifmap_enable2   <= 'b1;
        ifmap_enable3   <= 'b1;
        ifmap1          <= 'sd5;    
        ifmap2          <= 'sd6;    
        ifmap3          <= 'sd7;    
        repeat (1) @(posedge clk);
        ifmap_enable1   <= 'b0;
        ifmap_enable2   <= 'b0;
        ifmap_enable3   <= 'b0;
        $display("Loading ifmap  %5d %5d %5d", ifmap1, ifmap2, ifmap3);
       
        repeat(1) @(posedge clk);

        $display("PE Calculating MAC...");
        for (i = 0; i < 3; i = i + 1) begin
            //#1 display_control;
            //display_rf_mem;
            //display_mac;
            repeat(1) @(posedge clk);
        end

        $display("PE Accumulating Column...");
        for (i = 0; i < 2; i = i + 1) begin
            repeat(1) @(posedge clk);
            //#1 display_control;
            //display_rf_mem;
            //display_mac;
        end

        #1 $display("output_psum = %5d\n\n\n\n", output_psum1);
        repeat (1) @(posedge clk);

        // ifmap values
        ifmap_enable1   <= 'b1; 
        ifmap_enable2   <= 'b1;
        ifmap_enable3   <= 'b1;
        ifmap1          <= 'sd6;    
        ifmap2          <= 'sd7;    
        ifmap3          <= 'sd8;    
        repeat (1) @(posedge clk);
        ifmap_enable1   <= 'b0;
        ifmap_enable2   <= 'b0;
        ifmap_enable3   <= 'b0;
        $display("Loading ifmap  %5d %5d %5d", ifmap1, ifmap2, ifmap3);
       
        repeat(1) @(posedge clk);

        $display("PE Calculating MAC...");
        for (i = 0; i < 3; i = i + 1) begin
            //#1 display_control;
            //display_rf_mem;
            //display_mac;
            repeat(1) @(posedge clk);
        end

        $display("PE Accumulating Column...");
        for (i = 0; i < 2; i = i + 1) begin
            repeat(1) @(posedge clk);
            //#1 display_control;
            //display_rf_mem;
            //display_mac;
        end

        #1 $display("output_psum = %5d\n\n\n\n", output_psum1);
        repeat (1) @(posedge clk);
        $finish;
    end
endmodule
