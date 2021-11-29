`timescale 1ns/10ps

//------------------------------------------------------------------------------
//  Single-port SRAM model
//
//  This design was found at:
//      https://www.chipverify.com/verilog/verilog-single-port-ram
//------------------------------------------------------------------------------

module Single_Port_Sram
    #(
        parameter ADDR_WIDTH = 16,      // Address width for data select
        parameter DATA_WIDTH = 8,       // Data width for read/write
        parameter DEPTH = 2**16         // Memory depth
    )

    (
        input                   clk,    // Clock
        input [ADDR_WIDTH-1:0]  addr,   // Address to read/write
        inout [DATA_WIDTH-1:0]  data,   // Data lines to read/write
        input                   cs,     // Chip select
        input                   we,     // Write enable
        input                   oe      // Output enable
    );

    reg [DATA_WIDTH-1:0]    tmp_data;
    reg [DATA_WIDTH-1:0]    mem [DEPTH-1:0];    // 65535 8-bit memory cells

    always @(posedge clk) begin
        if (cs & we) begin                  // Write to memory
            mem[addr] <= data;
        end
    end

    always @ (posedge clk) begin
        if (cs & !we) begin                 // Read from memory
            tmp_data <= mem[addr];
        end
    end

    assign data = cs & oe & !we ? tmp_data : 'hz;

endmodule
