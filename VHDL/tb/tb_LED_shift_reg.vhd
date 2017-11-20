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
    signal clk : std_logic;

begin
    -- instantiate design under test
    DUT : entity work.LED_shift_reg
        generic map (
            
        )
        port map (
            
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
        
        -- implement some test cases
        
        -- end test
        assert false report LF & LF & "**** Test Completed ****" & LF severity failure;
    end process;

end tb_LED_shift_reg_arch;
