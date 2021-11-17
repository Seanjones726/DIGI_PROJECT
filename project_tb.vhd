LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity project_tb is
end entity project_tb;

architecture tb of project_tb is
signal clk_in, rst : std_logic;
signal x_out : integer;

component Alien_Movement is
	PORT(clk : in std_logic;
		reset : in std_logic;
		counter : buffer integer := 0;
		x_pos : out integer	
	);
end component Alien_Movement;

begin
UUT : Alien_Movement port map(clk_in, '0', open, x_out);

	Stimulus : process
	begin
	
	
	
	wait;
	end process;

end architecture tb;