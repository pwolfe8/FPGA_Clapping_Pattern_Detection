--Engineer     : Philip Wolfe
--Date         : 11/30/2017
--Name of file : xadc_test.vhd
--Description  : testing out the xadc
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity xadc_test is
    port (
        -- inputs --
        CLK100MHZ   : in  std_logic;
        vauxp6      : in  std_logic;
        vauxn6      : in  std_logic;
        btnL        : in  std_logic; -- map to reset
        -- outputs --
        led		    : out std_logic_vector(15 downto 0)
    );
end xadc_test;

architecture xadc_test_arch of xadc_test is
    -- component declarations
    COMPONENT xadc_wiz_0
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
    signal enable, ready : std_logic;
    signal adc_data : std_logic_vector(15 downto 0); -- measured adc values    
    signal address_in : std_logic_vector(6 downto 0);
    
    signal counter : unsigned(31 downto 0);

    -- buffer
--    signal adc_buf : array (0 to 31) of unsigned(15 downto 0);

    -- constants
    constant R_adc : positive := 16;

begin
    -- tie external interface to internal signals
    clk <= CLK100MHZ;
    reset <= btnL;

    -- ClapDetector : entity work.clap_detector
    --     generic map ( R_adc=>R_adc )
    --     port map (
    --         -- inputs --
    --         clk => CLK100MHz,
    --         reset => reset,
    --         XADC => unsigned(adc_data),
    --         -- outputs --
    --         clap_detected => clap_detected
    --     );
    
        -- instantiate design under test
    LED_buf : entity work.LED_shift_reg
        port map (
            -- inputs -- 
            reset => reset,
            clap_detected => clap_detected,
            pattern_finished => reset,
            -- outputs -- 
            leds=>led
        );

    -- led visuals
    -- led <= adc_data;

    -- process ( clk, reset ) begin
    --     if ( reset='1' ) then
    --         led <= (others=>'0');
    --     elsif ( rising_edge(clk) ) then
    --         case (adc_data(15 downto 12) ) is
    --             when X"1"   => led <= (1  downto 0 =>'1', others=>'0');
    --             when X"2"   => led <= (2  downto 0 =>'1', others=>'0');
    --             when X"3"   => led <= (3  downto 0 =>'1', others=>'0');
    --             when X"4"   => led <= (4  downto 0 =>'1', others=>'0');
    --             when X"5"   => led <= (5  downto 0 =>'1', others=>'0');
    --             when X"6"   => led <= (6  downto 0 =>'1', others=>'0');
    --             when X"7"   => led <= (7  downto 0 =>'1', others=>'0');
    --             when X"8"   => led <= (8  downto 0 =>'1', others=>'0');
    --             when X"9"   => led <= (9  downto 0 =>'1', others=>'0');
    --             when X"A"   => led <= (10 downto 0 =>'1', others=>'0');
    --             when X"B"   => led <= (11 downto 0 =>'1', others=>'0');
    --             when X"C"   => led <= (12 downto 0 =>'1', others=>'0');
    --             when X"D"   => led <= (13 downto 0 =>'1', others=>'0');
    --             when X"E"   => led <= (14 downto 0 =>'1', others=>'0');
    --             when X"F"   => led <= (15 downto 0 =>'1', others=>'0');
    --             when others => led <= (1 =>'1', others=>'0');
    --         end case;
    --     end if;
    -- end process;
    
    -- currently adc is 0.5V bias, 2.0V max... 220?
    
    -- xadc instantiation

    xadc_inst : xadc_wiz_0
    PORT MAP (
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

        -- leave the rest open
    );

    
end xadc_test_arch;
