--Author: Matthew Arceri
--Revision Date: 11/8/2017

library ieee;
use ieee.std_logic_1164.all
use ieee.numeric_std.all
use work

entity boundaryComp is
    generic(
        N: integer; --Data width
        M: integer; --Data length
        L: integer  --Pattern to check
    );
    type pattern_data is array (0 to M-1) of unsigned(N-1 downto 0);
    port (
        r_bank          : in unsigned(N-1 downto 0);  --This might just have a set size
        normalized_data : in pattern_data;
        pattern         : in pattern_data;
        match           : out std_logic_vector(M-1 downto 0);
    );
end boundaryComp;

architecture boundaryComp_arch of boundaryComp is
    variable upper,lower: is array(0 to M-1) of unsigned(N-1 downto 0); 
    begin
        -- Upper bound is stored_bounds(i, 0)
        -- Lower bound is stored_bounds(i, 1)
        for i in 0 to M-1 loop
            lower := resize(pattern(i,1),N+1) - normalized_data(i);
            upper := resize(normalized_data(i),N+1) - pattern(i,0);
            match(i) <= lower(N) and upper(N);
        end loop;

end boundaryComp_arch