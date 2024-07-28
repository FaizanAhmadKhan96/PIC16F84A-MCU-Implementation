entity orgate is
end entity;

architecture arch of orgate is
    signal a, b, c : bit;
begin
    
    c <= a or b;

    run_sim : process is
    begin
        a <= '0';
        b <= '0';

        wait for 1 ns;
        b <= '1';
        wait for 1 ns;
        b <= '0';
        wait for 2 ns;
        a <= '1';
        wait for 1 ns;

        wait; -- this stops simulation
    end process;

end architecture;
