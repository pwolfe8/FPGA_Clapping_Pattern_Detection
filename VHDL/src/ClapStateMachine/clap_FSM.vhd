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
        end_silence : real  -- amount of silence required to signal end of pattern
    );
    port (
        -- inputs --
        clk                 : in  std_logic;
        reset               : in  std_logic;
        clap_detected       : in  std_logic; -- strobed high for a few clock cycles when clap is detected
        check_pattern_done  : in  std_logic; -- denotes that pattern checking process is done
        -- outputs --
        pattern_finished    : out std_logic; -- pull high for a clock cycle to denote clap pattern finished
        num_intervals       : out unsigned(R_int_ctr-1 downto 0); --change this based on ceil(log2(N_int)) assuming N_int = 8 at max for now
        state_output        : out T_state;
        interval_bank_array : out T_bank;
        bank_overflowed     : out std_logic
    );
end clap_FSM;

architecture clap_FSM_arch of clap_FSM is
    -- globals from typePack.vhd
    -- type T_state is (IDLE, WAIT_FOR_NEXT_CLAP, LOG_INTERVAL, CHECKING_PATTERN);

    -- constant definitions
    constant T_END_SILENCE : positive := integer(f_clk * end_silence);
    constant R_clk_ctr : positive := 28; -- integer(ceil(log2(real(T_END_SILENCE))));
    -- constant R_clk_ctr : positive := 8; -- use this line for the testbench

    -- signal declarations  
    signal clk_counter : unsigned(R_clk_ctr-1 downto 0);
    signal state, next_state : T_state;
    signal load, flush : std_logic;
    signal pattern_finished_buf : std_logic;
    signal last_interval : unsigned(R_int-1 downto 0);
    signal interval_counter : unsigned(R_int_ctr-1 downto 0); -- count how many intervals have been stored
    signal CLK_MAX : unsigned(clk_counter'range) := to_unsigned(T_END_SILENCE+7,clk_counter'length);

    -- prev clap buffer
    signal prev_clap_detected : std_logic;

begin

    -- clock counter --
    process ( clk, reset ) begin
        if ( reset='1' ) then
            clk_counter <= (others=>'0');
            last_interval <= (others=>'0');
            prev_clap_detected <= '0';
        elsif ( rising_edge(clk) ) then
            if ( prev_clap_detected='0' and clap_detected='1' ) then 
                last_interval <= clk_counter(R_clk_ctr-1 downto R_clk_ctr-R_int); -- grab top R_int bits
                clk_counter <= (others=>'0');
            elsif ( clk_counter < CLK_MAX ) then
                clk_counter <= clk_counter + 1;
            end if;
            prev_clap_detected <= clap_detected;
        end if;
    end process;

    -- pattern finished logic (latch on rising edge of clock)
    process ( clk, reset, clap_detected ) begin
        if ( reset = '1' or clap_detected='1') then
            pattern_finished_buf <='0';
            pattern_finished <= '0';
        elsif ( rising_edge(clk) ) then
            -- make pattern_finished_buf high for one clock cycle
            if ( clk_counter=T_END_SILENCE ) then 
                pattern_finished_buf <= '1';
            else
                pattern_finished_buf <= '0';
            end if;
            pattern_finished <= pattern_finished_buf;
        end if;
    end process;

    -- instantiate shift register to store bank of data
    interval_bank : entity work.shift_register
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
                pattern_finished_buf,
                check_pattern_done )
    begin
        case state is
            when IDLE => 
                if ( prev_clap_detected='0' and clap_detected ='1' ) then
                    next_state <= WAIT_FOR_NEXT_CLAP;
                else
                    next_state <= IDLE;
                end if;
            when WAIT_FOR_NEXT_CLAP => 
                if ( prev_clap_detected='0' and clap_detected ='1' ) then
                    next_state <= LOG_INTERVAL;
                elsif ( pattern_finished_buf='1' ) then
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
            when others => -- hopefully never reach this

        end case;
    end process;

    -- logic to do while in the state
    Outputs : process ( state ) begin
        case state is
            when IDLE =>
                load <= '0';
                flush <= '1';
                bank_overflowed <= '0';
                interval_counter <= (others=>'0');
            when WAIT_FOR_NEXT_CLAP =>
                load <= '0';  -- de-assert
                flush <= '0'; -- de-assert
            when LOG_INTERVAL =>
                load <= '1'; -- load for 1 clock cycle
                flush <= '0';
                interval_counter <= interval_counter + 1;
                if ( interval_counter > N_int ) then
                    bank_overflowed <= '1';
                end if;
            when CHECKING_PATTERN =>
                load <= '0'; -- de-assert
                flush <= '0';
            when others => -- hopefully never reach this, but do nothing for now
                
        end case;
    end process;
    
    -- output current state
    state_output <= state;
    -- output intervals recorded after finished recording pattern
    process ( clk, reset ) begin
        if ( reset='1' ) then
            num_intervals <= (others=>'0');
        elsif ( rising_edge(clk) and pattern_finished_buf='1' ) then
            num_intervals <= interval_counter;        
        end if;
    end process;
    
    
end clap_FSM_arch;
