--Engineer     : Philip Wolfe
--Date         : 11/1/2017
--Name of file : pb_pattern_detector.vhd
--Description  : tests the system using a push button instead of clapping
--Testbench Instructions: use testbench end silence, tie btnC directly (no debounce)
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
    constant f_clk : real := 100.0e6;
    constant end_silence : real := 2.5;
    -- constant end_silence : real := 0.000000250; --25*T for testbench end_silence

    
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
        0 => (  -- pattern #1: simple pattern (1 interval)
            0 => (0=>X"10",1=>X"10"), -- target X"10" (there's only 1 interval)
            others => (others=>X"00")
        ),
        1 => ( -- pattern #2: 1x, 2x, 1x
            0 => (0=>X"0B",1=>X"15"), -- 1x is 0x10
            1 => (0=>X"1B",1=>X"25"), -- 2x is 0x20
            2 => (0=>X"0B",1=>X"15"), -- 1x is 0x10
            others => (others=>X"00")
        ),
        2 => ( -- pattern #3: some movie sound effect i don't know the name of
            0 => (0=>X"20",1=>X"40"), -- 3x is 0x30
            1 => (0=>X"0B",1=>X"15"), -- 1x is 0x10
            2 => (0=>X"1B",1=>X"25"), -- 2x is 0x20
            3 => (0=>X"1B",1=>X"25"), -- 2x
            others => (others=>X"00")
        ),
        -- 2 => ( -- pattern #4: galloping pattern (1x, 2x, 1x, 2x)
        --     0 => (0=>X"0B",1=>X"15"), -- 1x is 0x10
        --     1 => (0=>X"1B",1=>X"25"), -- 2x is 0x20
        --     2 => (0=>X"0B",1=>X"15"), -- 1x
        --     3 => (0=>X"1B",1=>X"25"), -- 2x
        --     others => (others=>X"00")
        -- ),
        3 => ( -- pattern #4: shave and a haircut beginning (https://en.wikipedia.org/wiki/Shave_and_a_Haircut)
            0 => (0=>X"1B",1=>X"25"), -- 2x is 0x20
            1 => (0=>X"0B",1=>X"15"), -- 1x is 0x10
            2 => (0=>X"0B",1=>X"15"), -- 1x
            3 => (0=>X"1B",1=>X"25"), -- 2x
            others => (others=>X"00")
        ),
        -- requires pattern length 8 --
    --    3 => ( -- pattern #2: shave and a haircut full (https://en.wikipedia.org/wiki/Shave_and_a_Haircut)
    --        0 => (0=>X"1B",1=>X"25"), -- 2x is 0x20
    --        1 => (0=>X"0B",1=>X"15"), -- 1x is 0x10
    --        2 => (0=>X"0B",1=>X"15"), -- 1x
    --        3 => (0=>X"1B",1=>X"25"), -- 2x
    --        4 => (0=>X"30",1=>X"50"), -- 4x
    --        5 => (0=>X"1B",1=>X"25"), -- 2x
    --        others => (others=>X"00")
    --    ),
        others => ( -- impossible to match other patterns
            0 => (0=>X"FF",1=>X"FF"), -- target X"10" (there's only 1 interval)
            others => (others=>X"00")
        )
    );

begin
    -- connect board to internal signals
    clk <= CLK100MHZ;
    reset <= btnL;

    -- -- translate btnC to a debounced clap_detected signal
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
    -- tie directly for testbench
    -- clap_detected <= btnC;

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
    display_state : entity work.sevenseg
        port map (
            -- inputs --
            clk => clk,
            reset => reset,-- left button resets
            patternIn => patterns_matched,
            state => state, -- this should change based on the center button
            -- debug signals
            int1 => interval_bank(0),
            num_intervals => num_intervals,
            min_done => min_done,
            norm_done => norm_done,
            check_pattern_done => check_pattern_done,
            -- ouputs --
            seg => sseg,
            an => an
    );

end pb_pattern_detector_arch;
