--Engineer     : Matt Arceri
--Date         : 11/20/2017
--Name of file : clap_detector.vhd
--Description  : detects if a clap has been detected based off ADC inputs
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.TYPE_PACK.all;

entity clap_detector is
    generic (
        R_int  : positive;
        N_int  : positive;
        N_patt : positive
    );
    port (
        -- inputs --
        clk, reset      : std_logic;
        XADC		    : in  unsigned(R_adc-1 downto 0); -- check on this from example XADC project...
        -- outputs --
        clap_detected	: out std_logic
    );
end clap_detector;

architecture clap_detector_arch of clap_detector is
    -- constant definitions
    type sig_array is array (0 to 20) of unsigned(R_adc-1 downto 0);

    --signal signal_array is array (0 to 20) of unsigned(R_adc) <= ((others=> (others=>'0')));
    -- signal declarations
    
begin
    --Add entire array together

    process(clk, reset)
        variable sum : unsigned(R_adc+20 downto 0);
        variable signal_array : sig_array  := ((others=> (others=>'0')));
    begin
        if(reset = '1') then
            signal_array := ((others=> (others=>'0')));
        elsif(rising_edge(clk)) then
            signal_array := XADC & signal_array(0 to 19);
            sum := (others => '0');
            for n in signal_array'range loop
                Sum := Sum + signal_array(n);                         
            end loop;

            if sum > 20000 then
                clap_detected <= '1';
            end if;
        end if;
    end process;
  
end clap_detector_arch;
