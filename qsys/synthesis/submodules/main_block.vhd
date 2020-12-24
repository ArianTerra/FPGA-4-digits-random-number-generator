library ieee;
use ieee.std_logic_1164.all;

entity main_block is

	port 
	(
		clk				: in  std_logic;
		rst				: in std_logic;
		gen_enable		: in  std_logic;
		key_in			: in  std_logic;
		nios_data_in	: in  std_logic_vector(15 downto 0);
		gen_data_in		: in  std_logic_vector(15 downto 0);
		start_gen_out	: out std_logic;
		data_out			: out std_logic_vector(15 downto 0)
	);

end main_block;

architecture rtl of main_block is



begin
	
	process(rst, clk, gen_enable)
	begin
	if rst = '1' then 
		data_out <= "0000000000000000";
	else 
		if gen_enable = '1' then
			data_out <= gen_data_in;
		else
			data_out <= nios_data_in;
		end if;
	end if;
	end process;
	start_gen_out <= key_in;
end rtl;
