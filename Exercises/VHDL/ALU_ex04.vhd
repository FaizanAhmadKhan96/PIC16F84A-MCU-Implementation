-- Behaviorial Model for ALU

library work;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.type_package.all;

--Declarartion of Entity
entity ALU_ex04 is
  port(
    W : in std_logic_vector(7 downto 0);
    F : in std_logic_vector(7 downto 0);
    operation : in operation_enum;
    bit_select: in std_logic_vector(2 downto 0);
    status_in : in std_logic_vector(2 downto 0);
    result : out std_logic_vector(7 downto 0);
    status : out std_logic_vector(2 downto 0)
    );
end entity ALU_ex04;

-- Defining the behavioral architecture
architecture behav of ALU_ex04 is

  -- type operation_enum is (ADDWF, ANDWF, CLRF, CLRW, COMF, DECF, DECFSZ, INCF, INFSZ, IORWF, MOVF, MOVWF, RLF, RRF, SUBWF, SWAPF, XORWF, NOP, BCF, BSF, BTFSC, BTFSS);

begin

  ALU : process (W,F,status_in,bit_select,operation) is

    variable Z_flag, DC_flag, C_flag: std_logic;
    variable result_temp,F_temp,W_temp: std_logic_vector(7 downto 0);

    procedure zero_flag (
      variable result_sig: in std_logic_vector(7 downto 0);
      variable z_flag: out std_logic
      ) is
    begin
      if (result_sig = "00000000") then
        z_flag := '1';
      else
        z_flag := '0';
      end if;

    end procedure zero_flag;              

    
    procedure digit_carry_flag (
      variable W_sig: in std_logic_vector(7 downto 0);
      variable F_sig: in std_logic_vector(7 downto 0);
      variable dc_flag: out std_logic
      ) is

      variable carry_sig : std_logic;
      
    begin

      carry_sig := (W_sig(3) and F_sig(3)) or (W_sig(2) and F_sig(2)) or (W_sig(1) and F_sig(1)) or (W_sig(0) and F_sig(0));

      if (carry_sig = '1') then
        dc_flag := '1';
      else
        dc_flag := '0';
      end if;

    end procedure digit_carry_flag;
    

    procedure carry_flag (
      signal op_sig: in operation_enum;
      variable W_sig: in std_logic_vector(7 downto 0);
      variable F_sig: in std_logic_vector(7 downto 0);
      variable c_flag: out std_logic
      ) is

      variable carry_sig : std_logic;
      
    begin

      case op_sig is
        
        when RLF =>

          if (F_sig(7) = '1') then
            c_flag := '1';
          else
            c_flag := '0';
          end if;

        when RRF =>

          if (F_sig(0) = '1') then
            c_flag := '1';
          else
            c_flag := '0';
          end if;
          
        when others =>

          carry_sig := (W_sig(7) and F_sig(7)) or (W_sig(6) and F_sig(6)) or (W_sig(5) and F_sig(5)) or (W_sig(4) and F_sig(4));

          if (carry_sig = '1') then
            c_flag := '1';
          else
            c_flag := '0';
          end if;

      end case;

    end procedure carry_flag;

  begin

    W_temp := W;
    F_temp := F;

    case operation is
      
      when ADDWF|ADDLW =>
        
        result_temp := std_logic_vector(unsigned(W_temp) + unsigned(F_temp));
        
        zero_flag(result_temp,Z_flag);
        status(2) <= Z_flag; 
        digit_carry_flag(W_temp,F_temp,DC_flag);
        status(1) <= DC_flag;
        carry_flag(operation,W_temp,F_temp,C_flag);
        status(0) <= C_flag;

        result <= result_temp;
        
        
      when ANDWF|ANDLW =>
        
        result_temp := W_temp and F_temp;

        zero_flag(result_temp,Z_flag);
        status(2) <= Z_flag;
        status(1) <= status_in(1);
        status(0) <= status_in(0);

        result <= result_temp;
        

      when CLRF =>
        
        F_temp := (others => '0');
        result_temp := F_temp;
        
        zero_flag(result_temp,Z_flag);
        status(2) <= Z_flag;
        status(1) <= status_in(1);
        status(0) <= status_in(0);

        result <= result_temp;
        
        
      when CLRW =>

        W_temp := (others => '0');
        result_temp := W_temp;
        
        zero_flag(result_temp,Z_flag);
        status(2) <= Z_flag;
        status(1) <= status_in(1);
        status(0) <= status_in(0);

        result <= result_temp;
        

      when COMF =>

        F_temp := NOT F_temp;
        result_temp := F_temp;
        
        zero_flag(result_temp,Z_flag);
        status(2) <= Z_flag;
        status(1) <= status_in(1);
        status(0) <= status_in(0);

        result <= result_temp;
        

      when DECF =>

        F_temp := std_logic_vector(unsigned(F_temp)-1);
        result_temp := F_temp;
        
        zero_flag(result_temp,Z_flag);
        status(2) <= Z_flag;
        status(1) <= status_in(1);
        status(0) <= status_in(0);

        result <= result_temp;
        

      when INCF =>

        F_temp := std_logic_vector(unsigned(F_temp)+1);
        result_temp := F_temp;
        
        zero_flag(result_temp,Z_flag);
        status(2) <= Z_flag;
        status(1) <= status_in(1);
        status(0) <= status_in(0);

        result <= result_temp;


      when IORWF|IORLW =>

        result_temp := W_temp or F_temp;

        zero_flag(result_temp,Z_flag);
        status(2) <= Z_flag;
        status(1) <= status_in(1);
        status(0) <= status_in(0);

        result <= result_temp;
        

      when MOVF =>

        result_temp := F_temp;
        
        zero_flag(result_temp,Z_flag);
        status(2) <= Z_flag;
        status(1) <= status_in(1);
        status(0) <= status_in(0);

        result <= result_temp;


      when MOVWF|MOVLW =>
        
        F_temp := W_temp;
        result_temp := F_temp;
        
        zero_flag(result_temp,Z_flag);
        status(2) <= status_in(2);
        status(1) <= status_in(1);
        status(0) <= status_in(0);

        result <= result_temp;

        
      when RLF =>
        
        zero_flag(result_temp,Z_flag);
        status(2) <= status_in(2);
        status(1) <= status_in(1);
        carry_flag(operation,W_temp,F_temp,DC_flag);
        status(0) <= C_flag;

        F_temp := F_temp(6 downto 0) & C_flag;
        result_temp := F_temp;

        result <= result_temp;

        
      when RRF =>
        
        zero_flag(result_temp,Z_flag);
        status(2) <= status_in(2);
        status(1) <= status_in(1);
        carry_flag(operation,W_temp,F_temp,DC_flag);
        status(0) <= C_flag;

        F_temp := C_flag & F_temp(7 downto 1);
        result_temp := F_temp;

        result <= result_temp;
        

      when SUBWF|SUBLW =>

        result_temp := std_logic_vector(unsigned(F_temp) + unsigned(not W_temp) + 1);
        
        zero_flag(result_temp,Z_flag);
        status(2) <= Z_flag; 
        digit_carry_flag(W_temp,F_temp,DC_flag);
        status(1) <= DC_flag;
        carry_flag(operation,W_temp,F_temp,DC_flag);
        status(0) <= C_flag;

        result <= result_temp;
        
        
      when SWAPF =>

        F_temp := F_temp(3 downto 0) & F_temp(7 downto 4);
        result_temp := F_temp;
        
        status(2) <= status_in(2);
        status(1) <= status_in(1);
        status(0) <= status_in(0);

        result <= result_temp;
        
      when XORWF|XORLW =>

        result_temp := W_temp xor F_temp;

        zero_flag(result_temp,Z_flag);
        status(2) <= Z_flag;
        status(1) <= status_in(1);
        status(0) <= status_in(0);

        result <= result_temp;
        
      when BCF =>

        F_temp(to_integer(unsigned(bit_select))) := '0';
        result_temp := F_temp;

        status(2) <= status_in(2);
        status(1) <= status_in(1);
        status(0) <= status_in(0);

        result <= result_temp;
        
      when BSF =>

        F_temp(to_integer(unsigned(bit_select))) := '1';
        result_temp := F_temp;

        status(2) <= status_in(2);
        status(1) <= status_in(1);
        status(0) <= status_in(0);

        result <= result_temp;
        
      when NOP =>

        null;
        status(2) <= status_in(2);
        status(1) <= status_in(1);
        status(0) <= status_in(0);

    end case;

    result <= result_temp;

  end process ALU;

end architecture behav;
