-- Testbench for Instruction Decoder
library work;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use work.type_package.all;

--Declarartion of Entity
entity tb_ex06 is
end entity tb_ex06;

-- Defining the behavioral architecture for the testbench
architecture test of tb_ex06 is

  constant DATA_WIDTH : positive := 8;
  constant ADDR_WIDTH : positive := 8;
  constant N : positive := 8;
  
  signal W_sig, F_sig, data_RAM, F_RAM, F_out, W_Reg : std_logic_vector(DATA_WIDTH-1 downto 0); -- Defining signals
  signal bit_sig, status_in, status_ALU :  std_logic_vector(2 downto 0);
  signal operation_sig :  operation_enum;
  signal result_ALU, pc_sig : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal instruct_sig : std_logic_vector(13 downto 0);
  signal  w_en, r_en, S : std_logic;
  signal clk : std_logic := '0';
  signal rst : std_logic := '1';
  signal addr : std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal last_pc : std_logic_vector(7 downto 0) := (others => '0');
  
  constant T_clk : time := 50 ns; -- Since external clock/oscillator frequency is 20Mhz so T_clk=1/f_clk

  file file_input : text; 
  
begin

-- Defining the stimuli that would be used to test the decoder

  dut_Decoder : entity work.Decoder_ex06(rtl)
    port map(
      clk => clk,
      rst => rst,
      ALU_status => status_ALU,
      RAM_status => status_in,
      instruction => instruct_sig,
      ALU_result => result_ALU,
      operation => operation_sig,
      r_en => r_en,
      w_en => w_en,
      selection => S,
      F_out => F_out,
      Bits => bit_sig,
      mem_addr => addr,
      W_Reg => W_Reg,
      pc  => pc_sig);

  dut_ALU : entity work.ALU_ex04(behav)
    port map(
      W => W_sig,
      F => F_sig,
      operation => operation_sig,
      status_in => status_in,
      bit_select => bit_sig,
      result => result_ALU,
      status => status_ALU);

  dut_RAM : entity work.RAM_ex05(rtl)
    generic map(DATA_WIDTH => DATA_WIDTH,
                ADDR_WIDTH => ADDR_WIDTH)
    port map(
      clk => clk,
      data_in => result_ALU,
      addr => addr,
      data_out => F_RAM,
      stat_in => status_ALU,
      w_en => w_en,
      r_en => r_en,
      rst => rst,
      stat_out => status_in);

  dut_Register : entity work.Register_ex06(rtl)
    generic map(N => N)
    port map(
      clk => clk,
      data_in => W_Reg,
      data_out => W_sig);

  dut_MUX : entity work.mux_ex02b(behav)
    port map(
      A => F_RAM,
      B => F_out,
      S => S,
      Q => F_sig);

  clock_gen : process is
  begin
    clk <= '0';
    wait for T_clk/2;
    clk <= '1';
    wait for T_clk/2;
    
  -- clk <= '1' after T_clk, '0' after 2*T_clk;
  -- wait for 2*T_clk;
  end process clock_gen;

--  reset_gen : process is
--begin
--  -- Assert reset
--  rst <= '1';
--  wait for T_clk/4;
--  
--  -- Deassert reset
--  rst <= '0';
--  wait;
--end process reset_gen;

  read_file : process is
    
    variable input_line : line;
    variable  instruction_val : bit_vector(13 downto 0);
    variable  read_ok : boolean;
--  signal last_pc : std_logic_vector(7 downto 0);

  begin
    
    file_open(file_input, "../files/OPCODE.txt",  read_mode);

    -- Reset
    wait for T_clk/4;
    rst <= '0';
    -- last_pc <= (others => '0');

--    wait for T_clk;
    
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
      wait until pc_sig /= last_pc;
      last_pc <= pc_sig;

--           wait for T_clk*4;
      
    end loop line_loop;
    
    file_close(file_input);
    
    wait; -- this stops simulation
    
  end process read_file;

end architecture test;
