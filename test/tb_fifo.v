`timescale 1ns/10ps

module tb;
    parameter ADDR_WIDTH    = 3;
    parameter DATA_WIDTH    = 8;
    parameter CLK_PERIOD    = 10;

    reg                             clk;
    reg                             rstb;
    reg                             load_enable;
    reg  signed [DATA_WIDTH-1:0]    value_in;
    reg         [ADDR_WIDTH-1:0]    reg_select;
    wire signed [DATA_WIDTH-1:0]    value_out;
    
    fifo
    #(
        .ADDR_WIDTH (ADDR_WIDTH),
        .DATA_WIDTH (DATA_WIDTH)
    )
    tb_fifo
    (
        .clk        (clk),
        .rstb       (rstb),
        .load_enable(load_enable),
        .value_in   (value_in),
        .reg_select (reg_select),
        .value_out  (value_out)
    );

    integer i;

    always #(CLK_PERIOD) clk = ~clk;

    task display_mem;
        begin
            $display("Mem [0]:%5d [1]:%5d [2]:%5d [3]:%5d [4]:%5d [5]:%5d [6]:%5d [7]:%5d", tb_fifo.memory[0], tb_fifo.memory[1], tb_fifo.memory[2], tb_fifo.memory[3], tb_fifo.memory[4], tb_fifo.memory[5], tb_fifo.memory[6], tb_fifo.memory[7]);
        end
    endtask

    initial begin
        clk         <= 'b0;
        rstb        <= 'b0;
        load_enable <= 'b0;
        reg_select  <= 'b0;
        value_in    <= 'b0;

        repeat (1) @(posedge clk);
        rstb    <= 'b1;
        $display("Reset...");
        display_mem;
        repeat (1) @(posedge clk);

        $display("\nPushing values..."); 

        load_enable <= 'b1;
        repeat (1) @(posedge clk);
        for (i = 0; i < 2**ADDR_WIDTH; i = i + 1) begin
            value_in <= i;
            repeat (1) @(posedge clk);
            #1 $display("\nvalue_in: %5d", value_in);
            display_mem;
        end

        load_enable <= 'b0;

        reg_select <= 'b0;
        #1 $display(value_out);

        reg_select <= 'b1;
        #1 $display(value_out);

        reg_select <= 'b10;
        #1 $display(value_out);
        
        $finish;
    end
   
endmodule
