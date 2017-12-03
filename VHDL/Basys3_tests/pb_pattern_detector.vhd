--Engineer     : Philip Wolfe
--Date         : 11/1/2017
--Name of file : pb_pattern_detector.vhd
--Description  : tests the system using a push button instead of clapping
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.type_pack.all;

entity pb_pattern_detector is
    port (
        -- inputs --
        CLK100MHZ   : in  std_logic;
        btnL        : in  std_logic; -- reset
        btnC        : in  std_logic; -- clap_detected
        -- outputs --
        leds		: out std_logic_vector(15 downto 0);
        sseg        : out std_logic_vector(6 downto 0);
        an          : out std_logic_vector(3 downto 0)
    );
end pb_pattern_detector;

architecture pb_pattern_detector_arch of pb_pattern_detector is
    -- constant definitions
    constant f_clk : real := real(100e6);
    constant end_silence : real := 2.5;
    
    -- signal declarations
    signal clk, reset : std_logic;
    signal check_pattern_done, pattern_finished, clap_detected : std_logic;
    signal bank_overflowed : std_logic;
    signal state : T_state := IDLE;
    signal interval_bank : T_bank;
    signal patterns_matched : std_logic_vector(3 downto 0);
    signal num_intervals : unsigned(R_int_ctr-1 downto 0);
    -- debug signals
    signal min_done, norm_done : std_logic;

    -- stored patterns 
    signal stored_patterns : T_stored :=
    (
        0 => (  -- simple pattern (1 interval)
            0 => (0=>X"10",1=>X"10"), -- target X"10" (there's only 1 interval)
            others => (others=>X"00")
        ),
        others => ( -- impossible
            0 => (0=>X"FF",1=>X"FF"), -- target X"10" (there's only 1 interval)
            others => (others=>X"00")
        )
        -- 1 => (  -- simple pattern length 4
        --     0 => (0=>X"17",1=>X"23"), -- target X"20" or 2x smallest
        --     1 => (0=>X"07",1=>X"13"), -- target X"20" or 2x smallest
        --     2 => (0=>X"07",1=>X"13"),-- target X"20" or 2x smallest
        --     others => (others=>X"00")
        -- ),
        -- 2 => (
        --     0 => (0=>X"16",1=>X"1A"),
        --     1 => (0=>X"10",1=>X"10"), -- the smallest val
        --     2 => (0=>X"2A",1=>X"2E"),
        --     3 => (0=>X"00",1=>X"00"),
        --     others => (others=>X"00")
        -- ),
        -- 3 => (
        --     0 => (0=>X"17",1=>X"19"),
        --     1 => (0=>X"00",1=>X"02"),
        --     2 => (0=>X"2B",1=>X"2D"),
        --     3 => (0=>X"00",1=>X"00"),
        --     others => (others=>X"00")
        -- )
    );

begin
    -- connect board to internal signals
    clk <= CLK100MHZ;
    reset <= btnL;

    -- translate btnC to a debounced clap_detected signal
    debouncer : entity work.debouncer
        generic map (
            F_clk_kHz       => 100e3, -- set to 5 for tb
            stable_time_ms  => 15 --set to 1 for tb
        )
        port map (
            -- inputs --
            clk                 => clk,
            reset               => reset,
            button_in           => btnC,
            -- outputs --
            button_out          => clap_detected
    );

    -- visualize claps
    led_shift_reg : entity work.led_shift_reg
        port map (
	        clk                 => clk,
            reset               => reset,
            clap_detected       => clap_detected,
            pattern_finished    => pattern_finished,
            leds                => leds
    );

    -- pump the claps into the clap_FSM
    FSM : entity work.clap_FSM
        generic map (
            f_clk               => f_clk,
            end_silence         => end_silence
        )
        port map (
            -- inputs --
            clk                 => clk,
            reset               => reset,
            clap_detected       => clap_detected,
            check_pattern_done  => check_pattern_done,
            -- outputs --
            pattern_finished    => pattern_finished,
            num_intervals       => num_intervals,
            state_output        => state,
            interval_bank_array => interval_bank,
            bank_overflowed     => bank_overflowed
    );    

    -- take the outputs of clap_FSM and check the pattern
    check : entity work.CheckPattern
        port map (
            -- inputs --
            clk                 => clk,
            reset               => reset,
            pattern_finished    => pattern_finished,
            interval_bank       => interval_bank,
            num_intervals       => num_intervals,
            stored_patterns     => stored_patterns,
            -- debug signals 
            min_done_out        => min_done,
            norm_done_out       => norm_done,
            -- outputs --
            check_pattern_done  => check_pattern_done,
            patterns_matched    => patterns_matched
    );

    -- sseg state visualizer
    an <= "1110"; -- write to sseg0
    display_state : entity work.sevenseg
        port map (
            -- inputs --
            rst => reset,-- left button resets
            patternIn => patterns_matched,
            state => state, -- this should change based on the center button
            -- debug signals
            min_done => min_done,
            norm_done => norm_done,
            check_pattern_done => check_pattern_done,
            -- ouputs --
            seg => sseg
    );

end pb_pattern_detector_arch;
