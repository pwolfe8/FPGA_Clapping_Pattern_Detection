--Engineer     : Philip Wolfe
--Date         : 11/30/2017
--Name of file : tb_clap_detector.vhd
--Description  : Test bench for clap_detector.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.TYPE_PACK.all;


entity tb_clap_detector is
end tb_clap_detector;

architecture tb_clap_detector_arch of tb_clap_detector is
    -- constant definitions
    constant T : time := 10 ns;
    
    -- testbench signal declarations
-- signal clk : std_logic;
    

begin
    -- instantiate design under test
    DUT : entity work.clap_detector
        generic map (
            R_int=>R_int,
            N_int=>N_int,
            N_patt=>N_patt,
            R_adc=>R_adc
        )
        port map (
            clk=>clk,
            reset=>reset,
            XADC=>last_val
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
        -- Paste entity's ports here. Connect signals in either form:
            --    "in1,in2,out1,out2"
            --    "portname1=>signal1, portname2=>signal2"
        -- implement some test cases
        
        -- end test
        assert false report LF & LF & "**** Test Completed ****" & LF severity failure;
    end process;

end tb_clap_detector_arch;
