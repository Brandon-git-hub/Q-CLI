`timescale 1ns / 1ps

module tb_modules;

    reg clk;
    reg rst_n;
    
    // 產生 50MHz Clock (20ns period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    // UART signals
    reg tx_start;
    reg [7:0] tx_data;
    wire tx;
    wire tx_busy;
    
    wire [7:0] rx_data;
    wire rx_ready;
    
    // GPIO signals
    reg bang_start;
    reg [2:0] bang_data_in;
    wire pa3, pa4, pa6;
    
    // Instantiate TX
    // For fast simulation, use CLKS_PER_BIT = 4
    uart_tx #(.CLKS_PER_BIT(4)) u_tx (
        .clk(clk),
        .rst_n(rst_n),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );
    
    // Instantiate RX
    // Connect tx directly to rx for loopback test
    uart_rx #(.CLKS_PER_BIT(4)) u_rx (
        .clk(clk),
        .rst_n(rst_n),
        .rx(tx),
        .rx_data(rx_data),
        .rx_ready(rx_ready)
    );
    
    // Instantiate GPIO Bit Bang
    gpio_bit_bang u_gpio (
        .clk(clk),
        .rst_n(rst_n),
        .bang_start(bang_start),
        .bang_data_in(bang_data_in),
        .pa3(pa3),
        .pa4(pa4),
        .pa6(pa6)
    );
    
    initial begin
        $dumpfile("tb_modules.vcd");
        $dumpvars(0, tb_modules);
        
        // Initialize
        rst_n = 0;
        tx_start = 0;
        tx_data = 0;
        bang_start = 0;
        bang_data_in = 0;
        
        #50;
        rst_n = 1;
        
        // Test UART
        #50;
        @(posedge clk);
        tx_data = 8'hA5; // 10100101
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;
        
        // Wait for rx_ready to go high
        wait(rx_ready == 1);
        
        if (rx_data == 8'hA5) begin
            $display("UART Test PASSED: Expected %h, Got %h", 8'hA5, rx_data);
        end else begin
            $display("UART Test FAILED: rx_ready=%b, Expected %h, Got %h", rx_ready, 8'hA5, rx_data);
        end
        
        // Test GPIO Bit Bang
        #50;
        @(posedge clk);
        bang_data_in = 3'b101; // pa6=1, pa4=0, pa3=1
        bang_start = 1;
        @(posedge clk);
        bang_start = 0;
        
        #50;
        if (pa6 == 1'b1 && pa4 == 1'b0 && pa3 == 1'b1) begin
            $display("GPIO Test PASSED");
        end else begin
            $display("GPIO Test FAILED");
        end
        
        #100;
        $finish;
    end

endmodule
