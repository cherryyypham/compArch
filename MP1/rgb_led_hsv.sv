module rgb_led_hsv (
    input  logic clk, 
    input  logic rst_n,  
    output logic led_r,  
    output logic led_g,  
    output logic led_b   
);

    // Counter for timing (12MHz clock, need 2M cycles for 1/6 second)
    logic [20:0] counter;  // 21 bits for 2M counts
    logic [2:0] color_select;  // 3 bits to select among 6 colors

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= '0;
            color_select <= '0;
        end else begin
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
    end

    always_comb begin
        case (color_select)
            0: {led_r, led_g, led_b} = 3'b100;  // RED
            1: {led_r, led_g, led_b} = 3'b110;  // YELLOW
            2: {led_r, led_g, led_b} = 3'b010;  // GREEN
            3: {led_r, led_g, led_b} = 3'b011;  // CYAN
            4: {led_r, led_g, led_b} = 3'b001;  // BLUE
            5: {led_r, led_g, led_b} = 3'b101;  // MAGENTA
            default: {led_r, led_g, led_b} = 3'b000;  // OFF
        endcase
    end
    
endmodule