library ieee;
use ieee.std_logic_1164.all;

entity key_controller_tb is
end entity;

architecture rtl of key_controller_tb is
	component key_controller is
		port 
		(
			clk 		: in  std_logic; 	--clk from frequency controller
			key_in 	: in  std_logic;	--input key data
			key_out 	: out std_logic	--output key data
		);
	end component;

signal clk_t 		: std_logic := '0';
signal key_in_t  	: std_logic := '0';
signal key_out_t  : std_logic := '0';

begin
	inst0: key_controller 
		port map(
			clk 		=> clk_t,
			key_in 	=> key_in_t,
			key_out	=> key_out_t
		);
	--input
	process
	begin
		wait for 100ps;
		key_in_t <= '1';
		wait for 1ps;
		key_in_t <= '0';
		wait for 2ps;
		key_in_t <= '1';
		wait for 1ps;
		key_in_t <= '0';
		wait for 2ps;
		key_in_t <= '1';
		wait for 50ps;
		key_in_t <= '0';
		wait for 1ps;
		key_in_t <= '1';
		wait for 1ps;
		key_in_t <= '0';
		wait for 2ps;
		key_in_t <= '1';
		wait for 1ps;
		key_in_t <= '0';
		wait for 1ps;
		key_in_t <= '1';
		wait for 1ps;
		key_in_t <= '0';
	end process;
	
	process
	begin
		wait for 5ps;
		clk_t <= '1';
		wait for 5ps;
		clk_t <= '0';
		
	end process;
	
end rtl;