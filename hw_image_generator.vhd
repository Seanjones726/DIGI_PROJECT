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
  
	row_a : INTEGER := 16;
	row_b : INTEGER := 32;
	row_c : INTEGER := 48;
	row_d : INTEGER := 64;
	row_e : INTEGER := 80;
	row_f : INTEGER := 96;
	row_g : INTEGER := 112;
	row_h : INTEGER := 128;
	row_i : INTEGER := 144;
	row_j : INTEGER := 160;
	row_k : INTEGER := 176;
	row_l	: INTEGER := 192;
	row_m : INTEGER := 208;
	row_n	: INTEGER := 224;
	row_o : INTEGER := 240;
	row_p : INTEGER := 256;
    
	col_a : INTEGER := 40;
	col_b : INTEGER := 80;
	col_c : INTEGER := 120;
	col_d : INTEGER := 160;
	col_e : INTEGER := 200;
	col_f : INTEGER := 240;
	col_g : INTEGER := 280;
	col_h : INTEGER := 320;
	col_i : INTEGER := 360;
	col_j : INTEGER := 400;
	col_k : INTEGER := 440;
	col_l	: INTEGER := 480;
	col_m : INTEGER := 520;
	col_n	: INTEGER := 560;
	col_o : INTEGER := 600;
	col_p : INTEGER := 640

	);  
  PORT(
    disp_ena :  IN   STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
    row      :  IN   INTEGER;    --row pixel coordinate
    column   :  IN   INTEGER;    --column pixel coordinate
	 triangle_start_h : IN INTEGER;
	 triangle_start_v : IN INTEGER;
    red      :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
    green    :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
    blue     :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0')); --blue magnitude output to DAC
END hw_image_generator;

ARCHITECTURE behavior OF hw_image_generator IS
BEGIN
  triangle_generate : PROCESS(row, column)
  
  variable triangle_x : INTEGER := (row-triangle_start_v)+triangle_start_h;
  variable triangle_y : INTEGER := triangle_start_v + (20);
  BEGIN
  
		IF(column <= triangle_x) and (column >= triangle_start_h) and (row >= triangle_start_v) and (row <= triangle_y) then
			red <= (OTHERS => '1');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
		ELSE                           --blanking time
			red <= (OTHERS => '0');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
		END IF;
	  
  END PROCESS triangle_generate;
  
  
END behavior;
