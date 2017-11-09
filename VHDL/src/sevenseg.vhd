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
        _name_		: in  _type_;
        -- outputs --
        --These are the 7seg display legs. 
        seg : out std_logic_vector ( 6 downto 0 )
       	--This is the selector for which of the 4 7seg displays get used. 
        an : out std_logic_vector (4 downto 0 )
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
--  |	6   |
--  4	    0
--  |---5---|
--  3       1
--  |___2___|
--
--
      4'h0: ssOut = 7'b1000000;
      4'h1: ssOut = 7'b1111001;
      4'h2: ssOut = 7'b0100100;
      4'h3: ssOut = 7'b0110000;
      4'h4: ssOut = 7'b0011001;
      4'h5: ssOut = 7'b0010010;
      4'h6: ssOut = 7'b0000010;
      4'h7: ssOut = 7'b1111000;
      4'h8: ssOut = 7'b0000000;
      4'h9: ssOut = 7'b0011000;
      4'hA: ssOut = 7'b0001000;
      4'hB: ssOut = 7'b0000011;
      4'hC: ssOut = 7'b1000110;
      4'hD: ssOut = 7'b0100001;
      4'hE: ssOut = 7'b0000110;
      4'hF: ssOut = 7'b0001110;
      default: ssOut = 7'b1001001;



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
