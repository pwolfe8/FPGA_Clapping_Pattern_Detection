--Engineer     : Will Sutton and Philip Wolfe
--Date         : 11/22/2017
--Name of file : sevenseg.vhd
--Description  : This file controls our seven segment outputs. 
--Behavior     : see min_not_zero.vhd for "done" signaling logic
--  When min_done goes high for one clock cycle divide_by_min should latch in min_val and
--  turn on a signal to denote execution should happen. (and then go through and divide each entry)
--  once all the entries have been calculated, signal div_done for 1 clock cycle to
--  let pattern_compare know to start comparing.
--  don't forget to de-assert signals
--  
--  Be sure to manage all the signal assertion/de-assertion for a signal/relevant signals
--  in the SAME process statement unless you want multiple driver signal behavior ("XXXX")
--  to show up in your testbench.

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
        bank        : in T_bank; -- bank of intervals
        min_done    : in std_logic; -- start dividing when min_done goes from low to high
        min_val     : in unsigned(R_int-1 downto 0); -- minimum value result
        -- outputs --
        div_done    : out std_logic; -- flip high for one cycle when dividing is done
        bank_out    : out T_bank    -- output normalized data
    );
end div_by_min;

architecture div_by_min_arch of div_by_min is
    -- constant definitions
    
    -- signal declarations
    numerator : unsigned (R_int-1 downto 0);
    divisor : unsigned (R_int downto 0);
    quotient : std_logic_vector (R_int downto 0);

begin

        










    -- divisior <= unsigned(min_val);
	-- intervals: for i in 0 to num_int loop
	-- --Get each chunk of the bank that we care about to do operations on. 
	-- 	numerator <= unsigned(resize(bank(R_int+R_int*i-1 downto R_int*i),R_int+1));
    -- Divider : entity work.divider
    --     generic map (
    --         R_int => R_int
    --     )
    --     port map (
    --         -- inputs --
    --         start         start
    --         numerator   => numerator;
    --         divisor     => divisor;
    --         -- outputs --
    --         done		: out std_logic;
    --         result      : out unsigned(R_int-1 downto 0)
    --     );
	-- 	--Store the quotient result (no decimal precision WS 11-15-17) for output. 
	-- 	bank_out(R_int+R_int*1-1 downto R_int*i) <= quotient;


end div_by_min_arch;
