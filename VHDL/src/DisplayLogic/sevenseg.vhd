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
        clk, reset          : in  std_logic;
        patternIn           : in  std_logic_vector ( N_patt-1 downto 0 );
        state               : in  T_state;
        -- debug signals --
        int1                : in  T_int;
        num_intervals       : in  unsigned(R_int_ctr-1 downto 0);
        min_done            : in  std_logic;
        norm_done           : in  std_logic;
        check_pattern_done  : in  std_logic;
        -- outputs --
        seg : out std_logic_vector ( 6 downto 0 ); --These are the 7seg display legs. 
        an  : out std_logic_vector ( 3 downto 0 )--This is the selector for which of the 4 7seg displays get used. 
    );
end sevenseg;

architecture sevenseg_arch of sevenseg is
    type T_seg is array(3 downto 0) of std_logic_vector(6 downto 0);

    signal min_done_buf, norm_done_buf, check_pattern_done_buf : std_logic := '0';
    signal an_buf : std_logic_vector(3 downto 0);
    signal seg_buf : T_seg;
    signal dig2, dig3, dig1 : unsigned(3 downto 0);
    signal seg0 : std_logic_vector(6 downto 0);
    signal clk_counter : unsigned(17 downto 0); -- 2^17*10ns=1.31ms for sseg refresh rate

begin
    an <= an_buf;

