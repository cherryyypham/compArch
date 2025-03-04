`timescale 1ns/1ps

module rgb_hsv_pwm_tb;
    // Clock and signals
    reg clk;
    wire RGB_R;
    wire RGB_G;
    wire RGB_B;
    
    // Instantiate the module
    rgb_hsv_pwm uut (
        .clk(clk),
        .RGB_R(RGB_R),
        .RGB_G(RGB_G),
        .RGB_B(RGB_B)
    );
    
    // Clock generation
    always #5 clk = ~clk; // 100 MHz clock (10 ns period)
    
    // Simulation control
    initial begin
        $dumpfile("rgb_hsv_pwm.vcd"); // Output waveform file
        $dumpvars(0, rgb_hsv_pwm_tb);
        
        clk = 0;
        
        // Run for just over 1 second to see the full cycle
        #1_100_000_000;
        
        $display("Simulation complete!");
        $finish;
    end
    
    // For monitoring the transition points more closely
    integer sample_interval = 16_666_667; // Sample at ~6 times per second (roughly at the transition points)
    integer monitor_counter = 0;
    
    always @(posedge clk) begin
        monitor_counter <= monitor_counter + 1;
        
        // Sample approximately at transition points plus midpoints
        if (monitor_counter % sample_interval == 0) begin
            $display("Time: %0t ms | RGB: R=%b G=%b B=%b", 
                    $time/1_000_000, RGB_R, RGB_G, RGB_B);
        end
    end
endmodule