library   ieee;
use       ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
--use IEEE.std_logic_arith.all;

entity alien_spawning is

	port(clk : in std_logic;
			S_status : buffer std_logic;
			M_status : buffer std_logic;
			L_status : buffer std_logic;			
			S_y : buffer integer;
			M_y : buffer integer;
			L_y : buffer integer;
			S_x : in integer;
			M_x : in integer;
			L_x : in integer;
			score : buffer integer;
			laser_1_x : in integer;
			laser_2_x : in integer;
			laser_3_x : in integer;
			laser_4_x : in integer;
			laser_5_x : in integer;
			laser_6_x : in integer;
			laser_7_x : in integer;
			laser_8_x : in integer;
			laser_1_y : in integer;
			laser_2_y : in integer;
			laser_3_y : in integer;
			laser_4_y : in integer;
			laser_5_y : in integer;
			laser_6_y : in integer;
			laser_7_y : in integer;
			laser_8_y : in integer
		);
end entity alien_spawning;

architecture arch of alien_spawning is
signal alien_num : integer := 0;
signal counter : integer := 0;
signal prng_set : std_logic := '1';
signal prng_out : std_logic_vector(7 DOWNTO 0);
signal set_pos : std_logic := '0';
signal S_yPos : integer := 50;
signal M_yPos : integer := 200;
signal L_yPos : integer := 300;

	component PRNG is
		port(clk	: in	STD_LOGIC;
			  set_bits	:	in STD_LOGIC;
			  bits_out	: out	STD_LOGIC_VECTOR(7 DOWNTO 0));
	end component PRNG;

