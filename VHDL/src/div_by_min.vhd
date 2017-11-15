--Engineer     : Philip Wolfe
--Date         : MM/DD/2017
--Name of file : sevenseg.vhd
--Description  : This file controls our seven segment outputs. 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity div_by_min is
    generic (
--        _name_			: _type_
	--Number of bits in the min value input
	        R_int			: positive;
	--Number of intervals
		num_int 		: positive

    );
    port (
        -- inputs --
	min_val : out std_logic_vector ( R_int downto 0)
        -- outputs --
    );
end div_by_min;

architecture div_by_min_arch of div_by_min is
    -- constant definitions
--    constant _name_ : _type_ := _value_;
    
    -- signal declarations
--    signal _name_ : _type_;



begin
   
end div_by_min_arch;
