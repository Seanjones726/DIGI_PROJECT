library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ship_controller is
port(

		
		clk: in STD_LOGIC;
		rst: in STD_LOGIC;
		
			
		GSENSOR_CS_N : OUT	STD_LOGIC;
		GSENSOR_SCLK : OUT	STD_LOGIC;
		GSENSOR_SDI  : INOUT	STD_LOGIC;
		GSENSOR_SDO  : INOUT	STD_LOGIC;
		
		x_pos     :  OUT INTEGER;
		y_pos     :  OUT INTEGER;
		data_x      : BUFFER STD_LOGIC_VECTOR(15 downto 0);
		data_y      : BUFFER STD_LOGIC_VECTOR(15 downto 0);
		data_z      : BUFFER STD_LOGIC_VECTOR(15 downto 0));
end ship_controller;

architecture bh of ship_controller is

signal x_signal, y_signal: integer;

signal x_clock, y_clock,x_updown,y_updown: std_logic;


component ADXL345_controller is port(
	
		reset_n     : IN STD_LOGIC;
		clk         : IN STD_LOGIC;
		data_valid  : OUT STD_LOGIC;
		data_x      : OUT STD_LOGIC_VECTOR(15 downto 0);
		data_y      : OUT STD_LOGIC_VECTOR(15 downto 0);
		data_z      : OUT STD_LOGIC_VECTOR(15 downto 0);
		SPI_SDI     : OUT STD_LOGIC;
		SPI_SDO     : IN STD_LOGIC;
		SPI_CSN     : OUT STD_LOGIC;
		SPI_CLK     : OUT STD_LOGIC	
    );
end component;

component updown_count is
    Port ( clk,rst,updown : in  STD_LOGIC;
			  min,max,origin: in integer;
           x_pos : BUFFER  integer);
end component;

begin

U0 : ADXL345_controller port map('1', clk, open, data_x, data_y, data_z, GSENSOR_SDI, GSENSOR_SDO, GSENSOR_CS_N, GSENSOR_SCLK);
X1 : updown_count port map(x_clock,rst,x_updown,0,320,10,x_signal);
Y1 : updown_count port map(y_clock,rst,y_updown,30,430,300,y_signal);

process(data_x(15 downto 0),rst)
	
	begin 
	
	if(data_x(11 downto 8) = "0000") then
			if(data_x(7 downto 4) > "1000") then
				x_updown <= '1';
				x_clock <= clk;
			else 
				x_updown <= '1';
				x_clock <= '0';
			end if;
	elsif(data_x(7 downto 4) < "1000") then
			x_updown <= '0';
			x_clock <= clk;
	else
			x_updown <= '0';
			x_clock <= '0';

		
	end if;
		
	end process;
	
process (data_y(15 downto 0),rst)

	begin

	if(data_y(11 downto 8) = "0000")  then
			if(data_y(7 downto 4) > "1000") then
				y_updown <= '0';
				y_clock <= clk;
			else 
				y_updown <= '0';
				y_clock <= '1';
			end if;

		elsif(data_y(7 downto 4) < "1000") then
			y_updown <= '1';
			--clock <= clock_slow;
			y_clock <= clk;
		else
			y_updown <= '1';
			y_clock <= '1';
			--clock <= clock_fast;
		--end if;
	end if;


	end process;
	
	x_pos <= x_signal;
	y_pos <= y_signal;
	end bh;




