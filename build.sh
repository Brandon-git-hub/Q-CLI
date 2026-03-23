#!/bin/bash

PROJECT_NAME="fpga_project"

echo "Starting Compilation..."

quartus_sh.exe --flow compile $PROJECT_NAME

quartus_cpf.exe -c -d EPCQ64 -s EP4CE22F17C6 output_files/fpga_project.sof output_files/fpga_project.jic
