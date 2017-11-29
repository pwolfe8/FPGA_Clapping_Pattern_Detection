--Engineer     : Philip Wolfe
--Date         : 11/22/2017
--Name of file : divider.vhd
--Description  : divides two intervals to give the ratio result
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divider is
    generic (
        R_int       : positive; -- resolution of interval
        R_ctr       : positive; -- resolution divider counter
        N_dec       : positive  -- number of fixed point decimal places
    );
    port (
        -- inputs --
        clk, reset  : in  std_logic;
        start       : in  std_logic;
        numerator   : in  unsigned(R_int-1 downto 0);
        denominator : in  unsigned(R_int-1 downto 0);
        -- outputs --
        done		: out std_logic;
        result      : out unsigned(R_int-1 downto 0)
    );
end divider;

architecture divider_arch of divider is
    -- constant definitions
    
    -- signal definitions
    signal N : unsigned(R_int+N_dec-1 downto 0); --adjusted numerator
    signal D : unsigned(R_int-1 downto 0); -- adjusted denominator
    signal done_buf, prev_done_buf : std_logic;

    -- debug signals
    -- signal counter : unsigned(R_ctr-1 downto 0);
    -- signal quotient : unsigned(R_int+N_dec-1 downto 0);
    -- signal remainder : unsigned(R_int-1 downto 0);

begin
    N <= numerator & to_unsigned(0,N_dec);
    D <= denominator;

    process ( clk, reset, start )
        variable idx : unsigned(R_ctr-1 downto 0);
        variable Q : unsigned(R_int+N_dec-1 downto 0); -- quotient
        variable R : unsigned(R_int-1 downto 0); -- remainder
    begin
        if ( reset='1' or start='1' ) then
            done <= '0';
            done_buf <= '0';
            idx := to_unsigned(R_int+N_dec-1,R_ctr);
            Q := (others=>'0');
            R := (others=>'0');
            result <= (others=>'0');
        elsif ( rising_edge(clk) ) then
        -- output to debug signals --
            -- counter <= idx;
            -- quotient <= Q;
            -- remainder <= R;

            prev_done_buf <= done_buf;
            if ( D>0 ) then
                if (idx > 0) then
                    R := R(R_int-2 downto 0) & N(to_integer(idx));
                    if ( R >= D ) then
                        R := R - D;
                        Q(to_integer(idx)) := '1';
                    end if;
                    -- decrement idx and check if done
                    idx := idx - 1;
                    if( not(idx>0) ) then
                        done_buf <= '1';
                        result <= Q(R_int-1 downto 0); -- assign Q to result
                    end if;
                end if;
                
                -- manage done signal
                if ( done_buf='1') then
                    done_buf <= '0';
                    done <= '1';
                else
                    done <= '0';
                end if;
                
            else 
                done <= '0';
                result <= (others=>'0');
            end if;
        end if;
    end process;
    
end divider_arch;
