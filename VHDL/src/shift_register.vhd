--Engineer     : Philip Wolfe
--Date         : 11/15/2017
--Name of file : shift_register.vhd
--Description  : implements shift register for interval bank array
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.TYPE_PACK.all;

entity shift_register is
    generic (
        R   : positive := 8; -- resolution of each entry
        Num : positive := 4  -- number of entries in shift register
    );
    port (
        -- inputs --
        clk         : in  std_logic;
        load		: in  std_logic; -- shifts in the next value
        flush       : in  std_logic; -- flushes all inputs when strobed
        in_val      : in  unsigned(R-1 downto 0); -- value to be shifted in
        -- outputs --
        data_out    : out T_bank
        
    );
end shift_register;

architecture shift_register_arch of shift_register is

begin
    process ( clk, load, flush )
        variable temp : T_bank;
    begin
        if ( flush='1' ) then
            temp := (others=>(others=>'0')); -- clear internal storage
            data_out <= temp; -- clear output
        elsif ( rising_edge(clk) ) then
            if ( load='1' ) then
                temp := in_val & temp(0 to 2);
            end if;
            data_out <= temp;
        end if;
    end process;
    
end shift_register_arch;
