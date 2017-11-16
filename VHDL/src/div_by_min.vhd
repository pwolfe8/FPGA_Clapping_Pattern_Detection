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
        bank    : in std_logic_vector   ( R_int*num_int-1 downto 0);
	min_val : out std_logic_vector ( R_int downto 0)
        -- outputs --
        bank_out    : in std_logic_vector   ( R_int*num_int-1 downto 0);
    );
end div_by_min;

architecture div_by_min_arch of div_by_min is
    -- constant definitions
--    constant _name_ : _type_ := _value_;
    
    -- signal declarations
--    signal _name_ : _type_;
numerator : unsigned (R_int-1 downto 0);
divisor : unsigned (R_int downto 0);
quotient : std_logic_vector (R_int+4 downto 0);

begin
	divisior <= unsigned(min_val);
	intervals: for i in 0 to num_int loop
	--Get each chunk of the bank that we care about to do operations on. 
		numerator <= unsigned(resize(bank(R_int+R_int*i-1 downto R_int*i),R_int+1));
		for j in 0 to R_int loop
			quotient(R_int downto 1) := quotient(R_int-1 downto 0);
			quotient(0) := numerator(a'length-1);	
			numerator(R_int downto 1) := numerator(R_int-1 downto 0);
			quotient := quotient-divisor;
			if(quotient(R_int-1) ='1') then
				numerator(0) :='0';
				quotient := quotient+divisor;
			else
				numerator(0) :='1';	
			end if;
		end loop;
		
				

unsigned(temp_numerator)/unsigned(min_val)



end div_by_min_arch;
