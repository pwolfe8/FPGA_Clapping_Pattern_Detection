--Engineer     : Philip Wolfe
--Date         : MM/DD/2017
--Name of file : tb_Top_Level_Detector.vhd
--Description  : Test bench for Top_Level_Detector.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Top_Level_Detector is
end tb_Top_Level_Detector;

architecture tb_Top_Level_Detector_arch of Top_Level_Detector is
    -- constant definitions
    constant adsf : positive := 16;
    
    -- testbench signal declarations
    

begin
    -- instantiate design under test
    DUT : entity work.Top_Level_Detector
        generic map (
            asdf=>asdf, fdsa=>17
        )
        port map (
            -- Paste entity's ports here. Connect signals in either form:
        --    "in1,in2,out1,out2"
        --    "portname1=>signal1, portname2=>signal2"
        );

    -- set up clock if you need it
    -- process begin
    -- 	clk <= '0';
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
        assert false report "Test Completed" severity failure;
    end process

end tb_Top_Level_Detector_arch;
