--Engineer     : William Sutton
--Date         : 11/08/2017
--Name of file : clockDiv.vhd
--Description  : Clock divider module that divides by an arbitrary power of two. 
--Based on: http://surf-vhdl.com/how-to-implement-clock-divider-vhdl/
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clockdiv is
	port(
	  clk_in  : in  std_logic;
  	  rst     : in  std_logic;
	  div	  : in  unsigned;
--  	  div     : in  std_logic_vector(n downto 0);
  	  clk_out : out std_logic);
end clock_div;

architecture clockdiv_arch of clockdiv is

	signal clk_counter        : unsigned;
	signal clk_divider        : unsigned;
	signal half_clk_divider   : unsigned;


begin

	process(i_rst,i_clk) begin
		if(i_rst='0') then
			clk_counter       <= (others=>'0');
			clk_divider       <= (others=>'0');
			half_clk_divider  <= (others=>'0');
			clk_out             <= '0';
		
		elsif(rising_edge(i_clk)) then
			clk_divider       <= unsigned(div)-1;
			half_clk_divider  <= unsigned('0'&div(div'length-1 downto 1));
			
			if(clk_counter < half_clk_divider) then 
				clk_counter   <= clk_counter + 1;
				clk_out          <= '0';
    	
    			elsif(clk_counter = clk_divider) then
				clk_counter   <= (others=>'0');
				clk_out           <= '1';
    			
    			else
				clk_counter   <= clk_counter + 1;
				clk_out           <= '1';
    			end if;
  		end if;
	end process;
end clockdiv_arch;

