library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity generator is

    generic (
        -- Default seed value.
        init_seed:  std_logic_vector(31 downto 0) := x"faf1fafc"
		  );

    port (
        -- Clock, rising edge active.
        clk:        in  std_logic;
        -- High when the user accepts the current random data word
        -- and requests new random data for the next clock cycle.
		  rst:		in std_logic;
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

end entity;


architecture xoroshiro128plus_arch of generator is

    -- Internal state of RNG.
    signal reg_state_s0:    std_logic_vector(15 downto 0) := init_seed(15 downto 0);
    signal reg_state_s1:    std_logic_vector(15 downto 0) := init_seed(31 downto 16);

    -- Output register.
    signal reg_valid:       std_logic := '0';
    signal reg_output:      std_logic_vector(15 downto 0) := (others => '0');

    -- Shift left.
    function shiftl(x: std_logic_vector; b: integer)
        return std_logic_vector
    is
        constant n: integer := x'length;
        variable y: std_logic_vector(n-1 downto 0);
    begin
        y(n-1 downto b) := x(x'high-b downto x'low);
        y(b-1 downto 0) := (others => '0');
        return y;
    end function;

    -- Rotate left.
    function rotl(x: std_logic_vector; b: integer)
        return std_logic_vector
    is
        constant n: integer := x'length;
        variable y: std_logic_vector(n-1 downto 0);
    begin
        y(n-1 downto b) := x(x'high-b downto x'low);
        y(b-1 downto 0) := x(x'high downto x'high-b+1);
        return y;
    end function;

begin

    -- Drive output signal.
    out_valid   <= reg_valid;
    out_data    <= reg_output;

    -- Synchronous process.
    process (clk) is
    begin
        if rising_edge(clk) then

            if out_ready = '1' or reg_valid = '0' then

                -- Prepare output word.
                reg_valid       <= '1';
                reg_output      <= std_logic_vector(unsigned(reg_state_s0) +
                                                    unsigned(reg_state_s1));

                -- Update internal state.
                reg_state_s0    <= reg_state_s0 xor
                                   reg_state_s1 xor
                                   rotl(reg_state_s0, 6) xor
                                   shiftl(reg_state_s0, 4) xor
                                   shiftl(reg_state_s1, 4);

                reg_state_s1    <= rotl(reg_state_s0, 7) xor
                                   rotl(reg_state_s1, 7);

            end if;
				if rst = '1' then
                reg_state_s0    <= init_seed(15 downto 0);
                reg_state_s1    <= init_seed(31 downto 16);
                reg_valid       <= '0';
                reg_output      <= (others => '0');
            end if;
        end if;
    end process;

end architecture;