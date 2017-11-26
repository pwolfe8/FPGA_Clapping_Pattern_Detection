--Engineer     : Matt Arceri
--Date         : 11/19/2017
--Name of file : pattern_compare.vhd
--Description  : checks the interval bank against our stored patterns
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.TYPE_PACK.all;

entity pattern_compare is
    generic (
        R_int  : positive;
        N_int  : positive;
        N_patt : positive
    );
    port (
        -- inputs --
        clk, reset          : in  std_logic;
        norm_done           : in  std_logic;
        norm_data           : in  T_bank;
        stored_patterns     : in  T_stored;
        -- outputs --
        check_pattern_done  : out std_logic := '0';
        patterns_matched    : out std_logic_vector(N_patt-1 downto 0)
    );
end pattern_compare;

architecture pattern_compare_arch of pattern_compare is
    -- constant definitions
    signal pattern_match : std_logic;
    signal current_pattern : T_bounds;
    -- signal declarations
    

begin

    compare : entity work.boundaryComp
    generic map (
        N => R_int,
        M => N_int
    )
    port map (
        normalized_data => norm_data,
        match=> pattern_match,
        pattern => current_pattern
    );

    -- normal processes
    process (clk,reset) 
        variable counter : unsigned(R_patt_ctr-1 downto 0) := to_unsigned(0, R_patt_ctr); --Has to be a variable due to sequential ifs
        variable has_finished : std_logic := '1';           --Has to be a variable due to sequential ifs
    begin
        if(reset = '1') then
            has_finished := '1';
            check_pattern_done <= '0';
        elsif(rising_edge(clk)) then
            if(norm_done = '1') then
                counter := to_unsigned(N_patt,R_patt_ctr);
                has_finished := '0';
            end if;

            if(counter = to_unsigned(0,R_patt_ctr)) then
                if(has_finished = '0') then
                    patterns_matched(0) <= pattern_match;
                    has_finished := '1';
                    check_pattern_done <= '1';
                else
                    check_pattern_done <= '0';
                end if;
            end if;

            if(counter /= to_unsigned(0,R_patt_ctr)) then
                if(counter /= to_unsigned(N_patt,R_patt_ctr)) then
                    patterns_matched(to_integer(counter)) <= pattern_match;
                end if;
                counter := counter - to_unsigned(1,R_patt_ctr);
                current_pattern <= stored_patterns(to_integer(counter));
            end if;
        end if;
        
    end process;
    -- component instantiations
    
    
end pattern_compare_arch;
