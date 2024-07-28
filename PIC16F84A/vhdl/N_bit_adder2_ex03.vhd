-- Behaviorial Model for N-bit Full Adder without carry_in

library work;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Declarartion of Entity
entity N_bit_adder2_ex03 is
   generic ( N : positive);
  port(
    A, B : in std_logic_vector(N-1 downto 0);
    S : out std_logic_vector(N-1 downto 0);
    CO : out std_logic
);
end entity N_bit_adder2_ex03;

-- Defining the behavioral architecture
architecture behav of N_bit_adder2_ex03 is
  
 begin

   adder : process (A,B) is
     
     begin

   -- Converting A and B to unsigned integer for addition and then again
   -- converting the result back to std_logic_vector
       
      S <= std_logic_vector(unsigned(A) + unsigned(B));

   -- Checking for Carry out

      if (A(N-1) = '1') and (B(N-1) = '1') then
       CO <= '1';
     else
       CO <= '0';
     end if;

     end process adder;

      -- CO <= '1' when (A(N-1) = '1' and B(N-1) = '1') else '0';

end architecture behav;
