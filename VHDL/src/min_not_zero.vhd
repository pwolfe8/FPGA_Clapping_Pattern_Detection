--Engineer     : Vasundhara Rawat
--Date         : 11/08/2017
--Name of file : min_not_zero.vhd
--Description  : description
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity min_not_zero is
    generic (
        R_int			: positive;
        num_int         : positive
    );
    port (
        -- inputs --
        bank    : in std_logic_vector   ( R_int*num_int-1 downto 0);
        -- outputs --    
        min_val : out std_logic_vector  ( R_int downto 0)
    );
end min_not_zero;

architecture rtl of min_not_zero is
    -- constant definitions


    
    -- signal declarations
    

begin
    -- normal processes
recursive_structure : if size/2 > 0 generate 
    smallerEntity : entity component.myEntity(structural)
        generic map (
            size => size/2`
        );
        port map ( 
            ... 
        );
end generate recursive_structure; 

    
    -- component instantiations
    
    
end architecture;
