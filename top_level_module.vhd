library ieee;
use ieee.std_logic_1164.all;


entity top_level_module is
	generic (
		gen_init_seed : std_logic_vector(31 downto 0) := x"faf1fafc"
	);
	port 
	(
		clk 			: in  std_logic; 		--out clk
		rst			: in  std_logic;
		data			: in 	std_logic_vector(31 downto 0);
		--key_in 		: in  std_logic;
		gen_enable	: in  std_logic := '1';
		hex_a_out	: out std_logic_vector(6 downto 0);
		hex_b_out	: out std_logic_vector(6 downto 0);
		hex_c_out	: out std_logic_vector(6 downto 0);
		hex_d_out	: out std_logic_vector(6 downto 0)
	);

end top_level_module;

architecture rtl of top_level_module is

	--COMPONENT key_controller
	component key_controller is
		port 
		(
			clk 	: in  std_logic; 	--clk from frequency controller
			key_in 	: in  std_logic;	--input key data
			key_out : out std_logic		--output key data
		);
	end component key_controller;
	
	component frequency_controller is
		generic
		(
			 FREQUENCY_IN 			: natural := 5_000_000;
			 FREQUENCY_OUT_KC 	: natural := 1_000_000;
			 FREQUENCY_OUT_GEN 	: natural := 1_000_000;
			 FREQUENCY_OUT_MAIN 	: natural := 1_000_000;
			 FREQUENCY_OUT_SSC 	: natural := 1_000_000
		);
		port 
		(
			clk 		 : in  std_logic;	--clk input from top level module
			clk_out_main : out std_logic;	--output to main block
			clk_out_kc	 : out std_logic;	--output to key controller
			clk_out_gen	 : out std_logic;
			clk_out_ssc	 : out std_logic
		);
	end component frequency_controller;
	
	component main_block is
		port 
		(
			clk				: in  std_logic;
			rst				: in  std_logic;
			gen_enable		: in  std_logic;
			key_in			: in  std_logic;
			nios_data_in	: in  std_logic_vector(15 downto 0);
			gen_data_in		: in  std_logic_vector(15 downto 0);
			start_gen_out	: out std_logic;
			data_out			: out std_logic_vector(15 downto 0)
		);

	end component main_block;
	
	component generator is
		generic (
        -- Default seed value.
			init_seed:  std_logic_vector(31 downto 0) 
		);

		port (
        -- Clock, rising edge active.
        clk:        in  std_logic;
        -- High when the user accepts the current random data word
        -- and requests new random data for the next clock cycle.
		  rst	: 			in std_logic;
        out_ready:  in  std_logic;
        -- High when valid random data is available on the output.
        -- This signal is low during the first clock cycle after reset and
        -- after re-seeding, and high in all other cases.
        out_valid:  out std_logic;
        -- Random output data (valid when out_valid = '1').
        -- A new random word appears after every rising clock edge
        -- where out_ready = '1'.
        out_data:   out std_logic_vector(15 downto 0) 
	 );
	end component generator;

	component seven_segment_controller is
		port 
		(
			clk 			: in 	std_logic;
			data_in		: in 	std_logic_vector(15 downto 0);
			dataA_out	: out std_logic_vector(6 downto 0);
			dataB_out	: out std_logic_vector(6 downto 0);
			dataC_out	: out std_logic_vector(6 downto 0);
			dataD_out	: out std_logic_vector(6 downto 0)
		);
	end component seven_segment_controller;
	
--INTERAL OUTPUT SIGNALS
signal key_kc_main 	: std_logic; 		--data out from key controller to main block

signal clk_fc_kc 		: std_logic;		--clk out from frequency controller to key controller
signal clk_fc_main 	: std_logic;		--clk from frequency controller to main block
signal clk_fc_gen 	: std_logic;		--clk from frequency controller to generator
signal clk_fc_ssc 	: std_logic;		--clk from frequency controller to 7 segm contr

signal data_gen_main	: std_logic_vector(15 downto 0);
--signal data_nios_main: std_logic_vector(15 downto 0);
signal data_main_scc	: std_logic_vector(15 downto 0);

--constant gen_init_seed : std_logic_vector(31 downto 0) := x"faf1fafc";
signal gen_out_ready : std_logic := '0';
signal gen_out_valid : std_logic := '0';
signal gen_out_data	: std_logic_vector(15  downto 0);


begin

l_kc: key_controller 
		port map(
			clk 				=> clk_fc_kc,		--[INPUT]  clk data from frequency controller
			key_in 			=> data(0),			--[INPUT]  input from top level module (outside)
			key_out 			=> key_kc_main		--[OUTPUT] output to internal signal
		);
		
l_fc: frequency_controller 
		port map(
			clk 				=> clk,
			clk_out_main 	=> clk_fc_main,
			clk_out_kc		=> clk_fc_kc,
			clk_out_gen		=> clk_fc_gen,
			clk_out_ssc		=> clk_fc_ssc
		);

l_main: main_block 
		port map(
			clk				=> clk_fc_main,
			rst 				=> rst,
			gen_enable		=> gen_enable,
			key_in 			=> key_kc_main,
			nios_data_in	=> data(16 downto 1),
			gen_data_in		=> data_gen_main,
			start_gen_out	=> gen_out_ready,
			data_out			=> data_main_scc
			
		);
		
l_gen: generator 
		generic map(
			init_seed => gen_init_seed
		)
		port map(
			clk 			=> clk_fc_gen,
			rst			=> rst,
			out_ready 	=> gen_out_ready,
			out_valid  	=> gen_out_valid,
			out_data  	=> data_gen_main
		);
		
l_ssc: seven_segment_controller
		port map(
			clk				=> clk_fc_ssc,
			data_in			=> data_main_scc,
			dataA_out		=> hex_a_out,
			dataB_out		=> hex_b_out,
			dataC_out		=> hex_c_out,
			dataD_out		=> hex_d_out
		);
end rtl;
