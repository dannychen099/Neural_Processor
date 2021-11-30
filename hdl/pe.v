`timescale 1ns/10ps

/*-----------------------------------------------------------------------------
    The PE has 4 modes of operation:
        1) Programming the weight IDs
        2) Listening for broadcast IDs that match the programmed IDs
        3) Calculating a MAC output
        4) Accumulating psums upwards through a PE array
        5) Sending psum value

    -- 1 --
    Programming the weight IDs for the filter/ifmap/psum weights is done by 
    first selecting the x and y coordiantes of the PE with  enable_x and 
    enable_y. Then, the PE must be set to receive weights by setting 
    control = 3'b001. Then, any values present on the filter_id, or ifmap_id 
    data lines is saved to internal registers.

    -- 2 --
    Listening to broadcast IDs is done by first selecting the x and y 
    coordinates of the PE by setting enable_x and enable_y high. Then,
    set control = 3'b010. Weight IDs are then broadcast on the filter_id, and 
    ifmap_id lines. With each broadcast, the weight values are simultaneously 
    broadcast on the  filter and ifmap data lines. If the filter_id and 
    ifmap_id broadcast values match the internally stored filter_id_reg and 
    ifmap_id_reg values, then the filter and ifmap values are saved in the PE.

    -- 3 --
    Calculating an MAC output is done when control = 3'b011 and with the PE 
    enabled by setting enable_x and enable_y high. Any internally stored filter
    weight, ifmap weight, and psum will generate an output. 

    -- 4 --
    A grid of PEs accumulate their psums upwards in the Row-Stationary 
    dataflow. Each PE has a secondary input that can be connected to another 
    PE's output psum. By setting control = 3'b100, and enabling the PE by 
    setting enable_x and enable_y high, this value is taken into the PE and 
    accumulated with the PE's own psum.

    -- 5 --
    The finalized ofmap value is retrieved at the end of a complete 
    convolution. After the psums have been fully accumulated, the PE may put 
    its calculated ofmap psum on the psum_output data line. Enable the PE by 
    setting enable_x and enable_y high and set control = 3'b101.

    If the PE shouldn't be doing anything (like waiting for other PEs to get their values), then it can be disabled by clearing enable_x and enable_y.
/-----------------------------------------------------------------------------*/
module pe
    #(
        parameter       BITWIDTH    = 16,
        parameter       GRID_X      = 0,
        parameter       GRID_Y      = 0,
        parameter [3:0] CTRL_PROG   = 3'b001,   // Control states
                        CTRL_LISTEN = 3'b010,
                        CTRL_MAC    = 3'b011,
                        CTRL_ACC    = 3'b100,
                        CTRL_PSUM   = 3'b101
    )
    (
        input   clk,            // Clock input
        input   rstb,           // Active-low reset
        input   enable_x,       // PE array X coordinate for ID and power gating
        input   enable_y,       // PE array Y coordinate for ID and power gating
        input [3:0] control,    // Control signal to tell what the PE should do

        // The same ports are used for programming ID values and broadcasting
        input [4:0] filter_id,  // Filter ID input
        input [5:0] ifmap_id,   // Ifmap ID input
        //input   [4:0] psum_id,  // unused for now?

        input signed [BITWIDTH-1:0] filter, // filter weight input
        input signed [BITWIDTH-1:0] ifmap,  // ifmap weight input
        input signed [BITWIDTH-1:0] psum,   // psum input
        input signed [BITWIDTH-1:0] below_psum, // port to the PE below for acc.
        
        output reg signed [BITWIDTH-1:0] psum_output   // psum output
    );

    reg [BITWIDTH-1:0]  filter_reg; // Stores current filter weight
    reg [BITWIDTH-1:0]  ifmap_reg;  // Stores current ifmap weight
    reg [BITWIDTH-1:0]  psum_reg;   // Stores current psum value
    wire [BITWIDTH-1:0] mac_output; // Output of the MAC (is psum)

    reg [4:0]   filter_id_reg;      // Stores filter ID
    reg [5:0]   ifmap_id_reg;       // Stores ifmap ID

    // Each PE has a MAC of its own
    mac
        #(
            .WIDTH(BITWIDTH)
        )
        pe_mac(
            .A      (filter_reg),
            .B      (ifmap_reg),
            .clk    (clk),
            .rstb   (rstb),
            .out    (mac_output)
        );

    always @(posedge clk or negedge rstb) begin
        // If reset is triggered...
        if (!rstb) begin
            filter_reg      <= 'sd0;
            ifmap_reg       <= 'sd0;
            psum_reg        <= 'sd0;
            filter_id_reg   <= 'sd0;
            ifmap_id_reg    <= 'sd0;
            psum_output     <= 'sd0;
        end else begin
            // Use enable_x and enable_y for power gating
            if (enable_x && enable_y) begin
                case (control)
                    // are enums synthesizable?
                    3'b000: begin
                        filter_reg  <= filter;
                        ifmap_reg   <= ifmap;
                        psum_reg    <= psum;
                    end
                endcase
            end
        end
    end
endmodule
