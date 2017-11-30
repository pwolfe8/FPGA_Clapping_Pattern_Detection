--Engineer     : Philip Wolfe
--Date         : 11/29/2017
--Name of file : tb_CheckPattern.vhd
--Description  : Test bench for CheckPattern.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.type_pack.all;


entity tb_CheckPattern is
end tb_CheckPattern;

architecture tb_CheckPattern_arch of tb_CheckPattern is
    -- constant definitions
    constant T : time := 10 ns;
    
    -- testbench signal declarations
    signal clk, reset : std_logic;
    signal pattern_finished : std_logic;
    signal interval_bank : T_bank;
    signal num_intervals : unsigned(R_int_ctr-1 downto 0);
    signal check_pattern_done : std_logic;
    signal patterns_matched : std_logic_vector(N_patt-1 downto 0);
    

begin
    -- instantiate design under test
    DUT : entity work.CheckPattern
        port map (
            -- inputs --
            clk                 => clk,
            reset               => reset,
            pattern_finished    => pattern_finished,
            interval_bank       => interval_bank,
            num_intervals       => num_intervals,
            -- outputs --
            check_pattern_done  => check_pattern_done,
            patterns_matched    => patterns_matched
        );

    -- set up clock
    process begin
    	clk <= '1';
    	wait for T/2;
    	clk <= '0';
    	wait for T/2;
    end process;
    
    process begin
        -- initialize signals
        reset <= '1';
        pattern_finished <= '0';
        interval_bank <= (
            0 => X"1E", -- 30 = min*1.5 normed to X"18" or 16*1.5
            1 => X"14", -- 20 = min*1.0 normed to X"10" or 16*1.0
            2 => X"36", -- 54 = min*2.7 normed to X"2B" or 16*2.6875
            others => (others=>'0')
        );
        num_intervals <= X"3";
        wait for T;
        reset <= '0';
        wait for T;
        pattern_finished <= '1';
        wait for T;
        pattern_finished <= '0';
        wait for 75*T;

        -- TEST CASE 1 --
        assert ( patterns_matched="0100" )
        report LF
            & "================ Test case 1 failed! ================" & LF
            & "received: " & to_hstring(patterns_matched) & LF
            & "expected: " & "0100" & LF
            & "====================================================="
        severity error;
        
        
        
        -- end test
        assert false report LF & LF & "**** Test Completed ****" & LF severity failure;
    end process;

end tb_CheckPattern_arch;
