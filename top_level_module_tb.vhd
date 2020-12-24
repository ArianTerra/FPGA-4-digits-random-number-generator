library ieee;
use ieee.std_logic_1164.all;

entity top_level_module_tb is
end entity;

architecture rtl of top_level_module_tb is
	component top_level_module is
		generic (
			gen_init_seed : std_logic_vector(31 downto 0)
		);
		port 
		(
			clk 		: in  std_logic; 		--out clk
			rst		: in std_logic;
			data			: in 	std_logic_vector(31 downto 0);
			--key_in 		: in  std_logic;
			gen_enable	: in  std_logic := '1';
			hex_a_out	: out std_logic_vector(6 downto 0);
			hex_b_out	: out std_logic_vector(6 downto 0);
			hex_c_out	: out std_logic_vector(6 downto 0);
			hex_d_out	: out std_logic_vector(6 downto 0)
		);
	end component;

signal clk_t 			: std_logic; 		--out clk
signal data_t  		: std_logic_vector(31 downto 0);
signal gen_enable_t 	: std_logic := '1';
signal rst_t 	: std_logic := '0';
signal hex_a_out_t  	: std_logic_vector(6 downto 0);
signal hex_b_out_t 	: std_logic_vector(6 downto 0);
signal hex_c_out_t 	: std_logic_vector(6 downto 0);
signal hex_d_out_t 	: std_logic_vector(6 downto 0);
	
begin
		inst0: top_level_module 
		generic map (
			gen_init_seed => x"faf1fafc"
		)
		port map(
			clk 			=> clk_t,
			rst			=> rst_t,
			data 		=> data_t,
			gen_enable 	=> gen_enable_t,
			hex_a_out	=> hex_a_out_t,
			hex_b_out	=> hex_b_out_t,
			hex_c_out 	=> hex_c_out_t,
			hex_d_out	=> hex_d_out_t
		);
	--input
	process
	begin
		wait for 200ps;
		data_t(0) <= '1';
		wait for 200ps;
		data_t(0) <= '0';
	end process;
	
	process
	begin
		wait for 10ps;
		clk_t <= '1';
		wait for 10ps;
		clk_t <= '0';
		
	end process;
	
end rtl;