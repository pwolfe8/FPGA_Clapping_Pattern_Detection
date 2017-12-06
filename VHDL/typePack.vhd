library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package type_pack is
    -- global constants
    constant R_int : positive := 8;     -- resolution of an interval
    constant N_dec : positive := 4;     -- fixed point resolution for normalization (16ths)
    
    constant N_int : positive := 4;     -- number of intervals in a bank
    constant R_int_ctr : positive := 4; -- ceil(log2(N_int))+1 resolution of interval counter
    
    constant N_patt : positive := 4;    -- number of stored patterns
    constant R_patt_ctr : positive := 3;-- ceil(log2(N_patt+1))
    constant R_adc : positive := 12;
    
    -- global subtypes
    subtype T_int is unsigned(R_int-1 downto 0); -- type for an time interval between claps

    -- global types
    type T_bank is array(0 to N_int-1) of T_int; -- type for interval bank
    type T_bounds is array(0 to N_int-1, 0 to 1) of T_int; -- type for boundaries
    type T_stored is array (0 to N_patt-1) of T_bounds; -- type for stored patterns (stores multiple bounds)
    type T_state is (IDLE, WAIT_FOR_NEXT_CLAP, LOG_INTERVAL, CHECKING_PATTERN);

end type_pack;
