--Engineer     : Philip Wolfe
--Date         : 11/20/2017
--Name of file : LED_shift_reg.vhd
--Description  : LED shift register
-- this should shift over an LED every time a clap is detected
-- still haven't decided what to do with an overflow...
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LED_shift_reg is
    -- generic (
    --     _name_			: _type_
    -- );
    port (
        -- inputs --
        clk, reset       : in  std_logic;
        clap_detected    : in  std_logic;
        pattern_finished : in  std_logic;
        -- outputs --
        leds		     : out std_logic_vector(15 downto 0)
    );
end LED_shift_reg;

architecture LED_shift_reg_arch of LED_shift_reg is
    -- constant definitions
        -- N = 16
        -- R = 1
    -- signal declarations
signal led_complete_buffer : std_logic := '0';

begin

    process ( clk, reset, clap_detected, pattern_finished )
        variable temp : std_logic_vector(15 downto 0);
    begin
        if ( reset='1') then
            temp := (others=>'0'); -- clear internal storage
            leds <= temp; -- clear output
	    led_complete_buffer <= '0';
        elsif (pattern_finished='1') then
	    led_complete_buffer <= '1';
        elsif ( rising_edge(clk) ) then
            if ( clap_detected='1') then 
		if (led_complete_buffer = '0') then
                    temp := "1" & temp(15 downto 1);
	        else
		    temp := (15=>'1',others=>'0');
		    led_complete_buffer <= '0';
		end if;
   	    end if;
		
            leds <= temp;
        end if;
    end process;
    
    
end LED_shift_reg_arch;