-- Seven segment bit to segment mapping.
-- 1 = segment off, 0 = segment on.
--   ___ ___
--  |	0   |
--  5	    1
--  |---6---|
--  4       2
--  |___3___|
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

    dig3 <= int1(7 downto 4);
    dig2 <= int1(3 downto 0);
    dig1 <= num_intervals; --to_unsigned(to_integer(num_intervals),4);
    process ( clk, reset ) begin
        if ( reset='1' ) then
            clk_counter <= (others=>'0');
        elsif ( rising_edge(clk) ) then
            if(clk_counter(17)='1') then
                clk_counter <= (others=>'0');
            else
                clk_counter <= clk_counter + 1;
            end if;
        end if;
    end process;

    -- write the 1st interval to sseg 3 & 2. normal codes on sseg 0
    process ( clk, reset )
        variable seg_idx : unsigned(1 downto 0) := "00";
    begin
        if ( reset='1' ) then
            an_buf <= "1110"; -- default to sseg0
            seg_buf <= (others=>(others=>'0'));
            seg <= (others=>'0');
        elsif ( rising_edge(clk) and clk_counter(17)='1' ) then
            -- decode dig3 & dig2
            case dig3 is
                when X"0" => seg_buf(3) <= "1000000";
                when X"1" => seg_buf(3) <= "1111001";
                when X"2" => seg_buf(3) <= "0100100";
                when X"3" => seg_buf(3) <= "0110000";
                when X"4" => seg_buf(3) <= "0011001";
                when X"5" => seg_buf(3) <= "0010010";
                when X"6" => seg_buf(3) <= "0000010";
                when X"7" => seg_buf(3) <= "1111000";
                when X"8" => seg_buf(3) <= "0000000";
                when X"9" => seg_buf(3) <= "0011000";
                when X"A" => seg_buf(3) <= "0001000";
                when X"B" => seg_buf(3) <= "0000011";
                when X"C" => seg_buf(3) <= "1000110";
                when X"D" => seg_buf(3) <= "0100001";
                when X"E" => seg_buf(3) <= "0000110";
                when X"F" => seg_buf(3) <= "0001110";
                when others => seg_buf(3) <= "1111111";    
            end case;
            case dig2 is
                when X"0" => seg_buf(2) <= "1000000";
                when X"1" => seg_buf(2) <= "1111001";
                when X"2" => seg_buf(2) <= "0100100";
                when X"3" => seg_buf(2) <= "0110000";
                when X"4" => seg_buf(2) <= "0011001";
                when X"5" => seg_buf(2) <= "0010010";
                when X"6" => seg_buf(2) <= "0000010";
                when X"7" => seg_buf(2) <= "1111000";
                when X"8" => seg_buf(2) <= "0000000";
                when X"9" => seg_buf(2) <= "0011000";
                when X"A" => seg_buf(2) <= "0001000";
                when X"B" => seg_buf(2) <= "0000011";
                when X"C" => seg_buf(2) <= "1000110";
                when X"D" => seg_buf(2) <= "0100001";
                when X"E" => seg_buf(2) <= "0000110";
                when X"F" => seg_buf(2) <= "0001110";
                when others => seg_buf(2) <= "1111111";    
            end case;
            -- dig1 should be number of intervals
            case dig1 is -- 12 = 1100
                when X"0" => seg_buf(1) <= "1000000";
                when X"1" => seg_buf(1) <= "1111001";
                when X"2" => seg_buf(1) <= "0100100";
                when X"3" => seg_buf(1) <= "0110000";
                when X"4" => seg_buf(1) <= "0011001";
                when X"5" => seg_buf(1) <= "0010010";
                when X"6" => seg_buf(1) <= "0000010";
                when X"7" => seg_buf(1) <= "1111000";
                when X"8" => seg_buf(1) <= "0000000";
                when X"9" => seg_buf(1) <= "0011000";
                when X"A" => seg_buf(1) <= "0001000";
                when X"B" => seg_buf(1) <= "0000011";
                when X"C" => seg_buf(1) <= "1000110";
                when X"D" => seg_buf(1) <= "0100001";
                when X"E" => seg_buf(1) <= "0000110";
                when X"F" => seg_buf(1) <= "0001110";
                when others => seg_buf(1) <= "1111111";    
            end case;

            -- pull in seg0 value
            seg_buf(0) <= seg0;

            -- write to 4 ssegs in a cycle
            seg <= seg_buf(to_integer(seg_idx));
            case seg_idx is
                when "11" => -- 3
                    an_buf <= "0111";
                when "10" => -- 2
                    an_buf <= "1011";
                when "01" => -- 1
                    an_buf <= "1101";
                when others => -- 0
                    an_buf <= "1110";
            end case;

            -- advance idx from 0 to 3 and back to 0
            if (seg_idx = "11") then
                seg_idx := (others=>'0');
            else
                seg_idx := seg_idx + 1;
            end if;
            
        end if;
    end process;

    process ( reset, min_done, norm_done, check_pattern_done ) begin
        if ( reset='1' ) then
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
					seg0 <= "1111001"; -- 1
				when "0010" => -- pattern 2
					seg0 <= "0100100"; -- 2
				when "0100" => -- pattern 3
					seg0 <= "0110000"; -- 3
				when "1000" => -- pattern 4
					seg0 <= "0011001"; -- 4
                when others => -- failed to match pattern
                    seg0 <= "0001110"; -- F
            end case;

            --  "1000000" when "00000", -- 0
            --  "1111001" when "00001", -- 1
            --  "0100100" when "00010", -- 2
            --  "0110000" when "00011", -- 3
            --  "0011001" when "00100", -- 4
            --  "0010010" when "00101", -- 5
            --  "0000010" when "00110", -- 6
            --  "1111000" when "00111", -- 7
            --  "0000000" when "01000", -- 8
            --  "0011000" when "01001", -- 9
            --  "0001000" when "01010", -- A
            --  "0000011" when "01011", -- b
            --  "1000110" when "01100", -- C
            --  "0100001" when "01101", -- d
            --  "0000110" when "01110", -- E
            --  "0001110" when "01111", -- F
            --  "0100011" when "10000", -- o
            --  "0101011" when "10001", -- n
            --  "0001100" when "10010", -- P
            --  "1100011" when "10011", -- u
            --  "0111111" when "10100", -- -
            --  "1110111" when "10101", -- _
            --  "1000111" when "10110", -- L
            --	"1111111" when others; -- nothing

        elsif (state = WAIT_FOR_NEXT_CLAP) then
            seg0 <= "1000111"; -- L
        elsif ( state = LOG_INTERVAL ) then
            seg0 <= "0101011"; -- n
        elsif ( state = CHECKING_PATTERN ) then
            if(min_done_buf='1' and norm_done_buf='1' and check_pattern_done_buf='1') then
                seg0 <= "1000110"; -- C
            elsif(min_done_buf='1' and norm_done_buf='1') then
                seg0 <= "0000011"; -- b
            elsif (min_done_buf='1') then
                seg0 <= "0001000"; -- A
            else
                seg0 <= "1110111"; -- _
            end if;
        end if;

    end process;
 
end sevenseg_arch;
