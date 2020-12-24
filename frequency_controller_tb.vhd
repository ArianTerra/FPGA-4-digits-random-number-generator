library ieee;
use ieee.std_logic_1164.all;

entity frequency_controller_tb is
end entity;

architecture rtl of frequency_controller_tb is
	component frequency_controller is
		generic
		(
		 FREQUENCY_IN 			: natural := 50_000_000;
		 FREQUENCY_OUT_KC 	: natural := 1_000_000;
		 FREQUENCY_OUT_GEN 	: natural := 1_000_000;
		 FREQUENCY_OUT_MAIN 	: natural := 1_000_000;
		 FREQUENCY_OUT_SSC 	: natural := 1_000_000
		);	
		port 
		(
			clk 		 	 : in  std_logic;	--clk input from top level module
			clk_out_main : out std_logic;	--output to main block
			clk_out_kc	 : out std_logic;	--output to key controller
			clk_out_gen	 : out std_logic;
			clk_out_ssc	 : out std_logic
		);
	end component;

signal clk_t 		: std_logic := '0';
signal clk_out_main_t 	: std_logic := '0';
signal clk_out_kc_t	: std_logic := '0';
signal clk_out_gen_t 	: std_logic := '0';
signal clk_out_ssc_t 	: std_logic := '0';

constant FREQUENCY_IN_t 			: natural := 50_000_000;
constant	FREQUENCY_OUT_KC_t  	: natural := 1_000_000;
constant	FREQUENCY_OUT_GEN_t  	: natural := 1_000_000;
constant	FREQUENCY_OUT_MAIN_t  	: natural := 1_000_000;
constant	FREQUENCY_OUT_SSC_t 	: natural := 1_000_000;

begin
	inst0: frequency_controller 
		generic map(
			FREQUENCY_IN => FREQUENCY_IN_t , 
			FREQUENCY_OUT_KC => FREQUENCY_OUT_KC_t ,
			FREQUENCY_OUT_GEN => FREQUENCY_OUT_GEN_t ,
			FREQUENCY_OUT_MAIN => FREQUENCY_OUT_MAIN_t ,
			FREQUENCY_OUT_SSC => FREQUENCY_OUT_SSC_t 
		)
		port map(
			clk 		=> clk_t,
			clk_out_main => clk_out_main_t,
			clk_out_kc => clk_out_kc_t,
			clk_out_gen => clk_out_gen_t,
			clk_out_ssc => clk_out_ssc_t
		);
	
	process
	begin
		wait for 5ps;
		clk_t <= '1';
		wait for 5ps;
		clk_t <= '0';
		
	end process;
	
end rtl;