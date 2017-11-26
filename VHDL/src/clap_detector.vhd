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

type signal_array is array (0 to 20) of 



architecture clap_detector_arch of clap_detector is
    -- constant definitions
    
    -- signal declarations
    

process()
begin
    -- normal processes
    
    -- component instantiations
    threshold <= 20000;
    sum <= 0;
    for i in 0 to 19 loop
        sum <= signal_array(i) + sum;
    end loop;

    if sum > threshold then
        clap_detected <= '1';
    end if;

    for i in 20 to signal_array'LENGTH loop
        sum <= sum + signal_array(i) - signal_array(i-20);
        if sum > threshold then
            clap_detected <= '1';
        end if;
    end loop;
end process;




    
    
end clap_detector_arch;
