--Engineer     : Philip Wolfe
--Date         : 11/16/2017
--Name of file : tb_clap_FSM.vhd
--Description  : Test bench for clap_FSM.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.TYPE_PACK.all;


entity tb_clap_FSM is
end tb_clap_FSM;

architecture tb_clap_FSM_arch of tb_clap_FSM is
    -- globals (set them in typePack.vhd before running testbench)
        -- set R_int to 8
        -- set N_int to 4
    
    -- constant definitions
    constant f_clk : real := 100.0e6;
    constant T : time := 10 ns;
    constant end_silence : real := 0.000000250; --25*T for simulation

    -- testbench signal declarations
    signal clk, reset : std_logic;
    signal clap_detected, check_pattern_done : std_logic;
    signal pattern_finished, bank_overflowed : std_logic;

    signal state_output : T_state;
    signal bank_array : T_bank;


begin
    -- instantiate design under test
    DUT : entity work.clap_FSM
        generic map (
            f_clk       => f_clk,
            end_silence => end_silence,
            -- from globals in typePack.vhd
            R_int       => R_int,
            N_int       => N_int,
            R_int_ctr   => R_int_ctr
        )
        port map (
        -- inputs --
        clk                 => clk,
        reset               => reset,
        clap_detected       => clap_detected,
        check_pattern_done  => check_pattern_done,
        -- outputs --
        pattern_finished    => pattern_finished,
        state_output        => state_output,
        interval_bank_array => bank_array,
        bank_overflowed     => bank_overflowed
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
        clap_detected <= '0';
        check_pattern_done <= '0';
        reset <= '1'; -- start with reset on (active high)
        wait for T;
        reset <= '0'; -- turn it off
        wait for T;

    -- let's feed in some clap detections now
        -- first clap
        clap_detected <= '1';
        wait for T;
        clap_detected <= '0';
        
        -- first interval
        wait for 20*T;

        -- second clap    
        clap_detected <= '1';
        wait for T;
        clap_detected <= '0';

        -- second interval
        wait for 23*T;

        -- third clap    
        clap_detected <= '1';
        wait for T;
        clap_detected <= '0';

        -- wait for > end_time
        wait for 28*T; -- end time is 25*T for this testbench

        -- "finish calculating" pattern
        check_pattern_done <= '1';
        wait for T;
        check_pattern_done <= '0';

        -- wait a bit at end to return to idle and see if clock stops itself at 29*T
        wait for 4*T;

        -- end test
        assert false report LF & "**** Test Completed ****" & LF severity failure;
    end process;

end tb_clap_FSM_arch;
