--Engineer     : Philip Wolfe
--Date         : 11/16/2017
--Name of file : tb_clap_FSM.vhd
--Description  : Test bench for clap_FSM.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_clap_FSM is
end tb_clap_FSM;

architecture tb_clap_FSM_arch of tb_clap_FSM is
    -- constant definitions
    constant T : time := 40 ns;
    constant f_clk : positive := 25e6;
    constant end_silence : real := 2.5;
    constant R_int : positive := 26;
    constant n_int : positive := 8;

    -- testbench signal declarations
    signal clk, reset : std_logic;
    signal clap_detected, check_pattern_done : std_logic;
    signal pattern_finished, bank_overflowed : std_logic;

    signal state_output_code : std_logic_vector(1 downto 0);
    signal bank_array : T_bank;

begin
    -- instantiate design under test
    DUT : entity work.clap_FSM
        generic map (
            f_clk=>f_clk, end_silence=>end_silence, R_int=>R_int, n_int=>n_int
        )
        port map (
        -- inputs --
        clk                 => clk,
        reset               => reset,
        clap_detected       => clap_detected,
        check_pattern_done  => check_pattern_done,
        -- outputs --
        pattern_finished    => pattern_finished,
        state_output_code   => state_output_code,
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
        reset <= '1'; -- start with reset on (active high)
        wait for T;
        reset <= '0'; -- turn it off
        


        
        
        -- end test
        assert false report "Test Completed" severity failure;
    end process;

end tb_clap_FSM_arch;
