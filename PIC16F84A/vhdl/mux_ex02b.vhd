library work;
library ieee;
use ieee.std_logic_1164.all;

entity mux_ex02b is

  port(A: in std_logic_vector(7 downto 0);
       B: in std_logic_vector(7 downto 0);
       S: in std_logic;
       Q: out std_logic_vector(7 downto 0));
  
end entity mux_ex02b;

architecture behav of mux_ex02b is

  begin
  --mux_sel : with S select
    --Q <= A when '0',
        -- B when '1';
   
  mux_sel: process (A,B,S) is
    begin
      
       case S is
         when '0' =>
           Q <= A;
            
            when '1' =>
            Q <= B;

            when others =>
            null;

       end case;

   end process mux_sel;

end architecture behav;
