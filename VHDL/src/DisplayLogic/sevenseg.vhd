--Engineer     : Will Sutton
--Date         : MM/DD/2017
--Name of file : sevenseg.vhd
--Description  : This file controls our seven segment outputs. 
--Behavior     : will receive state, clap_detected, and which patterns matched
-- if clap_detected then display "H" ( we can remove this part and put it in led_shift_register.vhd)
-- else display:
--      IDLE               : display prev matched pattern
--      WAIT_FOR_NEXT_CLAP : display "L"
--      LOG_INTERVAL       : display "n"
--      CHECKING_PATTERN   : display "n"

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.TYPE_PACK.all;

entity sevenseg is
    port (
        -- inputs --
        rst             : in std_logic;
        patternIn       : in std_logic_vector ( N_patt-1 downto 0 );
        state           : in T_state;
        -- debug signals --
        min_done, norm_done, check_pattern_done : in std_logic;
        -- outputs --
        seg : out std_logic_vector ( 6 downto 0 ); --These are the 7seg display legs. 
        an : out std_logic_vector ( 3 downto 0 )--This is the selector for which of the 4 7seg displays get used. 
    );
end sevenseg;

architecture sevenseg_arch of sevenseg is

    signal min_done_buf, norm_done_buf, check_pattern_done_buf : std_logic := '0';

begin

-- Seven segment 
-- bit to segment
-- mapping.
-- 1 = segment off.
--   ___ ___
--  |	0   |
--  5	    1
--  |---6---|
--  4       2
--  |___3___|
--
--
-- 0 = "1000000"
-- 1 = "1111001"
-- 2 = "0100100"
-- 3 = "0110000"
-- 4 = "0011001"
-- 5 = "0010010"
-- 6 = "0000010"
-- 7 = "1111000"
-- 8 = "0000000"
-- 9 = "0011000"
-- A = "0001000"
-- b = "0000011"
-- C = "1000110"
-- d = "0100001"
-- E = "0000110"
-- F = "0001110"
-- o = "0100011"
-- n = "0101011"
-- P = "0001100"
-- u = "1100011"
-- - = "0111111"
-- _ = "1110111"
-- L = "1000111"

    process ( rst, min_done, norm_done, check_pattern_done ) begin
        if ( rst='1' ) then
            min_done_buf <= '0';
            norm_done_buf <= '0';
            check_pattern_done_buf <= '0';
        elsif ( min_done='1' ) then
            min_done_buf <= '1';
        elsif ( norm_done='1' ) then
            norm_done_buf <= '1';
        elsif ( check_pattern_done='1' ) then
            check_pattern_done_buf <= '1';
        end if;
    end process;

	process ( state, min_done_buf, norm_done_buf, check_pattern_done_buf ) begin    
        if (state = IDLE ) then
			case patternIn is
				when "0001" => -- pattern 1
					seg <= "1111001"; -- 1
				when "0010" => -- pattern 2
					seg <= "0100100"; -- 2
				when "0100" => -- pattern 3
					seg <= "0110000"; -- 3
				when "1000" => -- pattern 4
					seg <= "0011001"; -- 4
                when others => -- failed to match pattern
                    seg <= "0001110"; -- F
            end case;

            --  "1000000" when "00000",
            --  "1111001" when "00001", -- Pattern 1
            --  "0100100" when "00010", -- Pattern 2
            --  "0110000" when "00011", -- Pattern 3
            --  "0011001" when "00100", 
            --  "0010010" when "00101",
            --  "0000010" when "00110",
            --  "1111000" when "00111",
            --  "0000000" when "01000",
            --  "0011000" when "01001",
            --  "0001000" when "01010",
            --  "0000011" when "01011",
            --  "1000110" when "01100",
            --  "0100001" when "01101",
            --  "0000110" when "01110",
            --  "0001110" when "01111",
            --  "0100011" when "10000",
            --  "0101011" when "10001",
            --  "0001100" when "10010",
            --  "1100011" when "10011",
            --  "0111111" when "10100",
            --  "1110111" when "10101",
            --  "1000111" when "10110",
            --	"1111111" when others;

        elsif (state = WAIT_FOR_NEXT_CLAP) then
            seg <= "1000111"; -- L
        elsif ( state = LOG_INTERVAL ) then
            seg <= "0101011"; -- n
        elsif ( state = CHECKING_PATTERN ) then
            if(min_done_buf='1' and norm_done_buf='1' and check_pattern_done_buf='1') then
                seg <= "1000110"; -- C
            elsif(min_done_buf='1' and norm_done_buf='1') then
                seg <= "0000011"; -- b
            elsif (min_done_buf='1') then
                seg <= "0001000"; -- A
            else
                seg <= "1110111"; -- _
            end if;
        end if;

    end process;
 
end sevenseg_arch;
