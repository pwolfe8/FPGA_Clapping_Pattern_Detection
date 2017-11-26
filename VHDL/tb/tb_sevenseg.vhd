--Engineer     : Philip Wolfe
--Date         : 11/20/2017
--Name of file : tb_sevenseg.vhd
--Description  : Test bench for sevenseg.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.TYPE_PACK.all;


entity tb_sevenseg is
    port (
        -- inputs --
        clk     : in  std_logic;
        btnC    : in  std_logic; -- advance to next state
        btnL    : in  std_logic; -- reset to idle state
        sw      : in  std_logic_vector(3 downto 0); -- switches for pattern_in
        -- outputs --
        seg     : out std_logic_vector(6 downto 0); -- sseg control signals
        an      : out std_logic_vector(3 downto 0)  -- selects the sseg to write to
    );
end tb_sevenseg;

architecture tb_sevenseg_arch of tb_sevenseg is
    -- signal declarations
    signal state : T_state := IDLE;
    signal btnC_buf : std_logic_vector(3 downto 0);
    signal advance_state : std_logic;

begin
    -- select sseg 0 all the time
    an <= (others=>'0');

    -- manage advance_state
    advance_state  <= btnC(3) and btnC(2) and btnC(1) and btnC(0);

    -- advance the state every time btnC is pressed
    process ( clk, btnL, advance_state ) begin
        if ( btnL='1' ) then --reset to idle
            state <= IDLE;
        elsif ( rising_edge(clk) ) then
            btnC_buf <= btnC & btnC_buf(3 downto 1); -- shift in new val
            if(advance_state='1') then
                -- insert case statement for transition logic here
            end if;
        end if;
    end process;

    -- instantiate sseg module and connect to input buttons and output sseg
    DUT : entity work.sevenseg
        port map (
            -- inputs --
            rst => btnL,-- left button resets
            patternIn => sw,
            state => state, -- this should change based on the center button
            -- ouputs --
            seg => seg,
            an => an
        );

end tb_sevenseg_arch;
