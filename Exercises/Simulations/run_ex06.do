vlib work
vcom -work work ../vhdl/type_package.vhd
vcom -work work ../vhdl/Decoder_ex06.vhd
vcom -work work ../vhdl/Register_ex06.vhd
vcom -work work ../vhdl/RAM_ex05.vhd
vcom -work work ../vhdl/ALU_ex04.vhd
vcom -work work ../vhdl/mux_ex02b.vhd
vcom -work work ../vhdl/tb_ex06.vhd

vsim work.tb_ex06
add wave clk
add wave r_en
add wave w_en
add wave rst
add wave addr
add wave status_in
add wave operation_sig
add wave F_sig
add wave W_sig
add wave status
add wave instruct_sig
add wave result_ALU
add wave pc_sig
add wave data_RAM
add wave F_RAM
add wave F_out
add wave W_Reg
add wave bit_sig
add wave status_RAM
add wave status_ALU
run 2000 ns
wave zoom full


