--Engineer     : Philip Wolfe
--Date         : MM/DD/2017
--Name of file : skeleton.vhd
--Description  : description
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
