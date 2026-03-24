# 定義變數
RTL_ALL = ../rtl/fpga_project.v ../rtl/uart_tx.v ../rtl/uart_rx.v ../rtl/gpio_bit_bang.v ../rtl/fifo.v
TB_PROJECT = ../sim/tb_fpga_project.v
TB_MODULES = ../sim/tb_modules.v

all: clean compile_project run_project

# 頂層專案模擬
compile_project:
	iverilog -o sim_project.out $(RTL_ALL) $(TB_PROJECT)

run_project:
	vvp sim_project.out

wave_project:
	gtkwave tb_fpga_project.vcd waves.gtkw

# 獨立模組模擬 (UART & GPIO)
modules: clean compile_modules run_modules

compile_modules:
	iverilog -o sim_modules.out $(RTL_ALL) $(TB_MODULES)

run_modules:
	vvp sim_modules.out

wave_modules:
	gtkwave tb_modules.vcd

synth:
	@echo "Starting Synthesis and Schematic Generation..."
	yosys -s ./synth.ys 2>&1 | tee ./synth.log
	# Generate SVG schematics for each design stage
	netlistsvg rtl_level.json -o schematic_rtl.svg --skin ../lib/digital_color.svg
	netlistsvg opt_level.json -o schematic_opt.svg --skin ../lib/digital_color.svg
	netlistsvg gate_level.json -o schematic_gate.svg --skin ../lib/digital_color.svg
	@echo "Synthesis complete. Files generated: schematic_rtl.svg, schematic_opt.svg, schematic_gate.svg"

clean:
	rm -f *.out *.vcd *.dot *.png *.gtkw *.svg *.json synth.log synth_output.v