module top (
    input  logic clk,  
    output logic RGB_R,  
    output logic RGB_G,  
    output logic RGB_B   
);

    // Counter for timing (12MHz clock, need 2M cycles for 1/6 second)
    logic [20:0] counter;  // 21 bits for 2M counts
    logic [2:0] color_select;  // 3 bits to select among 6 colors

    always_ff @(posedge clk) begin
        if (counter == 2_000_000) begin
            counter <= '0;
            if (color_select == 5)
                color_select <= '0;
            else
                color_select <= color_select + 1;
        end else begin
            counter <= counter + 1;
        end
    end

    always_comb begin
        case (color_select)
            0: {RGB_R, RGB_G, RGB_B} = 3'b100;  // RED
            1: {RGB_R, RGB_G, RGB_B} = 3'b110;  // YELLOW
            2: {RGB_R, RGB_G, RGB_B} = 3'b010;  // GREEN
            3: {RGB_R, RGB_G, RGB_B} = 3'b011;  // CYAN
            4: {RGB_R, RGB_G, RGB_B} = 3'b001;  // BLUE
            5: {RGB_R, RGB_G, RGB_B} = 3'b101;  // MAGENTA
            default: {RGB_R, RGB_G, RGB_B} = 3'b000;  // OFF
        endcase
    end
    
endmodule