library ieee;
use ieee.std_logic_1164.all;

entity frequency_manager is
  
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
  
end frequency_manager;

architecture rtl of frequency_manager is
  
  signal clk_r : std_logic := '0';
begin
  process (clk ) is 
    variable count : natural := 0; 
  begin
    if(rising_edge(clk)) then
      if(count=((FREQUENCY_IN/2)/FREQUENCY_OUT)-1) then
        clk_r <= not clk_r;
        count := 0;
      else
        count := count + 1;
      end if;
      
    end if;
  end process;
  clk_out <= clk_r;

end rtl;