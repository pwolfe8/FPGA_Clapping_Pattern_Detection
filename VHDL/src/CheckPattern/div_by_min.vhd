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
    port (
        -- inputs --
        clk, reset  : in std_logic;
        bank_in     : in T_bank; -- bank of intervals
        num_int     : in unsigned(R_int_ctr-1 downto 0);
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
    signal result_buf : unsigned(R_int-1 downto 0);
    signal div_done_buf, prev_div_done_buf : std_logic; -- for communicating when to start next division
    signal bank_buf : T_bank;
    signal norm_done_buf : std_logic;
    signal bank_at_idx : unsigned(R_int-1 downto 0);

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
        variable idx : unsigned(R_int_ctr-1 downto 0) := (others=>'0'); -- index for bank_in
        
    begin
        -- output to debug signals --
        counter <= idx;

        if ( reset='1' ) then
            result_buf <= (others=>'0');
            bank_buf <= (others=>(others=>'0'));
            idx := (others=>'0');
            bank_at_idx <= (others=>'0');
            numerator <= (others=>'0');
            denominator <= (others=>'0');
            div_done_buf <= '0';
            prev_div_done_buf <= '0';
            norm_done_buf <= '0';
            start_div <= '0';
        elsif ( min_done='1' ) then
            result_buf <= (others=>'0');
            bank_buf <= (others=>(others=>'0'));
            idx := num_int;   -- reset index to number of intervals recorded
            if (idx>0) then
                bank_at_idx <= bank_in(to_integer(idx-1));
                numerator <= bank_at_idx;
                denominator <= min_val; -- minimum value (doesn't change)
                div_done_buf <= '1';  -- start the process
                norm_done_buf <= '0';
            else
                norm_done_buf <= '1';
                prev_div_done_buf <= '0';
                div_done_buf <= '1';
            end if;
            
        elsif ( div_done='1' ) then
            div_done_buf <= '1';
        elsif ( rising_edge(clk) ) then
            result_buf <= result;
            prev_div_done_buf <= div_done_buf;

            -- manage bank_at_idx
            if (idx>0) then
                bank_at_idx <= bank_in(to_integer(idx-1));
            end if;

            -- process div_done_buf
            if ( div_done_buf='1' ) then
                div_done_buf <= '0'; -- deassert
                bank_buf(to_integer(idx)) <= result_buf; -- store in bank_buf
                if ( idx > 0 ) then
                    idx := idx - 1; -- decrement idx
                    numerator <= bank_at_idx; -- get new numerator
                    start_div <= '1'; -- start divider
                    -- check if done
                    if (not(idx>0) ) then
                        norm_done_buf <= '1';
                    end if;
                else
                    norm_done_buf <= '1';
                end if;  
            end if;

            -- manage deassertion of start_div
            if (start_div='1') then
                start_div <= '0'; --deassert
            end if;

        end if;
    end process;

    
    -- manage norm_done signal
    process ( clk, reset ) begin
        if ( reset='1' ) then
            norm_done <= '0';
        elsif ( rising_edge(clk) ) then
            if ( norm_done_buf='1' and prev_div_done_buf='0' and div_done_buf='1') then
                norm_done <= '1';
            else
                norm_done <= '0';
            end if;
        end if;
    end process;

    -- bank output values is our current storage
    bank_out <= bank_buf;

end div_by_min_arch;
