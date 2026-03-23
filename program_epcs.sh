#!/bin/bash

JIC_FILE="output_files/fpga_project.sof"

echo "Checking for USB-Blaster..."
quartus_pgm.exe -l

echo "Programming DE0-Nano..."
# -m jtag: 使用 JTAG 模式
# -c: 指定硬體名稱 (通常是 USB-Blaster)
# -o: 指令 "p" 代表 program (燒錄), v: Verify (驗證), b: Blank-check (檢查是否為空，可選)
#     i: 重要！這代表 "JTAG Indirect Configuration"。少了這個 i，Programmer 會以為你要把這份檔案直接塞進 FPGA 的 SRAM，導致裝置辨識錯誤。
quartus_pgm.exe -m jtag -c "USB-Blaster" -o "pvbi;$JIC_FILE"

# Using programming cable "USB-Blaster [USB-0]"
# Device 1 contains JTAG ID code 0x020F30DD
# Device 1 silicon ID is 0x16
