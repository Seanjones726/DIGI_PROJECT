library   ieee;
use       ieee.std_logic_1164.all;
use 	ieee.numeric_std.all;

package terrain_pkg is
		type terrain_x_array is array (0 to 10) of integer range 0 to 704;
		type terrain_y_array is array (0 to 10) of integer range 420 to 448;
end package;

library   ieee;
use       ieee.std_logic_1164.all;
use 	ieee.numeric_std.all;
use 	work.terrain_pkg.all;

entity terrain is
	
	port(clk : in std_logic;
		x_array : buffer terrain_x_array := (64,128,192,256,320,384,448,512,576,640,704);
		y_array : buffer terrain_y_array := (others => 420)
		-- t1x : buffer integer := 64;
		-- t2x : buffer integer := 128;
		-- t3x : buffer integer := 192;
		-- t4x : buffer integer := 256;
		-- t5x : buffer integer := 320;
		-- t6x : buffer integer := 384;
		-- t7x : buffer integer := 448;
		-- t8x : buffer integer := 512;
		-- t9x : buffer integer := 576;
		-- t10x : buffer integer := 640;
		-- t11x : buffer integer := 704;
		-- t1y : buffer integer := 448;
		-- t2y : buffer integer := 448;
		-- t3y : buffer integer := 448;
		-- t4y : buffer integer := 448;
		-- t5y : buffer integer := 448;
		-- t6y : buffer integer := 448;
		-- t7y : buffer integer := 448;
		-- t8y : buffer integer := 448;
		-- t9y : buffer integer := 448;
		-- t10y : buffer integer := 448;
		-- t11y : buffer integer := 448 
	);

end entity;

architecture arch of terrain is

	component PRNG is
		port(clk	: in	STD_LOGIC;
			  set_bits	:	in STD_LOGIC;
			  bits_out	: out	STD_LOGIC_VECTOR(7 DOWNTO 0));
	end component;
	
	signal prng_clk : std_logic;
	signal prng_rst : std_logic := '1';
	signal prng_out : std_logic_vector(7 downto 0);
	signal y_val : integer := 448;
	signal counter : integer := 0;
	
	
begin	

	U1 : PRNG port map(clk, prng_rst, prng_out);
	
	CHECK: process(clk) is
	variable var_x_array : terrain_x_array := x_array;
	variable y_start : integer := 64;
	variable up_down : std_logic;
	variable y_temp : integer := y_val;
	begin
		if(rising_edge(clk)) then
		
			if(prng_rst = '1') then
				prng_rst <= '0';
				
				for s in 0 to 10 loop
						x_array(s) <= y_start;
						y_start := y_start + 64;
						y_array(s) <= 448;
				end loop;
			else
				
				if(prng_clk = '1') then
					prng_clk <= '0';			
					
				end if;
				
				if(counter >= 300000) then
					
					for i in 0 to 10 loop
						--var_x_array(i) := var_x_array(i) - 1;
						x_array(i) <= x_array(i) - 1;
					end loop;
					
					counter <= 0;
				else
					counter <= counter + 1;
				end if;
				
				for j in 0 to 10 loop
					
					--if(var_x_array(j) <= 1) then
					if(x_array(j) = 0) then
						y_array(j) <= y_val;
						--var_x_array(j) := 704;
						x_array(j) <= 704;
						prng_clk <= '1';
					end if;
					
				end loop;
				
				--x_array <= var_x_array;
				
			end if;
			
			if(prng_out >= "01111111") then
				up_down := '1';
			else
				up_down := '0';
			end if;
			
			if(up_down = '1') then
				y_temp := y_temp - 1;
			else
				y_temp := y_temp + 1;
			end if;
			
			if(y_temp > 448) then
				y_temp := 448;
			elsif(y_temp < 420) then
				y_temp := 420;
			end if;
			
			y_val <= y_temp;
		
		end if;
	
	end process CHECK;
	
--	RNG: process(prng_out) is
--	variable up_down : std_logic;
--	variable y_temp : integer := y_val;
--	begin
--	
--		if(prng_out >= "01111111") then
--			up_down := '1';
--		else
--			up_down := '0';
--		end if;
--		
--		if(up_down = '1') then
--			y_temp := y_temp - 2;
--		else
--			y_temp := y_temp + 2;
--		end if;
--		
--		if(y_temp > 448) then
--			y_temp := 448;
--		elsif(y_temp < 350) then
--			y_temp := 350;
--		end if;
--		
--		y_val <= y_temp;
--	
--	end process RNG;

end architecture;