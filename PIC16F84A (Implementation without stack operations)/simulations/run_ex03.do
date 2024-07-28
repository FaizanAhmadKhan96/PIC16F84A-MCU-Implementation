vlib work
vcom -work work ../vhdl/N_bit_adder1_ex03.vhd
vcom -work work ../vhdl/N_bit_adder2_ex03.vhd
vcom -work work ../vhdl/tb_ex03.vhd

vsim work.tb_ex03
add wave A_sig
add wave B_sig
add wave S_sig1
add wave CO_sig1
add wave S_sig2
add wave CO_sig2
run -all
wave zoom full
