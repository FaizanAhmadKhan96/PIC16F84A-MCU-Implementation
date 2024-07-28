Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.type_package.all;
use work.state_package.all;

entity PIC_MCU is
  port(
    clk : in std_logic;
    rst : in std_logic;
    instruction_in   : in std_logic_vector(13 downto 0);
    PC : out std_logic_vector(12 downto 0);
    PORT_A : out std_logic_vector(7 downto 0);
    PORT_B : out std_logic_vector(7 downto 0) 
    );
end PIC_MCU;

architecture rtl of PIC_MCU is

  component Instruct_Reg is
    port(
      clk : in std_logic;                      -- Clock
      data_in : in std_logic_vector(13 downto 0);  -- data stored in Register
      data_out : out std_logic_vector(13 downto 0); -- read data from Register
      address_in : in std_logic_vector(7 downto 0);  -- data stored in Register
      address_out : out std_logic_vector(7 downto 0) -- read data from Register
      );
  end component Instruct_Reg;
  
  component Decoder_PIC is
    Port (
      clk : in STD_LOGIC;
      rst : in STD_LOGIC;
      instruction : in STD_LOGIC_VECTOR (13 downto 0);
      ALU_result : in STD_LOGIC_VECTOR (7 downto 0);
      operation : out operation_enum;
      state : out state_type;
      r_en : out STD_LOGIC;
      w_en : out STD_LOGIC;
      selection : out STD_LOGIC;
      F_out : out STD_LOGIC_VECTOR (7 downto 0);
      Bits : out  STD_LOGIC_VECTOR (2 downto 0);
      mem_addr : out STD_LOGIC_VECTOR (7 downto 0);
      PCL : out STD_LOGIC_VECTOR(10 downto 0);
      W_Reg : out STD_LOGIC_VECTOR (7 downto 0));
  end component Decoder_PIC;

--  component databus is
--    port(
--      d_sel : in std_logic; 
--      f_sel : in std_logic;
--      RAM_in : in std_logic_vector(7 downto 0);
--      RAM_out : in std_logic_vector(7 downto 0);
--      data_bus : out std_logic_vector(7 downto 0)  
--      );      
--  end component databus; 
  
  component mux_ex02b is

    port(
      A: in std_logic_vector(7 downto 0);
      B: in std_logic_vector(7 downto 0);
      S: in std_logic;
      Q: out std_logic_vector(7 downto 0));
  end component mux_ex02b;

  component ALU_ex04 is
    port(
      W : in std_logic_vector(7 downto 0);
      F : in std_logic_vector(7 downto 0);
      operation : in operation_enum;
      bit_select: in std_logic_vector(2 downto 0);
      status_in : in std_logic_vector(2 downto 0);
      PCL : in std_logic_vector(10 downto 0);
      PCL_counter : in std_logic_vector(7 downto 0);
      PCH : in std_logic_vector(4 downto 0);
      push : out std_logic;
      pop : out std_logic;   
      PC : out std_logic_vector(12 downto 0);
      result : out std_logic_vector(7 downto 0);
      status : out std_logic_vector(2 downto 0)
      );
  end component ALU_ex04;

  component Data_memory is
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
      PCLATH_in : in std_logic_vector(DATA_WIDTH-3 downto 0);
      PCL_in : in std_logic_vector(DATA_WIDTH-1 downto 0);
      data_out : out std_logic_vector(DATA_WIDTH-1 downto 0); -- read data from RAM
      stat_out : out std_logic_vector(DATA_WIDTH/2-2 downto 0);  -- read data from RAM
      PCLATH : out std_logic_vector(DATA_WIDTH-4 downto 0);
      PCL : out std_logic_vector(DATA_WIDTH-1 downto 0);
      Port_A : out std_logic_vector(DATA_WIDTH-1 downto 0);
      Port_B : out std_logic_vector(DATA_WIDTH-1 downto 0) 
      );
  end component Data_memory;

  component Register_ex06 is
    generic (
      N : positive);
    port(
      clk : in std_logic;                      -- Clock
      data_in : in std_logic_vector(N-1 downto 0);  -- data stored in Register
      data_out : out std_logic_vector(N-1 downto 0) -- read data from Register
      );
  end component Register_ex06;

  component Program_counter is
    port(
      clk : in std_logic;
      rst : in std_logic;
      state : in state_type;
      PCH : out std_logic_vector(4 downto 0);
      PCL_counter : out std_logic_vector(7 downto 0);
      pc : out std_logic_vector(12 downto 0)  
      );
  end component Program_counter;

  component Stack is
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
  end component Stack;

