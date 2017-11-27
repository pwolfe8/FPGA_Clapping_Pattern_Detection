--Engineer     : Philip Wolfe
--Date         : 11/19/2017
--Name of file : tb_min_not_zero.vhd
--Description  : Test bench for min_not_zero.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.TYPE_PACK.all;


entity tb_min_not_zero is
end tb_min_not_zero;

architecture tb_min_not_zero_arch of tb_min_not_zero is
    -- globals (set them in typePack.vhd before running testbench)
        -- set R_int to 8
        -- set N_int to 4
        -- set R_int_ctr to 4
        
    
    -- constant definitions
    constant T : time := 10 ns;
    
    -- testbench signal declarations
        -- inputs --
    signal clk, reset : std_logic;
    signal pattern_finished : std_logic;
    signal num_intervals : unsigned(R_int_ctr-1 downto 0);
    signal bank_array : T_bank;
        -- outputs --
    signal min_done : std_logic;
    signal smallest : unsigned(R_int-1 downto 0);
    
begin
    -- instantiate design under test
    DUT : entity work.min_not_zero
        -- generic map (
        --     R_int     => R_int,
        --     R_int_ctr => R_int_ctr
        -- )
        port map (
            -- inputs --
            clk              => clk,
            reset            => reset,
            pattern_finished => pattern_finished,
            num_intervals    => num_intervals,
            bank_array       => bank_array,
            -- outputs --
            min_done         => min_done,
            smallest    	 => smallest
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
        bank_array <= (
            0 => X"04",
            1 => X"01",
            2 => X"04",
            others => (others=>'0')
        );
        num_intervals <= to_unsigned(3,R_int_ctr);
        pattern_finished <= '0';
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;
        pattern_finished <= '1';
        wait for T;
        pattern_finished <= '0';
        wait for 60 ns;
        -- TEST CASE 1 --
        assert ( smallest = X"01" )
        report LF
            & "================ Test case 1 failed! ================" & LF
            & "received: " & to_hstring(smallest) & LF
            & "expected: " & to_hstring(X"01") & LF
            & "====================================================="
        severity error;

        
        bank_array <= (
            0 => X"17",
            1 => X"FF",
            2 => X"14",
            others => (others=>'0')
        );
        num_intervals <= to_unsigned(3,R_int_ctr);
        pattern_finished <= '1';
        wait for T;
        pattern_finished <= '0';
        wait for 60 ns;
        -- TEST CASE 2 --
        assert ( smallest = X"14" )
        report LF
            & "================ Test case 2 failed! ================" & LF
            & "received: " & to_hstring(smallest) & LF
            & "expected: " & to_hstring(X"14") & LF
            & "====================================================="
        severity error;

        -- end test
        assert false report LF & LF & "**** Test Completed ****" & LF severity failure;
    end process;

end tb_min_not_zero_arch;
