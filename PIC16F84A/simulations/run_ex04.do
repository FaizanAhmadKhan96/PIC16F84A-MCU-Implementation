vlib work
vcom -work work ../vhdl/type_package.vhd
vcom -work work ../vhdl/ALU_ex04.vhd
vcom -work work ../vhdl/tb_ex04.vhd

vsim work.tb_ex04
add wave W_sig
add wave F_sig
add wave operation_sig
add wave bit_select
add wave status_in
add wave result_sig
add wave status
run -all
wave zoom full
