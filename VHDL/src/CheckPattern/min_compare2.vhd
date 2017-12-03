--Engineer     : Vasundhara Rawat
--Date         : MM/DD/2017
--Name of file : min_not_zero.vhd
--Description  : description
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity min_compare2 is
    generic (
        R_int			: positive
    );

    port (
        -- inputs --
        left   : in unsigned( R_int-1 downto 0);
        right  : in unsigned( R_int-1 downto 0);

        -- outputs --    
        out_min_val_2 : out unsigned( R_int-1 downto 0)
    );
end min_compare2;

architecture rtl of min_compare2 is
    -- constant definitions
    
    -- signal declarations   

begin 
    process(left, right) begin
        if(left < right) then
            if (left /= to_unsigned(0,R_int)) then
                out_min_val_2 <= left;
            else
                out_min_val_2 <= right;
            end if;
        else
            if (right /= to_unsigned(0,R_int)) then
                out_min_val_2 <= right;
            else
                out_min_val_2 <= left;
            end if;
        end if;
    end process;   
end rtl;
