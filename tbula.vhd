library ieee;
use IEEE.Std_Logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity tbula is
end tbula;

architecture arch of tbula is

    signal A, B: SIGNED(15 downto 0);
	 signal result1, result2: SIGNED(15 downto 0);
	 signal Op: SIGNED(1 downto 0);
	 signal N, Z, O: STD_LOGIC;
	 
begin
    UUT : entity work.ula port map (A, B, Op, result1, result2, N, Z, O);

	 Op <= "00", "00" after 30 ns, "00" after 60 ns, "00" after 90 ns, "00" after 120 ns;
    A <= "0000000000000100", "1000000000000000" after 30 ns, "1111111111111111" after 60 ns, "1111111111111111" after 90 ns, "0000000001111111" after 120 ns;
	 B <= "0000000000000010", "0100000000000000" after 30 ns, "1111111111111111" after 60 ns, "0000000000000010" after 90 ns, "0000000000001000" after 120 ns;
	 
end arch;
