--Engineer     : Vasundhara Rawat
--Date         : 11/08/2017
--Name of file : tb_min_compare2.vhd
--Description  : Test bench for min_compare2.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_min_compare2 is
end tb_min_compare2;

architecture tb_min_compare2_arch of min_compare2 is
    -- constant definitions
    constant R_int : positive := 8;

    -- testbench signal declarations
    signal left : std_logic_vector ( R_int downto 0);
    signal right: std_logic_vector ( R_int downto 0);
    signal out_min_val_2 : out std_logic_vector  ( R_int downto 0);

begin
    -- instantiate design under test
    DUT : entity work.min_compare2
        generic map (
            R_int			: positive
        )
        port map (
            left   : in std_logic_vector   ( R_int downto 0);
            right  : in std_logic_vector   ( R_int downto 0);
            -- outputs --    
            out_min_val_2 : out std_logic_vector  ( R_int downto 0)
        );
    
    process begin
        -- initialize signals
        left => 0;
        right => 4;
        
        -- implement some test cases
        -- TEST CASE 1 --
        _set_inputs_here_
        wait for 10 ns;
        assert ( out_min_val_2 = right )
        report "================Test case 1 failed! Look at the waveform to debug!================"
        severity error;        
        -- end test
        assert false report "Test Completed" severity failure;
    end process

end tb_min_compare2_arch;
