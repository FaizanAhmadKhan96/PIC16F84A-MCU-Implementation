vlib work
vcom -work work ../vhdl/type_package.vhd
vcom -work work ../vhdl/state_package.vhd
vcom -2008 -work work ../vhdl/Decoder_PIC.vhd
vcom  -work work ../vhdl/Register_ex06.vhd
vcom  -work work ../vhdl/Data_memory.vhd
vcom  -work work ../vhdl/ALU_ex04.vhd
vcom  -work work ../vhdl/mux_ex02b.vhd
vcom  -work work ../vhdl/Instruct_Reg.vhd
vcom  -work work ../vhdl/Program_counter.vhd
vcom  -work work ../vhdl/databus.vhd
vcom  -work work ../vhdl/Stack.vhd
vcom  -work work ../vhdl/PIC_MCU.vhd
vcom  -work work ../vhdl/tb_PIC.vhd

vsim work.tb_PIC
add wave clk
add wave rst
add wave instruct_sig
add wave PC_sig
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Instruct_Reg_unit:data_in
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Instruct_Reg_unit:data_out
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Instruct_Reg_unit:address_in
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Instruct_Reg_unit:address_out
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Decoder_unit:current_state
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Decoder_unit:opcode
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Decoder_unit:operation_signal
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Decoder_unit:selection
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Decoder_unit:mem_addr
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Decoder_unit:r_en
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Decoder_unit:w_en
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:ALU_unit:W
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:ALU_unit:F
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:ALU_unit:operation
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:ALU_unit:bit_select
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:ALU_unit:status_in
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:ALU_unit:result
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:ALU_unit:status
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:MUX_unit:A
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:MUX_unit:B
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:MUX_unit:S
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:MUX_unit:Q
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Register_unit:data_in
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Register_unit:data_out
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Memory_unit:w_en
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Memory_unit:r_en
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Memory_unit:addr
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Memory_unit:data_in
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Memory_unit:data_out
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Memory_unit:stat_out
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Memory_unit:stat_in
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:Memory_unit:RAM
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:PC_unit:state
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:PC_unit:pc
add wave -position insertpoint  \sim/:tb_pic:dut_PIC:PC_unit:pc_reg
run 6000 ns
wave zoom full


