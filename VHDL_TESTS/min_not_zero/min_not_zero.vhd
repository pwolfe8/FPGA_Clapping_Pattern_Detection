--Engineer     : Philip Wolfe
--Date         : 11/18/2017
--Name of file : min_not_zero.vhd
--Description  : finds the minimum non-zero stored interval value from the interval bank
--Behavior     : checks the interval bank array backwards comparing current min with next value
-- delay is n+1 clk cycles, where n is the num_intervals recorded for the current pattern
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.TYPE_PACK.all;


entity min_not_zero is
    -- generic (
    --     R_int : positive;
    --     R_int_ctr : positive
    -- );
    port (
        -- inputs --
        clk              : in  std_logic;
        reset            : in  std_logic;
        pattern_finished : in  std_logic;
        num_intervals    : in  unsigned(R_int_ctr-1 downto 0);
        bank_array       : in  T_bank;
        -- outputs --
        min_done         : out std_logic;
        smallest    	 : out unsigned(R_int-1 downto 0)
    );
end min_not_zero;

architecture min_not_zero_arch of min_not_zero is

    -- signal declarations
    signal execute_process : std_logic; -- execute process when high
    signal prev_execute_process : std_logic;
    signal idx : unsigned(R_int_ctr-1 downto 0);
    signal bank_at_idx : unsigned(R_int-1 downto 0);
    signal compare_out : unsigned(R_int-1 downto 0);
    signal smallest_buf : unsigned(R_int-1 downto 0);
    
begin
    -- manage idx (indexing from 1, so 0 can be a signal of completion)
    -- on rising edge of pattern_finished reset idx & begin execute_process
    process ( clk, reset, pattern_finished ) begin
        if ( reset='1' ) then
            idx <= (others=>'0');
            execute_process <= '0';
            prev_execute_process <= '0';
        elsif ( pattern_finished = '1' ) then
            idx <= num_intervals;   -- reset index to prepare for calcs
            execute_process <= '1'; -- start the process
        elsif ( rising_edge(clk) ) then
            prev_execute_process <= execute_process;
            -- manage resetting idx
            if ( idx > 0 ) then
                idx <= idx - 1;
            else
                idx <= (others=>'0');
                execute_process <= '0'; -- stop the process
            end if;
        end if;
    end process;
    
    -- manage bank_at_idx at every clock cycle
    process ( clk, reset ) begin
        if ( reset='1' ) then
            bank_at_idx <= (others=>'0');
        elsif ( rising_edge(clk) ) then
            if ( idx=to_unsigned(0,R_int_ctr) ) then
                bank_at_idx <= (others=>'0');
            else
                bank_at_idx <= bank_array(to_integer(idx - 1)); -- translate to 0-indexed
            end if;
        end if;
    end process;

    -- instantiate min_compare2
    min_comp : entity work.min_compare2
        generic map (
            R_int   => R_int
        )
        port map (
            -- inputs -- 
            left    => bank_at_idx,
            right   => smallest_buf,
            -- outputs --
            out_min_val_2 => compare_out
        );

    -- min_compare2 feedback loop
    -- rising_edge of pattern_finished should reset
    smallest <= smallest_buf;
    process ( clk, reset, pattern_finished ) begin
        if ( reset='1' ) then
            smallest_buf <= (others=>'0');
        elsif ( pattern_finished = '1' ) then
            smallest_buf <= (others=>'0');
        elsif ( rising_edge(clk) ) then
                smallest_buf <= compare_out;
        end if;
    end process;

    -- manage valid bit "min_done" 
    process ( clk, reset ) begin
        if ( reset='1' ) then
            min_done <= '0';
        elsif ( rising_edge(clk) ) then
            if (prev_execute_process='1' and execute_process='0' ) then
                min_done <= '1'; -- high for a clock cycle when done
            else
                min_done <= '0';
            end if;
        end if;
    end process;
    
end min_not_zero_arch;
