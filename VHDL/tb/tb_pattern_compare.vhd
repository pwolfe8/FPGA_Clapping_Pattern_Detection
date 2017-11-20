--Engineer     : Matt Arceri
--Date         : 11/19/2017
--Name of file : tb_pattern_compare.vhd
--Description  : Test bench for pattern_compare.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.TYPE_PACK.all;

entity tb_pattern_compare is
end tb_pattern_compare;

architecture tb_pattern_compare_arch of tb_pattern_compare is
    -- constant definitions
    constant T : time := 10 ns;
    
    -- testbench signal declarations
        -- inputs --
    signal clk, reset : std_logic;
    signal norm_done : std_logic;
    signal norm_data : T_bank;
    signal stored_patterns : T_stored;
        -- outputs --
    check_pattern_done : std_logic;
    patterns_matched : std_logic_vector(N_patt-1 downto 0);
    
begin
    -- instantiate design under test
    DUT : entity work.pattern_compare
        generic map (
            R_int=>R_int,
            N_int=>N_int,
            N_patt=>N_patt
        )
        port map (
            -- inputs --
            clk                 => clk, 
            reset               => reset,
            norm_done           => norm_done,
            norm_data           => norm_data,
            stored_patterns     => stored_patterns,
            -- outputs --
            check_pattern_done  => check_pattern_done,
            patterns_matched    => patterns_matched
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
        norm_done <= '0';
        norm_data <= (
            0 => X"02",
            1 => X"01",
            2 => X"04",
            others => (others=>'0')
        );
        stored_patterns <= (
            0 =>(   -- bullshit pattern --
                0 => (0=>X"69",1=>X"69"),
                1 => (0=>X"69",1=>X"69"),
                2 => (0=>X"96",1=>X"96"),
                3 => (0=>X"00",1=>X"00")
            ),
            1 => (   -- actual matching pattern --
                0 => (0=>X"01",1=>X"03"),
                1 => (0=>X"00",1=>X"02"),
                2 => (0=>X"03",1=>X"05"),
                3 => (0=>X"00",1=>X"00")
            ),
            2 => (   -- matches one --
                0 => (0=>X"01",1=>X"03"),
                1 => (0=>X"00",1=>X"00"),
                2 => (0=>X"00",1=>X"00"),
                3 => (0=>X"00",1=>X"00")
            ),
            3 => (   -- matches 2
                0 => (0=>X"01",1=>X"03"),
                1 => (0=>X"00",1=>X"02"),
                2 => (0=>X"00",1=>X"00"),
                3 => (0=>X"00",1=>X"00")
            )
        );
        wait for 10 ns;

        reset <= '0';
        wait for 10 ns;
        -- pulse high 1 clock cycle
        norm_done <= '1';
        wait for T;
        norm_done <= '0';

        wait for 6*T;

        -- TEST CASE 1 --
        assert ( _some_boolean_checking_output_ )
        report LF
            & "================ Test case 1 failed! ================" & LF
            & "received: " & std_logic'image(patterns_matched) & LF
            & "expected: \"0100\"" & LF
            & "====================================================="
        severity error;
        
        
        -- end test
        assert false report LF & LF & "**** Test Completed ****" & LF severity failure;
    end process;

end tb_pattern_compare_arch;
