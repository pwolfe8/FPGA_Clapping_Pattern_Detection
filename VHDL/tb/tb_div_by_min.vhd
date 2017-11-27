--Engineer     : Philip Wolfe
--Date         : 11/19/2017
--Name of file : tb_div_by_min.vhd
--Description  : Test bench for div_by_min.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_div_by_min is
end tb_div_by_min;

architecture tb_div_by_min_arch of tb_div_by_min is
    -- constant definitions
    constant T : time := 10 ns;
    
    -- testbench signal declarations
    signal clk, reset : std_logic;
        -- inputs --
    signal bank : T_bank;
    signal min_done : std_logic;
    signal min_val : unsigned(R_int-1 downto 0);
        -- outputs --
    signal div_done : std_logic;
    signal bank_out : T_bank;

begin
    -- instantiate design under test
    DUT : entity work.div_by_min
        generic map (
            R_int=>R_int,
            N_int=>N_int
        )
        port map (
            -- inputs --
            bank        => bank,
            min_done    => min_done,
            min_val     => min_val,
            -- outputs --
            div_done    => div_done,
            bank_out    => bank_out
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
        reset <= '1';
        bank <= (
            0 => X"04", -- after div should be 01
            1 => X"06", -- after div should be 01
            2 => X"08", -- after div should be 02
            others => (others=>'0')
        );
        min_done <= '0';
        wait for T;
        reset <= '0';
        wait for T;
        min_done <= '1';
        wait for 100 ns; -- change this past however many clock cycles
                        -- you think division will take.
        
        -- TEST CASE 1 --      
        assert ( bank_out = X"01010200" )
        report LF
            & "================ Test case 1 failed! ================" & LF
            & "received: " & to_hstring(bank_out(0)) & to_hstring(bank_out(1)) & to_hstring(bank_out(2)) & to_hstring(bank_out(3)) & LF
            & "expected: " & to_hstring(X"01010200") & LF
            & "====================================================="
        severity error;
        
        
        -- end test
        assert false report LF & LF & "**** Test Completed ****" & LF severity failure;
    end process;

end tb_div_by_min_arch;
