vlib work
vcom -work work ../vhdl/type_package.vhd
vcom -work work ../vhdl/RAM_ex05.vhd
vcom -work work ../vhdl/ALU_ex04.vhd
vcom -work work ../vhdl/tb_ex05.vhd

vsim work.tb_ex05
add wave clk
add wave r_en
add wave w_en
add wave rst
add wave addr
add wave status_in
add wave operation_sig
add wave F_sig
add wave W_sig
add wave bit_select
add wave result_sig
add wave status
run 2000 ns
wave zoom full


