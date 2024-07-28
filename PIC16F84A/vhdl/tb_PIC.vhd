-- Testbench for Instruction Decoder
library work;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use work.type_package.all;

--Declarartion of Entity
entity tb_PIC is
end entity tb_PIC;

-- Defining the behavioral architecture for the testbench
architecture test of tb_PIC is

  signal PC_sig : std_logic_vector(12 downto 0);
  signal instruct_sig : std_logic_vector(13 downto 0);
  signal clk : std_logic := '0';
  signal rst : std_logic := '1';
  signal last_pc : std_logic_vector(12 downto 0) := (others => '0');
  
  constant T_clk : time := 50 ns; -- Since external clock/oscillator frequency is 20Mhz so T_clk=1/f_clk

  file file_input : text; 
  
begin

-- Defining the stimuli that would be used to test the decoder

  dut_PIC : entity work.PIC_MCU(rtl)
    port map(
      clk => clk,
      rst => rst,
      instruction_in => instruct_sig,
      PC  => PC_sig);

  clock_gen : process is
  begin
    clk <= '0';
    wait for T_clk/2;
    clk <= '1';
    wait for T_clk/2;
    
  -- clk <= '1' after T_clk, '0' after 2*T_clk;
  -- wait for 2*T_clk;
  end process clock_gen;

  reset_gen : process is
  begin
    -- Assert reset
    rst <= '1';
    wait for T_clk;
    
    -- Deassert reset
    rst <= '0';
    wait;
  end process reset_gen;

  read_file : process is
    
    variable input_line : line;
    variable  instruction_val : bit_vector(13 downto 0);
    variable  read_ok : boolean;

  begin
    
    file_open(file_input, "../files/OPCODE_PIC.txt",  read_mode);
    
    line_loop: while not endfile(file_input) loop
      
      readline(file_input, input_line);      
      read(input_line,instruction_val,read_ok);
      if not read_ok then
        report "error reading instruction from line: " & input_line.all
          severity warning;
        next line_loop;
      end if;
      
      instruct_sig <= to_stdlogicvector(instruction_val);

      -- Wait for the PC to change before reading the next instruction
      wait until PC_sig /= last_pc;
      last_pc <= PC_sig;
      
    end loop line_loop;
    
    file_close(file_input);
    
    wait; -- this stops simulation
    
  end process read_file;

end architecture test;