begin

	RNG: PRNG port map(set_pos,prng_set,prng_out);
	
	process(clk) is
	variable prng_val : integer := to_integer(unsigned(prng_out));
	variable set_y : std_logic := set_pos;
	variable L_yVar : integer := L_yPos;
	variable M_yVar : integer := M_yPos;
	variable S_yVar : integer := S_yPos;
	begin
		
		if(rising_edge(clk)) then
			if((counter >= 78000) and (set_y ='0')) then
				counter <= 0;
				set_y := '1';
			elsif(set_y = '0') then
				counter <= counter + 1;
			end if;
			
			if(set_y = '1') then
			
				if(L_status = '0') then
					--L_y <= (((prng_val * 480) / 255) + 130);
					L_y <= L_yVar;
					L_yVar:= L_yVar + 100;
					
					if(L_yVar > 350) then
						L_yVar := L_yVar - 350;
					elsif(L_yVar < 30) then
						L_yVar := 30;
					end if;
					
					L_yPos <= L_yVar;
					set_y := '0';
					L_status <= '1';
				elsif(M_status = '0') then
					--M_y <= (((prng_val * 530) / 255) + 80);
					M_y <= M_yVar;
					M_yVar:= M_yVar + 150;
					
					if(M_yVar > 400) then
						M_yVar := M_yVar - 375;
					elsif(M_yVar < 30) then
						M_yVar := 30;
					end if;
					
					M_yPos <= M_yVar;
					set_y := '0';
					M_status <= '1';
				elsif(S_status = '0') then
					--S_y <= (((prng_val * 560) / 255) + 50);
					S_y <= S_yVar;
					S_yVar:= S_yVar + 300;
					
					if(S_yVar > 430) then
						S_yVar := S_yVar - 400;
					elsif(S_yVar < 30) then
						S_yVar := 30;
					end if;
					
					S_yPos <= S_yVar;
					set_y := '0';
					S_status <= '1';
				end if;
				
			end if;
			
			if(((laser_1_x + 19) >= (L_x - 100)) and (laser_1_y <= (L_y + 100)) and (laser_1_y >= L_y) and ((laser_1_x + 19) <= L_x)) then
				L_status <= '0';
				score <= score + 1;
			elsif(((laser_2_x + 19) >= (L_x - 100)) and (laser_2_y <= (L_y + 100)) and (laser_2_y >= L_y) and ((laser_2_x + 19) <= L_x)) then
				L_status <= '0';
				score <= score + 1;
			elsif(((laser_3_x + 19) >= (L_x - 100)) and (laser_3_y <= (L_y + 100)) and (laser_3_y >= L_y) and ((laser_3_x + 19) <= L_x)) then
				L_status <= '0';
				score <= score + 1;
			elsif(((laser_4_x  + 19) >= (L_x - 100)) and (laser_4_y <= (L_y + 100)) and (laser_4_y >= L_y) and ((laser_4_x + 19) <= L_x)) then
				L_status <= '0';
				score <= score + 1;
			elsif(((laser_5_x  + 19) >= (L_x - 100)) and (laser_5_y <= (L_y + 100)) and (laser_5_y >= L_y) and ((laser_5_x + 19) <= L_x)) then
				L_status <= '0';
				score <= score + 1;
			elsif(((laser_6_x + 19) >= (L_x - 100)) and (laser_6_y <= (L_y + 100)) and (laser_6_y >= L_y) and ((laser_6_x + 19) <= L_x)) then
				L_status <= '0';
				score <= score + 1;
			elsif(((laser_7_x + 19) >= (L_x - 100)) and (laser_7_y <= (L_y + 100)) and (laser_7_y >= L_y) and ((laser_7_x + 19) <= L_x)) then
				L_status <= '0';
				score <= score + 1;
			elsif(((laser_8_x + 19) >= (L_x - 100)) and (laser_8_y <= (L_y + 100)) and (laser_8_y >= L_y) and ((laser_8_x + 19) <= L_x)) then
				L_status <= '0';
				score <= score + 1;
			end if;
			
			if(((laser_1_x + 19) >= (M_x - 50)) and (laser_1_y <= (M_y + 50)) and (laser_1_y >= M_y) and ((laser_1_x + 19) <= M_x)) then
				M_status <= '0';
				score <= score + 5;
			elsif(((laser_2_x + 19) >= (M_x - 50)) and (laser_2_y <= (M_y + 50)) and (laser_2_y >= M_y) and ((laser_2_x + 19) <= M_x)) then
				M_status <= '0';
				score <= score + 5;
			elsif(((laser_3_x + 19) >= (M_x - 50)) and (laser_3_y <= (M_y + 50)) and (laser_3_y >= M_y) and ((laser_3_x + 19) <= M_x)) then
				M_status <= '0';
				score <= score + 5;
			elsif(((laser_4_x  + 19) >= (M_x - 50)) and (laser_4_y <= (M_y + 50)) and (laser_4_y >= M_y) and ((laser_4_x + 19) <= M_x)) then
				M_status <= '0';
				score <= score + 5;
			elsif(((laser_5_x  + 19) >= (M_x - 50)) and (laser_5_y <= (M_y + 50)) and (laser_5_y >= M_y) and ((laser_5_x + 19) <= M_x)) then
				M_status <= '0';
				score <= score + 5;
			elsif(((laser_6_x + 19) >= (M_x - 50)) and (laser_6_y <= (M_y + 50)) and (laser_6_y >= M_y) and ((laser_6_x + 19) <= M_x)) then
				M_status <= '0';
				score <= score + 5;
			elsif(((laser_7_x + 19) >= (M_x - 50)) and (laser_7_y <= (M_y + 50)) and (laser_7_y >= M_y) and ((laser_7_x + 19) <= M_x)) then
				M_status <= '0';
				score <= score + 5;
			elsif(((laser_8_x + 19) >= (M_x - 50)) and (laser_8_y <= (M_y + 50)) and (laser_8_y >= M_y) and ((laser_8_x + 19) <= M_x)) then
				M_status <= '0';
				score <= score + 5;
			end if;
			
			if(((laser_1_x + 19) >= (S_x - 20)) and (laser_1_y <= (S_y + 20)) and (laser_1_y >= S_y) and ((laser_1_x + 19) <= S_x)) then
				S_status <= '0';
				score <= score + 10;
			elsif(((laser_2_x + 19) >= (S_x - 20)) and (laser_2_y <= (S_y + 20)) and (laser_2_y >= S_y) and ((laser_2_x + 19) <= S_x)) then
				S_status <= '0';
				score <= score + 10;
			elsif(((laser_3_x + 19) >= (S_x - 20)) and (laser_3_y <= (S_y + 20)) and (laser_3_y >= S_y) and ((laser_3_x + 19) <= S_x)) then
				S_status <= '0';
				score <= score + 10;
			elsif(((laser_4_x  + 19) >= (S_x - 20)) and (laser_4_y <= (S_y + 20)) and (laser_4_y >= S_y) and ((laser_4_x + 19) <= S_x)) then
				S_status <= '0';
				score <= score + 10;
			elsif(((laser_5_x  + 19) >= (S_x - 20)) and (laser_5_y <= (S_y + 20)) and (laser_5_y >= S_y) and ((laser_5_x + 19) <= S_x)) then
				S_status <= '0';
				score <= score + 10;
			elsif(((laser_6_x + 19) >= (S_x - 20)) and (laser_6_y <= (S_y + 20)) and (laser_6_y >= S_y) and ((laser_6_x + 19) <= S_x)) then
				S_status <= '0';
				score <= score + 10;
			elsif(((laser_7_x + 19) >= (S_x - 20)) and (laser_7_y <= (S_y + 20)) and (laser_7_y >= S_y) and ((laser_7_x + 19) <= S_x)) then
				S_status <= '0';
				score <= score + 10;
			elsif(((laser_8_x + 19) >= (S_x - 20)) and (laser_8_y <= (S_y + 20)) and (laser_8_y >= S_y) and ((laser_8_x + 19) <= S_x)) then
				L_status <= '0';
				score <= score + 10;
			end if;
			
			if(S_x <= 1) then
				S_status <= '0';
			elsif(M_x <= 1) then
				M_status <= '0';
			elsif(L_x <= 1) then
				L_status <= '0';
			end if;
			
		end if;
		
		
		
		if(prng_set = '1') then
			prng_set <= '0';
		end if;
		
		set_pos <= set_y;
	end process;

end architecture arch;