library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity updown_count is
    Port ( clk,rst,updown : in  STD_LOGIC;
			  min,max,origin: in integer;
           x_pos : BUFFER  integer);
end updown_count;

architecture Behavioral of updown_count is

signal counter:integer:= 1900;
signal x_pos_sig : integer := 0;


begin
process(clk,rst,updown)
begin

if(rst='1')then
	counter<=50000;
	x_pos_sig <=origin;
	
elsif(rising_edge(clk))then
	if(updown='0')then
		if(counter = 300000) then
			counter <= 0;
			if(x_pos_sig >= max) then
				x_pos_sig <= max;
			else
				x_pos_sig <= x_pos_sig +1;
			end if;
		else
			counter<=counter+1;
		end if;
	elsif(updown ='1') then
		if(counter = 0) then
			counter <= 300000;
			if(x_pos_sig <= min) then
				x_pos_sig <= min;
			else
				x_pos_sig <= x_pos_sig-1;
			end if;
		else
			counter<=counter-1;
		end if;
	end if;
end if;



end process;

x_pos<=x_pos_sig;
end Behavioral;