--Engineer     : Philip Wolfe
--Date         : MM/DD/2017
--Name of file : sevenseg.vhd
--Description  : This file controls our seven segment outputs. 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity skeleton is
    generic (
        _name_			: _type_
    );
    port (
        -- inputs --
        patternIn :  in std_logic_vector ( 4 downto 0 );
        _name_		: in  _type_;
        -- outputs --
        --These are the 7seg display legs. 
        seg : out std_logic_vector ( 6 downto 0 );
       	--This is the selector for which of the 4 7seg displays get used. 
        an : out std_logic_vector (4 downto 0 );
        _name_		: out _type_
    );
end skeleton;

architecture skeleton_arch of skeleton is
    -- constant definitions
    constant _name_ : _type_ := _value_;
    
    -- signal declarations
    signal _name_ : _type_;

begin
    -- normal processes
    process ( clk, rst ) begin
        if ( rst='1' ) then
            
        elsif ( rising_edge(clk) ) then
            
        end if;
    end process;

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
-- 1 = "0000110"
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

	with patternIn select
		seg <= "1000000" when "00000",
			"0000110" when "00001",
			"0100100" when "00010",
			"0110000" when "00011",
			"0011001" when "00100",
			"0010010" when "00101",
			"0000010" when "00110",
			"1111000" when "00111",
			"0000000" when "01000",
			"0011000" when "01001",
			"0001000" when "01010",
			"0000011" when "01011",
			"1000110" when "01100",
			"0100001" when "01101",
			"0000110" when "01110",
			"0001110" when "01111",
			"0100011" when "10000",
			"0101011" when "10001",
			"0001100" when "10010",
			"1100011" when "10011",
			"0111111" when "10100",
			"1110111" when "10101",
			"1111111" when others;

    -- component instantiations
    _name_ : entity work._entity_name_
        generic map (
             -- map generics here
        )
        port map (
            -- Paste entity's ports here. Connect signals in either form:
        --    "in1,in2,out1,out2"
        --    "portname1=>signal1, portname2=>signal2"
        );
    
    
end skeleton_arch;
