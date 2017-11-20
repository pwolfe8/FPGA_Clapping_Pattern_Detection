--Engineer     : Matt Arceri
--Date         : 11/19/2017
--Name of file : pattern_compare.vhd
--Description  : checks the interval bank against our stored patterns
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pattern_compare is
    generic (
        R_int  : positive;
        N_int  : positive;
        N_patt : positive
    );
    port (
        -- inputs --
        clk, reset          : in  std_logic;
        norm_done           : in  std_logic;
        norm_data           : in  T_bank;
        stored_patterns     : in  T_bounds;
        -- outputs --
        check_pattern_done  : out std_logic;
        patterns_matched    : out std_logic_vector(N_patt-1 downto 0)
    );
end pattern_compare;

architecture pattern_compare_arch of pattern_compare is
    -- constant definitions
    
    -- signal declarations
    

begin
    -- normal processes
    
    -- component instantiations
    
    
end pattern_compare_arch;
