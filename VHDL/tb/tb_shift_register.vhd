--Engineer     : Philip Wolfe
--Date         : 11/15/2017
--Name of file : tb_shift_register.vhd
--Description  : Test bench for shift_register.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.TYPE_PACK.all;

entity tb_shift_register is
end tb_shift_register;

architecture tb_shift_register_arch of tb_shift_register is
    -- constant definitions
    constant R : positive := 8;
    constant Num : positive := 4;
    constant T : time := 10 ns;

    -- testbench signal declarations
    signal clk : std_logic;
    signal load, flush : std_logic;
    signal in_val : unsigned(R-1 downto 0);
    signal data_out : T_bank;


begin
    -- instantiate design under test
    DUT : entity work.shift_register
        generic map ( R=>R, Num=>Num )
        port map (
            -- inputs --
            clk     => clk,
            load	=> load,
            flush   => flush,
            in_val  => in_val,
            -- outputs --
            data_out => data_out
        );

    -- set up clock if you need it
    process begin
    	clk <= '1';
    	wait for T/2;
    	clk <= '0';
    	wait for T/2;
    end process;
    
    process begin
        -- initialize
        in_val <= (others=>'0');
        load <= '0';
        flush <= '1';
        wait for 5 ns;
        flush <= '0';
        wait for 5 ns;

        -- TEST CASE 1 --
        in_val <= X"DE";
        wait for 5 ns;
        load <= '1';
        wait for 20 ns; -- 2 clock cycles with in_val=0xDE
        load <= '0';
        wait for 20 ns;
        
        assert ( data_out=(0=>X"DE", 1=>X"DE", 2 to 3 => X"00") )
        report LF
            & "================ Test case 2 failed! ================" & LF
            & "got: " & to_hstring(data_out(0)) & to_hstring(data_out(1)) & to_hstring(data_out(2)) & to_hstring(data_out(3)) & LF
            & "expected: " & to_hstring(X"DEDE0000") & LF
            & "====================================================="
        -- & "\nexpected: " & T_bank'image((0=>X"DE", 1=>X"DE", 2 to 3 => X"FF"))
        severity error;
        
        in_val <= X"AD";
        load <= '1';
        wait for 20 ns;
        load <= '0';
        wait for 20 ns;

        flush <= '1';
        wait for 20 ns;

        
        -- end test
        assert false report LF & LF & "==== Test Completed ====" & LF severity failure;
    end process;

end tb_shift_register_arch;
