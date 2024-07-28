-- RTL Model for Instruction Register block

library work;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Declarartion of Entity
entity Instruct_Reg is
  port(
    clk : in std_logic;                      -- Clock
    data_in : in std_logic_vector(13 downto 0);  -- data stored in Register
    data_out : out std_logic_vector(13 downto 0); -- read data from program memory
    address_in : in std_logic_vector(7 downto 0);  -- data stored in Register
    address_out : out std_logic_vector(7 downto 0) -- read data from Register
    );
end entity Instruct_Reg;

-- Defining the behavioral architecture
architecture rtl of Instruct_Reg is
  
begin

  simple_reg: process(clk) is

  begin
    
    if rising_edge(clk) then

      data_out <= data_in;
      address_out <= address_in;

    end if;
    
  end process simple_reg;

end architecture rtl;
