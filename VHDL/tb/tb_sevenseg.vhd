--Engineer     : Philip Wolfe
--Date         : 11/20/2017
--Name of file : tb_sevenseg.vhd
--Description  : Test bench for sevenseg.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.TYPE_PACK.all;


entity tb_sevenseg is
end tb_sevenseg;

architecture tb_sevenseg_arch of tb_sevenseg is
    -- constant definitions
    constant T : time := 10 ns; -- change this to period of clk (oscillator is 100MHz)

    -- testbench signal declarations
        -- inputs --
    signal clk, reset : std_logic;
    signal patternIn : std_logic_vector(N_patt-1 downto 0); -- 1 if pattern matches
    signal clap_detected : std_logic;
    signal state : T_state;
        -- outputs --
    signal seg : std_logic_vector(6 downto 0);
    signal an : std_logic_vector(3 downto 0);

begin
    -- instantiate design under test
    DUT : entity work.sevenseg
        -- generic map (
            
        -- )
        port map (
            -- inputs --
            clk => clk,
            rst => reset,
            patternIn => patternIn,
            clapDetected => clap_detected,
            state => state,
            -- ouputs --
            seg => seg,
            an => an
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
        state <= IDLE;
        clap_detected <= '0';
        wait for T;
        reset <= '0';
        wait for T;

        -- implement some test cases
        

        -- TEST CASE 1 --
        assert ( _some_boolean_checking_output_ )
        report LF
            & "================ Test case 1 failed! ================" & LF
            & "received: " & to_hstring(_signal_being_checked_) & LF
            & "expected: " & to_hstring(_expected_signal_) & LF
            & "====================================================="
        severity error;
        

        -- end test
        assert false report LF & LF & "**** Test Completed ****" & LF severity failure;
    end process;

end tb_sevenseg_arch;
