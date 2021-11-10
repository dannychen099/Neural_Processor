module weight_mux(
    weight_hid_i,
    weight_hid_i_10,
    weight_hid_i_20,
    weight_out_i,
    out,
    sel
);
    input [62 * 8 - 1: 0] weight_hid_i, weight_hid_i_10, weight_hid_i_20;
    input [240 - 1 : 0] weight_out_i;
    input [1 : 0] sel;

    output [62 * 8 - 1 : 0] out;

    assign out =    sel == 2'b00 ? weight_hid_i :
                    sel == 2'b01 ? weight_hid_i_10 :
                    sel == 2'b10 ? weight_hid_i_20 :
                    sel == 2'b11 ? {256'b0 , weight_out_i} :
                    496'bZ;    

endmodule