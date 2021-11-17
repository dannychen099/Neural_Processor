`timescale 1ns / 1ns
`include "controller.v"
`include "datapath.v"
`include "data_mem.v"
`include "label_mem.v"

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
        repeat(6010)
            #10 clk = ~clk;
            #6010
        $stop;
    end

endmodule