library ieee;
use ieee.std_logic_1164.all;

entity generator_tb is
end entity;

architecture rtl of generator_tb is
	component generator is
		generic (
        init_seed:  std_logic_vector(31 downto 0)
		);
    port (
        -- Clock, rising edge active.
        clk:        in  std_logic;
        -- High when the user accepts the current random data word
        -- and requests new random data for the next clock cycle.
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
	end component;
constant	gen_init_seed : std_logic_vector(31 downto 0) := x"faf1fafc";
signal gen_clk 		: std_logic := '0';
signal gen_out_ready : std_logic := '1';
signal gen_out_valid : std_logic := '0';
signal gen_out_data	: std_logic_vector(15  downto 0);

begin
	inst0: generator 
		generic map(
			init_seed => gen_init_seed
		)
		port map(
			clk 			=> gen_clk,
			out_ready 	=> gen_out_ready,
			out_valid  	=> gen_out_valid,
			out_data  	=> gen_out_data
		);
	--input
	process
	begin
		wait for 50ps;
		gen_clk <= '1';
		wait for 50ps;
		gen_clk <= '0';
	end process;
	
	--process
	--begin
	--	wait for 100ps;
	--	gen_out_ready <= '1';
	--	wait for 100ps;
	--	gen_out_ready <= '0';
	--end process;
end rtl;