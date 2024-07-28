-- RTL Model for Register block

library work;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Declarartion of Entity
entity Register_ex06 is
  generic (
    N : positive);
  port(
    clk : in std_logic;                      -- Clock
    data_in : in std_logic_vector(N-1 downto 0);  -- data stored in Register
    data_out : out std_logic_vector(N-1 downto 0) -- read data from Register
    );
end entity Register_ex06;

-- Defining the behavioral architecture
architecture rtl of Register_ex06 is
  
begin

  simple_reg: process(clk) is

  begin
    
    if rising_edge(clk) then

      data_out <= data_in;

    end if;
    
  end process simple_reg;

end architecture rtl;
