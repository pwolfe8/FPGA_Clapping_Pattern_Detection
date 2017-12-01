--Engineer     : Will Sutton
--Date         : 11/20/2017
--Name of file : LED_shift_reg.vhd
--Description  : LED shift register
-- this should shift over an LED every time a clap is detected
-- still haven't decided what to do with an interval overflow...
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LED_shift_reg is
    port (
        -- inputs --
        reset            : in  std_logic;
        clap_detected    : in  std_logic; -- clap_detected
        pattern_finished : in  std_logic;
        -- outputs --
        leds		     : out std_logic_vector(15 downto 0)
    );
end LED_shift_reg;

architecture LED_shift_reg_arch of LED_shift_reg is

    signal buf : std_logic_vector(15 downto 0);

begin

    leds <= buf;

    process ( reset, clap_detected, pattern_finished ) begin
        if ( reset='1' or pattern_finished='1') then
            buf <= (others=>'0'); -- clear internal storage
        elsif ( clap_detected='1') then 
            buf <= "1" & buf(15 downto 1);
        end if;
    end process;
    
    
end LED_shift_reg_arch;
