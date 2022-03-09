library ieee;
use IEEE.Std_Logic_1164.all;
use ieee.numeric_std.all;

entity tbula is
GENERIC(X: INTEGER:= 8);
end tbula;

architecture arch of tbula is

    signal reset, clk, inicio, pronto, erro, calculando, Overflow, Zero, Negativo, prontoUla, prontoSqrt: STD_LOGIC;
    signal Saida1, Saida2, A, B: STD_LOGIC_VECTOR(X-1 downto 0);
    SIGNAL opcode: STD_LOGIC_VECTOR(3 downto 0);
	 
begin
    UUT : entity work.mainula port map (reset, clk, inicio, pronto, prontoSqrt, erro, A, B, opcode, Saida1, Saida2, Overflow, Zero, Negativo);
    inicio <= '1';
	reset <= '0';
	 
    opcode <= "0001", "0001" after 30 ns, "0010" after 300 ns, "0011" after 450 ns, "0100" after 600 ns;
    A <= "00000011", "00001011" after 150 ns, "00001010" after 300 ns, "00000111" after 450 ns, "00000110" after 600 ns;
	B <= "00000011", "00000111" after 150 ns, "00000111" after 300 ns, "00000111" after 450 ns, "00000010" after 600 ns;
	 
	 
    tb1 : process
    constant periodo: time := 30 ns; 
    begin
        wait for periodo/2;
        clk <= '1';
        wait for periodo/2; 
        clk <= '0';
    end process;

end arch;
