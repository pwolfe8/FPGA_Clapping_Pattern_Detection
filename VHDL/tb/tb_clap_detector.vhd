--Engineer     : Philip Wolfe
--Date         : 11/20/2017
--Name of file : tb_clap_detector.vhd
--Description  : Test bench for clap_detector.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_clap_detector is
end tb_clap_detector;

architecture tb_clap_detector_arch of tb_clap_detector is
    -- constant definitions
    constant T : time := 10 ns;
    
    -- testbench signal declarations
    

begin
    -- instantiate design under test
    DUT : entity work.clap_detector
        generic map (
            
        )
        port map (
            
        );

    -- -- set up clock
    -- process begin
    -- 	clk <= '1';
    -- 	wait for T/2;
    -- 	clk <= '0';
    -- 	wait for T/2;
    -- end process;
    
    process begin
        -- initialize signals
        
        -- implement some test cases
        
        -- end test
        assert false report LF & LF & "**** Test Completed ****" & LF severity failure;
    end process;

end tb_clap_detector_arch;
