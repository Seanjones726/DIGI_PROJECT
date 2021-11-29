library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;


entity ship_collision_detector is
	generic(S_size : integer := 20;
				M_size : integer := 50;
				L_size : integer := 100);
	
	port(shipx	:	in integer;
			shipy	:	in integer;
			clk : in std_logic;
			S_xMax		: in integer;
			S_yMin		:	in integer;
			M_xMax		: in integer;
			M_yMin		:	in integer;
			L_xMax		: in integer;
			L_yMin		:	in integer;
			ship_reset		:	buffer std_logic;
			lives				:	out integer := 3);
			
end entity;

architecture arch of ship_collision_detector is
signal lives_sig : integer := 3;
begin
	
	--process(shipx, shipy, S_xMax, S_yMin, M_xMax, M_yMin, L_xMax, L_yMin) is
	process(clk) is
	variable ship_x1 : integer := shipx;
	variable ship_y1 : integer := shipy;
	variable ship_x2 : integer := shipx + 20;
	variable ship_y2 : integer := shipy + 20;
	variable S_xMin : integer := S_xMax - S_size;
	variable S_yMax : integer := S_yMin + S_size;
	variable M_xMin : integer := M_xMax - M_size;
	variable M_yMax : integer := M_yMin + M_size;
	variable L_xMin : integer := L_xMax - L_size;
	variable L_yMax : integer := L_yMin + L_size;
	begin
	
	if(rising_edge(clk)) then
		if(ship_y1 < L_yMax and ship_y1 > L_yMin and ship_x1 < L_xMax and ship_x1 > L_xMin) then
			ship_reset <= '1';
			lives_sig <= lives_sig - 1;		
		elsif(ship_y2 < L_yMax and ship_y2 > L_yMin and ship_x1 < L_xMax and ship_x1 > L_xMin) then
			ship_reset <= '1';
			lives_sig <= lives_sig - 1;	
		elsif(ship_y2 < L_yMax and ship_y2 > L_yMin and ship_x2 < L_xMax and ship_x2 > L_xMin) then
			ship_reset <= '1';
			lives_sig <= lives_sig - 1;
		end if;
		
		if(((ship_y1 < M_yMax) and (ship_y1 > M_yMin)) and ((ship_x1 < M_xMax) and (ship_x1 > M_xMin))) then
			ship_reset <= '1';
			lives_sig <= lives_sig - 1;		
		elsif(((ship_y2 < M_yMax) and (ship_y2 > M_yMin)) and ((ship_x1 < M_xMax) and (ship_x1 > M_xMin))) then
			ship_reset <= '1';
			lives_sig <= lives_sig - 1;	
		elsif(((ship_y2 < M_yMax) and (ship_y2 > M_yMin)) and ((ship_x2 < M_xMax) and (ship_x2 > M_xMin))) then
			ship_reset <= '1';
			lives_sig <= lives_sig - 1;
		end if;
		
		if(((ship_y1 < S_yMax) and (ship_y1 > S_yMin)) and ((ship_x1 < S_xMax) and (ship_x1 > S_xMin))) then
			ship_reset <= '1';
			lives_sig <= lives_sig - 1;		
		elsif(((ship_y2 < S_yMax) and (ship_y2 > S_yMin)) and ((ship_x1 < S_xMax) and (ship_x1 > S_xMin))) then
			ship_reset <= '1';
			lives_sig <= lives_sig - 1;	
		elsif(((ship_y2 < S_yMax) and (ship_y2 > S_yMin)) and ((ship_x2 < S_xMax) and (ship_x2 > S_xMin))) then
			ship_reset <= '1';
			lives_sig <= lives_sig - 1;
		end if;
	
	end if;
	
	if(ship_reset = '1') then
		ship_reset <= '0';
	end if;
	
	
	end process;
	lives <= lives_sig;
	
end architecture;