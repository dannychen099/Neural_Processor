`timescale 1ns/10ps

module tb;
    parameter   WIDTH = 16;

    reg signed  [WIDTH-1:0] in_tb;
    reg signed  [WIDTH-1:0] w_tb;
    reg                     clk_tb;
    reg                     rstb_tb;
    wire signed [WIDTH-1:0] out_tb;

    parameter CLK_PERIOD = 10;

    mac #(
        .WIDTH(WIDTH)
    )
    tb_mac(
        .A      (in_tb),
        .B      (w_tb),
        .clk    (clk_tb),
        .rstb   (rstb_tb),
        .out    (out_tb)    
    );

    initial begin
        clk_tb  = 1;
        in_tb   = 16'sd0;
        w_tb    = 16'sd0;
        rstb_tb = 1;
        rstb_tb = 0;
        #2 rstb_tb = 1;
        #3;

        // Clock cycle 1
        in_tb   = 16'sd1;
        w_tb    = 16'sd4;
        #(CLK_PERIOD);

        // Clock cycle 2
        in_tb   = 16'sd4;
        w_tb    = -16'sd3;
        #(CLK_PERIOD);

        // Clock cycle 3
        in_tb   = 16'sd7;
        w_tb    = 16'sd2;
        #(CLK_PERIOD);

        // Clock cycle 4
        in_tb   = -16'sd2;
        w_tb    = -16'sd1;
        #(CLK_PERIOD);

        // Clock cycle 5
        in_tb   = 16'sd3;
        w_tb    = 16'sd2;
        #(CLK_PERIOD);

        // Clock cycle 6
        in_tb   = -16'sd5;
        w_tb    = 16'sd1;
        #(CLK_PERIOD);

        // Clock cycle 7
        in_tb   = 16'sd2;
        w_tb    = -16'sd5;
        #(CLK_PERIOD);

        // Clock cycle 8
        in_tb   = 16'sd3;
        w_tb    = 16'sd7;
        #(CLK_PERIOD);

        in_tb   = 16'sd0;
        w_tb    = 16'sd0;
        #(CLK_PERIOD);

        in_tb   = 16'sd0;
        w_tb    = 16'sd0;
        #(CLK_PERIOD);

        in_tb   = 16'sd0;
        w_tb    = 16'sd0;
        #(CLK_PERIOD);

        $finish;

    end

    always begin
       #(CLK_PERIOD/2) clk_tb = 0;
       #(CLK_PERIOD/2) clk_tb = 1;
    end

    always begin
        #(CLK_PERIOD);
        $display(in_tb, w_tb, "\t",  clk_tb, rstb_tb, out_tb);
    end

endmodule
