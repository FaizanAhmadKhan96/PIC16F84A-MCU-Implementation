-- Testbench for Read Input and Write Output of ALU from both internal memory and external file
library work;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use work.type_package.all;

--Declarartion of Entity
entity tb_ex05 is
end entity tb_ex05;

-- Defining the behavioral architecture for the testbench
architecture test of tb_ex05 is

  constant DATA_WIDTH : positive := 8;
  constant ADDR_WIDTH : positive := 8;
  
  signal W_sig, F_sig : std_logic_vector(DATA_WIDTH-1 downto 0); -- Defining signals of
  signal bit_select, status_in, status :  std_logic_vector(2 downto 0);
  signal operation_sig :  operation_enum;
  signal result_sig : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal  w_en, r_en : std_logic := '0';
  signal clk : std_logic := '1';
  signal rst : std_logic := '1';
  signal addr : std_logic_vector(ADDR_WIDTH-1 downto 0);
  
  constant T_clk : time := 50 ns; -- Since external clock/oscillator frequency is 20Mhz so T_clk=1/f_clk

  file file_input : text; 
  
begin

-- Defining the stimuli that would be used to test the ALU

  dut_ALU : entity work.ALU_ex04(behav)
    port map(
      W => W_sig,
      F => F_sig,
      operation => operation_sig,
      status_in => status_in,
      bit_select => bit_select,
      result => result_sig,
      status => status);

  dut_RAM : entity work.RAM_ex05(rtl)
    generic map(DATA_WIDTH => DATA_WIDTH,
                ADDR_WIDTH => ADDR_WIDTH)
    port map(
      clk => clk,
      data_in => result_sig,
      addr => addr,
      data_out => F_sig,
      stat_in =>  status,
      w_en => w_en,
      r_en => r_en,
      rst => rst,
      stat_out => status_in);

  clock_gen : process is
  begin
    clk <= '1';
    wait for T_clk/2;
    clk <= '0';
    wait for T_clk/2;
    
  -- clk <= '1' after T_clk, '0' after 2*T_clk;
  -- wait for 2*T_clk;
  end process clock_gen;

  readWrite_RAM : process
  begin

-- Reset
  wait for T_clk/4;
   rst <= '0';
    
