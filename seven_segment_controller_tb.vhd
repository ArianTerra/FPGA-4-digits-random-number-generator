library ieee;
use ieee.std_logic_1164.all;

entity seven_segment_controller_tb is
end entity;

architecture rtl of seven_segment_controller_tb is
	component seven_segment_controller is
		port 
		(
			clk 		: in  std_logic;
			data_in		: in  std_logic_vector(15 downto 0);
			dataA_out	: out std_logic_vector(6 downto 0);
			dataB_out	: out std_logic_vector(6 downto 0);
			dataC_out	: out std_logic_vector(6 downto 0);
			dataD_out	: out std_logic_vector(6 downto 0)
		);
	end component;

signal clk_t 			: std_logic; 		--out clk
signal data_in_t		: std_logic_vector(15 downto 0);
signal dataA_out_t	: std_logic_vector(6 downto 0);
signal dataB_out_t	: std_logic_vector(6 downto 0);
signal dataC_out_t	: std_logic_vector(6 downto 0);
signal dataD_out_t	: std_logic_vector(6 downto 0);
	
begin
		inst0: seven_segment_controller 
		port map(
			clk 			=> clk_t,
			data_in => data_in_t,
			dataA_out => dataA_out_t,
			dataB_out => dataB_out_t,
			dataC_out => dataC_out_t,
			dataD_out => dataD_out_t
		);
	--input
	process
	begin
		wait for 100ps;
		data_in_t <= "1111000010100101";
		wait for 100ps;
		data_in_t <= "0001100011110000";
	end process;
	
	process
	begin
		wait for 10ps;
		clk_t <= '1';
		wait for 10ps;
		clk_t <= '0';
		
	end process;
	
end rtl;