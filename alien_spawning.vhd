library   ieee;
use       ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
--use IEEE.std_logic_arith.all;

entity alien_spawning is

	port(clk : in std_logic;
			S_status : buffer std_logic;
			M_status : buffer std_logic;
			L_status : buffer std_logic;			
			S_y : out integer;
			M_y : out integer;
			L_y : out integer;
			S_x : in integer;
			M_x : in integer;
			L_x : in integer
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
					M_yVar:= M_yVar + 200;
					
					if(M_yVar > 400) then
						M_yVar := M_yVar - 200;
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