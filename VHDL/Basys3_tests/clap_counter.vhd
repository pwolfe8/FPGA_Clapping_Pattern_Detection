--Engineer     : Philip Wolfe
--Date         : 12/04/2017
--Name of file : clap_counter.vhd
--Description  : counts your claps
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clap_counter is
    port (
        -- inputs --
        CLK100MHZ   : in  std_logic;
        vauxp6      : in  std_logic;
        vauxn6      : in  std_logic;
        btnL        : in  std_logic; -- map to reset
        -- outputs --
        leds		    : out std_logic_vector(15 downto 0)
    );
end clap_counter;

architecture clap_counter_arch of clap_counter is
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
    
    -- signal declarations
    signal clk, reset : std_logic;
    signal clap_detected : std_logic;
    signal clk_counter : unsigned(27 downto 0);
    signal above_threshold, start_holding : std_logic;
    signal adc_data : std_logic_vector(15 downto 0); -- measured adc values

    -- buffer
    signal led_buf : std_logic_vector(15 downto 0);

    -- constants
    constant R_adc : positive := 16;

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


    -- check if above threshold
    process (clk, reset ) begin
        if ( reset='1' ) then
            above_threshold <= '0';
        elsif( rising_edge(clk) ) then
            if (adc_data > X"C000") then
                above_threshold <= '1';
            else
                above_threshold <= '0';
            end if;
        end if;
    end process;

    -- -- low pass filter that shit or something
    -- ClapDetector : entity work.clap_detector
    -- generic map ( R_adc=>R_adc )
    -- port map (
    --     -- inputs --
    --     clk => clk,
    --     reset => reset,
    --     XADC => unsigned(adc_data),
    --     -- outputs --
    --     clap_detected => clap_detected
    -- );
    
    -- led visuals ( hold led(0) high for 1 sec after detection )
    leds(0) <= start_holding;
    process ( clk, reset ) begin
        if ( reset='1' ) then
            start_holding <= '0';
            clk_counter <= (others=>'0');
        elsif ( rising_edge(clk) ) then    
            if ( above_threshold='1' ) then
                start_holding <= '1';
                clk_counter <= (others=>'0');
            elsif ( start_holding='1' ) then
                if ( clk_counter(27)='0' ) then
                    clk_counter <= clk_counter + 1;
                else
                    start_holding <= '0';
                end if;
            end if;
        end if;
    end process;

    -- -- alternative led visuals (use led shift register buffer)
    -- LED_buffer : entity work.LED_shift_reg
    -- port map (
    --     -- inputs --
    --     clk => clk,
    --     reset => reset,
    --     clap_detected => above_threshold,
    --     pattern_finished => reset,
    --     -- outputs -- 
    --     leds=>leds
    -- );

    
end clap_counter_arch;
