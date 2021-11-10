module bias_mux(
    bias_hid_i,
    bias_hid_i_10,
    bias_hid_i_20,
    bias_out_i,
    out,
    sel
);
    input [8 - 1: 0] bias_hid_i, bias_hid_i_10, bias_hid_i_20, bias_out_i;
    input [1 : 0] sel;

    output [8 - 1 : 0] out;

    assign out =    sel == 2'b00 ? bias_hid_i :
                    sel == 2'b01 ? bias_hid_i_10 :
                    sel == 2'b10 ? bias_hid_i_20 :
                    sel == 2'b11 ? bias_out_i :
                    8'bZ;    

endmodule