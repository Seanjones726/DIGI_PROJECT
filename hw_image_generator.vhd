--------------------------------------------------------------------------------
--
--   FileName:         hw_image_generator.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 64-bit Version 12.1 Build 177 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 05/10/2013 Scott Larson
--     Initial Public Release
--    
--------------------------------------------------------------------------------
--
-- Altered 10/13/19 - Tyler McCormick 
-- Test pattern is now 8 equally spaced 
-- different color vertical bars, from black (left) to white (right)


LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY hw_image_generator IS
  GENERIC(
  
	hud_line_top : INTEGER := 30;
	hud_line_bottom : INTEGER := 450;
	L_size : INTEGER := 100;
	M_size : INTEGER := 50;
	S_size : INTEGER := 20

	);  
  PORT(
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
	 Alien_S_y	:	IN INTEGER
	 
	); 
	 
END hw_image_generator;

ARCHITECTURE behavior OF hw_image_generator IS


BEGIN
  triangle_generate : PROCESS(row, column)
  
  variable triangle_x : INTEGER := (row-triangle_start_v)+triangle_start_h;
  variable triangle_y : INTEGER := triangle_start_v + (20);
  variable triangle_lives_x1 : INTEGER := row;
  variable triangle_lives_y1 : INTEGER := 20;
  variable triangle_lives_x2 : INTEGER := row + 25;
  variable triangle_lives_y2 : INTEGER := 20;
  variable triangle_lives_x3 : INTEGER := row + 50;
  variable triangle_lives_y3 : INTEGER := 20;
  variable L_xBound : INTEGER := Alien_L_x - L_size;
  variable L_yBound : INTEGER := Alien_L_y + L_size;
  variable M_xBound : INTEGER := Alien_M_x - M_size;
  variable M_yBound : INTEGER := Alien_M_y + M_size;
  variable S_xBound : INTEGER := Alien_S_x - S_size;
  variable S_yBound : INTEGER := Alien_S_y + S_size;
  
  BEGIN
		
		if(row = hud_line_top) then		--HUD LINE
			red <= (OTHERS => '1');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '1');
		elsif(row = hud_line_bottom) then
			red <= (OTHERS => '1');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '1');
		elsif(column <= triangle_lives_x1) and (column >= 0) and (row >= 0) and (row <= triangle_lives_y1) and (lives >= 1) then
			red <= (OTHERS => '1');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
		elsif(column <= triangle_lives_x2) and (column >= 25) and (row >= 0) and (row <= triangle_lives_y2) and (lives >= 2) then
			red <= (OTHERS => '1');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
		elsif(column <= triangle_lives_x3) and (column >= 50) and (row >= 0) and (row <= triangle_lives_y3) and (lives = 3) then
			red <= (OTHERS => '1');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
		elsif(column <= triangle_x) and (column >= triangle_start_h) and (row >= triangle_start_v) and (row <= triangle_y) then	--Player Triangle Start
			red <= (OTHERS => '1');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
		elsif(column <= Alien_L_x) and (column >= L_xBound) and (row >= Alien_L_y) and (row <= L_yBound) and (Alien_L_en = '1') then
			red <= (OTHERS => '1');
			green <= (OTHERS => '1');
			blue <= (OTHERS => '0');
		elsif(column <= Alien_M_x) and (column >= M_xBound) and (row >= Alien_M_y) and (row <= M_yBound) and (Alien_M_en = '1') then
			red <= (OTHERS => '0');
			green <= (OTHERS => '1');
			blue <= (OTHERS => '1');
		elsif(column <= Alien_S_x) and (column >= S_xBound) and (row >= Alien_S_y) and (row <= S_yBound) and (Alien_S_en = '1') then
			red <= (OTHERS => '0');
			green <= (OTHERS => '1');
			blue <= (OTHERS => '0');
		else
			red <= (OTHERS => '0');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
		
		END IF;
		
  END PROCESS triangle_generate;
  
  
END behavior;
