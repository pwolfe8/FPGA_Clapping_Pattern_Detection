--Engineer     : Matt Arceri
--Date         : 11/09/2017
--Name of file : tb_boundaryComp.vhd
--Description  : Test bench for boundaryComp.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.TYPE_PACK.all;

entity tb_boundaryComp is
end tb_boundaryComp;

architecture tb_boundaryComp_arch of tb_boundaryComp is
    --Assuming 16ths of the shortest is the standard unit
    signal  normalized_data : recordedData := (to_unsigned(20,16), to_unsigned(70,16), to_unsigned(16,16), to_unsigned(63,16), to_unsigned(18,16), to_unsigned(80,16), to_unsigned(45,16), to_unsigned(30,16));
    signal  pattern1 : patternBounds;

    --Example patterns 
       --((17, 67, 10, 60, 12, 76, 41, 80),(23, 78, 17, 66, 19, 82, 49, 95)),
        --((27, 12, 45, 20, 70, 80, 89, 29),(36, 20, 64, 34, 82, 95, 109, 35)),
        --((37, 46, 12, 18, 57, 72, 11, 40),(45, 50, 19, 23, 63, 80, 17, 48))
    signal  match : std_logic;
begin
    pattern1<= ((to_unsigned(17,16),to_unsigned(23,16)),(to_unsigned(67,16),to_unsigned(78,16)),(to_unsigned(10,16),to_unsigned(17,16)),(to_unsigned(60,16),to_unsigned(66,16)),(to_unsigned(12,16),to_unsigned(19,16)),(to_unsigned(76,16),to_unsigned(82,16)),(to_unsigned(41,16),to_unsigned(49,16)),(to_unsigned(80,16),to_unsigned(95,16)));

    DUT : entity work.boundaryComp
        generic map (
            N => 16,
            M => 8,
            L => 8
        )
        port map (
           r_bank => to_unsigned(16,16),
           normalized_data => normalized_data,
           pattern => pattern1,
           match => match
        );
    
    process begin
        wait for 10 ns;   
        assert ( match = '0')  report "================Test case 1 failed!================" severity error;  
        
        --Correct the recorded data
        normalized_data(7) <= to_unsigned(90,16);
        wait for 10 ns;
        assert ( match = '1' ) report "================Test case 2 failed!================" severity error; 

        --Corrupt the recorded data
        normalized_data(2) <= to_unsigned(57,16);
        wait for 10 ns;
        assert ( match = '0' ) report "================Test case 3 failed!================" severity error; 

        --Correct the recorded data
        normalized_data(2) <= to_unsigned(16,16);
        wait for 10 ns;
        assert ( match = '1' ) report "================Test case 4 failed!================" severity error; 

        -- end test
        assert false report "Test Completed" severity failure;
    end process;

end tb_boundaryComp_arch;
