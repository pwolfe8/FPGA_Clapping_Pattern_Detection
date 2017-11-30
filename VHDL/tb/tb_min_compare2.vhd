--Engineer     : Philip Wolfe
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
    signal left : unsigned ( R_int-1 downto 0);
    signal right : unsigned ( R_int-1 downto 0);
    signal out_min_val_2 : unsigned ( R_int-1 downto 0);

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
        right <= (others=>'0');
        wait for 10 ns;
        -- TEST CASE 1 --
        assert ( out_min_val_2 = X"00" )
        report LF
            & "================ Test case 1 failed! ================" & LF
            & "received: " & to_hstring(out_min_val_2) & LF
            & "expected: " & to_hstring(X"00") & LF
            & "====================================================="
        severity error;

        -- TEST CASE 2 --
        left <= (others=>'0');
        right <= to_unsigned(4,R_int);
        wait for 10 ns;
        assert ( out_min_val_2 = right )
        report LF
            & "================ Test case 2 failed! ================" & LF
            & "received: " & to_hstring(out_min_val_2) & LF
            & "expected: " & to_hstring(X"04") & LF
            & "====================================================="
        severity error;
        
        
        -- TEST CASE 3 --
        left <= to_unsigned(8,R_int);
        right <= (others=>'0');
        wait for 10 ns;
        assert ( out_min_val_2 = X"00" )
        report LF
            & "================ Test case 3 failed! ================" & LF
            & "received: " & to_hstring(out_min_val_2) & LF
            & "expected: " & to_hstring(X"00") & LF
            & "====================================================="
        severity error;
        
        -- TEST CASE 4 --
        left <= to_unsigned(7,R_int);
        right <= to_unsigned(13,R_int);
        wait for 10 ns;
        assert ( out_min_val_2 = X"07" )
        report LF
            & "================ Test case 4 failed! ================" & LF
            & "received: " & to_hstring(out_min_val_2) & LF
            & "expected: " & to_hstring(X"07") & LF
            & "====================================================="
        severity error;
        
        -- TEST CASE 5 --
        left <= to_unsigned(13,R_int);
        right <= to_unsigned(7,R_int);
        wait for 10 ns;
        assert ( out_min_val_2 = X"07" )
        report LF
            & "================ Test case 5 failed! ================" & LF
            & "received: " & to_hstring(out_min_val_2) & LF
            & "expected: " & to_hstring(X"07") & LF
            & "====================================================="
        severity error;


        -- end test
        assert false report LF & "**** Test Completed ****" & LF severity failure;
    end process;

end tb_min_compare2_arch;
