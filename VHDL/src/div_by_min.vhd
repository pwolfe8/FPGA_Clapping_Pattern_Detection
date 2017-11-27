--Engineer     : Philip Wolfe
--Date         : 11/22/2017
--Name of file : sevenseg.vhd
--Description  : This file controls our seven segment outputs. 
--Behavior     : see min_not_zero.vhd for "done" signaling logic
--  When min_done goes high for one clock cycle divide_by_min should latch in min_val and
--  turn on a signal to denote execution should happen. (and then go through and divide each entry)
--  once all the entries have been calculated, signal div_done for 1 clock cycle to
--  let pattern_compare know to start comparing.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.TYPE_PACK.all;
-- globals for testbenches:
--  R_int = 8       -- resolution of intervals
--  N_int = 4       -- number of intervals
--  R_int_ctr = 4   -- resolution of interval counter

entity div_by_min is
    generic (
	--Number of bits in the min value input
        R_int   : positive;
	--Number of intervals
		N_int 	: positive
    );
    port (
        -- inputs --
        clk, reset  : in std_logic;
        bank_in     : in T_bank; -- bank of intervals
        min_done    : in std_logic; -- start dividing when min_done goes from low to high
        min_val     : in unsigned(R_int-1 downto 0); -- minimum value result
        -- outputs --
        norm_done   : out std_logic; -- flip high for one cycle when dividing is done
        bank_out    : out T_bank    -- output normalized data
    );
end div_by_min;

architecture div_by_min_arch of div_by_min is
    -- constant definitions

    -- signal declarations --
    -- divider signals
        -- input --
        signal start : std_logic;
        signal numerator, denominator : unsigned(R_int-1 downto 0);
        -- output --
        signal div_done : std_logic;
        signal result : unsigned(R_int-1 downto 0);

    signal idx : unsigned(R_int_ctr-1 downto 0);
    signal start_dividing, prev_start_dividing : std_logic;
    signal bank_out_buf : T_bank;

begin
    -- manage idx (indexing from 1, so 0 can be a signal of completion)
    -- manage denominator
    process ( clk, reset, min_done ) begin
        if ( reset='1' ) then
            idx <= (others=>'0');
            denominator <= (others=>'0');
        elsif ( min_done = '1' ) then
            idx <= num_intervals;   -- reset index to prepare for calcs
            denominator <= min_val; -- minimum value (doesn't change)
            start_dividing <= '1';  -- start the process
        elsif ( rising_edge(clk) ) then
            -- only decrement the idx if the divider has finished or start_dividing='1'
            if ( ready_for_next='1' ) then
                start_dividing <= '0'; --de-assert
                idx <= idx - 1; -- decrement idx
                
            end if;
        end if;
    end process;

    -- manage numerator at every clock cycle
    process ( clk, reset ) begin
        if ( reset='1' ) then
            numerator <= (others=>'0');
        elsif ( rising_edge(clk) ) then
            if ( idx=to_unsigned(0,R_int_ctr) ) then
                numerator <= (others=>'0');
            else
                numerator <= bank_in(to_integer(idx - 1)); -- translate to 0-indexed
            end if;
        end if;
    end process;

    -- manage storing the divided pattern result to the output normalized data bank
    process ( clk, reset ) begin
        if ( reset='1' ) then
            bank_out_buf <= (others=>(others=>'0'));
        elsif ( rising_edge(clk) ) then
            if ( ready_for_next='1' ) then 
                bank_out_buf(to_integer(idx-1)) <= result;
            end if;
        end if;
    end process;

    -- instantiate a divider. trigger by flipping start high for a clock cycle
    divider : entity work.divider
        generic map (
            R_int => R_int,
            R_ctr => 5, -- ceil(log2(R_int+N_dec)) + some
            N_dec => N_dec
        )
        port map (
            -- inputs --
            clk => clk,
            reset => reset,
            start => start,
            numerator => numerator,
            denominator => denominator,
            -- outputs --
            done => div_done,
            result => result
        );

    -- process for managing latching in the bank values

end div_by_min_arch;
