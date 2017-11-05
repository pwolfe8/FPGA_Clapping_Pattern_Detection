--Engineer     : Philip Wolfe
--Date         : 11/5/2017
--Name of file : tb_fifo.vhd
--Description  : Test bench for fifo. Should be storing un-binned raw time intervals between claps.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fifo is
end tb_fifo;

architecture tb_fifo_arch of fifo is
    -- constant definitions
    constant bit_width : positive := 8;
    constant fifo_length : positive := 16;

    -- testbench signal declarations
    

begin
    -- instantiate design under test
    DUT : entity work.fifo
        generic map (
            bit_width=>bit_width,
            fifo_length=>fifo_length
        )
        port map (
            
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

end tb_fifo_arch;
