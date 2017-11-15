--Engineer     : Philip Wolfe
--Date         : 11/14/2017
--Name of file : clap_interval_fsm.vhd
--Description  : clap interval counter and state machine
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clap_interval_fsm is
    generic (
        R_int : positive := 27       -- enough to handle ceil(log2(f_clk*T_END_SILENCE))
        n_int : positive := 16       -- number of intervals
        f_clk : positive := 25e6;    -- system frequency 25MHz
        end_silence : positive := 3; -- amount of silence required to signal end of pattern
    );
    port (
        -- inputs --
        clk                 : in  std_logic;
        reset               : in  std_logic;
        clap_detected       : in  std_logic; -- strobed high for a few clock cycles when clap is detected
        -- outputs --
        pattern_finished    : out std_logic;
        state_output_code   : out std_logic_vector(1 downto 0);
        interval_bank_array : out unsigned(R_bank-1 downto 0)
    );
end clap_interval_fsm;

architecture clap_interval_fsm_arch of clap_interval_fsm is
    -- define state types
    type state_t is (IDLE, LOG_INTERVALS, CHECKING_PATTERN);
    
    -- constant definitions
    constant T_END_SILENCE : positive := f_clk * end_silence;
    
    -- signal declarations  
    signal bank : array(n_int-1 downto 0) of unsigned(R_int-1 downto 0);

begin
-- counter logic -- 
    -- clock counter --
    process ( clk, reset, clap_detected ) begin
        if ( reset='1' or clap_detected='1' ) then
            clk_counter <= (others=>'0');
        elsif ( rising_edge(clk) ) then
            clk_counter <= clk_counter + 1;
        end if;
    end process;
    
    -- pattern finished logic (latch on rising edge of clock)
    process ( clk ) begin
        if ( rising_edge(clk) ) then
            if ( clk_counter >= T_END_SILENCE ) then
                pattern_finished <= '1';
            else
                pattern_finished <= '0';
            end if;
        end if;
    end process;

-- state machine --
    -- state machine reset & grab next state
    Grab_Next_State : process ( clk, reset ) begin
        if ( reset='1' ) then
            state <= IDLE;
        elsif ( rising_edge(clk) ) then
            state <= next_state;
        end if;
    end process;

    -- state machine transition logic
    State_Transition : process( state,
                                clap_detected,
                                clap_finished,
                                check_pattern_done )
    begin
        case state is
            when IDLE => 
                if ( clap_detected='1' ) then
                    next_state <= LOG_INTERVALS;
                end if;
            when LOG_INTERVALS =>
                if ( pattern_finished='1' ) then
                    next_state <= CHECKING_PATTERN;
                end if;
            when CHECKING_PATTERN =>
                if ( check_pattern_done='1' ) then
                    next_state <= IDLE;
                end if;
            when others => -- hopefully this state never is reached
                next_state <= IDLE; 
        end case;

    end process;

    -- state machine output logic
    Outputs : process ( state ) begin
        case state is
            when IDLE =>
                state_output_code <= "00";
            when LOG_INTERVALS =>
                state_output_code <= "01";
            when CHECKING_PATTERN =>
                state_output_code <= "10";
            when others => -- not supposed to be in this state
                state_output_code <= "00";
        end case;
    end process;
    
-- logging interval logic --
    log_intervals : process ( state ) begin
        if ( state=LOG_INTERVALS ) then
            
        end if;
    end process;


end clap_interval_fsm_arch;
