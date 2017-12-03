--Engineer     : Philip Wolfe
--Date         : 12/1/2017
--Name of file : debouncer.vhd
--Description  : debounces a push button. specify how many ms stable time in generic param.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity debouncer is
    generic (
        f_clk_kHz     : positive := 100e3;  -- freq clk in kHz
        stable_time_ms : positive := 50     -- required stable time in ms
    );
    port (
        -- inputs --
        clk, reset  : in  std_logic;
        button_in   : in  std_logic;
        -- outputs --
        button_out  : out std_logic
    );
end debouncer;

architecture debouncer_arch of debouncer is
    -- constant definitions
    constant T_stable : positive := stable_time_ms*f_clk_kHz;                    -- clock cycles for stable time
    constant R : positive := integer(ceil(log2(real(T_stable)))) + 1;   -- resolution of counter (+1 bit for preloading counter)

    -- signal definitions
    signal counter : unsigned(R-1 downto 0);    -- counter
    signal prev_button, cur_button : std_logic; -- buffers for button
    signal button_change : std_logic;           -- for if the button value has changed

begin

    button_change <= cur_button xor prev_button;

    process ( clk, reset ) begin
        if ( reset='1' ) then
            counter <= (others=>'0');
            prev_button <= '0';
            cur_button <= '0';
            button_out <= '0';
        elsif ( rising_edge(clk) ) then
            -- latch button buffers
            cur_button <= button_in;
            prev_button <= cur_button;

            -- manage counter & output
            if ( button_change='1' ) then
                counter <= (others=>'0');
                button_out <= '0';
            elsif ( counter(R-1)='0' ) then
                counter <= counter + 1;
                button_out <= '0';
            else
                button_out <= prev_button; -- output whatever the stable value is
            end if;
            
        end if;
    end process;
    
end debouncer_arch;
