# 定義變數
RTL = ../rtl/tap_fsm.v
TB  = ../sim/tb_tap.v

all: clean compile run

compile:
	iverilog -o sim.out $(RTL) $(TB)

run:
	vvp sim.out

wave:
	gtkwave tb_top_module.vcd waves.gtkw

# synth:
# 	yosys -s ./synth.ys 2>&1 | tee ./synth.log && \
# 	netlistsvg ./top_module.json -o schematic.svg --skin ../lib/digital_color.svg

# Synth: Run Yosys synthesis and generate multi-stage schematics
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