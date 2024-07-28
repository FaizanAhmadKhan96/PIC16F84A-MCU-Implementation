-- RTL Model for Memory block of ALU

library work;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Declarartion of Entity
entity Data_memory is
  generic (
    DATA_WIDTH : positive;
    ADDR_WIDTH : positive);
  port(
    clk : in std_logic;                      -- Clock
    addr : in std_logic_vector(ADDR_WIDTH-1 downto 0); -- Address input
    data_in : in std_logic_vector(DATA_WIDTH-1 downto 0);  -- data stored in RAM
    stat_in : in std_logic_vector(DATA_WIDTH/2-2 downto 0);  -- status stored in RAM
    PCLATH_in : in std_logic_vector(DATA_WIDTH-4 downto 0);
    PCL_in : in std_logic_vector(DATA_WIDTH-1 downto 0);
    w_en : in std_logic;                  -- Write enable
    r_en : in std_logic;                   -- Read enable
    rst : in std_logic;                   -- Reset
    data_out : out std_logic_vector(DATA_WIDTH-1 downto 0); -- read data from RAM
    stat_out : out std_logic_vector(DATA_WIDTH/2-2 downto 0);  -- read data from RAM
    Port_A : out std_logic_vector(DATA_WIDTH-1 downto 0);
    PCLATH : out std_logic_vector(DATA_WIDTH-4 downto 0);
    PCL : out std_logic_vector(DATA_WIDTH-1 downto 0);
    Port_B : out std_logic_vector(DATA_WIDTH-1 downto 0) 
    );
end entity Data_memory;

-- Defining the behavioral architecture
architecture rtl of Data_memory is

  type mem_array is array (0 to 2**ADDR_WIDTH - 1) of std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal RAM : mem_array;
  
begin

  synch_RAM : process (clk,rst) is
    
  begin

    if rising_edge(clk) then
      if rst = '1' then

        -- Reset operation: Preload memory with initial values
        for i in RAM'range loop
          RAM(i) <= (others => '0');
        end loop;

      end if;

      --Implemneting bank 0 of memory block

      -- Port A and B connected to output port

      Port_A <= RAM(05);

      Port_B <= RAM(06);

      -- PCL Register implementation with value coming from program counter

      RAM(02) <= PCL_in;
      PCL <= RAM(02);

      -- PCLATH Register implementation

      RAM(10)(4 downto 0) <= PCLATH_in;
      PCLATH <= RAM(10)(4 downto 0);

      -- Status Register implementation

      RAM(03)(2 downto 0) <= stat_in;
      stat_out <= RAM(03)(2 downto 0);

      -- General purpose register (SRAM) implementation ocupying addresses between 0C-4F in data memory

      if (addr = "00001100" or addr = "00001101" or addr = "00001110"  or addr = "00001111"  or addr = "00010000"  or addr = "00010001"  or addr = "00010010"  or addr = "00010011"  or addr = "00010100"  or addr = "00010101"  or addr = "00010110" or addr = "00010111"  or addr = "00011000" or addr = "00011001" or addr = "00011010" or addr = "00011011" or addr = "00011100" or addr = "00011101" or addr = "00011110" or addr = "00011111" or addr = "00100000"  or addr = "00100001"  or addr = "00100010"  or addr = "00100011"  or addr = "00100100"  or addr = "00100101"  or addr = "00100110" or addr = "00100111"  or addr = "00101000" or addr = "00101001" or addr = "00101010" or addr = "00101011" or addr = "00101100" or addr = "00101101" or addr = "00101110" or addr = "00101111" or addr = "00110000"  or addr = "00110001"  or addr = "00110010"  or addr = "00110011"  or addr = "00110100"  or addr = "00110101"  or addr = "00110110" or addr = "00110111"  or addr = "00111000" or addr = "00111001" or addr = "00111010" or addr = "00111011" or addr = "00111100" or addr = "00111101" or addr = "00111110" or addr = "00111111" or addr = "01000000"  or addr = "01000001"  or addr = "01000010"  or addr = "01000011"  or addr = "01000100"  or addr = "01000101"  or addr = "01000110" or addr = "01000111"  or addr = "01001000" or addr = "01001001" or addr = "01001010" or addr = "01001011" or addr = "01001100" or addr = "01001101" or addr = "01001110" or addr = "01001111") then
        
        if  w_en = '1' then
          
          -- Write operation
          RAM(to_integer(unsigned(addr))) <= data_in;  
          
        elsif  r_en = '1' then

          -- Read operation
          data_out <= RAM(to_integer(unsigned(addr)));
          
        end if;
      end if;
    end if;
    
  end process synch_RAM;

end architecture rtl;
