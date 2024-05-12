TOP=cpld
RTL=../rtl/cpld.vhd
LIB=DL.lib


# gate = mapped to target structure
gate-level: $(RTL) $(LIB)
	yosys -m ghdl -p 'ghdl $(RTL) -e $(TOP); synth -top $(TOP); dfflibmap -liberty $(LIB); abc -liberty $(LIB); clean; show -colors 1 -format png -stretch -prefix $(TOP)_gate_level -lib DL.v ;  write_verilog cpld_gate_level.v' 


# rtl = register transfer level
rtl-level: $(RTL)
	yosys -m ghdl -p 'ghdl $(RTL) -e $(TOP); clean; show -colors 1 -format png -stretch -prefix $(TOP)_rtl; write_verilog cpld_rtl.v' 


clean:
	rm -f *.dot
