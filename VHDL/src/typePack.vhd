library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package TYPE_PACK is
    type patternBounds is array (0 to 7,0 to 1) of unsigned(15 downto 0);
    type recordedData  is array (0 to 7) of unsigned(15 downto 0);

end TYPE_PACK;