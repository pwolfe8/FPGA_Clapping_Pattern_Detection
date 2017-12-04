--Engineer     : Philip Wolfe
--Date         : 12/3/2017
--Name of file : tb_sevenseg.vhd
--Description  : Test bench for sevenseg.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.type_pack.all;

entity tb_sevenseg is
end tb_sevenseg;

architecture tb_sevenseg_arch of tb_sevenseg is
    -- constant definitions
    constant T : time := 10 ns;
    
    -- testbench signal declarations
    signal clk, reset : std_logic;
    signal min_done, norm_done, check_pattern_done : std_logic;
    signal patterns_matched : std_logic_vector(N_patt-1 downto 0);
    signal state : T_state;
    signal sseg : std_logic_vector(6 downto 0);
    signal an : std_logic_vector(3 downto 0);
    signal int1 : unsigned(7 downto 0);

begin
    -- instantiate design under test
    DUT : entity work.sevenseg
        port map (
            -- inputs --
            clk => clk,
            reset => reset,
            patternIn => patterns_matched,
            state => state,
            -- debug signals -- 
            int1 => int1,
            min_done => min_done,
            norm_done => norm_done,
            check_pattern_done => check_pattern_done,
            -- outputs --
            seg => sseg,
            an => an
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
        patterns_matched <= "0010";
        state <= CHECKING_PATTERN;
        int1 <= X"69";
        min_done <= '0';
        norm_done <= '0';
        check_pattern_done <= '0';
        wait for T;
        reset <= '0';
        wait for T;

        min_done <= '1';
        wait for T;
        min_done <= '0'; 
        wait for 3*T;

        norm_done <= '1';
        wait for T;
        norm_done <= '0';
        wait for 3*T;

        check_pattern_done <= '1';
        wait for T;
        check_pattern_done <= '0';
        wait for 3*T;

        wait for 2*T;

        -- end test
        assert false report LF & LF & "**** Test Completed ****" & LF severity failure;
    end process;

end tb_sevenseg_arch;
