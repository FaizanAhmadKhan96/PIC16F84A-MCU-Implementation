vlib work
vcom -work work ../vhdl/mux_ex02b.vhd
vcom -work work ../vhdl/tb_ex02b.vhd 
 
vsim work.tb_ex02
add wave A
add wave B
add wave S
add wave Q
run -all
wave zoom full
