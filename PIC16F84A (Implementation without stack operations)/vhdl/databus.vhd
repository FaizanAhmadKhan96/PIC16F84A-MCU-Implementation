-- Behavioural Model for Data Bus

library work;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Declarartion of Entity
entity databus is
  port(
    w_en : in std_logic; 
    r_en : in std_logic;
    RAM_in : in std_logic_vector(7 downto 0);
    RAM_out : in std_logic_vector(7 downto 0);
    data_bus : out std_logic_vector(7 downto 0)  
    );
end entity databus;

-- Defining the behavioral architecture
architecture behav of databus is
  
begin

  dbus: process (w_en, r_en) begin
            if (r_en = '1' and w_en = '0') then
                data_bus <= RAM_in;              
            elsif (r_en = '0' and w_en = '1') then
                data_bus <= RAM_out;
            else
                data_bus <= (others => '0');
            end if;
            
        end process dbus;

end architecture behav;
