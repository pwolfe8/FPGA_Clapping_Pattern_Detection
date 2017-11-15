--Engineer     : Philip Wolfe
--Date         : 11/15/2017
--Name of file : tb_shift_register.vhd
--Description  : Test bench for shift_register.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_shift_register is
end tb_shift_register;

architecture tb_shift_register_arch of shift_register is
    -- constant definitions
    constant R : positive := 8;
    constant Num : positive := 4;

    -- testbench signal declarations
    signal clk : std_logic;
    signal in_val : unsigned(R-1 downto 0);
    signal load, flush : std_logic;



begin
    -- instantiate design under test
    DUT : entity work.shift_register
        generic map (
            R   => 8, -- resolution of each entry
            Num => 4  -- number of entries in shift register    
        )
        port map (
            -- inputs --
            clk     => clk,
            load	=> load,
            flush   => flush,
            in_val  => in_value,
            -- outputs --
            data_out    : unsigned(R*Num-1 downto 0) -- all data in shift register    -- Paste entity's ports here. Connect signals in either form:
            --    "in1,in2,out1,out2"
            --    "portname1=>signal1, portname2=>signal2"
        );

    -- set up clock if you need it
    process begin
    	clk <= '0';
    	wait for T/2;
    	clk <= '0';
    	wait for T/2;
    end process;
    
    process begin
        -- initialize signals
        -- Paste entity's ports here. Connect signals in either form:
        --    "in1,in2,out1,out2"
        --    "portname1=>signal1, portname2=>signal2"
        -- implement some test cases
        
        -- end test
        assert false report "Test Completed" severity failure;
    end process

end tb_shift_register_arch;
