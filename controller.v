module controller(
    clk,
    rst,
    eql,
    addr_count,
    mem_read,
    input_sel,
    reg_sel,
    weight_sel,
    bias_sel,
    reg_load,
    addr_count_enable,
    label_mem_read,
    ac_count_enable,
    done
);
    input clk,rst;
    input eql;
    input [9 : 0] addr_count;

    output reg mem_read;
    output reg input_sel, reg_sel;
    output reg [1 : 0] weight_sel, bias_sel;
    output reg [30 - 1 : 0] reg_load;
    output reg addr_count_enable, label_mem_read, ac_count_enable;
    output reg done;

    reg [2 : 0] states_pos, states_neg;
	
	always @(posedge clk, posedge rst)
    begin
        if (rst)
            states_pos <= 3'd0;
        else
            states_pos <= states_neg;
    end
	
    always @(states_pos, addr_count)
    begin
	case(states_pos)
		3'd0: states_neg = 3'd1;
		3'd1: states_neg = 3'd2;
		3'd2: states_neg = 3'd3;
		3'd3: 
		begin
			if(addr_count < 10'd750)
			states_neg = 3'd0;
			else
			states_neg = 3'd4;
		end
	endcase
    end

    

    always @(states_pos, eql)
    begin
        mem_read = 1'b0;
        input_sel = 1'b0;
        reg_sel = 1'b0;
        weight_sel = 2'd0;
        bias_sel = 2'd0;
        reg_load = 30'd0;
        label_mem_read = 1'b0;
        addr_count_enable = 1'b0;
        ac_count_enable = 1'b0;

        if (states_pos == 3'd0)
        begin
            mem_read = 1'b1;
            input_sel = 1'b1;
            weight_sel = 2'd0;
            bias_sel = 2'd0;
            reg_load = {20'd0, 10'b11111_11111};
        end

        if (states_pos == 3'd1)
        begin
            mem_read = 1'b1;
            input_sel = 1'b1;
            weight_sel = 2'd1;
            bias_sel = 2'd1;
            reg_load = {10'd0, 10'b11111_11111, 10'd0};
        end

        if (states_pos == 3'd2)
        begin
            mem_read = 1'b1;
            input_sel = 1'b1;
            weight_sel = 2'd2;
            bias_sel = 2'd2;
            reg_load = {10'b11111_11111, 20'd0};
        end

        if (states_pos == 3'd3)
        begin
            reg_sel = 1'b1;
            weight_sel = 2'd3;
            bias_sel = 2'd3;
            label_mem_read = 1'b1;
            addr_count_enable = 1'b1;
            ac_count_enable = eql;
        end

        if (states_pos == 3'd4)
        begin
            done = 1'b1;
        end

    end

endmodule