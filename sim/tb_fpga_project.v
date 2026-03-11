`timescale 1ns/1ps

module tb_fpga_project();

    reg  CLOCK_50;
    wire [7:0]   LED;
    reg  [1:0]   KEY;
    reg  [3:0]   SW;

    // 實例化被測設計 (DUT)
    fpga_project dut (
        .CLOCK_50(CLOCK_50),
        .LED(LED),
        .KEY(KEY),
        .SW(SW)
    );

    initial begin
        CLOCK_50 = 0;
        forever #10 CLOCK_50 = ~CLOCK_50;
    end

    // 測試流程
    initial begin
        // Initialize Inputs
        KEY = 2'b10;
        SW  = 'd0;

        #5;
        KEY[0] = 1;
        $display("Test Start.");

        #200;
        
        $display("Test Finished.");
        $finish;
    end

    // 產生波形檔供
    initial begin
        $dumpfile("tb_fpga_project.vcd");
        $dumpvars(0, tb_fpga_project);
    end

endmodule