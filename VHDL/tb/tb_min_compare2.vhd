--Engineer     : Vasundhara Rawat
--Date         : 11/08/2017
--Name of file : tb_min_compare2.vhd
--Description  : Test bench for min_compare2.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_min_compare2 is
end tb_min_compare2;

architecture tb_min_compare2_arch of tb_min_compare2 is
    -- constant definitions
    constant R_int : positive := 8;

    -- testbench signal declarations
    signal left : std_logic_vector ( R_int-1 downto 0);
    signal right : std_logic_vector ( R_int-1 downto 0);
    signal out_min_val_2 : std_logic_vector  ( R_int-1 downto 0);

begin
    -- instantiate design under test
    DUT : entity work.min_compare2
        generic map (
            R_int => R_int
        )
        port map (
            -- inputs -- 
            left            => left,
            right           => right,
            -- outputs --    
            out_min_val_2   => out_min_val_2
        );
    
    process begin
        -- initialize signals
        left <= (others=>'0');
        right <= std_logic_vector(to_unsigned(4,R_int) );
        wait for 10 ns;

        -- TEST CASE 1 --
        assert ( out_min_val_2 = right )
        report "================Test case 1 failed! Look at the waveform to debug!================"
        severity error;
        
        -- end test
        assert false report LF & "**** Test Completed ****" & LF severity failure;
    end process;

end tb_min_compare2_arch;
