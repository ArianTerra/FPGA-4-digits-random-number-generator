library ieee;
use ieee.std_logic_1164.all;

entity seven_segment_controller is
	
	port 
	(
		clk 		: in  std_logic;
		data_in		: in  std_logic_vector(15 downto 0);
		dataA_out	: out std_logic_vector(6 downto 0);
		dataB_out	: out std_logic_vector(6 downto 0);
		dataC_out	: out std_logic_vector(6 downto 0);
		dataD_out	: out std_logic_vector(6 downto 0)
	);
end seven_segment_controller;

architecture rtl of seven_segment_controller is
	function Convert(data : in std_logic_vector(3 downto 0)) return std_logic_vector is
	begin
		case data is
			when "0000" => return "1000000"; --0
			when "0001" => return "1111001"; --1
			when "0010" => return "0100100"; --2
			when "0011" => return "0110000"; --3
			when "0100" => return "0011001"; --4
			when "0101" => return "0010010"; --5
			when "0110" => return "0000010"; --6
			when "0111" => return "1111000"; --7
			when "1000" => return "0000000"; --8
			when "1001" => return "0010000"; --9
			when "1010" => return "0001000"; --A
			when "1011" => return "0000011"; --B
			when "1100" => return "1000110"; --C
			when "1101" => return "0100001"; --D
			when "1110" => return "0100001"; --E
			when "1111" => return "0000110"; --F
			when others => return "XXXXXXX";
		end case;
	end function;
begin
	
	dataA_out <= Convert(data_in(15 downto 12));
	dataB_out <= Convert(data_in(11 downto 8));
	dataC_out <= Convert(data_in(7 downto 4));
	dataD_out <= Convert(data_in(3 downto 0));

end rtl;
