--Engineer     : Philip Wolfe
--Date         : 12/1/2017
--Name of file : tb_LED_buf_test.vhd
--Description  : Test bench for LED_buf_test.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_LED_buf_test is
end tb_LED_buf_test;

architecture tb_LED_buf_test_arch of tb_LED_buf_test is
    -- constant definitions
    constant T : time := 10 ns;
    
    -- testbench signal declarations
    signal clk, reset, button, pattern_finished : std_logic;
    signal leds : std_logic_vector(15 downto 0);
    

begin
    -- instantiate design under test
    DUT : entity work.LED_buf_test
        port map (
            CLK100MHz=>clk,
            btnL=>reset,
            btnc=>button,
            btnR=>pattern_finished,
            -- outputs -- 
            led => leds
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
        button <= '0';
        pattern_finished <= '0';
        wait for T;
        reset <= '0';
        wait for 11*T;

        -- do stuff with the button
        button <= '1';
        wait for T;
        button <= '0';
        wait for 2*T;
        button <= '1';
        wait for 11*T;
        button <='0';
        wait for 3*T;
        button <='1';
        wait for 5*T;
        button <= '0';
        wait for T;
        button <= '1';
        wait for 12*T;
        button <='0';
        wait for 12*T;


        -- end test
        assert false report LF & LF & "**** Test Completed ****" & LF severity failure;
    end process;

end tb_LED_buf_test_arch;
