-- Testbench for Multiplexer

--Declarartion of Entity
entity tb_ex01 is
end entity tb_ex01;

-- Defining the behavioral architecture for the testbench of the Multiplexer
architecture behav of tb_ex01 is
    signal A, B, Q:bit_vector(7 downto 0); -- Defining signals of multiplexer
    signal S: bit;
    
 constant delay : time := 5 ns; -- Defining 5ns delay as constant
    
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
       
    stimuli : process is
    begin
        A <= "01010101";
        B <= "00110011";
        S <= '0';

        wait for delay;
        S <= '1';
        wait for delay;
        S <= '0';
        wait for delay;
        S <= '1';
        wait for delay;

        wait; -- this stops simulation
    end process;

end architecture;
