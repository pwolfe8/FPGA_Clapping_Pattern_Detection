--Engineer     : Philip Wolfe
--Date         : 11/5/2017
--Name of file : fifo.vhd
--Description  : first in first out buffer to store intervals between claps
            -- consider alternate data structure that allows combinational logic 
            -- for the 0.1sec binned data
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo is
    generic (
        bit_width : positive := 8;
        fifo_length : positive
    );
    port (
        -- inputs --
        clk         : in  std_logic;
        rst         : in  std_logic;
        data_in     : in  unsigned(bit_width-1 downto 0);
        read_data   : in  std_logic;
        write_data  : in  std_logic;
        -- outputs --
        data_out    : out unsigned(bit_width-1 downto 0);
        fifo_empty  : out std_logic;
        fifo_full   : out std_logic
    );
end fifo;

architecture fifo_arch of fifo is
    -- constant definitions
    
    -- signal declarations
    

begin
    -- normal processes
    
    -- component instantiations
    
    
end fifo_arch;
