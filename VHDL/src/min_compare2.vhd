--Engineer     : Vasundhara Rawat
--Date         : MM/DD/2017
--Name of file : min_not_zero.vhd
--Description  : description
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity min_val_2 is
    generic (
        R_int			: positive
    );

    port (
        -- inputs --
        left   : in std_logic_vector   ( R_int downto 0);
        right  : in std_logic_vector   ( R_int downto 0);

        -- outputs --    
        out_min_val_2 : out std_logic_vector  ( R_int downto 0)
    );
end min_val_2;

architecture rtl of min_val_2 is
    -- constant definitions   
    -- signal declarations   
process(left, right) 
begin
    -- normal processes
    if(left < right) and (left /= '0') then
        out_min_val_2 <= left;
    elsif (right /= (others =>'0') then
        out_min_val_2 <= right;
    else 
        out_min_val_2 <= (others => '0');
    end if;
end process;   
end architecture;
