--Engineer     : Philip Wolfe
--Date         : 12/1/2017
--Name of file : tb_debouncer.vhd
--Description  : Test bench for debouncer.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_debouncer is
end tb_debouncer;

architecture tb_debouncer_arch of tb_debouncer is
    -- constant definitions
    constant T : time := 10 ns;
    
    -- testbench signal declarations
    signal clk, reset, button_in, button_out : std_logic;
    

begin
    -- instantiate design under test
    DUT : entity work.debouncer
        generic map (
            F_clk_kHz => 3,
            stable_time_ms => 2
        )
        port map (
            -- inputs --
            clk => clk,
            reset => reset,
            button_in => button_in,
            -- outputs --
            button_out => button_out
        );

    -- -- set up clock
    process begin
    	clk <= '1';
    	wait for T/2;
    	clk <= '0';
    	wait for T/2;
    end process;
    
    process begin
        -- initialize signals
        reset <= '1';
        button_in <= '0';
        wait for T;
        reset <= '0';
        wait for 12*T;
        button_in <= '1';
        wait for 2*T;
        button_in <= '0';
        wait for 3*T;
        button_in <= '1';
        wait for 25*T;
        button_in <= '0';
        wait for 10*T;
        
        -- end test
        assert false report LF & LF & "**** Test Completed ****" & LF severity failure;
    end process;

end tb_debouncer_arch;
