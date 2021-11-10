module label_mem(
    addr,
    mem_read,
    out
);
    input [9 : 0] addr;
    input mem_read;
    output reg [4 - 1 : 0] out;
    reg[4 - 1 : 0] mem[0 : 749];

    initial
	begin
		$readmemb("Test_Label.txt", mem);
	end

    always @(*)
    begin
        if (mem_read == 1'b1)
            out = mem[addr];
        else
            out = 4'bZ;
    end

endmodule   