# 定義變數
RTL = ../rtl/fpga_project.v
TB  = ../sim/tb_fpga_project.v

all: clean compile run

compile:
	iverilog -o sim.out $(RTL) $(TB)

run:
	vvp sim.out

wave:
	gtkwave tb_fpga_project.vcd waves.gtkw

synth:
	@echo "Starting Synthesis and Schematic Generation..."
	yosys -s ./synth.ys 2>&1 | tee ./synth.log
	# Generate SVG schematics for each design stage
	netlistsvg rtl_level.json -o schematic_rtl.svg --skin ../lib/digital_color.svg
	netlistsvg opt_level.json -o schematic_opt.svg --skin ../lib/digital_color.svg
	netlistsvg gate_level.json -o schematic_gate.svg --skin ../lib/digital_color.svg
	@echo "Synthesis complete. Files generated: schematic_rtl.svg, schematic_opt.svg, schematic_gate.svg"

clean:
	rm -f sim.out *.vcd *.dot *.png *.gtkw *.svg *.json synth.log synth_output.v