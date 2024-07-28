-- RTL Model for Memory block of ALU

library work;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Declarartion of Entity
entity RAM_ex05 is
  generic (
    DATA_WIDTH : positive;
    ADDR_WIDTH : positive);
  port(
    clk : in std_logic;                      -- Clock
    addr : in std_logic_vector(ADDR_WIDTH-1 downto 0); -- Address input
    data_in : in std_logic_vector(DATA_WIDTH-1 downto 0);  -- data stored in RAM
    stat_in : in std_logic_vector(DATA_WIDTH/2-2 downto 0);  -- status stored in RAM
    w_en : in std_logic;                  -- Write enable
    r_en : in std_logic;                   -- Read enable
    rst : in std_logic;                   -- Reset
    data_out : out std_logic_vector(DATA_WIDTH-1 downto 0); -- read data from RAM
    stat_out : out std_logic_vector(DATA_WIDTH/2-2 downto 0)  -- read data from RAM
    );
end entity RAM_ex05;

-- Defining the behavioral architecture
architecture rtl of RAM_ex05 is

  type mem_array is array (0 to 2**ADDR_WIDTH - 1) of std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal RAM : mem_array;
  
begin

--  synch_RAM : process (clk) is
--    
--  begin
--    
--    if rising_edge(clk) then
--
--      -- Preload memory with initial values of 0 without reset as semiconductor
--      -- memories do not have reset pin
--      for i in RAM'range loop
--        RAM(i) <= (others => '0');
--      end loop;
--      
--      if  w_en = '1' then
--        if addr = "00000011" then
--          
--          -- Write operation
--          RAM(to_integer(unsigned(addr))) <= data_in;
--          
--        else
--          
--          RAM(to_integer(unsigned(addr))) <= data_in;
--          
--          RAM(03) <= (others => '0'); -- Clear previous data
--          RAM(03)(2 downto 0) <= stat_in;
--          
--        end if;
--        
--      elsif  r_en = '1' then
--        if addr = "00000011" then
--          -- Read operation
--          data_out <= RAM(to_integer(unsigned(addr)));
--          stat_out <= (others => '0');
--        else
--          data_out <= RAM(to_integer(unsigned(addr)));
--          stat_out <= RAM(03)(2 downto 0);
--        end if;
--      end if;
--    end if;
--    
--  end process synch_RAM;

  -- synch_RAM_synch_reset : process (clk) is
  --   
  -- begin
  --
  --   if rising_edge(clk) then
  --     if rst = '1' then
  --
  --    -- Reset operation: Preload memory with initial values
  -- for i in RAM'range loop
  --   RAM(i) <= (others => '0');
  -- end loop;
  -- --data_out <= (others => '0');  -- Output data during reset
  -- --stat_out <= (others => '0');  -- Output status during reset
  --     
  --    elsif  w_en = '1' then
  --       if addr = "00000011" then
  --
  --         -- Write operation
  --       RAM(to_integer(unsigned(addr))) <= data_in;
  --         
  --       else
  --
  --          RAM(to_integer(unsigned(addr))) <= data_in;
  --         
  --       RAM(03) <= (others => '0'); -- Clear previous data
  --       RAM(03)(2 downto 0) <= stat_in;
  --          
  --     end if;
  --       
  --     elsif  r_en = '1' then
  --        if addr = "00000011" then
  --       -- Read operation
  --       data_out <= RAM(to_integer(unsigned(addr)));
  --         stat_out <= stat_in;
  --       else
  --         data_out <= RAM(to_integer(unsigned(addr)));
  --         stat_out <= RAM(03)(2 downto 0);
  --       end if;
  --     end if;
  --   end if;
  --   
  -- end process synch_RAM_synch_reset;


  synch_RAM_asynch_reset : process (clk,rst) is
    
  begin

    if rst = '1' then
      
      -- Reset operation: Preload memory with initial values
      for i in RAM'range loop
        RAM(i) <= (others => '0');
      end loop;

    end if;
    
    if rising_edge(clk) then

      RAM(03)(2 downto 0) <= stat_in;
      stat_out <= RAM(03)(2 downto 0);
      
      if  w_en = '1' then
        if addr = "00000011" then
          
          -- Write operation
          RAM(to_integer(unsigned(addr))) <= data_in;
          
        else
          
          RAM(to_integer(unsigned(addr))) <= data_in;
          
        end if;
        
      elsif  r_en = '1' then
        
        data_out <= RAM(to_integer(unsigned(addr)));
        
      end if;
    end if;
    
  end process synch_RAM_asynch_reset;


end architecture rtl;
