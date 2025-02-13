module rgb_led_hsv_tb;
    logic clk;
    logic rst_n;
    logic led_r, led_g, led_b;

    rgb_led_simple dut (.*);

    initial begin
        clk = 0;
        forever #41.667 clk = ~clk;
    end

    // Test sequence
    initial begin
        rst_n = 0;
        #100;
        rst_n = 1;
        
        #2_000_000;
        
        $finish;
    end
endmodule