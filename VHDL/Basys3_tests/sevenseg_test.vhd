--Engineer     : Philip Wolfe
--Date         : 11/20/2017
--Name of file : sevenseg_test.vhd
--Description  : Test bench for sevenseg.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.TYPE_PACK.all;


entity sevenseg_test is
    port (
        -- inputs --
        CLK100MHZ   : in  std_logic;
        btnC        : in  std_logic;                    -- advance to next state
        btnL        : in  std_logic;                    -- reset to idle state
        sw          : in  std_logic_vector(3 downto 0); -- switches for pattern_in
        -- outputs --
        sseg        : out std_logic_vector(6 downto 0); -- sseg control signals
        an          : out std_logic_vector(3 downto 0)  -- selects the sseg to write to
    );
end sevenseg_test;

architecture sevenseg_test_arch of sevenseg_test is

    -- signal declarations
    signal state : T_state := IDLE;    
    signal clk, reset, advance_state, prev_advance_state : std_logic;
    signal pattern_in : std_logic_vector(3 downto 0);

begin

    -- translate board inputs to signals
    clk <= CLK100MHZ;
    reset <= btnL;
    pattern_in <= sw;

    -- debounce btnC out to advance_state
    debouncer : entity work.debouncer
        generic map (
            F_clk_kHz => 100e3, -- set to 5 for tb
            stable_time_ms => 25 --set to 1 for tb
        )
        port map (
            -- inputs --
            clk => clk,
            reset => reset,
            button_in => btnC,
            -- outputs --
            button_out => advance_state
        );

    -- select sseg 0 all the time
    an <= "1110";

    -- advance the state every time btnC is pressed
    process ( clk, reset, advance_state ) begin
        if ( reset='1' ) then --reset to idle
            state <= IDLE;
        elsif ( rising_edge(clk) ) then
            if(prev_advance_state='0' and advance_state='1') then
                case state is
                    when IDLE => 
                        state <= WAIT_FOR_NEXT_CLAP;
                    when WAIT_FOR_NEXT_CLAP => 
                        state <= LOG_INTERVAL;
                    when LOG_INTERVAL =>
                        state <= CHECKING_PATTERN;
                    when CHECKING_PATTERN =>
                        state <= IDLE;
                end case;       
            end if;
            prev_advance_state <= advance_state;
        end if;
    end process;

    -- instantiate sseg module and connect to input buttons and output sseg
    DUT : entity work.sevenseg
        port map (
            -- inputs --
            rst => reset,-- left button resets
            patternIn => pattern_in,
            state => state, -- this should change based on the center button
            -- ouputs --
            seg => sseg
        );

end sevenseg_test_arch;