-- Declare all the constants
  constant DATA_WIDTH : positive := 8;
  constant ADDR_WIDTH : positive := 8;
  constant N : positive := 8;
  constant WIDTH : positive := 13;
  constant DEPTH : positive := 8;

-- Declare all the necessary signals
  signal instruct_sig : std_logic_vector(13 downto 0);
  signal result_ALU : std_logic_vector(7 downto 0);
  signal operation_sig : operation_enum;
  signal r_en : std_logic;
  signal w_en : std_logic;
  signal S : std_logic;
  signal F_out : std_logic_vector(7 downto 0);
  signal bit_sig : std_logic_vector(2 downto 0);
  signal addr : std_logic_vector(7 downto 0);
  signal W_Reg : std_logic_vector(7 downto 0);
  signal W_sig : std_logic_vector(7 downto 0);
  signal F_sig : std_logic_vector(7 downto 0);
  signal status_in : std_logic_vector(2 downto 0);
  signal status_ALU : std_logic_vector(2 downto 0);
  signal data_out : std_logic_vector(7 downto 0);
  signal addr_out : std_logic_vector(7 downto 0);
  signal F_RAM : std_logic_vector(7 downto 0);
  signal state_sig : state_type;
  signal push, pop : std_logic;
  signal pc_sig : std_logic_vector(12 downto 0);
  signal PCL_in, PCL_counter : std_logic_vector(7 downto 0);
  signal PCH_in, PCH : std_logic_vector(4 downto 0);
  signal PCL : std_logic_vector(10 downto 0);
  
begin

  Decoder_unit : Decoder_PIC
    port map(
      clk => clk,
      rst => rst,
      instruction => instruct_sig,
      ALU_result => result_ALU,
      operation => operation_sig,
      state => state_sig,
      r_en => r_en,
      w_en => w_en,
      selection => S,
      F_out => F_out,
      Bits => bit_sig,
      mem_addr => addr,
      PCL => PCL,
      W_Reg => W_Reg);

  ALU_unit : ALU_ex04
    port map(
      W => W_sig,
      F => F_sig,
      operation => operation_sig,
      status_in => status_in,
      bit_select => bit_sig,
      PCL  => PCL,
      PCL_counter  => PCL_counter,
      PCH  => PCH,
      push  => push,
      pop  => pop,  
      PC  => pc_sig,
      result => result_ALU,
      status => status_ALU);

  Memory_unit : Data_memory
    generic map(DATA_WIDTH => DATA_WIDTH,
                ADDR_WIDTH => ADDR_WIDTH)
    port map(
      clk => clk,
      rst => rst,
      data_in => result_ALU,
      addr => addr_out,
      data_out => F_RAM,
      stat_in => status_ALU,
      PCLATH_in => PCH_in,
      PCL_in => PCL_in,
      w_en => w_en,
      r_en => r_en,
      stat_out => status_in,
      PCLATH => PCH,
      PCL => PCL_counter,
      Port_A => PORT_A,
      Port_B => PORT_B);

  Register_unit : Register_ex06
    generic map(N => N)
    port map(
      clk => clk,
      data_in => W_Reg,
      data_out => W_sig);

  MUX_unit : mux_ex02b
    port map(
      A => F_RAM,
      B => F_out,
      S => S,
      Q => F_sig);

  Instruct_Reg_unit : Instruct_Reg
    port map(
      clk => clk,
      data_in => instruction_in,
      data_out => instruct_sig,
      address_in => addr,
      address_out => addr_out);

--DataBus_unit : databus
--  port map(
--    d_sel => D, 
--    f_sel => S,
--    RAM_in => AlU_result,
--    RAM_out => F_RAM,
--    data_bus => data_out);

  PC_unit : Program_counter
    port map(
      clk => clk,
      rst => rst,
      state => state_sig,
      PCH => PCH_in,
      PCL_counter => PCL_in,
      pc => PC);
  
  Stack_unit : Stack
    generic map (
      WIDTH => WIDTH,
      DEPTH => DEPTH)
    port map(
      clk  => clk,                     
      rst  => rst,
      push  => push,
      pop  => pop,
      data_in  => pc_sig,
      data_out  => PC);

end architecture rtl;
