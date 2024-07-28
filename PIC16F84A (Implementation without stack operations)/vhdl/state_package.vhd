-- Package of states

library work;

package state_package is
  
  type state_type is (
    Delay,
    iFetch,
    Delay_Mread,
    Mread,
    Execute,
    Mwrite);
  
end package state_package;
