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
--     generic (
--        _name_			: _type_
--     );
    port (
        -- inputs --
--        clk             : in std_logic; --Assuming 50Mhz clock for now. 
        rst             : in std_logic;
        patternIn       : in std_logic_vector ( N_patt-1 downto 0 );
        clapDetected    : in std_logic;
        state           : T_state;
        -- outputs --
        --These are the 7seg display legs. 
        seg : out std_logic_vector ( 6 downto 0 );
       	--This is the selector for which of the 4 7seg displays get used. 
        an : out std_logic_vector ( 3 downto 0 )
    );
end sevenseg;

architecture sevenseg_arch of sevenseg is
    -- constant definitions
--    constant _name_ : _type_ := _value_;
    
    -- signal declarations
--    signal _name_ : _type_;

begin

--clockDiv : unsigned;
--clapDetectedClk : std_logic;


    
--    process ( clk, rst ) begin
--        if ( rst='1' ) then
            
--        elsif ( rising_edge(clk) ) then
            
--        end if;
--    end process;

    -- display H when clap detected
--    process ( clapDetectedClk, clapDetected ) begin
--    	if ( rising_edge(clk) and clapDetected = '1') then
--	    	seg <= "1110110" -- display "H" for 5 seconds
--    	end if;
--    end process;

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
-- 1 = "0000110" ** double check this one (invert?)
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


-- @Will compare to sevensegdecoder.v from example XADC project:
    --   4'h0: ssOut = 7'b1000000;
    --   4'h1: ssOut = 7'b1111001;
    --   4'h2: ssOut = 7'b0100100;
    --   4'h3: ssOut = 7'b0110000;
    --   4'h4: ssOut = 7'b0011001;
    --   4'h5: ssOut = 7'b0010010;
    --   4'h6: ssOut = 7'b0000010;
    --   4'h7: ssOut = 7'b1111000;
    --   4'h8: ssOut = 7'b0000000;
    --   4'h9: ssOut = 7'b0011000;
    --   4'hA: ssOut = 7'b0001000;
    --   4'hB: ssOut = 7'b0000011;
    --   4'hC: ssOut = 7'b1000110;
    --   4'hD: ssOut = 7'b0100001;
    --   4'hE: ssOut = 7'b0000110;
    --   4'hF: ssOut = 7'b0001110;
    --   default: ssOut = 7'b1001001;

	process ( state ) begin
		if (state = IDLE ) then
--			with signed(patternIn) select
--				seg <=
--        "0000110" when '1',
--        "0100100" when '2',
--        "0110000" when '4',
--        "0011001" when '8',
--        "0001110" when others;
			case patternIn is
				when "0001" => 
					seg <= "0000110";
				when "0010" => 
					seg <= "0100100";
				when "0100" =>  
					seg <= "0110000";
				when "1000" =>  
					seg <= "0011001";
				when others =>  
					seg <= "0001110";
			end case;


--        "1000000" when "00000", --Pattern 1
-- 				"0000110" when "00001", --Pattern 2
--				"0100100" when "00010",
--				"0110000" when "00011",
--				"0011001" when "00100", 
--				"0010010" when "00101",
--				"0000010" when "00110",
--				"1111000" when "00111",
--				"0000000" when "01000",
--				"0011000" when "01001",
--				"0001000" when "01010",
--				"0000011" when "01011",
--				"1000110" when "01100",
--				"0100001" when "01101",
--				"0000110" when "01110",
--				"0001110" when "01111",
--				"0100011" when "10000",
--				"0101011" when "10001",
--				"0001100" when "10010",
--				"1100011" when "10011",
--				"0111111" when "10100",
--				"1110111" when "10101",
 --       "1000111" when "10110",
--				"1111111" when others;

    elsif (state = WAIT_FOR_NEXT_CLAP) then
      seg <= "1000111";

    else
      seg <= "0101011";

    end if;

end process;
    -- component instantiations
--    clockDiv : entity work.clockDiv
--        generic map (
             -- map generics here
--        )
--        port map (
--        	clk,
--        	clapDetectedClk,
--        	clockDiv
            -- Paste entity's ports here. Connect signals in either form:
        --    "in1,in2,out1,out2"
        --    "portname1=>signal1, portname2=>signal2"
--        );

 
end sevenseg_arch;
