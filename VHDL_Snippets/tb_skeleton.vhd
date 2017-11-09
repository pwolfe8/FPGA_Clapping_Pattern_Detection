--Engineer     : Philip Wolfe
--Date         : MM/DD/2017
--Name of file : tb_skeleton.vhd
--Description  : Test bench for skeleton.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_skeleton is
end tb_skeleton;

architecture tb_skeleton_arch of skeleton is
    -- constant definitions
    
    -- testbench signal declarations
    

begin
    -- instantiate design under test
    DUT : entity work.skeleton
        generic map (
            
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
        
        -- TEST CASE 1 --
        _set_inputs_here_
        wait for 10 ns;
        assert ( _check_outputs_here_ )
        report "================Test case 1 failed! Look at the waveform to debug!================"
        severity error;
        


        -- end test
        assert false report "Test Completed" severity failure;
    end process

end tb_skeleton_arch;
