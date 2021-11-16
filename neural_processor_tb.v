`timescale 1ns / 1ns

module neural_processor_tb();
    reg clk, rst;
    wire done;
    wire [9 : 0] accuracy;
    neural_processor neural_processor(clk, rst, done, accuracy);

    initial begin
        rst = 1'b1;
        clk = 0;
        #15
        rst = 1'b0;
        repeat(200000)
            #10 clk = ~clk;
            #10000
        $stop;
    end

endmodule