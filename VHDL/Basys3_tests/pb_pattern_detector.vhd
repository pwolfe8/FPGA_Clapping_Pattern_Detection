--Engineer     : Philip Wolfe
--Date         : 11/1/2017
--Name of file : pb_pattern_detector.vhd
--Description  : tests the system using a push button instead of clapping
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pb_pattern_detector is
    port (
        -- inputs --
        CLK100MHZ   : in  std_logic;
        btnL        : in  std_logic; -- reset
        btnC        : in  std_logic; -- clap_detected
        -- outputs --
        leds		: out std_logic_vector(15 downto 0);
        sseg        : out std_logic_vector(6 downto 0);
        an          : out std_logic_vector(3 downto 0)
    );
end pb_pattern_detector;

architecture pb_pattern_detector_arch of pb_pattern_detector is
    -- constant definitions
    
    -- signal declarations
    

begin
    -- normal processes
    
    -- component instantiations
    
    
end pb_pattern_detector_arch;
