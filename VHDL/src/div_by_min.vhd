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
    signal numerator, denominator : unsigned(R_int-1 downto 0);
    signal result : unsigned(R_int-1 downto 0);
    signal start_div, div_done : std_logic;
    
    -- buffers
    signal start_div_buf, div_done_buf : std_logic; -- for communicating when to start next division
    signal bank_buf : T_bank;

    -- debug signals
    signal counter : unsigned(R_int_ctr-1 downto 0);


begin

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
            start => start_div,
            numerator => numerator,
            denominator => denominator,
            -- outputs --
            done => div_done,
            result => result
        );

    -- main process
    process ( clk, reset, min_done, div_done )
        signal idx : unsigned(R_int_ctr-1 downto 0);

    begin
        if ( reset='1' ) then
            idx := (others=>'0');
            numerator <= (others=>'0');
            denominator <= (others=>'0');
            div_done_buf <= '0';
        elsif ( min_done='1' ) then
            idx := to_unsigned(N_int,R_int);   -- reset index to prepare for divisions
            numerator <= bank_in(to_integer(idx));
            denominator <= min_val; -- minimum value (doesn't change)
            div_done_buf <= '1';  -- start the process
        elsif ( div_done='1' ) then
            div_done_buf <= '1';
        elsif ( rising_edge(clk) ) then
        -- output to debug signals --
            counter <= idx;
            
            -- process div_done_buf
            if ( div_done_buf='1' ) then
                div_done_buf <= '0'; -- deassert
                if ( idx > 0 ) then
                    bank_buf(to_integer(idx-1)) <= result; -- store in bank_buf
                    idx := idx - 1; -- decrement idx
                    numerator <= bank_in(to_integer(idx-1)); -- get new numerator
                    start_div_buf <= '1'; -- start divider
                end if; -- otherwise we've reached end of interval

                -- manage deassertion of start_div
                if (start_div_buf='1') then
                    start_div_buf <= '0'; --deassert
                    start_div <= '1';
                else
                    start_div <= '0'; -- deassert
                end if;

            end if;
        end if;
    end process;

    -- bank output values is our current storage
    bank_out <= bank_buf;

end div_by_min_arch;
