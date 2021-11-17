library   ieee;
use       ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Alien_Movement is
	PORT(clk : in std_logic;
		reset : in std_logic;
		counter : buffer integer := 0;
		x_pos : out integer	
	);
end entity Alien_Movement;


architecture arch of Alien_Movement is
signal temp : integer := 0;
--signal counter : integer := 0;

begin
	
	process(clk, reset) is
	variable cnt : integer := counter;
	--variable x : integer := x_pos;
	begin
	
		if(reset = '1') then
			temp <= 640;
		elsif(rising_edge(clk)) then
			cnt := cnt + 1;
			--counter <= counter + 1;
		end if;
		
		
		if((cnt = 390000)) then
			temp <= temp - 1;
			cnt := 0;
			--counter <= 0;
		end if;
		
		counter <= cnt;
	end process;
		x_pos <= temp;

end architecture arch;