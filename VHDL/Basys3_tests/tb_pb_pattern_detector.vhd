--Engineer     : Philip Wolfe
--Date         : 12/5/2017
--Name of file : tb_pb_pattern_detector.vhd
--Description  : Test bench for pb_pattern_detector.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_pb_pattern_detector is
end tb_pb_pattern_detector;

architecture tb_pb_pattern_detector_arch of tb_pb_pattern_detector is
    -- constant definitions
    constant T : time := 10 ns;
    
    -- testbench signal declarations
    signal clk, reset, clap_detected : std_logic;
    signal leds : std_logic_vector(15 downto 0);
    signal sseg : std_logic_vector(6 downto 0);
    signal an : std_logic_vector(3 downto 0);

begin
    -- instantiate design under test
    DUT : entity work.pb_pattern_detector
        port map (
            CLK100MHZ => clk,
            btnL => reset,
            btnC => clap_detected,
            -- outputs --
            leds => leds,
            sseg => sseg,
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
        clap_detected <= '0';
        wait for T;
        reset <= '0';
        wait for T;
        -- start some tests
        
        -- clap 
        clap_detected <= '1';
        wait for 5*T;
        clap_detected <= '0';

        -- gap
        wait for 10*T;

        -- don't clap 
        clap_detected <= '0';
        wait for 5*T;
        clap_detected <= '0';

        -- end gap
        wait for 60*T;
        
        -- send another pattern
         -- clap 
        clap_detected <= '1';
        wait for 5*T;
        clap_detected <= '0';

        -- gap
        wait for 10*T;

        -- clap 
        clap_detected <= '1';
        wait for 3*T;
        clap_detected <= '0';

        -- end gap
        wait for 60*T;
        
        -- end test
        assert false report LF & LF & "**** Test Completed ****" & LF severity failure;
    end process;

end tb_pb_pattern_detector_arch;
