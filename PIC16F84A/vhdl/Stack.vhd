-- RTL Model for Stack

library work;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Declarartion of Entity
entity Stack is
  generic (
    WIDTH : positive;
    DEPTH : positive);
  port(
    clk : in std_logic;                      -- Clock
    rst : in std_logic;
    push : in std_logic;
    pop : in std_logic;
    data_in : in std_logic_vector(WIDTH - 1 downto 0);
    data_out : out std_logic_vector(WIDTH - 1 downto 0)
    );
end entity Stack;

-- Defining the behavioral architecture
architecture rtl of Stack is

  type stack_array is array (0 to DEPTH - 1) of std_logic_vector(WIDTH - 1 downto 0);
  signal stack : stack_array := (others => (others => '0'));
  signal sp : integer range 0 to DEPTH - 1 := 0; -- stack pointer
  
begin

  process (clk, rst)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        sp <= 0;
        stack <= (others => (others => '0'));
      else
        if (push = '1' and pop = '0') then
          stack(sp) <= data_in;
          sp <= (sp + 1) mod DEPTH - 1;
        elsif (push = '0' and pop = '1') then
          data_out <= stack(sp);
          sp <= sp - 1;
        else
          data_out <= data_in;
        end if;
      end if;
    end if;
  end process;

end architecture rtl;
