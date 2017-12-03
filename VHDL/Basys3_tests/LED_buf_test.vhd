--Engineer     : Philip Wolfe
--Date         : 11/30/2017
--Name of file : LED_buf_test.vhd
--Description  : test LED shift register on basys3
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LED_buf_test is
    port (
        -- inputs --
        CLK100MHZ   : in  std_logic;
        btnL        : in  std_logic; -- for reset
        btnC        : in  std_logic; -- for clap_detected
        btnR        : in  std_logic; -- for pattern_finished
        -- outputs --
        led		    : out std_logic_vector(15 downto 0)
    );
end LED_buf_test;

architecture LED_buf_test_arch of LED_buf_test is

    signal clk, reset, clap_detected, pattern_finished : std_logic;

begin
    -- connect board to internal signals
    clk <= CLK100MHZ;
    reset <= btnL;
    pattern_finished- <= btnR;

    debouncer : entity work.debouncer
        generic map (
            F_clk_kHz => 100e3, -- set to 5 for tb
            stable_time_ms => 15 --set to 1 for tb
        )
        port map (
            -- inputs --
            clk => clk,
            reset => reset,
            button_in => btnC,
            -- outputs --
            button_out => clap_detected
        );

    led_shift_reg : entity work.led_shift_reg
        port map (
	    clk=>clk,
            reset=>reset,
            clap_detected=>clap_detected,
            pattern_finished=>pattern_finished,
            leds=>led
        );
    
end LED_buf_test_arch;
