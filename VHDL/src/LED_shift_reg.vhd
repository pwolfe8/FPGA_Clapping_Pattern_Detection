--Engineer     : Philip Wolfe
--Date         : 11/20/2017
--Name of file : LED_shift_reg.vhd
--Description  : LED shift register
-- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LED_shift_reg is
    -- generic (
    --     _name_			: _type_
    -- );
    port (
        -- inputs --
        clap_detected   : in  std_logic;
        -- outputs --
        leds		    : out std_logic_vector(15 downto 0)
    );
end LED_shift_reg;

architecture LED_shift_reg_arch of LED_shift_reg is
    -- constant definitions
    
    -- signal declarations
    signal pattern_finished : std_logic;

begin
    -- normal processes
    
    -- component instantiations
    shift_reg : entity work.shift_register
        generic map (
            
        )
        port map (
            
        );
    
    
end LED_shift_reg_arch;
