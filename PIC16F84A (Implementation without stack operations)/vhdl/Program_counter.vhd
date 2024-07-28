-- RTL Model for counter

library work;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.state_package.all;

--Declarartion of Entity
entity Program_counter is
  port(
    clk : in std_logic;
    rst : in std_logic;
    state : in state_type;
    PCH : out std_logic_vector(4 downto 0);
    PCL_counter : out std_logic_vector(7 downto 0);
    pc : out std_logic_vector(12 downto 0)  
    );
end entity Program_counter;

-- Defining the behavioral architecture
architecture rtl of Program_counter is

--   type state_type is (iFetch, Mread, Execute, Mwrite);
--   signal state_sig : state_type;
  signal pc_reg : unsigned(12 downto 0):= (others => '0');
  
begin

  counter: process (clk, rst) 
    
  begin

    if rising_edge(clk) then               
      if rst = '1' then
        pc_reg <= (others => '0'); -- Initialize PC to 0
      end if;
      pc <= std_logic_vector(pc_reg);
      -- counter increments after each instruction reaches Mwrite stage
      if state = Mwrite then
        -- pc_reg <= unsigned(pc_reg) + 1;
        -- pc <= std_logic_vector(pc_reg);
        pc <= std_logic_vector(unsigned(pc_reg) + 1);
        pc_reg <= pc_reg +1;
        PCH <= std_logic_vector(pc_reg(12 downto 8));
        PCL_counter <= std_logic_vector(pc_reg(7 downto 0));
      end if;
    end if;
    
  end process counter;

end architecture rtl;
