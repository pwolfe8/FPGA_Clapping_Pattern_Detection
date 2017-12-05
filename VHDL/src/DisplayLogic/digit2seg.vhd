--Engineer     : Philip Wolfe
--Date         : 12/4/2017
--Name of file : digit2seg.vhd
--Description  : translates a 4 bit unsigned digit sseg output code
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity digit2seg is
    port (
        -- inputs --
        digit   : in  unsigned(3 downto 0);
        -- outputs --
        seg_out : out std_logic_vector(6 downto 0)
    );
end digit2seg;

architecture digit2seg_arch of digit2seg is

begin

    -- Seven segment bit to segment mapping.
    -- 1 = segment off, 0 = segment on.
    --   ___ ___
    --  |	0   |
    --  5	    1
    --  |---6---|
    --  4       2
    --  |___3___|
    --
    with ( digit ) select
        seg_out <=
            "1000000" when X"0",
            "1111001" when X"1",
            "0100100" when X"2",
            "0110000" when X"3",
            "0011001" when X"4",
            "0010010" when X"5",
            "0000010" when X"6",
            "1111000" when X"7",
            "0000000" when X"8",
            "0011000" when X"9",
            "0001000" when X"A",
            "0000011" when X"B",
            "1000110" when X"C",
            "0100001" when X"D",
            "0000110" when X"E",
            "0001110" when X"F",
            "1111111" when others; -- should never reach this

end digit2seg_arch;
