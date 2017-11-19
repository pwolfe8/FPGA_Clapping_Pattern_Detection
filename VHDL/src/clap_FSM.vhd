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
        f_clk : real;       -- system frequency
        end_silence : real; -- amount of silence required to signal end of pattern
        R_int : positive;   -- enough to handle ceil(log2(f_clk*T_END_SILENCE))
        n_int : positive    -- number of intervals in bank
    );
    port (
        -- inputs --
        clk                 : in  std_logic;
        reset               : in  std_logic;
        clap_detected       : in  std_logic; -- strobed high for a few clock cycles when clap is detected
        check_pattern_done  : in  std_logic; -- denotes that pattern checking process is done
        -- outputs --
        pattern_finished    : out std_logic;
        num_intervals       : out std_logic_vector(2 downto 0); --change this based on ceil(log2(n_int)) assuming n_int = 8 at max for now
        state_output_code   : out std_logic_vector(1 downto 0);
        interval_bank_array : out T_bank;
        bank_overflowed     : out std_logic
    );
end clap_FSM;

architecture clap_FSM_arch of clap_FSM is
    -- define state types
    type state_t is (IDLE, WAIT_FOR_NEXT_CLAP, LOG_INTERVAL, CHECKING_PATTERN);

    -- constant definitions
    constant T_END_SILENCE : positive := integer(real(f_clk) * end_silence);
    constant R_int_ctr : positive := 4; -- ceil(log2(16))
        -- clock counter resolution is ceil(log2(T_END_SILENCE))

    -- signal declarations  
    signal state, next_state : state_t;
    signal load, flush : std_logic;
    signal pattern_finished_buf : std_logic;
    signal last_interval : unsigned(R_int-1 downto 0);
    signal clk_counter : unsigned(R_int-1 downto 0);
    signal interval_counter : unsigned(R_int_ctr-1 downto 0); -- count how many intervals have been stored

begin

    -- clock counter --
    process ( clk, reset ) begin
        if ( reset='1' ) then
            clk_counter <= (others=>'0');
            last_interval <= (others=>'0');
        elsif ( rising_edge(clk) ) then
            clk_counter <= clk_counter + 1;
            if ( clap_detected='1' ) then 
                last_interval <= clk_counter;
                clk_counter <= (others=>'0');
            end if;
        end if;
    end process;

    -- pattern finished logic (latch on rising edge of clock)
    pattern_finished <= pattern_finished_buf;
    process ( clk, reset, clap_detected ) begin
        if ( reset = '1' or clap_detected='1') then
            pattern_finished_buf <='0';
        elsif ( rising_edge(clk) and clk_counter >= T_END_SILENCE ) then
            pattern_finished_buf <= '1';
        end if;
    end process;

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

-- state machine --
    -- state machine reset & grab next state
    process ( clk, reset ) begin
        if ( reset='1' ) then
            state <= IDLE;
        elsif ( rising_edge(clk) ) then
            state <= next_state;
        end if;
    end process;

    -- state machine transition logic
    process (   state,
                clap_detected,
                pattern_finished,
                check_pattern_done )
    begin
        case state is
            when IDLE => 
                if ( clap_detected ='1' ) then
                    next_state <= WAIT_FOR_NEXT_CLAP;
                else
                    next_state <= IDLE;
                end if;
            when WAIT_FOR_NEXT_CLAP => 
                if ( clap_detected ='1' ) then
                    next_state <= LOG_INTERVAL;
                elsif ( pattern_finished='1' ) then
                    next_state <= CHECKING_PATTERN;
                else
                    next_state <= WAIT_FOR_NEXT_CLAP;
                end if;
            when LOG_INTERVAL =>
                next_state <= WAIT_FOR_NEXT_CLAP;
            when CHECKING_PATTERN =>
                if ( check_pattern_done='1' ) then
                    next_state <= IDLE;
                else
                    next_state <= CHECKING_PATTERN;
                end if;
            when others =>

        end case;

    end process;

    -- logic to do while in the state
    Outputs : process ( state ) begin
        case state is
            when IDLE =>
                state_output_code <= "00";
                load <= '0';
                flush <= '1';
                bank_overflowed <= '0';
                interval_counter <= (others=>'0');
            when WAIT_FOR_NEXT_CLAP =>
                state_output_code <= "01";
                load <= '0';  -- de-assert
                flush <= '0'; -- de-assert
            when LOG_INTERVAL =>
                state_output_code <= "10";
                load <= '1'; -- load for 1 clock cycle
                flush <= '0';
                interval_counter <= interval_counter + 1;
                if ( interval_counter>n_int ) then
                    bank_overflowed <= '1';
                end if;
            when CHECKING_PATTERN =>
                state_output_code <= "11";
                load <= '0'; -- de-assert
                flush <= '0';
            when others =>

        end case;
    end process;
    

end clap_FSM_arch;
