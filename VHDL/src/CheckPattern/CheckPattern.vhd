--Engineer     : Philip Wolfe
--Date         : 11/29/2017
--Name of file : CheckPattern.vhd
--Description  : Top level file for checking if a recorded pattern matches any stored patterns.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.type_pack.all;

entity CheckPattern is
    port (
        -- inputs --
        clk, reset          : in  std_logic;
        pattern_finished    : in  std_logic;
        interval_bank       : in  T_bank;
        num_intervals       : in  unsigned(R_int_ctr-1 downto 0);
        stored_patterns     : in  T_stored;
        -- outputs --
        min_done_out, norm_done_out : out std_logic; -- debug signals
        check_pattern_done  : out std_logic;
        patterns_matched    : out std_logic_vector(N_patt-1 downto 0)
    );
end CheckPattern;

architecture CheckPattern_arch of CheckPattern is
    -- constant definitions
    
    -- signal declarations
    signal min_done, norm_done : std_logic;
    signal smallest : unsigned(R_int-1 downto 0);
    signal norm_data : T_bank;

begin
    -- debug signals
    min_done_out <= min_done;
    norm_done_out <= norm_done;

    -- find smallest nonzero interval value
    Min : entity work.min_not_zero
    port map (
        -- inputs --
        clk                 => clk,
        reset               => reset,
        pattern_finished    => pattern_finished,
        bank_array          => interval_bank,
        num_intervals       => num_intervals,
        -- outputs --
        min_done            => min_done,
        smallest    	    => smallest
    );

    -- normalize interval bank by dividing by smallest nonzero interval value
    Norm : entity work.div_by_min
        port map (
            -- inputs --
            clk             => clk,
            reset           => reset,
            bank_in         => interval_bank,
            num_int         => num_intervals,
            min_done        => min_done,
            min_val         => smallest,
            -- outputs --
            norm_done       => norm_done,
            bank_out        => norm_data
        );

    -- compare to stored patterns 
    Compare : entity work.pattern_compare
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
    
    
end CheckPattern_arch;
