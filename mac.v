`timescale 1ns/1ns

module mac(
    in,
    weight,
    out
);
    input [62 * 8 - 1 : 0] in, weight;
    output [20 : 0] out;  
    reg [20 : 0] neg ;
    reg [20 : 0] pos ;
	integer i;
	always @(in, weight) begin
		neg = 21'b0;
        pos = 21'b0;
		for (i = 0 ; i < 62 ; i = i + 1)
		begin
			if (in[8 * i + 7] ^ weight[8 * i + 7] == 1'b1) //negative
            begin
				neg = neg + in[8 * i +: 7] * weight[8 * i +: 7];
            end
			else
            begin
				pos = pos + in[8 * i +: 7] * weight[8 * i +: 7];  
            end
		end
	end

    wire [19 : 0] pos_res, neg_res;
    assign pos_res = pos - neg;
    assign neg_res = neg - pos;
    assign out = (pos > neg) ? {1'b0, pos_res} : {1'b1, neg_res};

endmodule







