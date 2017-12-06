--Engineer     : Philip Wolfe
--Date         : 11/19/2017
--Name of file : tb_div_by_min.vhd
--Description  : Test bench for div_by_min.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.TYPE_PACK.all;


entity tb_div_by_min is
end tb_div_by_min;

architecture tb_div_by_min_arch of tb_div_by_min is
    -- constant definitions
    constant T : time := 10 ns;
    
    -- testbench signal declarations
    signal clk, reset : std_logic;
        -- inputs --
    signal bank_in : T_bank;
    signal num_int : unsigned(R_int_ctr-1 downto 0);
    signal min_done : std_logic;
    signal min_val : unsigned(R_int-1 downto 0);
        -- outputs --
    signal norm_done : std_logic;
    signal bank_out : T_bank;

begin
    -- instantiate design under test
    DUT : entity work.div_by_min
        port map (
            -- inputs --
            clk         => clk,
            reset       => reset,
            bank_in     => bank_in,
            num_int     => num_int,
            min_done    => min_done,
            min_val     => min_val,
            -- outputs --
            norm_done   => norm_done,
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
        bank_in <= (
            0 => X"04", -- after div should be 16 or X"10"
            1 => X"06", -- after div should be 24 or X"18"
            2 => X"08", -- after div should be 32 or X"20"
            others => (others=>'0')
        );
        num_int <= X"3";
        min_val <= X"04";
        min_done <= '0';
        wait for T;
        reset <= '0';
        wait for 2*T;
        min_done <= '1';
        wait for T;
        min_done <= '0';
        wait for (N_int+1)*12*T; -- change this past however many clock cycles
                        -- you think division will take.
        
        -- TEST CASE 1 --      
        -- assert ( bank_out = X"01010200" )
        -- report LF
        --     & "================ Test case 1 failed! ================" & LF
        --     & "received: " & to_hstring(bank_out(0)) & to_hstring(bank_out(1)) & to_hstring(bank_out(2)) & to_hstring(bank_out(3)) & LF
        --     & "expected: " & to_hstring(X"01010200") & LF
        --     & "====================================================="
        -- severity error;
        

        bank_in <= (
            0 => X"23", -- after div should be 70 or X"46"
            1 => X"08", -- after div should be 16 or X"10"
            others => (others=>'0')
        );
        num_int <= X"2";
        min_val <= X"08";
        wait for T;
        min_done <='1';
        wait for T;
        min_done <= '0';
        wait for (N_int+1)*12*T;


        -- test no one clap
        bank_in <= (
            0 => X"00",
            others => (others=>'0')
        );
        num_int <= X"0";
        min_val <= X"00";
        wait for T;
        min_done <='1';
        wait for T;
        min_done <= '0';
        wait for (N_int+1)*12*T;

        
        -- end test
        assert false report LF & LF & "**** Test Completed ****" & LF severity failure;
    end process;

end tb_div_by_min_arch;
