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
    PCL : in std_logic_vector(10 downto 0);
    PCL_counter : in std_logic_vector(7 downto 0);
    PCH : in std_logic_vector(4 downto 0);
    push : out std_logic;
    pop : out std_logic;   
    PC : out std_logic_vector(12 downto 0);
    result : out std_logic_vector(7 downto 0);
    status : out std_logic_vector(2 downto 0)
    );
end entity ALU_ex04;

-- Defining the behavioral architecture
architecture behav of ALU_ex04 is

  signal pcl_sig : std_logic_vector(10 downto 0);
  signal pcl_c : std_logic_vector(7 downto 0);
  signal pch_sig : std_logic_vector(1 downto 0);
  signal pch_c : std_logic_vector(4 downto 0);
  signal pc_sig : std_logic_vector(12 downto 0);

begin

  ALU : process (W,F,status_in,bit_select,operation) is

    variable Z_flag, DC_flag, C_flag: std_logic;
    variable result_temp,F_temp,W_temp: std_logic_vector(7 downto 0);
--    variable pc :  std_logic_vector(13 downto 0);


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


      when MOVWF =>
        
        F_temp := W_temp;
        result_temp := F_temp;
        
        zero_flag(result_temp,Z_flag);
        status(2) <= status_in(2);
        status(1) <= status_in(1);
        status(0) <= status_in(0);

        result <= result_temp;

      when MOVLW =>
        
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

      when CALL =>

        pcl_sig <= PCL;
        pch_sig <= PCH(4 downto 3);

        pc_sig <= pch_sig & pcl_sig;

        PC <= pc_sig;

        push <= '1';
        pop <= '0';

      when GOTO =>

        pcl_sig <= PCL;
        pch_sig <= PCH(4 downto 3);

        pc_sig <= pch_sig & pcl_sig;

        PC <= pc_sig;

        push <= '0';
        pop <= '0';

      when RETLW =>

        pcl_c <= PCL_counter;
        pch_c <= PCH;

        pc_sig <= pch_c & pcl_c;

        PC <= pc_sig;

        push <= '0';
        pop <= '1';

    end case;

    result <= result_temp;

  end process ALU;

end architecture behav;
