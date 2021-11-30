
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity laser_controller is
        port (  clock :	IN	STD_LOGIC;
					 laser_1_x : buffer integer;
					 laser_2_x : buffer integer;
					 laser_3_x : buffer integer;
					 laser_4_x : buffer integer;
					 laser_5_x : buffer integer;
					 laser_6_x : buffer integer;
					 laser_7_x : buffer integer;
					 laser_8_x : buffer integer;
					 laser_1_y : buffer integer;
					 laser_2_y : buffer integer;
					 laser_3_y : buffer integer;
					 laser_4_y : buffer integer;
					 laser_5_y : buffer integer;
					 laser_6_y : buffer integer;
					 laser_7_y : buffer integer;
					 laser_8_y : buffer integer;
					 las1_en : out integer;
					 las2_en : out integer;
					 las3_en : out integer;
					 las4_en : out integer;
					 las5_en : out integer;
					 las6_en : out integer;
					 las7_en : out integer;
					 las8_en : OUT INTEGER;
                ship_x: in integer;
					 ship_y: in integer;
					 fire: in std_logic);
		end laser_controller;

architecture bh of laser_controller is



signal start_laser: std_logic := '0'; 
signal laser_state: integer := 0;
signal counter,reset_counter,laser_counter : integer := 0;

begin

starting: process(fire,counter)

begin 

	if((fire'event and fire = '1')) then
		if (counter >= 10000000) then
			reset_counter <= 1;
			case laser_state is
				when 0 =>
					las1_en <= 1;
					laser_state <= 1;
					start_laser <= '1';
					
				when 1 =>
					las2_en <= 1;
					laser_state <= 2;
					start_laser <= '1';
					
				when 2 =>
					las3_en <= 1;
					laser_state <= 3;
					start_laser <= '1';
					
				when 3 =>
					las4_en <= 1;
					laser_state <= 4;
					start_laser <= '1';
					
				when 4 =>
					las5_en <= 1;
					laser_state <= 5;
					start_laser <= '1';
					
				when 5 =>
					las6_en <= 1;
					laser_state <= 6;
					start_laser <= '1';
					
				when 6 =>
					las7_en <= 1;
					laser_state <= 7;
					start_laser <= '1';
					
				when 7 =>
					las8_en <= 1;
					laser_state <= 0;
					start_laser <= '1';
					
				when others =>
					las1_en <= 1;
					laser_state <= 0;
					start_laser <= '1';
					
			end case;
		else 
			reset_counter <= 0;
			start_laser <= '0';
		end if;
	end if;
	
end process starting;

counting : process(clock,reset_counter)
	begin
	if(rising_edge(clock)) then
		if(reset_counter = 1) then
			counter <= 0;
		else 
			counter <= counter +1;
		end if;
	end if;
end process counting;

laser_change : process(clock,start_laser,ship_x,ship_y)
	begin
	if((clock'event and clock = '1')) then 
		if(laser_counter >= 100000) then
		
			laser_counter <=0;
			
			laser_1_x <= laser_1_x + 1;	
			
			laser_2_x <= laser_2_x + 1;	
			
			laser_3_x <= laser_3_x + 1;	
			
			laser_4_x <= laser_4_x + 1;	
			
			laser_5_x <= laser_5_x + 1;	
			
			laser_6_x <= laser_6_x + 1;	
			
			laser_7_x <= laser_7_x + 1;	
			
			laser_8_x <= laser_8_x + 1;
			
			if(laser_1_x > 850) then 
				laser_1_x <= 849;
			end if;
			if(laser_2_x > 850) then 
				laser_2_x <= 849;
			end if;
			if(laser_3_x > 850) then 
				laser_3_x <= 849;
			end if;
			if(laser_4_x > 850) then 
				laser_4_x <= 849;
			end if;
			if(laser_5_x > 850) then 
				laser_5_x <= 849;
			end if;
			if(laser_6_x > 850) then 
				laser_6_x <= 849;
			end if;
			if(laser_7_x > 850) then 
				laser_7_x <= 849;
			end if;
			if(laser_8_x > 850) then 
				laser_8_x <= 849;
			end if;
			
		else
			laser_counter <= laser_counter + 1;
			if(start_laser = '1') then
				case laser_state is
				when 0 =>
					laser_1_x <= ship_x;
					laser_1_y <= ship_y + 19;
				when 1 =>
					laser_2_x <= ship_x;
					laser_2_y <= ship_y + 19;
				when 2 =>
					laser_3_x <= ship_x;
					laser_3_y <= ship_y + 19;
				when 3 =>
					laser_4_x <= ship_x;
					laser_4_y <= ship_y + 19;
				when 4 =>
					laser_5_x <= ship_x;
					laser_5_y <= ship_y + 19;
				when 5 =>
					laser_6_x <= ship_x;
					laser_6_y <= ship_y + 19;
				when 6 =>
					laser_7_x <= ship_x;
					laser_7_y <= ship_y + 19;
				when 7 =>
					laser_8_x <= ship_x;
					laser_8_y <= ship_y + 19;
				when others =>
					laser_8_x <= ship_x;
					laser_8_y <= ship_y + 19;
			end case;
			end if;	
				
		end if;
	end if;
	
	end process laser_change;

end bh;