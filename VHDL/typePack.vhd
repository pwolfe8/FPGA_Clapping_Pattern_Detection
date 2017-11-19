library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package TYPE_PACK is
    -- global constants
    constant R_int : positive := 8;     -- resolution of an interval
    constant N_int : positive := 4;     -- number of intervals in a bank
    constant R_int_ctr : positive := 4; -- ceil(log2(N_int)). resolution of interval counter
    constant matts_number_intervals : positive := 8;
    
    -- global interval array type (interval bank)
    type T_bank is array(0 to N_int-1) of unsigned(R_int-1 downto 0);

    -- matt's types. we should merge these eventually
    type patternBounds is array (0 to matts_number_intervals-1, 0 to 1) of unsigned(R_int-1 downto 0);
    type recordedData  is array (0 to matts_number_intervals-1) of unsigned(R_int-1 downto 0);

end TYPE_PACK;
