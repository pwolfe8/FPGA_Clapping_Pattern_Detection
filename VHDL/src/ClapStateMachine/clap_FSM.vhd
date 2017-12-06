--Engineer     : Philip Wolfe
--Date         : 11/14/2017
--Name of file : clap_FSM.vhd
--Description  : clap interval counter and state machine
--Testbench instructions: use R_clk_ctr=8 for testbench
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
    signal state, next_state : T_state;
    signal load, flush : std_logic;
    signal last_interval : unsigned(R_int-1 downto 0);
    signal clk_counter : unsigned(R_clk_ctr-1 downto 0);
    signal CLK_MAX : unsigned(clk_counter'range) := to_unsigned(T_END_SILENCE+7,clk_counter'length);

    -- buffers
    signal prev_clap_detected, cur_clap_detected : std_logic;
    signal pattern_finished_buf, prev_pattern_finished_buf : std_logic;
    signal prev_check_pattern_done, cur_check_pattern_done, check_pattern_done_buf : std_logic;

begin

    -- clock counter, last_interval, pattern_finished
    process ( clk, reset ) begin
        if ( reset='1' ) then
            clk_counter <= (others=>'0');
            last_interval <= (others=>'0');
            prev_clap_detected <= '0';
            cur_clap_detected <= '0';
        elsif ( rising_edge(clk) ) then
            if ( prev_clap_detected='0' and cur_clap_detected='1' ) then 
                last_interval <= clk_counter(R_clk_ctr-1 downto R_clk_ctr-R_int); -- grab top R_int bits
                clk_counter <= (others=>'0');
            elsif ( clk_counter < CLK_MAX ) then
                clk_counter <= clk_counter + 1;
            end if;
            cur_clap_detected <= clap_detected;
            prev_clap_detected <= cur_clap_detected;
        end if;
    end process;

    -- pattern finished logic (latch on rising edge of clock)
    process ( clk, reset ) begin
        if ( reset = '1' ) then
            pattern_finished <= '0';
            pattern_finished_buf <='0';
            prev_pattern_finished_buf <= '0';
        elsif ( rising_edge(clk) ) then
            -- make pattern_finished_buf high for one clock cycle
            prev_pattern_finished_buf <= pattern_finished_buf;
            if ( clk_counter>T_END_SILENCE ) then 
                pattern_finished_buf <= '1';
            else
                pattern_finished_buf <= '0';
            end if;

            if (prev_pattern_finished_buf='0' and pattern_finished_buf='1') then
                pattern_finished <= '1';
            else
                pattern_finished <= '0';
            end if;

        end if;
    end process;

    -- latch in pattern
    process ( clk, reset, state ) begin
        if ( reset='1' ) then
            cur_check_pattern_done <= '0';
            prev_check_pattern_done <= '0';
            check_pattern_done_buf <= '0';
        elsif ( rising_edge(clk) ) then
            if ( prev_check_pattern_done='0' and cur_check_pattern_done='1' ) then
                check_pattern_done_buf <= '1';
            end if;
            prev_check_pattern_done <= cur_check_pattern_done;
            cur_check_pattern_done <= check_pattern_done;

            if (state=IDLE) then
                check_pattern_done_buf <= '0';
            end if;

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
                cur_clap_detected,
                pattern_finished_buf,
                check_pattern_done_buf )
    begin
        case state is
            when IDLE => 
                if ( prev_clap_detected='0' and cur_clap_detected ='1' ) then
                    next_state <= WAIT_FOR_NEXT_CLAP;
                else
                    next_state <= IDLE;
                end if;
            when WAIT_FOR_NEXT_CLAP => 
                if ( prev_clap_detected='0' and cur_clap_detected ='1' ) then
                    next_state <= LOG_INTERVAL;
                elsif ( prev_pattern_finished_buf='0' and pattern_finished_buf='1' ) then
                    next_state <= CHECKING_PATTERN;
                else
                    next_state <= WAIT_FOR_NEXT_CLAP;
                end if;
            when LOG_INTERVAL =>
                next_state <= WAIT_FOR_NEXT_CLAP;
            when others => -- CHECKING_PATTERN =>
                if ( check_pattern_done_buf='1' ) then
                    next_state <= IDLE;
                else
                    next_state <= CHECKING_PATTERN;
                end if;
        end case;
    end process;

    -- logic to do while in the state
    Outputs : process ( state ) begin
        case state is
            when IDLE =>
                load <= '0';
                flush <= '1';
                bank_overflowed <= '0';
            when WAIT_FOR_NEXT_CLAP =>
                load <= '0';  -- de-assert
                flush <= '0'; -- de-assert
            when LOG_INTERVAL =>
                load <= '1'; -- load for 1 clock cycle
                flush <= '0';
            when others => -- CHECKING_PATTERN =>
                load <= '0'; -- de-assert
                flush <= '0';
        end case;
    end process;

    -- count how many intervals have been stored
    process ( clk, reset )
        variable clap_counter : unsigned(R_int_ctr-1 downto 0) := (others=>'0');
    begin
        if ( reset='1' ) then
            clap_counter := (others=>'0');
        elsif ( rising_edge(clk) ) then
            if (clap_counter>0) then
                num_intervals <= clap_counter-1;
            else
                num_intervals <= (others=>'0');
            end if;

            if ( prev_clap_detected='0' and cur_clap_detected='1' ) then
                clap_counter := clap_counter + 1;
            elsif (check_pattern_done_buf='1' ) then
                clap_counter := (others=>'0');
            end if;
        end if;
    end process;
    
    -- output current state
    state_output <= state;
    
end clap_FSM_arch;
