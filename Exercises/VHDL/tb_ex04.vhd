-- Testbench for Read Input and Write Output of a Full Adder
library work;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use work.type_package.all;

--Declarartion of Entity
entity tb_ex04 is
end entity tb_ex04;

-- Defining the behavioral architecture for the testbench
architecture test of tb_ex04 is
  
    signal W_sig, F_sig : std_logic_vector(7 downto 0); -- Defining signals of
    signal bit_select, status_in :  std_logic_vector(2 downto 0);
    signal operation_sig :  operation_enum;
    signal result_sig : std_logic_vector(7 downto 0);
    signal status :  std_logic_vector(2 downto 0);
    
 constant delay : time := 10 ns; -- Defining 10ns delay as constant

  file file_input : text;
  file file_output : text;    
    
begin

-- Defining the stimuli that would be used to test the ALU

dut1: entity work.ALU_ex04(behav)
port map(
 W => W_sig,
 F => F_sig,
 operation => operation_sig,
 status_in => status_in,
 bit_select => bit_select,
 result => result_sig,
 status => status);
       
    read_write : process is
   
    variable input_line, output_line : line;
    variable  W_val, F_val, result_val: bit_vector(7 downto 0);
    variable bit_select_val, status_in_val, status_val :  bit_vector(2 downto 0);
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
 
    file_open(file_input, "../files/instruction_set.txt",  read_mode);
    file_open(file_output, "../files/result.txt", write_mode);

       write(output_line, string'("[Z_f,DC_f,C_f]OPERT[Result]"));
      writeline(file_output, output_line);
 
   line_loop: while not endfile(file_input) loop
      
      readline(file_input, input_line);
      read(input_line,status_in_val,read_ok);
      if not read_ok then
      report "error reading status from line: " & input_line.all
        severity warning;
      next line_loop;
      end if;

 
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

       read(input_line, F_val,read_ok);
      if not read_ok then
      report "error reading F_value from line: " & input_line.all
        severity warning;
      next line_loop;
    end if;
 
      status_in <= to_stdlogicvector(status_in_val);
      operation_sig <= string_to_enum(operation_val);
      bit_select <= to_stdlogicvector(bit_select_val);
      W_sig <= to_stdlogicvector(W_val);
      F_sig <= to_stdlogicvector(F_val);
     
       wait for delay;
      
      status_val := to_bitvector(status);  -- conversion of std_logic type to bit_vector type
      result_val := to_bitvector(result_sig);

      case operation_sig is
       
          when ADDWF|ADDLW =>
            
            write(output_line, status_val);
            write(output_line,  string'("ADD"));
            write(output_line, result_val);
            writeline(file_output, output_line);

              wait for delay;
       
          when ANDWF|ANDLW =>
            
            write(output_line, status_val);
            write(output_line,  string'("AND"));
            write(output_line, result_val);
            writeline(file_output, output_line);

              wait for delay;  

        when CLRF =>
            
            write(output_line, status_val);
            write(output_line,  string'("CLRF"));
            write(output_line, result_val);
            writeline(file_output, output_line);

              wait for delay;
       
         when CLRW =>

            write(output_line, status_val);
            write(output_line,  string'("CLRF"));
            write(output_line, result_val);
            writeline(file_output, output_line);

              wait for delay;

         when COMF =>

            write(output_line, status_val);
            write(output_line,  string'("COMF"));
            write(output_line, result_val);
            writeline(file_output, output_line);

              wait for delay;

         when DECF =>

            write(output_line,  string'("DECF"));
            write(output_line, result_val);
            writeline(file_output, output_line);

              wait for delay;
            

         when INCF =>

            write(output_line, status_val);
            write(output_line,  string'("INCF"));
            write(output_line, result_val);
            writeline(file_output, output_line);

              wait for delay;


         when IORWF|IORLW =>

            write(output_line, status_val);
            write(output_line,  string'("IOR"));
            write(output_line, result_val);
            writeline(file_output, output_line);

              wait for delay;
             
         when MOVF =>

            write(output_line, status_val);
            write(output_line,  string'("MOVF"));
            write(output_line, result_val);
            writeline(file_output, output_line);

              wait for delay;


         when MOVWF|MOVLW =>

            write(output_line, status_val);
            write(output_line,  string'("MOV"));
            write(output_line, result_val);
            writeline(file_output, output_line);

              wait for delay;

            
         when RLF =>

            write(output_line, status_val);
            write(output_line,  string'("RLF"));
            write(output_line, result_val);
            writeline(file_output, output_line);

              wait for delay;

            
         when RRF =>

            write(output_line, status_val);
            write(output_line,  string'("RRF"));
            write(output_line, result_val);
            writeline(file_output, output_line);

              wait for delay;
            

         when SUBWF|SUBLW =>

            write(output_line, status_val);
            write(output_line,  string'("SUB"));
            write(output_line, result_val);
            writeline(file_output, output_line);

              wait for delay;
            
         when SWAPF =>

            write(output_line, status_val);
            write(output_line,  string'("SWAPF"));
            write(output_line, result_val);
            writeline(file_output, output_line);

              wait for delay;
            
         when XORWF|XORLW =>

            write(output_line, status_val);
            write(output_line,  string'("XOR"));
            write(output_line, result_val);
            writeline(file_output, output_line);

              wait for delay;
            
         when BCF =>

            write(output_line, status_val);
            write(output_line,  string'("BCF"));
            write(output_line, result_val);
            writeline(file_output, output_line);

              wait for delay;
             
         when BSF =>

            write(output_line, status_val);
            write(output_line,  string'("BSF"));
            write(output_line, result_val);
            writeline(file_output, output_line);

              wait for delay;
            
         when NOP =>

            write(output_line, status_val);
            write(output_line,  string'("NOP"));
            write(output_line, result_val);
            writeline(file_output, output_line);

              wait for delay;

       end case;
     
    end loop line_loop;
 
    file_close(file_input);
    file_close(file_output);
     
        wait; -- this stops simulation
            
  end process read_write;

end architecture test;
