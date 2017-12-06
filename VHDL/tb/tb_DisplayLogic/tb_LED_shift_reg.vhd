--Engineer     : Philip Wolfe
--Date         : 11/20/2017
--Name of file : tb_LED_shift_reg.vhd
--Description  : Test bench for LED_shift_reg.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_LED_shift_reg is
end tb_LED_shift_reg;

architecture tb_LED_shift_reg_arch of tb_LED_shift_reg is
    -- constant definitions
    constant T : time := 10 ns;
    
    -- testbench signal declarations
    signal clk, reset : std_logic;
    signal clap_detected, pattern_finished : std_logic;
    signal leds : std_logic_vector(15 downto 0);

begin
    -- instantiate design under test
    DUT : entity work.LED_shift_reg
        port map (
            -- inputs -- 
            clk=> clk,
            reset => reset,
            clap_detected => clap_detected,
            pattern_finished => pattern_finished,
            -- outputs -- 
            leds=>leds
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
        -- reset starts high and then goes low
        reset <= '1';
        clap_detected <= '0';
        pattern_finished <= '0';
        wait for T;
        reset <= '0';
        wait for T;

        -- clap --
        clap_detected <= '1';
        wait for 4*T;
        clap_detected <= '0';
        wait for T;
        -- wait for a while --
        wait for 3*T;

        -- clap --
        clap_detected <= '1'; 
        wait for T;
        clap_detected <= '0';
        wait for T;
        -- wait for a while --
        wait for 4*T;

        -- clap --
        clap_detected <= '1'; 
        wait for 2*T;
        clap_detected <= '0';
        wait for 5*T;
        -- wait for a while --
        wait for 3*T;

        -- flush --
        pattern_finished <= '1';
        wait for 3*T;
        pattern_finished <= '0';
        -- wait for 2*T;

        -- clap --
        clap_detected <= '1'; 
        wait for T;
        clap_detected <= '0';
        wait for T;
        -- wait for a while --
        wait for 3*T;

        -- clap --
        clap_detected <= '1'; 
        wait for 3*T;
        clap_detected <= '0';
        wait for T;
        -- wait for a while --
        wait for 2*T;


        -- end test
        assert false report LF & LF & "**** Test Completed ****" & LF severity failure;
    end process;

end tb_LED_shift_reg_arch;