-- Read from memory
    wait for T_clk/4;
    r_en <= '1';
    w_en <= '0';
    
    addr <= x"00"; -- Set memory address to read
    wait for T_clk;

    -- Write to memory
    w_en <= '1';
    r_en <= '0';
    
    addr <= x"01"; -- Set memory address to write
    wait for T_clk;

    -- Read from memory
    r_en <= '1';
    w_en <= '0';
    
    addr <= x"01"; -- Set memory address to read
    wait for T_clk;

    -- Write to memory
    w_en <= '1';
    r_en <= '0';
    
    addr <= x"02"; -- Set memory address to write
    wait for T_clk;

    -- Read from memory
    r_en <= '1';
    w_en <= '0';
    
    addr <= x"02"; -- Set memory address to read
    wait for T_clk;

    -- Write to memory
    w_en <= '1';
    r_en <= '0';
    
    addr <= x"03"; -- Set memory address to write
    wait for T_clk;

    -- Read from memory
    r_en <= '1';
    w_en <= '0';
    
    addr <= x"03"; -- Set memory address to read
    wait for T_clk;

    -- Write to memory
    w_en <= '1';
    r_en <= '0';
    
    addr <= x"04"; -- Set memory address to write
    wait for T_clk;

    -- Read from memory
    r_en <= '1';
    w_en <= '0';
    
    addr <= x"04"; -- Set memory address to read
    wait for T_clk;

    -- Write to memory
    w_en <= '1';
    r_en <= '0';
    
    addr <= x"05"; -- Set memory address to write
    wait for T_clk;

    -- Read from memory
    r_en <= '1';
    w_en <= '0';
    
    addr <= x"05"; -- Set memory address to read
    wait for T_clk;

    -- Write to memory
    w_en <= '1';
    r_en <= '0';
    
    addr <= x"06"; -- Set memory address to write
    wait for T_clk;

    -- Read from memory
    r_en <= '1';
    w_en <= '0';
    
    addr <= x"06"; -- Set memory address to read
    wait for T_clk;

    -- Write to memory
    w_en <= '1';
    r_en <= '0';
    
    addr <= x"07"; -- Set memory address to write
    wait for T_clk;

    -- Read from memory
    r_en <= '1';
    w_en <= '0';
    
    addr <= x"07"; -- Set memory address to read
    wait for T_clk;

    -- Write to memory
    w_en <= '1';
    r_en <= '0';
    
    addr <= x"08"; -- Set memory address to write
    wait for T_clk;

    -- Read from memory
    r_en <= '1';
    w_en <= '0';
    
    addr <= x"08"; -- Set memory address to read
    wait for T_clk;

    -- Write to memory
    w_en <= '1';
    r_en <= '0';
    
    addr <= x"09"; -- Set memory address to write
    wait for T_clk;

    -- Read from memory
    r_en <= '1';
    w_en <= '0';
    
    addr <= x"09"; -- Set memory address to read
    wait for T_clk;

    -- Write to memory
    w_en <= '1';
    r_en <= '0';
    
    addr <= x"0A"; -- Set memory address to write
    wait for T_clk;

    -- Read from memory
    r_en <= '1';
    w_en <= '0';
    
    addr <= x"0A"; -- Set memory address to read
    wait for T_clk;

    -- Write to memory
    w_en <= '1';
    r_en <= '0';
    
    addr <= x"0B"; -- Set memory address to write
    wait for T_clk;

    -- Read from memory
    r_en <= '1';
    w_en <= '0';
    
    addr <= x"0B"; -- Set memory address to read
    wait for T_clk;

    -- Write to memory
    w_en <= '1';
    r_en <= '0';
    
    addr <= x"0C"; -- Set memory address to write
    wait for T_clk;

    -- Read from memory
    r_en <= '1';
    w_en <= '0';
    
    addr <= x"0C"; -- Set memory address to read
    wait for T_clk;

    -- Write to memory
    w_en <= '1';
    r_en <= '0';
    
    addr <= x"0D"; -- Set memory address to write
    wait for T_clk;

    -- Read from memory
    r_en <= '1';
    w_en <= '0';
    
    addr <= x"0D"; -- Set memory address to read
    wait for T_clk;

    -- Write to memory
    w_en <= '1';
    r_en <= '0';
    
    addr <= x"0E"; -- Set memory address to write
    wait for T_clk;

    -- Read from memory
    r_en <= '1';
    w_en <= '0';
    
    addr <= x"0E"; -- Set memory address to read
    wait for T_clk;

    -- Write to memory
    w_en <= '1';
    r_en <= '0';
    
    addr <= x"0F"; -- Set memory address to write
    wait for T_clk;

    -- Read from memory
    r_en <= '1';
    w_en <= '0';
    
    addr <= x"0F"; -- Set memory address to read
    wait for T_clk;

    -- Write to memory
    w_en <= '1';
    r_en <= '0';
    
    addr <= x"10"; -- Set memory address to write
    wait for T_clk;

    -- Read from memory
    r_en <= '1';
    w_en <= '0';
    
    addr <= x"10"; -- Set memory address to read
    wait for T_clk;

    -- Write to memory
    w_en <= '1';
    r_en <= '0';
    
    addr <= x"1A"; -- Set memory address to write
    wait for T_clk;
    
  end process readWrite_RAM;

  read_file : process is
    
    variable input_line : line;
    variable  W_val : bit_vector(7 downto 0);
    variable bit_select_val :  bit_vector(2 downto 0);
    variable operation_val : string(1 to 5);
    variable  read_ok : boolean;

    function string_to_enum(str: string) return operation_enum is
    begin
      if str = "ADDWF" then
        return ADDWF;
      elsif str = "ADDLW" then
        return ADDLW;
      elsif str = "ANDWF" then
        return ANDWF;
      elsif str = "ANDLW" then
        return ANDLW;
      elsif str = "CLRFX" then
        return CLRF;
      elsif str = "CLRWX" then
        return CLRW;
      elsif str = "COMFX" then
        return COMF;
      elsif str = "DECFX" then
        return DECF;
      elsif str = "IORWF" then
        return IORWF;
      elsif str = "IORLW" then
        return IORLW;
      elsif str = "MOVFX" then
        return MOVF;
      elsif str = "MOVLW" then
        return MOVLW;
      elsif str = "MOVWF" then
        return MOVWF;
      elsif str = "RLFXX" then
        return RLF;
      elsif str = "RRFXX" then
        return RRF;
      elsif str = "SUBWF" then
        return SUBWF;
      elsif str = "SUBLW" then
        return SUBLW;
      elsif str = "SWAPF" then
        return SWAPF;
      elsif str = "XORLW" then
        return XORLW;
      elsif str = "XORWF" then
        return XORWF;
      elsif str = "NOPXX" then
        return NOP;
      elsif str = "BCFXX" then
        return BCF;
      elsif str = "BSFXX" then
        return BSF;
      else
        return NOP; -- or any default value
      end if;
    end function string_to_enum;
    
  begin
    
    file_open(file_input, "../files/instruction_set2.txt",  read_mode);

    wait for T_clk;
    
    line_loop: while not endfile(file_input) loop
      
      readline(file_input, input_line);
      read(input_line,operation_val,read_ok);
      if not read_ok then
        report "error reading operation_val from line: " & input_line.all
          severity warning;
        next line_loop;
      end if;

      read(input_line,bit_select_val,read_ok);
      if not read_ok then
        report "error reading status from line: " & input_line.all
          severity warning;
        next line_loop;
      end if;

      read(input_line, W_val,read_ok);
      if not read_ok then
        report "error reading W_value from line: " & input_line.all
          severity warning;
        next line_loop;
      end if;
      
      operation_sig <= string_to_enum(operation_val);
      bit_select <= to_stdlogicvector(bit_select_val);
      W_sig <= to_stdlogicvector(W_val);
      
      wait for T_clk*2;
      
    end loop line_loop;
    
    file_close(file_input);
    
    wait; -- this stops simulation
    
  end process read_file;

end architecture test;
