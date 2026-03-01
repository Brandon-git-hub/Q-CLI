#!/bin/bash

SOF_FILE="output_files/fpga_project.sof"

echo "Checking for USB-Blaster..."
quartus_pgm.exe -l

echo "Programming DE0-Nano..."
# -m jtag: 使用 JTAG 模式
# -c: 指定硬體名稱 (通常是 USB-Blaster)
# -o: 指令 "p" 代表 program (燒錄)
quartus_pgm.exe -m jtag -c "USB-Blaster" -o "p;$SOF_FILE"
