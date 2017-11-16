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
    -- constant definitions
    
    -- signal declarations

    -- type declarations
    -- subtype T_interval  is unsigned(R-1 downto 0); -- put R here later
    -- type    T_bank is array(NATURAL range <>) of T_interval;
    -- type T_bank is array(Num-1 downto 0) of unsigned(R-1 downto 0);

    -- -- function definitions
    
    -- function to_slv(arr : T_bank) return unsigned is
    --     variable slv : unsigned((arr'length * 32) - 1 downto 0);
    -- begin
    --   for i in slvv'range loop
    --     slv((i * 32) + 31 downto (i * 32))      := slvv(i);
    --   end loop;
    --   return slv;
    -- end function;


begin
    process ( load, flush )
        variable temp : T_bank;
    begin
        if ( flush='1' ) then
            temp := (others=>(others=>'0'));
            data_out <= temp;
        elsif ( rising_edge(clk) ) then
            if ( load='1' ) then
                -- for i in 0 to Num-2 loop
                --     temp(i) := temp(i+1);
                -- end loop;
                -- temp(Num-1) := in_val;
                temp := temp(3) & temp(2) & in_val;
            end if;

            data_out <= temp;

        end if;
    end process;
    
end shift_register_arch;
