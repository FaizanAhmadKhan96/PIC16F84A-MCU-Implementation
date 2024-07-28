-- rtl Model for Decoder (State machine)

library work;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.type_package.all;
use work.state_package.all;

--Declarartion of Entity

entity Decoder_PIC is
  Port ( clk : in STD_LOGIC;
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
end entity Decoder_PIC;

architecture rtl of Decoder_PIC is

--  type state_type is (iFetch, Mread, Execute, Mwrite);
  signal current_state, next_state : state_type;
  signal opcode : STD_LOGIC_VECTOR(5 downto 0);
  signal d : STD_LOGIC;
  signal b : STD_LOGIC_VECTOR(2 downto 0);
  signal k : STD_LOGIC_VECTOR(7 downto 0);
  signal k1 : STD_LOGIC_VECTOR(10 downto 0);
  signal operation_signal : operation_enum;
  signal result : STD_LOGIC_VECTOR(7 downto 0);

begin

  synch_stateMach : process(clk, rst)
    
  begin

    if rising_edge(clk) then
      if rst = '1' then
        current_state <= Delay;
      end if;
      current_state <= next_state;
    end if;
    state <= current_state;
  end process synch_stateMach;

  Instruction_Decoder : process(all)

    variable f : STD_LOGIC_VECTOR(7 downto 0);
    
  begin

    w_en <= '0';
    r_en <= '0';
    
    case current_state is

      when Delay =>

        next_state <= iFetch;
        
      when iFetch =>

        opcode <= instruction(13 downto 8);

        --- Byte Operations

        if (opcode = "000111") then

          operation_signal <= ADDWF;
          d <= instruction(7);
          f := '0' & instruction(6 downto 0);
          next_state <= Mread;
          
        elsif (opcode = "000101") then --when "000101" =>

          operation_signal <= ANDWF;
          d <= instruction(7);
          f := '0' & instruction(6 downto 0);
          next_state <= Mread;

        elsif (opcode = "000001") then -- when "000001" =>

          if (instruction(7) = '1') then
            operation_signal <= CLRF;
            f := '0' & instruction(6 downto 0);
            next_state <= Mread;
          else
            operation_signal <= CLRW;
            next_state <= Execute;
          end if;

        elsif (opcode = "001001") then  --when "001001" =>

          operation_signal <= COMF;
          d <= instruction(7);
          f := '0' & instruction(6 downto 0);
          next_state <= Mread;

        elsif (opcode = "000011") then -- when "000011" =>

          operation_signal <= DECF;
          d <= instruction(7);
          f := '0' & instruction(6 downto 0);
          next_state <= Mread;

        elsif (opcode = "001010") then -- when "001010" =>

          operation_signal <= INCF;
          d <= instruction(7);
          f := '0' & instruction(6 downto 0);
          next_state <= Mread;

        elsif (opcode = "000100") then  --when "000100" =>

          operation_signal <= IORWF;
          d <= instruction(7);
          f := '0' & instruction(6 downto 0);
          next_state <= Mread;

        elsif (opcode = "001000") then  --when "001000" =>

          operation_signal <= MOVF;
          d <= instruction(7);
          f := '0' & instruction(6 downto 0);
          next_state <= Mread;

        elsif (opcode = "000000") then -- when "000000" =>

          if (instruction(7) = '1') then
            operation_signal <= MOVWF;
            f := '0' & instruction(6 downto 0);
            next_state <= Mread;
          elsif (instruction(7) = '1') then
            operation_signal <= NOP;
            next_state <= Execute;
          -- else
          --   operation_signal <= RETURN;
          --   next_state <= Execute;
          end if;

        elsif (opcode = "001101") then  --when "001101" =>

          operation_signal <= RLF;
          d <= instruction(7);
          f := '0' & instruction(6 downto 0);
          next_state <= Mread;

        elsif (opcode = "001100") then -- when "001100" =>

          operation_signal <= RRF;
          d <= instruction(7);
          f := '0' & instruction(6 downto 0);
          next_state <= Mread;

        elsif (opcode = "000010") then -- when "000010" =>

          operation_signal <= SUBWF;
          d <= instruction(7);
          f := '0' & instruction(6 downto 0);
          next_state <= Mread;

        elsif (opcode = "001110") then -- when "001110" =>

          operation_signal <= SWAPF;
          d <= instruction(7);
          f := '0' & instruction(6 downto 0);
          next_state <= Mread;

        elsif (opcode = "000110") then  --when "000110" =>

          operation_signal <= XORWF;
          d <= instruction(7);
          f := '0' & instruction(6 downto 0);
          next_state <= Mread;

          --- Bit Operations

        elsif (opcode = "010000" or opcode = "010010" or opcode = "010001" or opcode = "010011") then  --when "0100xx" =>

          operation_signal <= BCF;
          b <= instruction(9 downto 7);
          f := '0' & instruction(6 downto 0);
          next_state <= Mread;

        elsif (opcode = "010100" or opcode = "010110" or opcode = "010101" or opcode = "010111") then --when "0101xx" =>

          operation_signal <= BSF;
          b <= instruction(9 downto 7);
          f := '0' & instruction(6 downto 0);
          next_state <= Mread;

          --- Literal and control Operations

        elsif (opcode = "111110" or opcode = "111111") then --when "11111x" =>

          operation_signal <= ADDLW;
          k <= instruction(7 downto 0);
          next_state <= Execute;

        elsif (opcode = "111001") then --when "111001" =>

          operation_signal <= ANDLW;
          k <= instruction(7 downto 0);
          next_state <= Execute;

        elsif (opcode = "111000") then --when "111000" =>

          operation_signal <= IORLW;
          k <= instruction(7 downto 0);
          next_state <= Execute;

        elsif (opcode = "110000" or opcode = "110001" or opcode = "110010" or opcode = "110011") then -- when "1100xx" =>

          operation_signal <= MOVLW;
          k <= instruction(7 downto 0);
          next_state <= Execute;

        elsif (opcode = "111100" or opcode = "111101") then --when "11110x" =>

          operation_signal <= SUBLW;
          k <= instruction(7 downto 0);
          next_state <= Execute;

        elsif (opcode = "111010") then --when "111010" =>

          operation_signal <= XORLW;
          k <= instruction(7 downto 0);
          next_state <= Execute;

          --- Stack Operations

        elsif (opcode = "110100" or opcode = "110101" or opcode = "110110" or opcode = "110111") then -- when "1101xx" =>
          
          operation_signal <= RETLW;
          k <= instruction(7 downto 0);
          next_state <= Execute;
          
        elsif (opcode = "100000" or opcode = "100001" or opcode = "100010" or opcode = "100011"  or opcode = "100100" or opcode = "100101" or opcode = "100111") then  --when "100xxx" =>
          
          operation_signal <= CALL;
          k1 <= instruction(10 downto 0);
          next_state <= Execute;
          
        elsif (opcode = "101000" or opcode = "101001" or opcode = "101010" or opcode = "101011"  or opcode = "101100" or opcode = "101101" or opcode = "101111") then  -- when "101xxx" =>
          
          operation_signal <= GOTO;
          k1 <= instruction(10 downto 0);
          next_state <= Execute;

--          else
--
--            report "Incorrect OPCODE detected!" severity warning;

        end if;

      when Mread =>

        r_en <= '1';
        w_en <= '0';
        mem_addr <= f;
        
        next_state <=  Delay_Mread;

      when Delay_Mread =>

        r_en <= '1';
        w_en <= '0';
        next_state <= Execute;

      when Execute =>

        operation <= operation_signal;
        
        if (operation_signal = ADDWF or operation_signal = ANDWF or operation_signal = CLRF or operation_signal = COMF or operation_signal = DECF or operation_signal = INCF or operation_signal = IORWF or operation_signal = MOVF or operation_signal = MOVWF or operation_signal = RLF or operation_signal = RRF or operation_signal = SUBWF or operation_signal = SWAPF or operation_signal = XORWF) then
          
          selection <='0';

        elsif (operation_signal = BCF or operation_signal = BSF) then

          Bits <= b;
          selection <= '0';

        elsif (operation_signal = ADDLW or operation_signal = ANDLW or operation_signal = IORLW or operation_signal = MOVLW or operation_signal = SUBLW or operation_signal = XORLW) then

          F_out <= k;
          selection <= '1';

        elsif (operation_signal = RETLW ) then

          F_out <= k;
          selection <= '1';

          next_state <= Delay;

        elsif (operation_signal = CALL or operation_signal = GOTO ) then

          PCL <= k1;
          
          next_state <= Delay;

          -- else
          --
          --   F_out <= k1;
          
        end if;
        
        next_state <= Mwrite;

      when Mwrite =>

        result <= ALU_result;

        if (operation_signal = ADDWF or operation_signal = ANDWF or operation_signal = COMF or operation_signal = DECF or operation_signal = INCF or operation_signal = IORWF or operation_signal = MOVF or operation_signal = RLF or operation_signal = RRF or operation_signal = SUBWF or operation_signal = SWAPF or operation_signal = XORWF) then

          if (d = '1') then
            
            r_en <= '0';
            w_en <= '1';
            mem_addr <= f;

          else

            W_Reg <= result;

          end if;
          
        elsif (operation_signal = BCF or operation_signal = BSF) then
          
          r_en <= '0';
          w_en <= '1';
          mem_addr <= f;

        elsif (operation_signal = CLRF or operation_signal = MOVWF) then

          r_en <= '0';
          w_en <= '1';
          mem_addr <= f;

        elsif (operation_signal = CLRW or operation_signal = NOP) then

          W_Reg <= result;

        elsif (operation_signal = ADDLW or operation_signal = ANDLW or operation_signal = IORLW or operation_signal = MOVLW or operation_signal = SUBLW or operation_signal = XORLW) then

          W_Reg <= result;

          --else
          --
          --  W_Reg <= result;

        end if;
        
        next_state <= Delay;
        
    end case;
  end process Instruction_Decoder;

end architecture rtl;
