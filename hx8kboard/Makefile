chip.bin: chip.v ../pew.v hx8kboard.pcf
	../png2memh.js
	yosys -q -p "synth_ice40 -top chip -blif chip.blif" chip.v ../pew.v
	arachne-pnr -d 8k -p hx8kboard.pcf -o chip.asc --post-place-blif chip.post.blif chip.blif
	yosys -q -o chip.post.json chip.post.blif
	icetime -j chip.sta.json -d hx8k -mtr chip.rpt chip.asc
	icepack chip.asc chip.bin

.PHONY: upload
upload:
	iceprog chip.bin

.PHONY: clean
clean:
	$(RM) -f chip.blif chip.post.blif chip.post.json chip.sta.json chip.asc chip.ex chip.bin pew.txt
