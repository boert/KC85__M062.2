TOP = M062_tb

TOP_low =  $(shell echo $(TOP) | tr '[:upper:]' '[:lower:]')


ghdl_simulation: ../rtl/*.vhd  ../rtl_tb/*.vhd
	ghdl -a --std=08 --work=rft ../contrib/VHDL-RFT-TTL/rtl/D*.vhd
	ghdl -a --std=08 --work=rft ../contrib/VHDL-RFT-TTL/rtl/U6*.vhd
	ghdl -a --std=08 --work=rft ../contrib/VHDL-RFT-TTL/rtl/U7*.vhd
	ghdl -a --std=08 --work=rft ../contrib/VHDL-RFT-TTL/rtl/component_package.vhd
	ghdl -a --std=08 $^
	ghdl -e --std=08 $(TOP)
	ghdl -r --std=08 $(TOP) --vcd=wave.vcd


view: wave.vcd
	gtkwave  wave.vcd  --save=wave.gtkw

clean:
	rm -f $(TOP_low)
	rm -f wave.vcd
	rm -f *.o
	rm -f *.cf

