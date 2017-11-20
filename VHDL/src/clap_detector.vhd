--Engineer     : Vasundhara Rawat
--Date         : 11/20/2017
--Name of file : clap_detector.vhd
--Description  : detects if a clap has been detected based off ADC inputs
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clap_detector is
    generic (
        _name_			: _type_
    );
    port (
        -- inputs --
        clk, reset      : std_logic;
        XADC		    : in  _type_; -- check on this from example XADC project...
        -- outputs --
        clap_detected	: out std_logic
    );
end clap_detector;

architecture clap_detector_arch of clap_detector is
    -- constant definitions
    
    -- signal declarations
    

begin
    -- normal processes
    
    -- component instantiations
    
    
end clap_detector_arch;
