`timescale 1ns/1ps

module tb_tap();

    // 訊號定義
    reg  tck;
    reg  trst_n;
    reg  tms;
    wire [3:0] current_state;

    // 實例化被測設計 (DUT)
    tap_fsm dut (
        .tck(tck),
        .trst_n(trst_n),
        .tms(tms),
        .state(current_state)
    );

    // 產生時鐘 (TCK)，週期 20ns (50MHz)
    always #10 tck = ~tck;

    // 測試流程
    initial begin
        // 初始化
        tck = 0;
        trst_n = 0;
        tms = 1;      // JTAG 標準：TMS 保持 1 會回到 Reset
        
        // 1. 硬體重置
        #45 trst_n = 1;
        $display("--- Reset Released ---");

        // 2. 確保回到 TEST-LOGIC-RESET (連打 5 個 TMS=1)
        @(posedge tck); tms = 1;
        repeat(5) @(posedge tck);
        $display("State: %h (Expected: 0 - TEST_LOGIC_RESET)", current_state);

        // 3. 前往 SHIFT-DR 狀態 (路徑：0 -> 1 -> 2 -> 3 -> 4)
        // TMS 序列應為: 0 -> 1 -> 0 -> 0
        @(posedge tck); tms = 0; // -> RUN-TEST/IDLE
        @(posedge tck); tms = 1; // -> SELECT-DR-SCAN
        @(posedge tck); tms = 0; // -> CAPTURE-DR
        @(posedge tck); tms = 0; // -> SHIFT-DR
        
        $display("Entering SHIFT-DR...");
        repeat(8) @(posedge tck); // 在 SHIFT-DR 停留 8 個週期 (模擬移位 8 bits)
        
        // 4. 回到 RUN-TEST/IDLE (路徑：4 -> 5 -> 8 -> 1)
        // TMS 序列應為: 1 -> 1 -> 0
        @(posedge tck); tms = 1; // -> EXIT1-DR
        @(posedge tck); tms = 1; // -> UPDATE-DR
        @(posedge tck); tms = 0; // -> RUN-TEST/IDLE

        $display("Back to IDLE.");
        #100;
        $display("Test Finished.");
        $finish;
    end

    // 產生波形檔供 GTKWave 查看
    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, tb_tap);
    end

endmodule