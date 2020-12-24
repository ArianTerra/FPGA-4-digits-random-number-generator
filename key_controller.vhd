library ieee;
use ieee.std_logic_1164.all;

entity key_controller is

	port 
	(
		clk 	: in  std_logic; 	--clk from frequency controller
		key_in 	: in  std_logic;	--input key data
		key_out : out std_logic	--output key data
	);

end key_controller;

architecture rtl of key_controller is

signal O1, O2, O3 : std_logic;

begin
	strobe: process(clk) is 
	begin
		if(rising_edge(clk)) then
			O1 <= key_in;
			O2 <= O1;
			O3 <= O2;
		end if;
	end process strobe;
	key_out <= O1 and O2 and O3;
end rtl;
