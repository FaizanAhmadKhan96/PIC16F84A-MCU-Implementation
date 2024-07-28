-- Behaviorial Model for N-bit Full Adder

library ieee;
use ieee.std_logic_1164.all;

--Declarartion of Entity
entity N_bit_adder_preEx03 is
   generic ( N : positive := 10); --assigned an arbitary value to N otherwise it gives fatal error when loading design
  port(
    A, B : in std_logic_vector(N-1 downto 0);
    CI : in std_logic;
    S : out std_logic_vector(N-1 downto 0);
    CO : out std_logic
);
end entity N_bit_adder_preEx03;

-- Defining the behavioral architecture
architecture behav of N_bit_adder_preEx03 is
  
-- Declaring internal signals
  signal S_signal : std_logic_vector(N-1 downto 0);
  signal CO_signal : std_logic;
  
 begin

   adder : for bit_in in N-1 downto 0 generate

     begin

  S_signal(bit_in) <= ((A(bit_in) XOR B(bit_in)) XOR CI);
  CO_signal <= ((A(bit_in) AND B(bit_in)) OR (CI AND A(bit_in))) OR (CI AND B(bit_in));

   end generate adder;

   -- Assign internal signals to outputs
   S <= S_signal; 
   CO <= CO_signal;

end architecture behav;
