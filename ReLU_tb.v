`timescale 1ns / 1ns

module ReLU_tb();

    reg [80 - 1 : 0] in = {8'd2, 8'd1, 8'd7, 8'd20, 8'd17, 8'd13, 8'd15, 8'd6, 8'd7 , 8'd9};

    wire [3 : 0] max_val;
    reg enable = 1'b1;
    ReLU ReLU(
        .in(in),    
        .enable(enable),
        .max_val(max_val)
    );

    initial begin
        #100;
        $stop;
    end
endmodule   