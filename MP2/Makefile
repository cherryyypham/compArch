SRC = rgb_hsv_pwm
TB = $(SRC)_tb
PCF = ../common/iceBlinkPico.pcf

build:
	yosys -p "synth_ice40 -top $(SRC) -json $(SRC).json" $(SRC).sv
	nextpnr-ice40 --up5k --package sg48 --json $(SRC).json --pcf $(PCF) --asc $(SRC).asc
	icepack $(SRC).asc $(SRC).bin

prog:
	dfu-util --device 1d50:6146 --alt 0 -D $(SRC).bin -R

test:
	iverilog -o $(TB).out $(SRC).sv $(TB).sv
	vvp $(TB).out
	@if [ -f $(SRC).vcd ]; then gtkwave $(SRC).vcd; else echo "Error: VCD file not found!"; fi


clean:
	rm -rf $(SRC).blif $(SRC).asc $(SRC).json $(SRC).bin $(TB).out $(SRC).vcd

