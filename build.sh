#!/bin/bash

PROJECT_NAME="fpga_project"
# TOP_ENTITY="top"
# DEVICE_FAMILY="Cyclone IV E"
# DEVICE_PART="EP4CE22F17C6"
# OUT_DIR="output_files"

# # 1. 如果專案還沒初始化，先初始化
# if [ ! -f "${PROJECT_NAME}.qsf" ]; then
#     echo "Initializing new project..."
#     quartus_sh.exe --prepare -f "$DEVICE_FAMILY" -t "$TOP_ENTITY" "$PROJECT_NAME"
# fi

# echo "Setting Project Assignments..."

# # 使用 --tcl_eval 直接寫入 QSF 設定，避開長參數解析問題
# quartus_sh.exe --tcl_eval project_open $PROJECT_NAME <<EOF
# set_global_assignment -name TOP_LEVEL_ENTITY $TOP_ENTITY
# set_global_assignment -name PROJECT_OUTPUT_DIRECTORY $OUT_DIR
# set_global_assignment -name DEVICE $DEVICE_PART
# set_global_assignment -name VERILOG_FILE rtl/top.v

# # 指定腳位
# set_location_assignment PIN_R8 -to CLOCK_50
# set_location_assignment PIN_A15 -to LED[0]
# set_location_assignment PIN_A13 -to LED[1]
# set_location_assignment PIN_B13 -to LED[2]
# set_location_assignment PIN_A11 -to LED[3]
# set_location_assignment PIN_D1 -to LED[4]
# set_location_assignment PIN_F3 -to LED[5]
# set_location_assignment PIN_B1 -to LED[6]
# set_location_assignment PIN_L3 -to LED[7]

# export_assignments
# project_close
# EOF

echo "Starting Compilation..."

# 3. 執行編譯全流程
quartus_sh.exe --flow compile $PROJECT_NAME