module bias_output_mem(
    bias_output0, bias_output1, bias_output2, bias_output3, bias_output4, bias_output5, bias_output6, bias_output7, bias_output8, bias_output9
);
    output [7 : 0] bias_output0, bias_output1, bias_output2, bias_output3, bias_output4, bias_output5, bias_output6, bias_output7, bias_output8, bias_output9;

    assign bias_output0 = 8'b10000011;
    assign bias_output1 = 8'b10101110;
    assign bias_output2 = 8'b00100011;
    assign bias_output3 = 8'b00000010;
    assign bias_output4 = 8'b00010101;
    assign bias_output5 = 8'b00000011;
    assign bias_output6 = 8'b10011111;
    assign bias_output7 = 8'b11000110;
    assign bias_output8 = 8'b01010110;
    assign bias_output9 = 8'b00000111;
endmodule