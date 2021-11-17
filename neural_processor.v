`timescale 1ns/1ns
`include "controller.v"
`include "datapath.v"
`include "data_mem.v"
`include "label_mem.v"

module neural_processor(
    clk,
    rst,
    done,
    accuracy
);
    input clk, rst;
    output done;
    output [9 : 0] accuracy;

    wire eql, mem_read, input_sel, reg_sel, addr_count_enable, ac_count_enable, label_mem_read;
    wire [1 : 0] weight_sel, bias_sel;
    wire [30 - 1 : 0] reg_load;
    wire [9 : 0] addr_count;

    wire [62 * 8 - 1 : 0] in;

    wire [3 : 0] expected;
    controller controller(
        .clk(clk),
        .rst(rst),
        .eql(eql),
        .addr_count(addr_count),
        .mem_read(mem_read),
        .input_sel(input_sel),
        .reg_sel(reg_sel),
        .weight_sel(weight_sel),
        .bias_sel(bias_sel),
        .reg_load(reg_load),
        .addr_count_enable(addr_count_enable),
        .label_mem_read(label_mem_read),
        .ac_count_enable(ac_count_enable),
        .done(done)
    );

    
    datapath datapath(  
        .in(in),
        .input_sel(input_sel),
        .reg_sel(reg_sel),
        .weight_sel(weight_sel),
        .bias_sel(bias_sel),
        .clk(clk),
        .rst(rst),
        .reg_load(reg_load),
        .addr_count(addr_count),
        .addr_count_en(addr_count_enable),
        .accuracy(accuracy),
        .acc_count_en(ac_count_enable),
        .eql(eql),
        .expected(expected)
    );

    data_mem data_mem(
        .addr(addr_count),
        .mem_read(mem_read),
        .out(in)
    );  

    label_mem label_mem(
        .addr(addr_count),
        .mem_read(label_mem_read),
        .out(expected)
    );   

endmodule

