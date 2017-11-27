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

begin
    -- -- manage the pattern_finished signal flushing stuff?
    -- process ( reset, clk ) begin
    --     if ( reset='1' ) then
     
    --     elsif ( rising_edge(clk) ) then
            
    --     end if;
    -- end process;

    process ( clk, reset, flush, load )
        variable temp : std_logic_vector(15 downto 0);
    begin
        if ( reset='1' or flush='1' ) then
            temp := (others=>'0'); -- clear internal storage
            leds <= temp; -- clear output
        elsif ( rising_edge(clk) ) then
            if ( load='1' ) then
                temp := in_val & temp(15 to 1);
            end if;
            data_out <= temp;
        end if;
    end process;
    
    
end LED_shift_reg_arch;
