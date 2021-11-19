library   ieee;
use       ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Alien_Movement is
	PORT(clk : in std_logic;
		enable : in std_logic;
		counter : buffer integer := 0;
		x_pos : out integer	
	);
end entity Alien_Movement;


architecture arch of Alien_Movement is
signal temp : integer := 0;
--signal counter : integer := 0;

begin
	
	process(clk, enable) is
	--variable cnt : integer := counter;
	--variable x : integer := x_pos;
	begin
	
		
		if(enable = '1') then
			if(rising_edge(clk)) then
				if((counter = 390000)) then
					temp <= temp - 1;
					--cnt := 0;
					counter <= 0;
				else
					--cnt := cnt + 1;
					counter <= counter + 1;
				end if;
			end if;
		else
			temp <= 640;
		end if;
		
		
		
		
		--counter <= cnt;
	end process;
		x_pos <= temp;

end architecture arch;