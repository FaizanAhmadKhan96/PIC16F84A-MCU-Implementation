-- rtl Model for Decoder (State machine)

library work;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.type_package.all;

--Declarartion of Entity

entity Decoder_ex06 is
  Port ( clk : in STD_LOGIC;
         rst : in STD_LOGIC;
         ALU_status : in STD_LOGIC_VECTOR (2 downto 0);
         RAM_status : in STD_LOGIC_VECTOR (2 downto 0);
         instruction : in STD_LOGIC_VECTOR (13 downto 0);
         ALU_result : in STD_LOGIC_VECTOR (7 downto 0);
         operation : out operation_enum;
         r_en : out STD_LOGIC;
         w_en : out STD_LOGIC;
         selection : out STD_LOGIC;
         F_out : out STD_LOGIC_VECTOR (7 downto 0);
         Bits : out  STD_LOGIC_VECTOR (2 downto 0);
         mem_addr : out STD_LOGIC_VECTOR (7 downto 0);
         W_Reg : out STD_LOGIC_VECTOR (7 downto 0);
         pc : out STD_LOGIC_VECTOR (7 downto 0));
end entity Decoder_ex06;

architecture rtl of Decoder_ex06 is

  type state_type is (iFetch, Mread, Execute, Mwrite);
  signal current_state, next_state : state_type;
  signal opcode : STD_LOGIC_VECTOR(5 downto 0);
  signal d : STD_LOGIC;
  signal b : STD_LOGIC_VECTOR(2 downto 0);
  signal k : STD_LOGIC_VECTOR(7 downto 0);
--signal k1 : STD_LOGIC_VECTOR(10 downto 0);
  signal operation_signal : operation_enum;
  signal result : STD_LOGIC_VECTOR(7 downto 0);
  signal s : STD_LOGIC;
  signal pc_reg : unsigned(7 downto 0):= (others => '0');

begin

  synch_stateMach : process(clk, rst)

--    variable pc_reg : unsigned(7 downto 0):= (others => '0');
    
  begin
    if rst = '1' then
      pc_reg <= "00000000"; -- Initialize PC to 0
      pc <= STD_LOGIC_VECTOR(pc_reg);
      current_state <= iFetch;
    end if;
    if rising_edge(clk) then
      current_state <= next_state;
      -- Update PC on each instruction fetch cycle
      if current_state = Mwrite then
        pc_reg <= pc_reg + 1;
        pc <= std_logic_vector(pc_reg);
      end if;
    end if;
  end process synch_stateMach;

  Instruction_Decoder : process(all)

    variable f : STD_LOGIC_VECTOR(7 downto 0);
    variable pc_reg : unsigned(7 downto 0) := (others => '0');
--    variable d : STD_LOGIC;
--    variable operation_signal : operation_enum;
    
  begin

    w_en <= '0';
    r_en <= '0';
    
    case current_state is
      
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

          -- when "1101xx" =>
          --
          -- operation_signal <= RETLW;
          -- k <= instruction(7 downto 0);
          -- next_state <= Execute;
          --
          -- when "100xxx" =>
          --
          -- operation_signal <= CALL;
          -- k1 <= instruction(10 downto 0);
          -- next_state <= Execute;
          --
          -- when "101xxx" =>
          --
          -- operation_signal <= GOTO;
          -- k1 <= instruction(10 downto 0);
          -- next_state <= Execute;

--          else
--
--            report "Incorrect OPCODE detected!" severity warning;

        end if;

      when Mread =>

        r_en <= '1';
        w_en <= '0';
        mem_addr <= f;
        
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

            if (ALU_status /= RAM_status and operation_signal = SWAPF) then
              assert false report "Status register override detected!" severity note;
            end if;

          else

            W_Reg <= result;

            if (ALU_status /= RAM_status and operation_signal = SWAPF) then
              assert false report "Status register override detected!" severity note;
            end if;

          end if;
          
        elsif (operation_signal = BCF or operation_signal = BSF) then
          
          r_en <= '0';
          w_en <= '1';
          mem_addr <= f;

          if (ALU_status /= RAM_status and (operation_signal = BCF or operation_signal = BSF)) then
            assert false report "Status register override detected!" severity note;
          end if;

        elsif (operation_signal = CLRF or operation_signal = MOVWF) then

          r_en <= '0';
          w_en <= '1';
          mem_addr <= f;

          if (ALU_status /= RAM_status and operation_signal = MOVWF) then
            assert false report "Status register override detected!" severity note;
          end if;

        elsif (operation_signal = CLRW or operation_signal = NOP) then

          W_Reg <= result;

          if (ALU_status /= RAM_status and operation_signal = NOP) then
            assert false report "Status register override detected!" severity note;
          end if;

        elsif (operation_signal = ADDLW or operation_signal = ANDLW or operation_signal = IORLW or operation_signal = MOVLW or operation_signal = SUBLW or operation_signal = XORLW) then

          W_Reg <= result;

          if (ALU_status /= RAM_status and operation_signal = MOVLW) then
            assert false report "Status register override detected!" severity note;
          end if;

          --else
          --
          --  W_Reg <= result;

        end if;
        
        -- Always increment PC
--        pc_reg :=  pc_reg + 1;
--        pc <= STD_LOGIC_VECTOR(pc_reg);
        next_state <= iFetch;
        
    end case;
  end process Instruction_Decoder;

end architecture rtl;
