module input_mux(
    input_sel,
    reg_sel,
    in,
    reg_hid,
    out
);
    input input_sel, reg_sel;
    input [62 * 8 - 1:0] in;
    input [30 * 8 - 1:0] reg_hid;

    output reg[62 * 8 - 1:0] out;

    always @(*)
    begin
        if (input_sel)
            out = in;
        else
        if (reg_sel)
            out = {256'b0 ,reg_hid};
        else
            out = 496'bZ;
    end

endmodule