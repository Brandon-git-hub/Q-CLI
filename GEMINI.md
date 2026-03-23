# 專案概覽 (Project Overview)
這是一個基於 Intel/Altera Cyclone IV 架構的 DE0-Nano FPGA 專案（晶片型號：EP4CE22F17C6）。
主要硬體描述語言為 Verilog。專案包含了從 RTL 設計、硬體模擬、邏輯合成到實體硬體燒錄的完整流程。

## 專案結構 (Directory Structure)
- `rtl/`: 存放 Verilog RTL 原始碼檔案（頂層模組為 `fpga_project.v`）。
- `sim/`: 包含測試平台 (Testbench)、模擬用的 `Makefile`，以及 Yosys 邏輯合成腳本 (`synth.ys`)。
- `doc/DE0_Nano/`: 包含 DE0-Nano 開發板及相關晶片（如 Cyclone IV, I2C EEPROM, ADC 等）的規格書與參考文件。
- `lib/`: 存放供 `netlistsvg` 產生電路圖時使用的自訂 SVG 佈景主題。
- `output_files/`: Quartus 編譯後產生的二進制輸出檔案（例如供 SRAM 燒錄的 `.sof` 檔與供 EPCS 燒錄的 `.jic` 檔）。
- `build.sh`: 執行 Quartus CLI (`quartus_sh.exe` 與 `quartus_cpf.exe`) 進行專案編譯與格式轉換的 Bash 腳本。
- `program_sram.sh`: 透過 Quartus Programmer (`quartus_pgm.exe`) 將 `.sof` 檔燒錄至 FPGA SRAM (揮發性) 的 Bash 腳本。
- `program_epcs.sh`: 透過 JTAG Indirect Configuration 模式，將 `.jic` 檔燒錄至 EPCS 記憶體 (非揮發性) 的 Bash 腳本。

## 關鍵技術與工具 (Key Technologies & Tools)
- **硬體描述語言:** Verilog
- **FPGA 晶片 / 開發板:** Cyclone IV (EP4CE22F17C6) / Terasic DE0-Nano
- **主要開發工具:** Intel Quartus Prime (使用 CLI 工具 `quartus_sh.exe` 及 `quartus_pgm.exe`)
- **模擬工具 (Simulation):** Icarus Verilog (`iverilog`, `vvp`) & GTKWave (`gtkwave`)
- **邏輯合成與視覺化 (Synthesis & Visualization):** Yosys & `netlistsvg`

## 建置與執行 (Building and Running)
開發或測試前，請確認系統中已安裝並配置好對應的環境變數。若在 WSL 環境下遇到 `Exec format error`，請參考 `README.md` 中的 WSLInterop 修復指令。

### 1. 硬體編譯與燒錄 (Hardware Compile & Program)
- **編譯專案:** 執行 `./build.sh` 進行硬體編譯、佈線，並產生 `.sof` 及 `.jic` 檔。
- **燒錄至 SRAM (揮發性):** 確認 DE0-Nano 已透過 USB-Blaster 連接，執行 `./program_sram.sh` 進行快速測試。
- **燒錄至 EPCS (非揮發性):** 執行 `./program_epcs.sh` 將韌體寫入 Flash，使斷電後仍能保存設計。

### 2. 模擬與波形觀察 (Simulation)
進入 `sim/` 目錄，可使用以下 Makefile 指令進行操作：
- **頂層模組模擬:** 
  - `make all`: 清除舊檔案、編譯 `fpga_project.v` 與其 Testbench，並執行模擬。
  - `make wave_project`: 開啟 `gtkwave` 檢視頂層模擬波形。
- **獨立模組模擬 (UART & GPIO):**
  - `make modules`: 編譯子模組與其專屬 Testbench (`tb_modules.v`)，並執行模擬。
  - `make wave_modules`: 開啟 `gtkwave` 檢視模組層級模擬波形。

### 3. 邏輯合成與電路圖產生 (Synthesis & Schematics)
- 進入 `sim/` 目錄並執行 `make synth`。此指令會呼叫 Yosys (`synth.ys`) 對 RTL 設計進行多階段的合成與最佳化，並自動利用 `netlistsvg` 產生對應的 SVG 硬體電路圖 (包含 RTL層級、最佳化層級與閘級電路圖)。

## 開發規範與 AI 指引 (Development Conventions & AI Instructions)
- **語言預設:** 請始終以「繁體中文」進行回答。
- **修改原則:** 除非使用者特別要求，否則請勿直接修改原始碼檔案，請以提供程式碼片段及修改建議為主。
- **測試流程:** 若使用者要求新增功能或修復問題，建議提示使用者更新對應的 Testbench (`sim/tb_fpga_project.v` 或 `sim/tb_modules.v`)，並透過 `make all` 或 `make modules` 來驗證其正確性。