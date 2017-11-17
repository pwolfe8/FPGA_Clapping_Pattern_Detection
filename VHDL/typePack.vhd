library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package TYPE_PACK is
    -- resolution of an interval 
    constant R_int : positive := 8;
    -- number of intervals in a bank
    constant Num_int : positive := 4;
    -- bank type
    type T_bank is array(0 to Num_int-1) of unsigned(R_int-1 downto 0);

    -- matt's types. we should merge these eventually
    type patternBounds is array (0 to 7,0 to 1) of unsigned(15 downto 0);
    type recordedData  is array (0 to 7) of unsigned(15 downto 0);

end TYPE_PACK;
