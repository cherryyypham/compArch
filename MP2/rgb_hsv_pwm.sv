// `timescale 1ns/1ps

// module rgb_hsv_pwm (
//     input clk,
//     output wire RGB_R,
//     output wire RGB_G,
//     output wire RGB_B
// );

//     // Counter for timing
//     reg [26:0] counter = 0;
//     reg [7:0] pwm_counter = 0;
    
//     // Constants for timing
//     localparam CLK_FREQ = 100_000_000;  // 100MHz
//     localparam FULL_CYCLE_TIME = CLK_FREQ;  // 1 second for full cycle
//     localparam SEGMENT_TIME = FULL_CYCLE_TIME / 6;  // Time per color segment
    
//     // Position tracking
//     reg [26:0] cycle_position = 0;  // Position within the entire color cycle
//     reg [2:0] segment = 0;          // Current color segment (0-5)
//     reg [7:0] t = 0;                // Transition progress (0-255)
    
//     // RGB values
//     reg [7:0] r_val = 255, g_val = 0, b_val = 0;
    
//     always @(posedge clk) begin
//         // Increment counters
//         cycle_position <= (cycle_position >= FULL_CYCLE_TIME - 1) ? 0 : cycle_position + 1;
//         pwm_counter <= pwm_counter + 1;
        
//         // Calculate which segment we're in and progress within segment
//         segment <= cycle_position / SEGMENT_TIME;
        
//         // Calculate transition value (0-255) based on position within segment
//         t <= ((cycle_position % SEGMENT_TIME) * 255) / (SEGMENT_TIME - 1);
        
//         // Set RGB values based on segment and transition progress
//         case (segment)
//             0: begin // Red to Yellow (R=255, G=0→255, B=0)
//                 r_val <= 255;
//                 g_val <= t;
//                 b_val <= 0;
//             end
//             1: begin // Yellow to Green (R=255→0, G=255, B=0)
//                 r_val <= 255 - t;
//                 g_val <= 255;
//                 b_val <= 0;
//             end
//             2: begin // Green to Cyan (R=0, G=255, B=0→255)
//                 r_val <= 0;
//                 g_val <= 255;
//                 b_val <= t;
//             end
//             3: begin // Cyan to Blue (R=0, G=255→0, B=255)
//                 r_val <= 0;
//                 g_val <= 255 - t;
//                 b_val <= 255;
//             end
//             4: begin // Blue to Magenta (R=0→255, G=0, B=255)
//                 r_val <= t;
//                 g_val <= 0;
//                 b_val <= 255;
//             end
//             5: begin // Magenta to Red (R=255, G=0, B=255→0)
//                 r_val <= 255;
//                 g_val <= 0;
//                 b_val <= 255 - t;
//             end
//         endcase
//     end
    
//     // PWM outputs
//     assign RGB_R = (pwm_counter < r_val);
//     assign RGB_G = (pwm_counter < g_val);
//     assign RGB_B = (pwm_counter < b_val);

// endmodule

module top (
    input  logic clk,  
    output logic RGB_R,  
    output logic RGB_G,  
    output logic RGB_B   
);

    localparam INC_DEC_INTERVAL = 12000,     // CLK frequency is 12MHz, so 12,000 cycles is 1ms
    localparam INC_DEC_MAX = 200,            // Transition to next state after 200 increments / decrements, which is 0.2s
    localparam PWM_INTERVAL = 1200,          // CLK frequency is 12MHz, so 1,200 cycles is 100us
    localparam INC_DEC_VAL = PWM_INTERVAL / INC_DEC_MAX
    
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