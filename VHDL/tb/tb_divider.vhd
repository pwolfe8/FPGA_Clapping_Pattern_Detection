--Engineer     : Philip Wolfe
--Date         : 11/22/2017
--Name of file : tb_divider.vhd
--Description  : Test bench for divider.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.TYPE_PACK.all;

entity tb_divider is
end tb_divider;

architecture tb_divider_arch of tb_divider is
    -- constant definitions
    constant T : time := 10 ns;

    -- testbench signal declarations
    signal clk, reset : std_logic;
    signal start, done : std_logic;
    signal numerator, denominator, result : unsigned(R_int-1 downto 0);

begin
    -- instantiate design under test
    DUT : entity work.divider
        generic map (
            R_int => R_int,
            R_ctr => 5,
            N_dec => N_dec
        )
        port map (
            -- inputs --
            clk => clk,
            reset => reset,
            start => start,
            numerator => numerator,
            denominator => denominator,
            -- outputs --
            done => done,
            result => result
        );

    -- set up clock if you need it
    process begin
    	clk <= '1';
    	wait for T/2;
    	clk <= '0';
    	wait for T/2;
    end process;
    
    process begin
        -- initialize signals
        reset <= '1';
        start <= '0';
        wait for T;
        reset <= '0'; 
        numerator <= X"06";
        denominator <= X"04";
        wait for T;
        start <= '1';
        wait for T;
        start <= '0';
        wait for (R_int+6)*T;
        -- TEST CASE 1 --
        assert ( result = X"18" ) --24
        report LF
            & "================ Test case 1 failed! ================" & LF
            & "received: " & to_hstring(result) & LF
            & "expected: " & to_hstring(X"18") & LF
            & "====================================================="
        severity error;
        
        numerator <= X"10";
        denominator <= X"20";
        wait for T;
        start <= '1';
        wait for T;
        start <= '0';
        wait for (R_int+6)*T;
        -- TEST CASE 2 --
        assert ( result = X"08" ) -- 8
        report LF
            & "================ Test case 2 failed! ================" & LF
            & "received: " & to_hstring(result) & LF
            & "expected: " & to_hstring(X"08") & LF
            & "====================================================="
        severity error;
        
        -- divide by 0 error?
        numerator <= X"20";
        denominator <= X"00";
        wait for T;
        start <= '1';
        wait for T;
        start <= '0';
        wait for (R_int+6)*T;
        -- TEST CASE 3 --
        assert ( result = X"00" ) -- 0
        report LF
            & "================ Test case 3 failed! ================" & LF
            & "received: " & to_hstring(result) & LF
            & "expected: " & to_hstring(X"00") & LF
            & "====================================================="
        severity error;
                
        numerator <= X"20";
        denominator <= X"20";
        wait for T;
        start <= '1';
        wait for T;
        start <= '0';
        wait for (R_int+6)*T;
        -- TEST CASE 4 --
        assert ( result = X"10" ) -- 16
        report LF
            & "================ Test case 4 failed! ================" & LF
            & "received: " & to_hstring(result) & LF
            & "expected: " & to_hstring(X"10") & LF
            & "====================================================="
        severity error;

        numerator <= X"36";
        denominator <= X"14";
        wait for T;
        start <= '1';
        wait for T;
        start <= '0';
        wait for (R_int+6)*T;
        -- TEST CASE 5 --
        assert ( result = X"2A" ) -- 42
        report LF
            & "================ Test case 5 failed! ================" & LF
            & "received: " & to_hstring(result) & LF
            & "expected: " & to_hstring(X"2A") & LF
            & "====================================================="
        severity error;


        wait for 6*T;

        -- end test
        assert false report "Test Completed" severity failure;
    end process;


end tb_divider_arch;
