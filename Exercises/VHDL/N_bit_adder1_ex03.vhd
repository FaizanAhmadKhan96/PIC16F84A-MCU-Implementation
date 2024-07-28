-- Behaviorial Model for N-bit Full Adder without carry_in

library work;
library ieee;
use ieee.std_logic_1164.all;

--Declarartion of Entity
entity N_bit_adder1_ex03 is
   generic ( N : positive);
  port(
    A, B : in std_logic_vector(N-1 downto 0);
    S : out std_logic_vector(N-1 downto 0);
    CO : out std_logic
);
end entity N_bit_adder1_ex03;

-- Defining the behavioral architecture
architecture behav of N_bit_adder1_ex03 is
  
-- Declaring internal signals
  signal S_signal : std_logic_vector(N-1 downto 0);
  signal CO_signal : std_logic_vector(N-1 downto 0);
  
 begin

   adder : for bit_in in N-1 downto 0 generate
     
     begin

       lsb_cell: if bit_in = 0 generate

         S_signal(bit_in) <= A(bit_in) XOR B(bit_in);
          CO_signal(bit_in) <= A(bit_in) AND B(bit_in);

          end generate lsb_cell;

       msb_cell: if bit_in = N-1 generate
                      
        S_signal(bit_in) <= ((A(bit_in) XOR B(bit_in)) XOR  CO_signal(bit_in-1));
         CO_signal(bit_in) <= ((A(bit_in) AND B(bit_in)) OR (CO_signal(bit_in-1) AND A(bit_in))) OR (CO_signal(bit_in-1) AND B(bit_in));
          -- CO_signal(bit_in) <= (((((A(bit_in) AND B(bit_in)) OR  CO_signal(bit_in-1)) AND A(bit_in)) OR  CO_signal(bit_in-1)) AND B(bit_in));
       
        end generate msb_cell;

         mid_cell: if  bit_in > 0 and  bit_in < N-1 generate
                                     
           S_signal(bit_in) <= ((A(bit_in) XOR B(bit_in)) XOR  CO_signal(bit_in-1));
            CO_signal(bit_in) <= ((A(bit_in) AND B(bit_in)) OR (CO_signal(bit_in-1) AND A(bit_in))) OR (CO_signal(bit_in-1) AND B(bit_in));
         --  CO_signal(bit_in) <= (((((A(bit_in) AND B(bit_in)) OR  CO_signal(bit_in-1)) AND A(bit_in)) OR  CO_signal(bit_in-1)) AND B(bit_in));

          end generate mid_cell;

  end generate adder;

   -- Assign internal signals to outputs
   S <= S_signal; 
   CO <= CO_signal(N-1);

end architecture behav;
