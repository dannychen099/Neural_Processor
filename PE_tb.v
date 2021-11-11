`timescale 1ns / 1ns

module PE_tb();
    reg [62 * 8 - 1 : 0] in, weight;
    reg [7 : 0] bias;
    wire [7 : 0] out;

    PE PE(
        bias,
        weight,
        in,
        out
    );

    initial begin
        in = { {464'b0},  {1'b1, 7'd127}, {1'b1, 7'd103}, {1'b0, 7'd93}, {1'b0, 7'd100} };

        weight = { {464'b0}, {1'b0, 7'd2}, {1'b1, 7'd3}, {1'b0, 7'd4}, {1'b1, 7'd5} };

        bias = {1'b0, 7'd100}; 

        //out = 100*127 - 73 -> 127
        #500
        in = {496'b0 };

        weight = { {464'b0}, {1'b0, 7'd2}, {1'b1, 7'd3}, {1'b0, 7'd4}, {1'b1, 7'd5} };

        bias = {8'b0}; 
        //out = 0
        #1000;
        $stop;
    end
endmodule