-- ECE 4110 VGA example
--
-- This code is the top level structural file for code that can
-- generate an image on a VGA display. The default mode is 640x480 at 60 Hz
--
-- Note: This file is not where the pattern/image is produced
--
-- Tyler McCormick 
-- 10/13/2019


library   ieee;
use       ieee.std_logic_1164.all;

entity vga_top is
	
	port(
	   --Accel. Ports
		
		GSENSOR_CS_N : OUT	STD_LOGIC;
		GSENSOR_SCLK : OUT	STD_LOGIC;
		GSENSOR_SDI  : INOUT	STD_LOGIC;
		GSENSOR_SDO  : INOUT	STD_LOGIC;
		
		
		data_x      : BUFFER STD_LOGIC_VECTOR(15 downto 0);
		data_y      : BUFFER STD_LOGIC_VECTOR(15 downto 0);
		data_z      : BUFFER STD_LOGIC_VECTOR(15 downto 0);
		
		--general Keys and inputs for testing
	
		key1 : in std_logic;
		sw0 : in std_logic;
		sw1 : in std_logic;
		sw2 : in std_logic;
		-- Inputs for image generation
		
		pixel_clk_m		:	IN	STD_LOGIC;     -- pixel clock for VGA mode being used 
		reset_n_m		:	IN	STD_LOGIC; --active low asycnchronous reset
		
		-- Outputs for image generation 
		
		h_sync_m		:	OUT	STD_LOGIC;	--horiztonal sync pulse
		v_sync_m		:	OUT	STD_LOGIC;	--vertical sync pulse 
		
		red_m      :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
		green_m    :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
		blue_m     :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0') --blue magnitude output to DAC
	
	);
	
end vga_top;

architecture vga_structural of vga_top is

	component vga_pll_25_175 is 
	
		port(
		
			inclk0		:	IN  STD_LOGIC := '0';  -- Input clock that gets divided (50 MHz for max10)
			c0			:	OUT STD_LOGIC          -- Output clock for vga timing (25.175 MHz)
		
		);
		
	end component;
	
	component vga_controller is 
	
		port(
		
			pixel_clk	:	IN	STD_LOGIC;	--pixel clock at frequency of VGA mode being used
			reset_n		:	IN	STD_LOGIC;	--active low asycnchronous reset
			h_sync		:	OUT	STD_LOGIC;	--horiztonal sync pulse
			v_sync		:	OUT	STD_LOGIC;	--vertical sync pulse
			disp_ena	:	OUT	STD_LOGIC;	--display enable ('1' = display time, '0' = blanking time)
			column		:	OUT	INTEGER;	--horizontal pixel coordinate
			row			:	OUT	INTEGER;	--vertical pixel coordinate
			n_blank		:	OUT	STD_LOGIC;	--direct blacking output to DAC
			n_sync		:	OUT	STD_LOGIC   --sync-on-green output to DAC
		
		);
		
	end component;
	
	component Alien_Movement is
		PORT(clk : in std_logic;
			enable : in std_logic;
			x_start : in integer;
			counter : buffer integer := 0;
			x_pos : out integer	
		);
	end component Alien_Movement;
	
	component ship_collision_detector is
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
				lives				:	out integer);
			
	end component;
	
	component alien_spawning is

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
	end component;
	
	component pll IS
		PORT
		(
			inclk0		: IN STD_LOGIC  := '0';
			c0		: OUT STD_LOGIC 
		);
	END component;

	
	component hw_image_generator is
	
		port(
    disp_ena :  IN   STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
    row      :  IN   INTEGER;    --row pixel coordinate
    column   :  IN   INTEGER;    --column pixel coordinate
	 lives		:	IN	INTEGER;
	 triangle_start_h : IN INTEGER;
	 triangle_start_v : IN INTEGER;
    red      :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
    green    :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
    blue     :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --blue magnitude output to DAC
	 Alien_L_en	:	IN STD_LOGIC;
	 Alien_M_en	:	IN STD_LOGIC;
	 Alien_S_en	:	IN STD_LOGIC;
	 Alien_L_x	:	IN INTEGER;
	 Alien_L_y	:	IN INTEGER;
	 Alien_M_x	:	IN INTEGER;
	 Alien_M_y	:	IN INTEGER;
	 Alien_S_x	:	IN INTEGER;
	 Alien_S_y	:	IN INTEGER); 
END component;

	component ship_controller is
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
		end component;
	
	signal pll_OUT_to_vga_controller_IN, dispEn : STD_LOGIC;
	signal rowSignal, colSignal : INTEGER;
	signal lives_sig : INTEGER;
	signal L_en, M_en, S_en : STD_LOGIC := '0';
	signal L_xSig : INTEGER;-- := 400;
	signal L_ySig : INTEGER := 300;
	signal M_xSig : INTEGER;-- := 200;
	signal M_ySig : INTEGER := 200;
	signal S_xSig : INTEGER;-- := 520;
	signal S_ySig : INTEGER := 50;
	signal Lstart : INTEGER := 739;
	signal Mstart : INTEGER := 689;
	signal Sstart : INTEGER := 659;
	signal c0_sig : std_logic;
	signal ship_xSig,ship_ySig : integer;
	--signal ship_xSig,ship_ySig : integer := 330;
	signal ship_rst : std_logic;
	--signal am_rst1, am_rst2, am_rst3 : std_logic;
	
	
begin	

--L_en <= sw0;
--M_en <= sw1;
--S_en <= sw2;

pll_inst : pll PORT MAP (
		inclk0	 => pixel_clk_m,
		c0	 => c0_sig
	);

-- Just need 3 components for VGA system 
	U1	:	vga_pll_25_175 port map(pixel_clk_m, pll_OUT_to_vga_controller_IN);
	U2	:	vga_controller port map(pll_OUT_to_vga_controller_IN, reset_n_m, h_sync_m, v_sync_m, dispEn, colSignal, rowSignal, open, open);
	U3	:	hw_image_generator port map(dispEn, rowSignal, colSignal, lives_sig, ship_xSig,ship_ySig, red_m, green_m, blue_m, L_en, M_en, S_en, L_xSig, L_ySig, M_xSig, M_ySig, S_xSig, S_ySig);
	U4	:	Alien_Movement port map(clk => pixel_clk_m, enable => L_en, counter => open, x_start => Lstart, x_pos => L_xSig);
	U5	:	Alien_Movement port map(clk => pixel_clk_m, enable => M_en, counter => open, x_start => Mstart, x_pos => M_xSig);
	U6	:	Alien_Movement port map(clk => pixel_clk_m, enable => S_en, counter => open, x_start => Sstart, x_pos => S_xSig);
	U7 : ship_controller port map(pixel_clk_m,ship_rst,GSENSOR_CS_N,GSENSOR_SCLK,GSENSOR_SDI, GSENSOR_SDO,ship_xSig,ship_ySig, data_x, data_y, data_z);
	U8 : ship_collision_detector port map(ship_xSig, ship_ySig, pixel_clk_m, S_xSig, S_ySig, M_xSig, M_ySig, L_xSig, L_ySig, ship_rst, lives_sig);
	U9 : alien_spawning port map(pixel_clk_m, S_en, M_en, L_en, S_ySig, M_ySig, L_ySig, S_xSig, M_xSig, L_xSig);

end vga_structural;






