vlib work
vcom -work work ../vhdl/N_bit_adder_preEx03.vhd 

vsim work.N_bit_adder_preEx03
add wave A
add wave B
add wave CI
add wave S
add wave CO
run -all
wave zoom full
