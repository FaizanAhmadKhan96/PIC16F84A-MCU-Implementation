vlib work
vcom -work work ../vhdl/tb_ex01.vhd 

vsim work.tb_ex01
add wave A
add wave B
add wave S
add wave Q
run -all
wave zoom full
