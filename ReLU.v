module ReLU(
    in,    
    enable,
    max_val 
);
    input [80 - 1 : 0] in;
    input enable;
    output reg [3 : 0] max_val;

    wire [7 : 0] PE_0 = in[7 : 0];
    wire [7 : 0] PE_1 = in[15 : 8];
    wire [7 : 0] PE_2 = in[23 : 16];
    wire [7 : 0] PE_3 = in[31 : 24];
    wire [7 : 0] PE_4 = in[39 : 32];
    wire [7 : 0] PE_5 = in[47 : 40];
    wire [7 : 0] PE_6 = in[55 : 48];
    wire [7 : 0] PE_7 = in[63 : 56];
    wire [7 : 0] PE_8 = in[71 : 64];
    wire [7 : 0] PE_9 = in[79 : 72];

    
    always @(*)
    begin
        if (enable == 1'b0)
            max_val = 4'bZ;
        else
        //0
        if (PE_0 >= PE_1 && PE_0 >= PE_2 && PE_0 >= PE_3 && PE_0 >= PE_4 && PE_0 >= PE_5 && PE_0 >= PE_6 && PE_0 >= PE_7 && PE_0 >= PE_8 && PE_0 >= PE_9)
            max_val = 4'b0000;
        else
        //1
        if (PE_1 >= PE_0 && PE_1 >= PE_2 && PE_1 >= PE_3 && PE_1 >= PE_4 && PE_1 >= PE_5 && PE_1 >= PE_6 && PE_1 >= PE_7 && PE_1 >= PE_8 && PE_1 >= PE_9)
            max_val = 4'b0001;
        else
        //2
        if (PE_2 >= PE_0 && PE_2 >= PE_1 && PE_2 >= PE_3 && PE_2 >= PE_4 && PE_2 >= PE_5 && PE_2 >= PE_6 && PE_2 >= PE_7 && PE_2 >= PE_8 && PE_2 >= PE_9)
            max_val = 4'b0010;
        else
        //3
        if (PE_3 >= PE_0 && PE_3 >= PE_1 && PE_3 >= PE_2 && PE_3 >= PE_4 && PE_3 >= PE_5 && PE_3 >= PE_6 && PE_3 >= PE_7 && PE_3 >= PE_8 && PE_3 >= PE_9)
            max_val = 4'b0011;
        else
        //4
        if (PE_4 >= PE_0 && PE_4 >= PE_1 && PE_4 >= PE_2 && PE_4 >= PE_3 && PE_4 >= PE_5 && PE_4 >= PE_6 && PE_4 >= PE_7 && PE_4 >= PE_8 && PE_4 >= PE_9)
            max_val = 4'b0100;

        else
        //5
        if (PE_5 >= PE_0 && PE_5 >= PE_1 && PE_5 >= PE_2 && PE_5 >= PE_3 && PE_5 >= PE_4 && PE_5 >= PE_6 && PE_5 >= PE_7 && PE_5 >= PE_8 && PE_5 >= PE_9)
            max_val = 4'b0101;

        else
        //6
        if (PE_6 >= PE_0 && PE_6 >= PE_1 && PE_6 >= PE_2 && PE_6 >= PE_3 && PE_6 >= PE_4 && PE_6 >= PE_5 && PE_6 >= PE_7 && PE_6 >= PE_8 && PE_6 >= PE_9)
            max_val = 4'b0110;

        else
        //7
        if (PE_7 >= PE_0 && PE_7 >= PE_1 && PE_7 >= PE_2 && PE_7 >= PE_3 && PE_7 >= PE_4 && PE_7 >= PE_5 && PE_7 >= PE_6 && PE_7 >= PE_8 && PE_7 >= PE_9)
            max_val = 4'b0111;

        else
        //8
        if (PE_8 >= PE_0 && PE_8 >= PE_1 && PE_8 >= PE_2 && PE_8 >= PE_3 && PE_8 >= PE_4 && PE_8 >= PE_5 && PE_8 >= PE_6 && PE_8 >= PE_7 && PE_8 >= PE_9)
            max_val = 4'b1000;

        else
        //9
        if (PE_9 >= PE_0 && PE_9 >= PE_1 && PE_9 >= PE_2 && PE_9 >= PE_3 && PE_9 >= PE_4 && PE_9 >= PE_5 && PE_9 >= PE_6 && PE_9 >= PE_7 && PE_9 >= PE_8)
            max_val = 4'b1001;
    end
endmodule

