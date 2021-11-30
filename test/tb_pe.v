`timescale 1ns/10ps

module tb;
    parameter BITWIDTH = 16;
    parameter GRID_X = 10;
    parameter GRID_Y = 10;
    
    reg         clk;
    reg         rstb;
    reg         enable_x;
    reg         enable_y;
    reg [3:0]   control;

    reg [4:0]   filter_id;
    reg [5:0]   ifmap_id;

    reg signed [BITWIDTH-1:0] filter;
    reg signed [BITWIDTH-1:0] ifmap;
    reg signed [BITWIDTH-1:0] psum;
    reg signed [BITWIDTH-1:0] below_psum;
    
    wire signed [BITWIDTH-1:0] psum_output;

    pe #(
        .BITWIDTH       (BITWIDTH),
        .GRID_X         (GRID_X),
        .GRID_Y         (GRID_Y)
    )
    tb_pe(
        .clk            (clk),
        .rstb           (rstb),
        .enable_x       (enable_x),
        .enable_y       (enable_y),
        .control        (control),
        .filter_id      (filter_id),
        .ifmap_id       (ifmap_id),
        .filter         (filter),
        .ifmap          (ifmap),
        .psum           (psum),
        .below_psum     (below_psum),
        .psum_output    (psum_output)
    );
    
    always #10 clk = ~clk;
    initial begin
        // Initialize everything to zero
        clk         <= 'b0;         // Start clock
        rstb        <= 'b0;         // Begin reset
        enable_x    <= 'b0;
        enable_y    <= 'b0;
        control     <= 'b0;
        filter_id   <= 'b0;
        ifmap_id    <= 'b0;
        filter      <= 'b0;
        ifmap       <= 'b0;
        psum        <= 'b0;
        below_psum  <= 'b0;

        repeat (1) @(posedge clk);
        
        rstb        <= 'b1;         // Stop reset
        enable_x    <= 'b1;         // Enable
        enable_y    <= 'b1;         // Enable

        repeat (1) @(posedge clk);

        // Test weight ID loading
        filter_id   <= 
        control     <= tb_pe.CTRL_PROG;
        repeat (1) @(posedge clk);
        $display(control);
        $finish;
    end
endmodule
