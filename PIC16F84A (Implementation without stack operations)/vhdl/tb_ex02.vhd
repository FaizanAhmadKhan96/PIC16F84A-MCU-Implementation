-- Testbench for Read Input and Write Output of Multiplexer

use STD.textio.all;

--Declarartion of Entity
entity tb_ex02 is
end entity tb_ex02;

-- Defining the behavioral architecture for the testbench of the Multiplexer
architecture behav of tb_ex02 is
  
    signal A, B, Q:bit_vector(7 downto 0); -- Defining signals of multiplexer
    signal S: bit;
    
 constant delay : time := 10 ns; -- Defining 5ns delay as constant

  file file_input : text;
  file file_output : text;    
    
begin

  --Implementing digital logic of multiplexer, this can be done through either
  --concurrent selected signal assignments as
  
    --mux_sel : with S select
    --Q <= A when '0',
      --   B when '1';
  
--OR through a process statement which is also concurrent in nature with
--sequential selected signal assignment inside it as
  
      mux_sel : process (A,B,S) is
    begin
      
       case S is
         when '0' =>
           Q <= A;
            
            when '1' =>
            Q <= B;

       end case;

   end process mux_sel;

-- Defining the stimuli that would be used to test the logic of multiplexer
-- implemented in the first half of the test bench
       
    read_write : process is
   
    variable input_line     : line;
    variable output_line     : line;
    variable  A_bits : bit_vector(7 downto 0);
    variable  B_bits : bit_vector(7 downto 0);
    variable  Q_bits : bit_vector(7 downto 0);
    variable  S_bit : bit;
    variable  read_ok : boolean; 
     
  begin
 
    file_open(file_input, "/home/fkhan/ELEC-E9540/new_project1/files/input_bits.txt",  read_mode);
    file_open(file_output, "/home/fkhan/ELEC-E9540/new_project1/files/output_bits.txt", write_mode);
 
   line_loop: while not endfile(file_input) loop
      
      readline(file_input, input_line);
      read(input_line, A_bits,read_ok);
      if not read_ok then
      report "error reading A_bits from line: " & input_line.all
        severity warning;
      next line_loop;
    end if;
      read(input_line, B_bits);           
      read(input_line, S_bit);
 
      A <= A_bits;
      B <= B_bits;
      S <= S_bit;
 
      wait for delay;

      -- case S is
        -- when '0' =>
          -- Q <= A;
            
           -- when '1' =>
            --Q <= B;

      -- end case;

      Q_bits := Q;

       write(output_line, string'("Output Q value:"));
      writeline(file_output, output_line);
 
      write(output_line, Q_bits);
      writeline(file_output, output_line);
    end loop;
 
    file_close(file_input);
    file_close(file_output);
     
        wait; -- this stops simulation
    end process read_write;

end architecture behav;
