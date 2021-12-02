library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sound_system is
	port(clk : in std_logic;
			ship_crash : in std_logic;
			invicible : in std_logic;
			laser : in std_logic;
			obj_destroy : in std_logic;
			sound_out : buffer std_logic
			);

end entity sound_system;

architecture arch of sound_system is

	
	signal crash : std_logic;
	signal counter_crash, counter_laser, counter_obj : integer := 0;
	signal timer_crash, timer_laser, timer_obj : integer := 0;
	signal flag_crash, flag_timer, flag_obj : std_logic := '0';
	
begin

	crash <= ship_crash and not invicible;
	
	TIMER: process(clk) is
	begin
	
	if(rising_edge(clk)) then
	
		if(crash = '1' and flag_crash = '0') then
			timer_crash <= 7500000;
			--timer_crash <= 50000000;
			flag_crash <= '1';
		end if;
		
		if(flag_crash = '1') then
			if(timer_crash >= 1) then
				timer_crash <= timer_crash - 1;
				
				if(counter_crash > 0) then
					counter_crash <= counter_crash - 1;
				else
					counter_crash <= 25000;
					
					if(sound_out = '1') then
						sound_out <= '0';
					else
						sound_out <= '1';
					end if;
					
				end if;
				
			else
				flag_crash <= '0';
			end if;
			
		end if;
		
	end if;
	
	end process;
	

end architecture arch;