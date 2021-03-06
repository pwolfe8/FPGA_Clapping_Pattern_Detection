--Author: Matthew Arceri
--Revision Date: 11/8/2017

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.TYPE_PACK.all;

entity boundaryComp is
    generic(
        N: integer; --Data width
        M: integer --Data length (matts_number_intervals)
        -- L: integer  --Pattern to check
    );
    port (
        -- r_bank          : in unsigned(N-1 downto 0);  --This might just have a set size
        normalized_data : in T_bank;
        pattern         : in T_bounds;
        match           : out std_logic
    );
end boundaryComp;

architecture boundaryComp_arch of boundaryComp is
    type recordedDataPlusOne  is array (0 to M-1) of unsigned(N downto 0);
    signal upper,lower: recordedDataPlusOne;
    signal boundMatch : std_logic_vector(M-1 downto 0);
    constant all_ones :std_logic_vector(M-1 downto 0) := (others=>'1');
    begin
        -- Upper bound is stored_bounds(i, 1)
        -- Lower bound is stored_bounds(i, 0)
        U1: for i in 0 to M-1 generate
        begin
            lower(i) <= (normalized_data(i) - resize(unsigned(pattern(i,0)),N+1));
            upper(i) <= (pattern(i,1) - resize(normalized_data(i),N+1));
            boundMatch(i) <= (not lower(i)(N)) and (not upper(i)(N));
        end generate;
        
        match <= '1' when (boundMatch = all_ones) else '0';

end boundaryComp_arch;
