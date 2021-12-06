`timescale 1ns/10ps

module gin
#(
    parameter BITWIDTH          = 16,
    parameter TAG_LENGTH        = 4,
    parameter NUM_CONTROLLERS   = 10,
    parameter Y_BUS_SIZE      = NUM_CONTROLLERS,
    parameter X_BUS_SIZE      = NUM_CONTROLLERS,
    parameter Y_PACKET_LENGTH   = 2*TAG_LENGTH + BITWIDTH,
    parameter X_PACKET_LENGTH   = TAG_LENGTH + BITWIDTH
)
(
    input                           clk,
    input                           rstb,
    input                           program,
    input  [TAG_LENGTH-1:0]         scan_tag_in,
    output [TAG_LENGTH-1:0]         scan_tag_out,
    input                           gin_enable,
    output                          gin_ready,
    inout  [Y_PACKET_LENGTH-1:0]    data_packet, //2 tags in data, to split
    // PE connections
    output [X_BUS_SIZE*Y_BUS_SIZE-1:0] pe_enable,
    input  [X_BUS_SIZE*Y_BUS_SIZE-1:0] pe_ready,
    inout  [(BITWIDTH*X_BUS_SIZE*Y_BUS_SIZE)-1:0] pe_value
);

    // Y-bus internal connections (single y-bus)
    wire [TAG_LENGTH-1:0]                   row_id;
    wire [X_PACKET_LENGTH-1:0]              y_value_to_pass;
    wire [(X_PACKET_LENGTH*Y_BUS_SIZE)-1:0] y_bus_output;

    // X-bus internal connections (multiple x-buses)
    wire [TAG_LENGTH-1:0]               col_id          [0:Y_BUS_SIZE-1];
    wire [X_PACKET_LENGTH-1:0]          x_data_packet   [0:Y_BUS_SIZE-1];
    wire [(BITWIDTH*X_BUS_SIZE)-1:0]    x_bus_output    [0:Y_BUS_SIZE-1];
    wire [BITWIDTH-1:0]                 x_value_to_pass [0:Y_BUS_SIZE-1];
    wire [Y_BUS_SIZE-1:0]               x_bus_enable;
    wire [Y_BUS_SIZE-1:0]               x_bus_ready; 
    wire [X_BUS_SIZE-1:0]               x_bus_pe_enable [0:Y_BUS_SIZE-1];
    wire [X_BUS_SIZE-1:0]               x_bus_pe_ready  [0:Y_BUS_SIZE-1];

    wire [TAG_LENGTH-1:0]               bus_scan_tag_out[0:Y_BUS_SIZE];
    assign scan_tag_out = bus_scan_tag_out[Y_BUS_SIZE];


    // Split the incoming data packet into the tag (row_id) and value 
    assign row_id = data_packet[Y_PACKET_LENGTH-1:X_PACKET_LENGTH];
    assign y_value_to_pass = data_packet[X_PACKET_LENGTH-1:0];

    // Y-bus multicast controller state/enable
    assign gin_ready = &x_bus_ready;

    gin_bus
    #(
        .BITWIDTH       (X_PACKET_LENGTH),
        .TAG_LENGTH     (TAG_LENGTH),
        .NUM_CONTROLLERS(Y_BUS_SIZE)
    )
    y_bus
    (
        .clk                (clk),
        .rstb               (rstb),
        .program            (program),
        .scan_tag_in        (scan_tag_in),
        .scan_tag_next_bus  (bus_scan_tag_out[0]), 
        .bus_enable         (gin_enable),
        .bus_ready          (gin_ready),
        .tag                (row_id),
        .data_source        (y_value_to_pass),
        .target_enable      (x_bus_enable),
        .target_ready       (x_bus_ready),
        .output_value       (y_bus_output)
    );

    generate
        genvar i;
        for (i = 0; i < Y_BUS_SIZE; i = i+1) begin: x_bus_vector

            // Take each Y-bus controller output and assign the data packet to
            // each X-bus's input data packet.
            assign x_data_packet[i]
                = y_bus_output[X_PACKET_LENGTH*(i+1)-1:(X_PACKET_LENGTH*i)];

            // Split each X-bus data packet into the col_id (which PE) and 
            // value to pass
            assign col_id[i] = x_data_packet[i][X_PACKET_LENGTH-1:BITWIDTH];
            assign x_value_to_pass[i] = x_data_packet[i][BITWIDTH-1:0];
    
            assign pe_enable[i*X_BUS_SIZE +: X_BUS_SIZE] = x_bus_pe_enable[i];
            assign pe_value[i*X_BUS_SIZE*BITWIDTH +: X_BUS_SIZE*BITWIDTH] = x_bus_output[i];
            assign x_bus_pe_ready[i] = pe_ready[i*X_BUS_SIZE +: X_BUS_SIZE];
            
            
            gin_bus
            #(
                .BITWIDTH       (BITWIDTH),
                .TAG_LENGTH     (TAG_LENGTH),
                .NUM_CONTROLLERS(X_BUS_SIZE)
            )
            x_bus
            (
                .clk                (clk),
                .rstb               (rstb),
                .program            (program),
                .scan_tag_in        (bus_scan_tag_out[i]),
                .scan_tag_next_bus  (bus_scan_tag_out[i+1]),
                .bus_enable         (x_bus_enable[i]),
                .bus_ready          (x_bus_ready[i]),
                .tag                (col_id[i]),
                .data_source        (x_value_to_pass[i]),
                .target_enable      (x_bus_pe_enable[i]),
                .target_ready       (x_bus_pe_ready[i]),
                .output_value       (x_bus_output[i])
            );
        end
    endgenerate
endmodule
