--Engineer     : Philip Wolfe
--Date         : 12/04/2017
--Name of file : TopLevel.vhd
--Description  : counts your claps instead of just detecting them
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.type_pack.all;

entity TopLevel is
    port (
        -- inputs --
        CLK100MHZ   : in  std_logic; -- 100MHz clock from Basys3
        vauxp6      : in  std_logic; -- pos output of mic
        vauxn6      : in  std_logic; -- neg terminal of mic (wire to GND)
        btnL        : in  std_logic; -- reset
        -- outputs --
        leds		: out std_logic_vector(15 downto 0);-- output leds
        sseg        : out std_logic_vector(6 downto 0); -- sseg output    
        an          : out std_logic_vector(3 downto 0)  -- sseg multiplexer
    );
end TopLevel;

architecture TopLevel_arch of TopLevel is
    -- Xilinx xadc IP component declaration
    COMPONENT xadc_mic
    PORT (
        di_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        daddr_in : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        den_in : IN STD_LOGIC;
        dwe_in : IN STD_LOGIC;
        drdy_out : OUT STD_LOGIC;
        do_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        dclk_in : IN STD_LOGIC;
        reset_in : IN STD_LOGIC;
        vp_in : IN STD_LOGIC;
        vn_in : IN STD_LOGIC;
        vauxp6 : IN STD_LOGIC;
        vauxn6 : IN STD_LOGIC;
        channel_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        eoc_out : OUT STD_LOGIC;
        alarm_out : OUT STD_LOGIC;
        eos_out : OUT STD_LOGIC;
        busy_out : OUT STD_LOGIC
    );
    END COMPONENT;

    -- constant definitions
    constant f_clk : real := 100.0e6;
    constant end_silence : real := 2.5;
    
    -- signal declarations
    signal clk, reset : std_logic;
    signal adc_data : std_logic_vector(15 downto 0); -- measured adc values

    -- pattern detection stuff
    signal check_pattern_done, pattern_finished : std_logic;
    signal bank_overflowed : std_logic;
    signal state : T_state := IDLE;
    signal interval_bank : T_bank;
    signal patterns_matched : std_logic_vector(3 downto 0);
    signal num_intervals : unsigned(R_int_ctr-1 downto 0);
    -- debug signals
    signal min_done, norm_done : std_logic;
    -- clap threshold stuff
    signal above_thresh_ctr : unsigned(23 downto 0);
    signal clap_ctr : unsigned(3 downto 0);
    signal clap_detected, prev_clap_detected: std_logic;
    -- leds signal
    signal flush_leds : std_logic;

    -- stored patterns (pattern length max = 4 for now)
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
        3 => ( -- pattern #4: shave and a haircut beginning (https://en.wikipedia.org/wiki/Shave_and_a_Haircut)
            0 => (0=>X"1B",1=>X"25"), -- 2x is 0x20
            1 => (0=>X"0B",1=>X"15"), -- 1x is 0x10
            2 => (0=>X"0B",1=>X"15"), -- 1x
            3 => (0=>X"1B",1=>X"25"), -- 2x
            others => (others=>X"00")
        ),
        others => ( -- impossible to match other patterns
            0 => (0=>X"FF",1=>X"FF"), -- target X"10" (there's only 1 interval)
            others => (others=>X"00")
        )
    );


begin
    -- tie external interface to internal signals
    clk <= CLK100MHZ;
    reset <= btnL;

    -- xadc instantiation
    xadc_inst : xadc_mic
    port map (
        -- don't enable reset for adc
        reset_in => '0',
        -- auxiliary analog input p&n
        vauxp6 => vauxp6,
        vauxn6 => vauxn6,
        -- dedicated analog input p&n
        vp_in => '0',
        vn_in => '0',
        -- Dynamic Reconfiguration Port stuff
        daddr_in    => "0010110",  -- read ch6
        dclk_in     => clk,
        den_in      => '1',
        di_in       => (others => '0'),
        dwe_in      => '0',
        do_out      => adc_data,
        drdy_out    => open 
        -- leave the rest open too
    );

    -- looking for 15ms worth of claps out of 20 ms?
    -- clock counter 20 ms
    process ( clk, reset )
        variable clk_counter : unsigned(23 downto 0);
        variable begin_counting : std_logic;
        variable clap_thresh : std_logic_vector(5 downto 0) := "100011";
    begin
        if ( reset='1' ) then
            clk_counter := (others=>'0');
            begin_counting := '0';
        elsif ( rising_edge(clk) ) then
            -- look for first sound above threshold before starting 20ms sample
            if ( begin_counting='1' ) then
                if( clk_counter(23)='0' ) then -- under 80ms -- change back to 21 if neede
                    clk_counter := clk_counter + 1;
                    if ( adc_data(15 downto 10) > clap_thresh ) then
                        above_thresh_ctr <= above_thresh_ctr + 1;
                    end if;
                else
                    begin_counting := '0';
                    above_thresh_ctr <= (others=>'0');
                    clk_counter := (others=>'0');
                end if;
            elsif ( adc_data(15 downto 10) > clap_thresh ) then
                begin_counting := '1';
            end if;
                
        end if;
    end process;
    -- clap detection (based on if above_thresh_ctr > detection_thresh)
    -- need to ignore other claps if tripped for 5-10ms
    process ( clk, reset )
        variable ignore_ctr : unsigned(24 downto 0);
        variable begin_ignore : std_logic;
    begin
        if ( reset='1' ) then
            clap_detected <= '0';
            begin_ignore := '0';
            ignore_ctr := (others=>'0');
        elsif ( rising_edge(clk) ) then
            if ( begin_ignore='1' ) then
                if ( ignore_ctr(24)='0' ) then -- under 160ms
                    ignore_ctr := ignore_ctr + 1;
                else
                    clap_detected <= '0';
                    begin_ignore := '0';
                    ignore_ctr := (others=>'0');
                end if;
            elsif ( above_thresh_ctr(23 downto 17) > "0000001" ) then -- check if more than 5ms in that 20 ms period
                clap_detected <= '1';
                begin_ignore := '1';
            end if;
            prev_clap_detected <= clap_detected;
        end if;
    end process;

    -- -- count the claps too here
    -- process ( clk, reset ) begin
    --     if ( reset='1' ) then
    --         clap_ctr <= (others=>'0');
    --     elsif ( rising_edge(clk) ) then
    --         if ( prev_clap_detected='0' and clap_detected='1' ) then
    --             clap_ctr <= clap_ctr + 1;
    --         end if;
    --     end if;
    -- end process;
    -- an <= "1110"; -- only write to the sseg0
    -- trans_clap_ctr : entity work.digit2seg
    -- port map (
    --     digit => clap_ctr,
    --     seg_out => sseg
    -- );

    process ( reset, pattern_finished ) begin
        if ( reset='1' ) then
            flush_leds <= '0';
        elsif (pattern_finished='1')  then
            flush_leds <= '1';
        else
            flush_leds <= '0';
        end if;
        -- elsif ( rising_edge(clk) ) then
        --     if ( =IDLE ) then
        --         flush_leds <= '1';
        --     else
        --         flush_leds <= '0';
        --     end if;
        -- end if;
    end process;

    -- led shiftregister buffer
    LED_buffer : entity work.LED_shift_reg
    port map (
        -- inputs --
        clk => clk,
        reset => reset,
        clap_detected => clap_detected,
        pattern_finished => flush_leds,
        -- outputs -- 
        leds=>leds
    );

-- feed clap_detected into rest of system

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

    
end TopLevel_arch;
