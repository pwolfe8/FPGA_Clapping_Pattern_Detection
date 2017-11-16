--Engineer     : Philip Wolfe
--Date         : 11/14/2017
--Name of file : clap_FSM.vhd
--Description  : clap interval counter and state machine
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.TYPE_PACK.all;


entity clap_FSM is
    generic (
        f_clk : positive := 25e6;   -- system frequency 25MHz
        end_silence : real := 2.5;  -- amount of silence required to signal end of pattern
        R_int : positive := 26;     -- enough to handle ceil(log2(f_clk*T_END_SILENCE))
        n_int : positive := 8       -- number of intervals
    );
    port (
        -- inputs --
        clk                 : in  std_logic;
        reset               : in  std_logic;
        clap_detected       : in  std_logic; -- strobed high for a few clock cycles when clap is detected
        check_pattern_done  : in  std_logic; -- denotes that pattern checking process is done
        -- outputs --
        pattern_finished    : out std_logic;
        state_output_code   : out std_logic_vector(1 downto 0);
        interval_bank_array : out T_bank;
        bank_overflowed     : out std_logic
    );
end clap_FSM;

architecture clap_FSM_arch of clap_FSM is
    -- define state types
    type state_t is (IDLE, LOG_INTERVAL, CHECKING_PATTERN);

    -- constant definitions
    constant T_END_SILENCE : positive := integer(real(f_clk) * end_silence);
    constant R_clk_ctr : positive := 30; -- ceil(log2(T_END_SILENCE))
    constant R_clap_ctr : positive := 4; -- ceil(log2(16))

    -- signal declarations  
    signal state, next_state : state_t;

    signal load, flush : std_logic := '0';
    signal last_interval : unsigned(R_int-1 downto 0);

    signal clk_counter : unsigned(R_clk_ctr-1 downto 0);
    signal clap_counter : unsigned(R_clap_ctr-1 downto 0);

begin
-- counter logic -- 
    -- clock counter --
    process ( clk, reset, clap_detected ) begin
        if ( reset='1' or clap_detected='1' ) then
            last_interval <= clk_counter;
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
                                pattern_finished,
                                check_pattern_done )
    begin
        case state is
            when IDLE => 
                flush <= '0';
                if ( clap_detected='1' ) then
                    next_state <= LOG_INTERVAL;    
                end if;
            when LOG_INTERVAL =>
                if ( pattern_finished='1' ) then
                    next_state <= CHECKING_PATTERN;
                else
                    next_state <= IDLE;
                end if;
            when CHECKING_PATTERN =>
                if ( check_pattern_done='1' ) then
                    next_state <= IDLE;
                    bank_overflowed <= '0';
                    pattern_finished <= '0';
                    flush <= '1';
                end if;
            when others => -- hopefully this state never is reached
                next_state <= IDLE; 
        end case;

    end process;

    -- logic to do while in the state
    Outputs : process ( state ) begin
        case state is
            when IDLE =>
                load <= '0';
                state_output_code <= "00";
            when LOG_INTERVAL =>
                load <= '1';
                state_output_code <= "01";
                clap_counter <= clap_counter + 1;
                if ( clap_counter>=n_int ) then
                    bank_overflowed <= '1';
                end if;
            when CHECKING_PATTERN =>
                load <= '0';
                state_output_code <= "10";
                clap_counter <= (others=>'0');
            when others => -- not supposed to be in this state
                state_output_code <= "00";
        end case;
    end process;
    
-- logging intervals --
    -- instantiate shift register to store bank of data
    int_bank : entity work.shift_register
        generic map ( R=>R_int, Num=>n_int )
        port map (
            -- inputs --
            clk     => clk,
            load	=> load,
            flush   => flush,
            in_val  => last_interval,
            -- outputs --
            data_out => interval_bank_array
        );

end clap_FSM_arch;
