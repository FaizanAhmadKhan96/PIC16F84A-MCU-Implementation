vlib work
vcom -work work ../vhdl/type_package.vhd
vcom -2008 -work work ../vhdl/Decoder_ex06.vhd
vcom  -work work ../vhdl/Register_ex06.vhd
vcom  -work work ../vhdl/RAM_ex05.vhd
vcom  -work work ../vhdl/ALU_ex04.vhd
vcom  -work work ../vhdl/mux_ex02b.vhd
vcom  -work work ../vhdl/tb_ex06.vhd

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
add wave instruct_sig
add wave result_ALU
add wave pc_sig
add wave F_RAM
add wave F_out
add wave W_Reg
add wave bit_sig
add wave status_ALU
add wave -position insertpoint  \sim/:tb_ex06:dut_Decoder:current_state
add wave -position insertpoint  \sim/:tb_ex06:dut_RAM:RAM
add wave -position insertpoint  \sim/:tb_ex06:dut_Decoder:opcode
add wave -position insertpoint  \sim/:tb_ex06:dut_Decoder:d
add wave -position insertpoint  \sim/:tb_ex06:dut_Decoder:selection
add wave -position insertpoint  \sim/:tb_ex06:dut_Decoder:operation_signal
add wave -position insertpoint  \sim/:tb_ex06:dut_Decoder:b
add wave -position insertpoint  \sim/:tb_ex06:dut_Decoder:result
add wave -position insertpoint  \sim/:tb_ex06:dut_Decoder:mem_addr
run 5600 ns
wave zoom full


