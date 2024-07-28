vlib work
vcom -work work ../vhdl/orgate.vhd 

vsim work.orgate
add wave a
add wave b
add wave c
run -all
wave zoom full
