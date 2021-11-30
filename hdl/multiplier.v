`timescale 1ns/10ps

module multiplier
    #(
        parameter WIDTH = 16    // Bit width for each operand
    )
   
    (
        input signed    [WIDTH-1:0]   operand_a, 
        input signed    [WIDTH-1:0]   operand_b,

        output signed   [WIDTH-1:0]  result
    );
    
    assign result = operand_a * operand_b;

endmodule
