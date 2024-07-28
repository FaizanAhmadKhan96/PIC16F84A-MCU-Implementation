-- Testbench for Read Input and Write Output of a Full Adder
library work;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;

--Declarartion of Entity
entity tb_ex03 is
end entity tb_ex03;

-- Defining the behavioral architecture for the testbench
architecture test of tb_ex03 is

  constant N : positive := 8;
  
    signal A_sig, B_sig : std_logic_vector(N-1 downto 0); -- Defining signals of
    signal S_sig1,S_sig2 :  std_logic_vector(N-1 downto 0);
    signal CO_sig1,CO_sig2 :  std_logic;
    
 constant delay : time := 10 ns; -- Defining 10ns delay as constant

  file file_input : text;
  file file_output : text;    
    
begin

-- Defining the stimuli that would be used to test the first Adder design
-- implemented in the first half of the test bench

dut1: entity work.N_bit_adder1_ex03(behav)
generic map(N => N) 
port map(
 A => A_sig,
 B=> B_sig,
 S=> S_sig1,
 CO=> CO_sig1);

  dut2: entity work.N_bit_adder2_ex03(behav)
 generic map(N => N) 
 port map(
  A => A_sig,
  B=> B_sig,
  S=> S_sig2,
  CO=> CO_sig2);
       
    read_write : process is
   
    variable input_line, output_line : line;
    variable  A_value, B_value,  S_value: integer range 0 to 2**N-1;
    variable CO_value : bit;
    variable char : character;
    variable  read_ok : boolean; 
     
  begin
 
    file_open(file_input, "../files/input.csv",  read_mode);
    file_open(file_output, "../files/output.csv", write_mode);

     write(output_line, string'("Result of first Adder:"));
      writeline(file_output, output_line);

       write(output_line, string'("Sum,Carry Out"));
      writeline(file_output, output_line);
 
   line_loop: while not endfile(file_input) loop
      
      readline(file_input, input_line);
      read(input_line, A_value,read_ok);
      if not read_ok then
      report "error reading A_value from line: " & input_line.all
        severity warning;
      next line_loop;
    end if;


      read(input_line, char); -- read comma and then read the next integer value

       read(input_line, B_value,read_ok);
      if not read_ok then
      report "error reading B_value from line: " & input_line.all
        severity warning;
      next line_loop;
    end if;
 
      A_sig <= std_logic_vector(to_unsigned(A_value,N)); -- conversion of integer type of A_value to A_sig of std_logic_vector type of N bits
      B_sig <= std_logic_vector(to_unsigned(B_value,N)); -- conversion of integer type of B_value to B_sig of std_logic_vector type of N bits


       wait for delay;
      
      S_value := to_integer(unsigned(S_sig1)); -- conversion of std_logic_vector type of N bits of S_sig to S_value of integer type
      CO_value := to_bit(CO_sig1); -- conversion of std_logic type of CO_sig to CO_value of integer type

       write(output_line, S_value);
       write(output_line,  string'(","));
       write(output_line, CO_value);
      writeline(file_output, output_line);

       wait for delay;
      
      S_value := to_integer(unsigned(S_sig2)); -- conversion of std_logic_vector type of N bits of S_sig to S_value of integer type
      CO_value := to_bit(CO_sig2); -- conversion of std_logic type of CO_sig to CO_value of integer type

       write(output_line, S_value);
       write(output_line,  string'(","));
       write(output_line, CO_value);
      writeline(file_output, output_line);
      
     
    end loop line_loop;
 
    file_close(file_input);
    file_close(file_output);
     
        wait; -- this stops simulation
  end process read_write;


-- Defining the stimuli that would be used to test the second  Adder design
-- implemented in the second half of the test bench

  --dut2: entity work.N_bit_adder2_ex03(behav)
  -- generic map(N => N) 
  -- port map(
  --   A => A_sig,
  --   B=> B_sig,
  --   S=> S_sig,
  --   CO=> CO_sig);
  --    
  -- read_write2 : process is
  --
  -- variable input_line, output_line : line;
  -- variable  A_value, B_value, S_value: integer;
  -- variable CO_value : bit;
  -- variable char : character;
  -- variable  read_ok : boolean; 
  --  
  --egin
  --
  -- file_open(file_input, "/home/fkhan/ELEC-E9540/new_project1/files/input.csv",  read_mode);
  -- file_open(file_output, "/home/fkhan/ELEC-E9540/new_project1/files/output.csv", write_mode);
  --
  --  wait for delay;
  --
  --  write(output_line, string'("Result of Second Adder:"));
  --   writeline(file_output, output_line);
  --
  --    write(output_line, string'("Sum,Carry Out"));
  --   writeline(file_output, output_line);
  --
  --line_loop2: while not endfile(file_input) loop
  --   
  --   readline(file_input, input_line);
  --   read(input_line, A_value,read_ok);
  --   if not read_ok then
  --   report "error reading A_value from line: " & input_line.all
  --     severity warning;
  --   next line_loop2;
  -- end if;
  --   read(input_line, char); -- read comma and then read the next integer value          
  --    read(input_line, B_value,read_ok);
  --   if not read_ok then
  --   report "error reading B_value from line: " & input_line.all
  --     severity warning;
  --   next line_loop2;
  -- end if;
  --
  --   A_sig <= std_logic_vector(to_unsigned(A_value,N)); -- conversion of integer type of A_value to A_sig of std_logic_vector type of N bits
  --   B_sig <= std_logic_vector(to_unsigned(B_value,N)); -- conversion of integer type of B_value to B_sig of std_logic_vector type of N bits
  --
  --   S_value := to_integer(unsigned(S_sig)); -- conversion of std_logic_vector type of N bits of S_sig to S_value of integer type
  --   CO_value := to_bit(CO_sig); -- conversion of std_logic type of CO_sig to CO_value of integer type
  --
  --    write(output_line, S_value);
  --    write(output_line,  string'(","));
  --    write(output_line, CO_value);
  --   writeline(file_output, output_line);
  --   
  --   wait for delay;
  -- end loop  line_loop2;
  --
  -- file_close(file_input);
  -- file_close(file_output);
  --  
  --     wait; -- this stops simulation
  -- end process read_write2;

end architecture test;
