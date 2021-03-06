library ieee;
use ieee.std_logic_1164.all;

entity frequency_controller is
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

end frequency_controller;

architecture rtl of frequency_controller is

 component frequency_manager is
  
    generic
    (
      FREQUENCY_IN : natural := 50_000_000;
      FREQUENCY_OUT : natural := 1_000_000
    );
    
    port 
    (
      clk  : in std_logic;
      clk_out : out std_logic
    );
    
  end component frequency_manager;

begin
  l1:frequency_manager 
    generic map(FREQUENCY_IN,FREQUENCY_OUT_KC)
    port map(
      clk => clk,
      clk_out => clk_out_kc
    );
  l2:frequency_manager 
    generic map(FREQUENCY_IN,FREQUENCY_OUT_GEN)
    port map(
      clk => clk,
      clk_out => clk_out_gen
    );
  l3:frequency_manager 
    generic map(FREQUENCY_IN,FREQUENCY_OUT_MAIN)
    port map(
      clk => clk,
      clk_out => clk_out_main
    );
	l4:frequency_manager 
    generic map(FREQUENCY_IN,FREQUENCY_OUT_SSC)
    port map(
      clk => clk,
      clk_out => clk_out_ssc
    );
end rtl;
