-- Behaviorial Model for Full Adder

library ieee;
use ieee.std_logic_1164.all;

--Declarartion of Entity
entity adder_preEx03 is
  port(
    A, B, CI : in std_logic;
    S, CO : out std_logic
);
end entity adder_preEx03;

-- Defining the behavioral architecture
architecture behav of adder_preEx03 is
  
 begin

   S <= A XOR B XOR CI ;
 CO <= (A AND B) OR (CI AND A) OR (CI AND B) ;

end architecture behav;
