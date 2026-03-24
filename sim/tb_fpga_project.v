`timescale 1ns/1ps

module tb_fpga_project();

    reg        CLOCK_50;
    wire [7:0] LED;
    reg  [1:0] KEY;
    reg  [3:0] SW;
    wire [33:0] GPIO_0;
    reg        uart_rx_tb; // UART stimulus from testbench

    // Drive the DUT's RX pin (GPIO_0[0]) from our stimulus register.
    assign GPIO_0[0] = uart_rx_tb;

    // 實例化被測設計 (DUT)
    fpga_project dut (
        .CLOCK_50(CLOCK_50),
        .LED(LED),
        .KEY(KEY),
        .SW(SW),
        .GPIO_0(GPIO_0) // Connect GPIO for UART
    );

    // Clock generator
    initial begin
        CLOCK_50 = 0;
        forever #10 CLOCK_50 = ~CLOCK_50; // 50 MHz clock
    end

    // UART Send Task
    // Baud rate is approx 115200 for 50MHz clock and divider of 434
    // Bit period = 434 * 20ns = 8680 ns
    task uart_send_byte(input [7:0] data);
        integer i;
        begin
            // Start bit (low)
            uart_rx_tb = 1'b0;
            #(8680);

            // 8 Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                uart_rx_tb = data[i];
                #(8680);
            end

            // Stop bit (high)
            uart_rx_tb = 1'b1;
            #(8680);
        end
    endtask

    // 測試流程
    initial begin
        // Initialize Inputs
        KEY = 2'b11; // De-assert reset (rst_n = 1)
        SW  = 4'b0000;
        uart_rx_tb = 1'b1; // UART idle is high

        #200;
        
        // Assert reset
        KEY[0] = 0;
        #200;
        
        // De-assert reset
        KEY[0] = 1;
        #200;

        $display("Test Start: Sending 3 consecutive bytes (0xAA, 0x55, 0xF0) to test FIFO.");

        // Send three bytes back-to-back to test FIFO buffering
        uart_send_byte(8'hAA);
        uart_send_byte(8'h55);
        uart_send_byte(8'hF0);

        // Wait long enough for the DUT to loop back all three bytes.
        // Each byte takes 10 bit-periods to send. 3 bytes * 10 * 8680 ns
        #(3 * 10 * 8680);
        
        #20000; // Some extra margin

        $display("Test Finished. Check tb_fpga_project.vcd waveform to verify loopback.");
        $finish;
    end

    // 產生波形檔供
    initial begin
        $dumpfile("tb_fpga_project.vcd");
        $dumpvars(0, tb_fpga_project);
    end

endmodule
