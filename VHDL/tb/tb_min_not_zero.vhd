--Engineer     : Philip Wolfe
--Date         : MM/DD/2017
--Name of file : tb_min_not_zero.vhd
--Description  : Test bench for _entity_being_tested_.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb__entity_being_tested_ is
end tb__entity_being_tested_;

architecture tb__entity_being_tested__arch of _entity_being_tested_ is
    -- constant definitions
    
    -- testbench signal declarations
    

begin
    -- instantiate design under test
    DUT : entity work._entity_being_tested_
        generic map (
            -- Paste entity's ports here. Connect signals in either form:
        --    "in1,in2,out1,out2"
        --    "portname1=>signal1, portname2=>signal2"
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
        
        -- implement some test cases
        
        -- end test
        assert false report "Test Completed" severity failure;
    end process

end tb__entity_being_tested__arch;
