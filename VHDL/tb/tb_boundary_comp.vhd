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
    signal  normalized_data : recordedData;
    signal  pattern1 : patternBounds;

    --Example patterns 
       --((17, 67, 10, 60, 12, 76, 41, 80),(23, 78, 17, 66, 19, 82, 49, 95)),
        --((27, 12, 45, 20, 70, 80, 89, 29),(36, 20, 64, 34, 82, 95, 109, 35)),
        --((37, 46, 12, 18, 57, 72, 11, 40),(45, 50, 19, 23, 63, 80, 17, 48))
    signal  match : std_logic;
begin

    DUT : entity work.boundaryComp
        generic map (
            N => R_int,                     -- Data width (resolution of entries in interval bank)
            M => matts_number_intervals     -- number of intervals in bank
            -- L => 8              -- Pattern to check (not used?...)
        )
        port map (
        --    r_bank => to_unsigned(16,8), -- also not used. dammit matt
           normalized_data => normalized_data,
           pattern => pattern1,
           match => match --nice job labeling this as an output matt
        );
    
    process begin
        
        -- initialize signals
        pattern1 <= (
            (to_unsigned(17,R_int), to_unsigned(23,R_int)),
            (to_unsigned(67,R_int), to_unsigned(78,R_int)),
            (to_unsigned(10,R_int), to_unsigned(17,R_int)),
            (to_unsigned(60,R_int), to_unsigned(66,R_int)),
            (to_unsigned(12,R_int), to_unsigned(19,R_int)),
            (to_unsigned(76,R_int), to_unsigned(82,R_int)),
            (to_unsigned(41,R_int), to_unsigned(49,R_int)),
            (to_unsigned(80,R_int), to_unsigned(95,R_int))
        );
        normalized_data <= (
            to_unsigned(20,R_int),
            to_unsigned(70,R_int),
            to_unsigned(16,R_int),
            to_unsigned(63,R_int),
            to_unsigned(18,R_int),
            to_unsigned(80,R_int),
            to_unsigned(45,R_int),
            to_unsigned(30,R_int)
        );

        wait for 10 ns;   
        assert ( match = '0')  report "================Test case 1 failed!================" severity error;  
        
        --Correct the recorded data
        normalized_data(7) <= to_unsigned(90,R_int);
        wait for 10 ns;
        assert ( match = '1' ) report "================Test case 2 failed!================" severity error; 

        --Corrupt the recorded data
        normalized_data(2) <= to_unsigned(57,R_int);
        wait for 10 ns;
        assert ( match = '0' ) report "================Test case 3 failed!================" severity error; 

        --Correct the recorded data
        normalized_data(2) <= to_unsigned(16,R_int);
        wait for 10 ns;
        assert ( match = '1' ) report "================Test case 4 failed!================" severity error; 

        -- end test
        assert false report LF & "**** Test Completed ****" & LF severity failure;
    end process;

end tb_boundaryComp_arch;
