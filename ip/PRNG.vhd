library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PRNG is
	port(clk	: in	STD_LOGIC;
		  set_bits	:	in STD_LOGIC;
		  bits_out	: out	STD_LOGIC_VECTOR(7 DOWNTO 0));
end entity PRNG;

architecture PRNG_arch of PRNG is
signal D0, D1, D2, D3, D4, D5, D6, D7, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7 : STD_LOGIC;
	
	begin
				
		LFSR : process(clk, set_bits) is
		begin
			
			if(rising_edge(clk)) then
				Q0 <= D0;
				Q1 <= D1;
				Q2 <= D2;
				Q3 <= D3;
				Q4 <= D4;
				Q5 <= D5;
				Q6 <= D6;
				Q7 <= D7;
			end if;
			if(set_bits = '1') then
				Q0 <= '1';
				Q1 <= '1';
				Q2 <= '1';
				Q3 <= '1';
				Q4 <= '1';
				Q5 <= '1';
				Q6 <= '1';
				Q7 <= '1';			
			end if;
			
			D7 <= Q6;
			D6 <= Q5;
			D5 <= Q4;
			D4 <= Q3;
			D3 <= Q2;
			D2 <= Q1;
			D1 <= Q0;			
			D0 <= Q7 xor Q5 xor Q4 xor Q3;
			
			bits_out(0) <= Q0;
			bits_out(1) <= Q1;
			bits_out(2) <= Q2;
			bits_out(3) <= Q3;
			bits_out(4) <= Q4;
			bits_out(5) <= Q5;
			bits_out(6) <= Q6;
			bits_out(7) <= Q7;
		
			
		end process LFSR;

end architecture PRNG_arch;
		  