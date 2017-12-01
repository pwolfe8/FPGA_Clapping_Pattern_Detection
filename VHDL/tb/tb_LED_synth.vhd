--Engineer     : Philip Wolfe
--Date         : 11/30/2017
--Name of file : tb_LED_synth.vhd
--Description  : test LED shift register on basys3
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_LED_synth is
    port (
        -- inputs --
        clk         : in  std_logic;
        btnL        : in  std_logic; -- for reset
        sw0         : in  std_logic; -- for clap_detected
        btnR        : in  std_logic; -- for pattern_finished
        -- outputs --
        led		    : out std_logic_vector(15 downto 0)
    );
end tb_LED_synth;

architecture tb_LED_synth_arch of tb_LED_synth is

    signal reset, clap_detected, pattern_finished : std_logic;
    -- signal clap_detected_buf, pattern_finished_buf : std_logic_vector(3 downto 0);


begin
    reset <= btnL;

    -- clap_detected <= 
    --     '1' when clap_detected_buf="0011" else
    --     '0';
    -- pattern_finished <= 
    --     '1' when pattern_finished_buf="0011" else
    --     '0';

    process ( clk, reset ) begin
        if ( reset='1' ) then
            -- clap_detected_buf <= (others=>'0');
            -- pattern_finished_buf <= (others=>'0');
            clap_detected <= '0';
        elsif ( rising_edge(clk) ) then
            clap_detected <= sw0;
            pattern_finished <= btnR;
            -- clap_detected_buf <= btnC & clap_detected_buf(3 downto 1);
            -- pattern_finished_buf <= btnR & pattern_finished_buf(3 downto 1);
        end if;
    end process;


    led_shift_reg : entity work.led_shift_reg
        port map (
            reset=>reset,
            clap_detected=>clap_detected,
            pattern_finished=>pattern_finished,
            leds=>led
        );
    
end tb_LED_synth_arch;
