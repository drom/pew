chip.bin: chip.v ../pew.v blackice.pcf
	../png2memh.js
	yosys -q -p "read_verilog chip.v ; read_verilog ../pew.v ; synth_ice40 -blif chip.blif"
	arachne-pnr -d 8k -P tq144:4k -p blackice.pcf --post-place-blif chip.post.blif chip.blif -o chip.asc
	yosys -q -o chip.post.json chip.post.blif
	icetime -j chip.sta.json -d hx8k chip.asc
	icepack chip.asc chip.bin

.PHONY: upload
upload:
	stty raw cs8 115200 < /dev/ttyUSB0 && cat chip.bin > /dev/ttyUSB0

.PHONY: clean
clean:
	$(RM) -f chip.blif chip.post.blif chip.post.json chip.sta.json chip.asc chip.ex chip.bin pew.txt
